# Step 1: Harmonization

Lifts the GWAS from hg19 → hg38 and reconciles its variant IDs, alleles, and column names with the 1000 Genomes reference panel so downstream tools can join on a stable key. Wraps [`summary-gwas-imputation/src/gwas_parsing.py`](https://github.com/hakyimlab/summary-gwas-imputation).

## What harmonization does

1. **Liftover** positions hg19 → hg38 using the UCSC chain file.
2. **Re-key** each variant to the canonical panel ID `chr<pos>_<pos>_<ref>_<alt>_b38` so Steps 2–4 can join against the 1000 Genomes / GTEx tables.
3. **Drop** variants not in the reference panel (they'd be unusable downstream anyway).
4. **Standardize** column names / strands / alleles (flips effect direction if alleles are swapped).
5. **Insert** fixed `sample_size` and `n_cases` columns (OpenGWAS summary stats don't carry per-variant N).

## Inputs

| Flag | Description | Where it lives |
|---|---|---|
| `--trait` | OpenGWAS ID, used to name the output file | — |
| `--gwas-file` | Input `.table.gz` on hg19 (from `vcf_convert/`) | `data/gwas/tables/<trait>.table.gz` |
| `--liftover` | hg19 → hg38 UCSC chain file | `data/liftover/hg19ToHg38.over.chain.gz` |
| `--snp-metadata` | 1000 Genomes panel variant list (~365 MB) | `data/reference/variant_metadata.txt.gz` |
| `--gwas-parsing` | `gwas_parsing.py` from summary-gwas-imputation | `../external/summary-gwas-imputation/src/gwas_parsing.py` |
| `--sample-size` | Total sample size (optional, default `NA`) | `data/gwas/manifest.csv` column |
| `--n-cases` | Case count (optional, default `NA`) | — |
| `--output-dir` | Override default output location (optional) | default: `data/harmonized/` |

## Output

`data/harmonized/harmonized_<trait>.txt.gz` — the same variants, now on hg38 with columns:

```
variant_id   panel_variant_id   chromosome   position
effect_allele   non_effect_allele   frequency
pvalue   zscore   effect_size   standard_error
sample_size   n_cases
```

## Run

Per trait (idempotent — skips if output already exists):

```bash
bash scripts/harmonization/run_harmonize.sh \
  --trait         bbj-a-90 \
  --gwas-file     data/gwas/tables/bbj-a-90.table.gz \
  --liftover      data/liftover/hg19ToHg38.over.chain.gz \
  --snp-metadata  data/reference/variant_metadata.txt.gz \
  --gwas-parsing  ../external/summary-gwas-imputation/src/gwas_parsing.py \
  --sample-size   212036
```

Loop over all 8 traits driven by the manifest:

```bash
awk -F, 'NR>1 {gsub(/"/,"",$0); print $1"\t"$7}' data/gwas/manifest.csv \
  | while IFS=$'\t' read -r trait n; do
      bash scripts/harmonization/run_harmonize.sh \
        --trait "$trait" \
        --gwas-file    "data/gwas/tables/${trait}.table.gz" \
        --liftover     data/liftover/hg19ToHg38.over.chain.gz \
        --snp-metadata data/reference/variant_metadata.txt.gz \
        --gwas-parsing ../external/summary-gwas-imputation/src/gwas_parsing.py \
        --sample-size  "${n:-NA}"
    done
```

## Runtime

~3–5 minutes per trait on a laptop, dominated by loading the 365 MB SNP metadata. Single-threaded — running multiple traits in parallel is I/O-bound and usually not worth it.

## Troubleshooting

- **`KeyError: 'n_cases' not in index`** (downstream in Step 2b merge): your harmonized file is missing the `n_cases` column. This script always inserts it; if you're consuming an externally-harmonized file, add the column before running merge.
- **Many variants dropped**: expected — typically 10–30% of OpenGWAS variants aren't in the 1000 Genomes EUR panel (rare, non-biallelic, or not typed).
