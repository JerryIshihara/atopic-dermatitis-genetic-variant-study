# Step 2: Summary-statistic imputation (+ merge)

Fills in variants that are in the 1000 Genomes panel but missing from the GWAS, using Gaussian imputation against LD. Wraps [`summary-gwas-imputation`](https://github.com/hakyimlab/summary-gwas-imputation)'s `gwas_summary_imputation.py` and its postprocess merger.

## Why impute

GWAS arrays typed ~0.5–1 M SNPs, but GTEx prediction models (Step 3) expect up to ~7 M variants. Any missing SNP in a gene's prediction model weights that gene's signal toward noise. Imputation recovers the missing z-scores from LD with neighbors.

## Algorithm

Per (chromosome, sub-batch):

$$z_{\text{missing}} = \Sigma_{21}\,\Sigma_{11}^{-1}\,z_{\text{observed}}$$

where $\Sigma$ is the reference-panel LD matrix, $\Sigma_{21}$ is the cross-covariance between missing and observed variants, and $\Sigma_{11}$ is the observed-observed block (with ridge regularization = 0.1 for numerical stability). The job is parallel over ~1,700 approximately-independent LD blocks (the `eur_ld.bed.gz` file), batched 10 ways per chromosome for a total of 22 × 10 = **220 jobs per trait**.

## Scripts

### `run_impute.sh` — Step 2 (220 jobs)

Runs all 220 (chromosome, sub_batch) jobs locally via `xargs -P`. Idempotent: any batch whose output already exists is skipped.

| Flag | Description |
|---|---|
| `--gwas-file` | Harmonized GWAS from Step 1 (`data/harmonized/harmonized_<trait>.txt.gz`) |
| `--ld-regions` | Approximately-independent LD blocks (`data/regions/eur_ld.bed.gz`) |
| `--parquet-dir` | Dir with `chr{1..22}.variants.parquet` + `variant_metadata.parquet` (`data/reference/reference_panel_1000G/`) |
| `--impute-script` | `gwas_summary_imputation.py` (`../external/summary-gwas-imputation/src/...`) |
| `--output-dir` | Where per-batch outputs go (`data/imputed/<trait>/`) |
| `--sub-batches` | Batches per chromosome (default 10 → 220 jobs total) |
| `--n-jobs` | Local parallel workers (default 2; each uses ~6 GB RAM) |
| `--chromosome` / `--batch` | Run only one chr or one sub-batch (for testing / resume) |

Output: `data/imputed/<trait>/chr${chr}_batch${batch}.txt.gz` × 220.

### `run_merge.sh` — Step 2b (merge 220 → 1)

Concatenates, deduplicates, and sorts the 220 batches plus the original harmonized variants. Wraps `gwas_summary_imputation_postprocess.py`.

| Flag | Description |
|---|---|
| `--gwas-file` | Original harmonized GWAS (re-read for the "original" rows) |
| `--imputed-dir` | Directory from `run_impute.sh` containing the 220 batches |
| `--postprocess-script` | `gwas_summary_imputation_postprocess.py` |
| `--output` | Final merged file path (e.g. `data/imputed/final_imputed_<trait>.txt.gz`) |
| `--sub-batches` | Expected batches per chromosome (default 10; only used for the pre-flight count) |

Output: one `data/imputed/final_imputed_<trait>.txt.gz` per trait with columns matching Step 1 plus `current_build`, `imputation_status` (`original` | `imputed`), and `n_cases`.

## Run

```bash
# Step 2 (220 batches, ~1 hr locally at 2 jobs; much faster on cloud — see below)
bash scripts/imputation/run_impute.sh \
  --gwas-file     data/harmonized/harmonized_bbj-a-90.txt.gz \
  --ld-regions    data/regions/eur_ld.bed.gz \
  --parquet-dir   data/reference/reference_panel_1000G \
  --impute-script ../external/summary-gwas-imputation/src/gwas_summary_imputation.py \
  --output-dir    data/imputed/bbj-a-90 \
  --n-jobs        4

# Step 2b (merge, ~1–2 min)
bash scripts/imputation/run_merge.sh \
  --gwas-file          data/harmonized/harmonized_bbj-a-90.txt.gz \
  --imputed-dir        data/imputed/bbj-a-90 \
  --postprocess-script ../external/summary-gwas-imputation/src/gwas_summary_imputation_postprocess.py \
  --output             data/imputed/final_imputed_bbj-a-90.txt.gz
```

## Runtime & resources

- **Per-batch**: 30 s – 15 min depending on chromosome size and SNP coverage; chr1/chr2 are the slowest.
- **Per trait (local, 2 parallel workers)**: ~45–90 min.
- **Memory**: ~6 GB per in-flight Python process (mostly parquet caching), so `--n-jobs N` needs ~6N GB free RAM.
- **Disk**: ~50 MB per batch → ~11 GB total per trait before merge; ~300 MB after merge.
- **Merge**: ~1–2 min, fits in memory.

For 8 traits × 220 batches = 1,760 jobs, running locally takes most of a day. Cloud distribution (GCP VMs with Filestore-backed work queue) is ~1 hour; the deploy scripts live in the companion research repo but aren't part of this pipeline's required path.

## Troubleshooting

- **Killed (OOM)**: reduce `--n-jobs` or check that your machine has ≥ 6 GB/worker free.
- **Missing parquet file**: confirm both `chrN.variants.parquet` **and** `variant_metadata.parquet` are in `--parquet-dir`; the imputer needs both.
- **Merge fails with `KeyError: 'n_cases'`**: the harmonized input is missing the `n_cases` column. See [`../harmonization/README.md`](../harmonization/README.md).
