# Preliminary: OpenGWAS VCF → standardized TSV

Converts OpenGWAS-format `.vcf.gz` files into the tab-separated `.table.gz` layout expected by the harmonization step. Not strictly a pipeline "step" — it's a format adapter — but it has to run before Step 1 if your starting point is a VCF.

## What the conversion does

OpenGWAS ships association summary statistics in a quirky VCF where the association values (effect size, SE, log-p, zscore) live as FORMAT fields on each variant line. This pre-step extracts them into plain columns:

| OpenGWAS VCF field | Output column |
|---|---|
| `ID` / `CHROM:POS:REF:ALT` | `variant_id` |
| `CHROM`, `POS` | `chromosome`, `position` |
| `REF`, `ALT` | `non_effect_allele`, `effect_allele` |
| FORMAT `ES`, `SE` | `effect_size`, `standard_error` |
| FORMAT `LP`  (`= -log10 p`) | `pvalue` (computed: `10^-LP`) |
| FORMAT `ES/SE` or `EZ` | `zscore` |

## Scripts

### `vcf_to_table.py`
Python script that converts one VCF to one `.table.gz`. Runs under any Python 3.9+ with `cyvcf2` installed (the `metaxcan` conda env from `setup/` has it).

```bash
python3 scripts/vcf_convert/vcf_to_table.py input.vcf.gz output.table.gz
```

### `convert_vcf_batch.sh`
Wrapper that converts every `*.vcf.gz` under one directory to `.table.gz` in another, skipping any already converted. Also emits a small sanity check comparing `z` to `ES/SE` on the first variant of the first output file.

```bash
bash scripts/vcf_convert/convert_vcf_batch.sh <input_dir> <output_dir>
# e.g.
bash scripts/vcf_convert/convert_vcf_batch.sh data/gwas/vcfs data/gwas/tables
```

## Inputs / outputs

| Location | Content |
|---|---|
| Input  | `data/gwas/vcfs/<trait>.vcf.gz` (not gitignored by default; add yourself if committing) |
| Output | `data/gwas/tables/<trait>.table.gz` (~200–500 MB each, gitignored) |

## How to get the VCFs

OpenGWAS exposes each dataset at `https://gwas.mrcieu.ac.uk/files/<opengwas_id>/<opengwas_id>.vcf.gz`. For the 8 AD cohorts in this study, see `data/gwas/manifest.csv` for the IDs. Download manually or with any CLI tool (`curl -L`, `wget`). This pipeline deliberately does not ship a download-automation script — bring your own VCFs and point the batch converter at them.
