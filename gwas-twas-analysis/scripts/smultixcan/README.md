# Step 4: S-MultiXcan (cross-tissue gene-level TWAS)

Combines evidence across all 49 single-tissue S-PrediXcan results for each gene into a single, more powerful multi-tissue statistic. Wraps [`MetaXcan/software/SMulTiXcan.py`](https://github.com/hakyimlab/MetaXcan).

## Why cross-tissue

Pooling across correlated tissues increases power (more signal per gene) and avoids the 49× multiple-testing burden. For a gene expressed in multiple tissues, an association in the right tissue often propagates to correlated tissues — S-MultiXcan captures that as a single test.

## Algorithm

Joint test of per-tissue z-scores, accounting for the cross-tissue correlation of the predicted expression. Uses SVD truncation (`--cutoff_condition_number 30`) to regularize when tissues are too collinear to invert.

## Inputs

| Flag | Description | Where |
|---|---|---|
| `--trait` | Trait ID (used to match Step 3 output filenames) | — |
| `--gwas-file` | Merged imputed GWAS from Step 2b | `data/imputed/final_imputed_<trait>.txt.gz` |
| `--spredixcan-dir` | Dir containing `spredixcan_<trait>_*.csv` from Step 3 | `data/spredixcan/<trait>/` |
| `--models-dir` | Same GTEx mashr models as Step 3 | `data/reference/gtex_v8_mashr_models/` |
| `--snp-covariance` | SNP-SNP covariance across all mashr tissues | `data/reference/gtex_v8_expression_mashr_snp_smultixcan_covariance.txt.gz` |
| `--metaxcan-dir` | Root of cloned MetaXcan repo | `../external/MetaXcan/` |
| `--output` | Final CSV path | `data/output/smultixcan_<trait>.csv` |

## Output

One CSV at `data/output/smultixcan_<trait>.csv`, ~6 MB, ~22,300 genes, columns:

```
gene  gene_name  pvalue  n  n_indep  p_i_best  t_i_best  p_i_worst  t_i_worst
eigen_max  eigen_min  eigen_min_kept  z_min  z_max  z_mean  z_sd  tmi  status
```

Key columns:
- `pvalue` — the multi-tissue p-value (what you rank genes by).
- `n` — number of tissues with a prediction model for that gene.
- `n_indep` — effective independent dimensions after SVD truncation.
- `t_i_best` / `p_i_best` — best single-tissue t-stat / p (useful for sign + tissue attribution).
- `status` — `0` means successful fit; anything else means the test was degenerate and `pvalue` is unreliable.

## Run

Per trait:

```bash
bash scripts/smultixcan/run_smultixcan.sh \
  --trait           bbj-a-90 \
  --gwas-file       data/imputed/final_imputed_bbj-a-90.txt.gz \
  --spredixcan-dir  data/spredixcan/bbj-a-90 \
  --models-dir      data/reference/gtex_v8_mashr_models \
  --snp-covariance  data/reference/gtex_v8_expression_mashr_snp_smultixcan_covariance.txt.gz \
  --metaxcan-dir    ../external/MetaXcan \
  --output          data/output/smultixcan_bbj-a-90.csv
```

Idempotent: skips if `--output` already exists.

Loop over all 8 traits:

```bash
for t in $(tail -n +2 data/gwas/manifest.csv | cut -d, -f1 | tr -d '"'); do
  bash scripts/smultixcan/run_smultixcan.sh \
    --trait "$t" \
    --gwas-file      "data/imputed/final_imputed_${t}.txt.gz" \
    --spredixcan-dir "data/spredixcan/${t}" \
    --models-dir     data/reference/gtex_v8_mashr_models \
    --snp-covariance data/reference/gtex_v8_expression_mashr_snp_smultixcan_covariance.txt.gz \
    --metaxcan-dir   ../external/MetaXcan \
    --output         "data/output/smultixcan_${t}.csv"
done
```

## Runtime

Single-threaded, ~5–15 min per trait. Memory peaks ~3–5 GB per run (keep this in mind if running several in parallel).

## Downstream

`data/output/smultixcan_*.csv` is the terminal artifact of this pipeline — the cross-cohort meta-analysis notebook (`../../../notebooks/01_bbj_analysis.ipynb` and the multi-cohort notebook in the parent research repo) reads these directly.

## Reference

The SNP-SNP covariance file (`gtex_v8_expression_mashr_snp_smultixcan_covariance.txt.gz`, ~33 MB) comes from the same [Zenodo 3518299](https://zenodo.org/record/3518299) bundle as the per-tissue models. This file does NOT change between traits — it's a property of the GTEx mashr model family, not the GWAS.
