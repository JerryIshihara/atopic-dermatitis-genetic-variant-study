# Preliminary: conda environments + external tools

One-time setup before running any pipeline step. Installs Miniconda (if missing), creates the two Python environments the pipeline uses, and clones the upstream tools from the Hakyi lab.

## Scripts

### `download_external.sh`
Shallow-clones two third-party repositories into `../external/` (sibling of `gwas-twas-analysis/`):

| Repo | Provides |
|---|---|
| [`hakyimlab/MetaXcan`](https://github.com/hakyimlab/MetaXcan) | `software/SPrediXcan.py`, `software/SMulTiXcan.py` (Steps 3 + 4) |
| [`hakyimlab/summary-gwas-imputation`](https://github.com/hakyimlab/summary-gwas-imputation) | `src/gwas_parsing.py`, `src/gwas_summary_imputation.py`, `src/gwas_summary_imputation_postprocess.py` (Steps 1 + 2 + 2b) |

Idempotent: skips anything already cloned.

```bash
bash scripts/setup/download_external.sh
```

### `setup_env.sh`
Installs Miniconda (to `$HOME/miniconda3`) if it's not already on PATH, then creates two Python 3.9 conda environments:

| Env | Used by | Python packages |
|---|---|---|
| `gwasimputation` | Steps 1, 2, 2b | numpy, pandas, scipy, h5py, pyliftover, pyarrow |
| `metaxcan` | Steps 3, 4 | numpy, pandas, scipy, h5py, cyvcf2, pyliftover |

Both pinned to Python 3.9 for pyarrow/numpy compatibility with the upstream tools. Idempotent: existing envs are skipped.

```bash
bash scripts/setup/setup_env.sh
```

After this completes, activate with `conda activate gwasimputation` (or `metaxcan`) if you want to call tools interactively. The pipeline scripts invoke the envs through `conda run` or absolute `$CONDA_BASE/envs/<env>/bin/python`, so no manual activation is required.

## What you still need to download manually

The setup scripts don't fetch the heavy reference data (11 GB of parquets + 250 MB of GTEx models + 365 MB of SNP metadata). See per-step READMEs for the specific downloads needed, or grab everything from Zenodo:

- [Zenodo 3657902](https://zenodo.org/record/3657902) — 1000 Genomes reference panel + variant metadata (Steps 1, 2)
- [Zenodo 3518299](https://zenodo.org/record/3518299) — GTEx v8 mashr eqtl models + SMulTiXcan SNP covariance (Steps 3, 4)
- [UCSC chain files](https://hgdownload.soe.ucsc.edu/goldenPath/hg38/liftOver/) — liftover (Step 1, ~222 KB; grab `hg19ToHg38.over.chain.gz`)

## Output of this step

```
<repo-root>/external/
  MetaXcan/
  summary-gwas-imputation/

$HOME/miniconda3/envs/
  gwasimputation/
  metaxcan/
```
