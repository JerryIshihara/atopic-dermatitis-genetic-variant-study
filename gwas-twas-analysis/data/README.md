# Data layout

Every file under `data/` stays local (this README is the only tracked file here). Populate the folders yourself by downloading from the sources listed below and/or by running the pipeline steps to produce the intermediates.

## Skip the heavy lifting: download pre-computed intermediates

All pipeline intermediates for the 8 atopic dermatitis cohorts in this study (harmonized, imputed, S-PrediXcan, S-MultiXcan) are published as a single Zenodo deposit:

**DOI: [10.5281/zenodo.19683730](https://doi.org/10.5281/zenodo.19683730)**  ·  ~8.1 GB total  ·  CC-BY 4.0


| Zenodo archive   | Extracts to                                                        | Size    |
| ---------------- | ------------------------------------------------------------------ | ------- |
| `gwas.zip`       | `data/gwas/tables/` (standardized TSV from OpenGWAS VCFs)          | 2.7 GB  |
| `harmonized.zip` | `data/harmonized/` (Step 1 output)                                 | 2.4 GB  |
| `imputed.zip`    | `data/imputed/` (Step 2 merged + per-batch outputs)                | 2.7 GB  |
| `spredixcan.zip` | `data/spredixcan/<trait>/` (Step 3 output, 49 tissues × 8 cohorts) | 290 MB  |
| `smultixcan.zip` | `data/output/` (Step 4 gene-level CSVs)                            | 19.6 MB |


Downloading these lets you skip Steps 0–4 entirely and go straight to analysis / the notebooks. You still need the reference data below (liftover chain, 1000 Genomes panel, GTEx models, LD regions) if you want to re-run any step or add a new trait.

## Expected folder layout

```
data/
├── gwas/                                   GWAS input
│   ├── manifest.csv                        8-cohort metadata (keep a copy here;
│   │                                       the template in the repo is at
│   │                                       gwas-twas-analysis/manifest.csv)
│   ├── vcfs/                               OpenGWAS VCFs (pre-conversion)
│   │   └── <trait>.vcf.gz                  ~100 MB – 1 GB each
│   └── tables/                             Standardized TSV (post vcf_convert)
│       └── <trait>.table.gz                ~200–500 MB each
│
├── liftover/                               Liftover reference
│   └── hg19ToHg38.over.chain.gz            ~222 KB
│
├── reference/                              Heavy reference data (Steps 1–4)
│   ├── variant_metadata.txt.gz             ~365 MB   (Step 1)
│   ├── reference_panel_1000G/              ~11 GB    (Step 2)
│   │   ├── chr{1..22}.variants.parquet
│   │   └── variant_metadata.parquet
│   ├── gtex_v8_mashr_models/               ~250 MB   (Steps 3, 4)
│   │   ├── mashr_<tissue>.db               (49 files)
│   │   └── mashr_<tissue>.txt.gz           (49 files)
│   └── gtex_v8_expression_mashr_snp_smultixcan_covariance.txt.gz   ~33 MB   (Step 4)
│
├── regions/                                Imputation LD region atlas
│   └── eur_ld.bed.gz                       ~13 KB
│
├── harmonized/                             Step 1 output
│   └── harmonized_<trait>.txt.gz           ~300 MB each
│
├── imputed/                                Step 2 output
│   ├── <trait>/chr*_batch*.txt.gz          220 per-batch files per trait
│   └── final_imputed_<trait>.txt.gz        merged (~300 MB each)
│
├── spredixcan/                             Step 3 output
│   └── <trait>/spredixcan_<trait>_<tissue>.csv   (49 per trait, ~2 MB each)
│
└── output/                                 Step 4 output (terminal)
    └── smultixcan_<trait>.csv              ~6 MB each
```

## Where to download


| Path                                                                  | Source                                                                                                                                                                                  |
| --------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `gwas/vcfs/*.vcf.gz`                                                  | [OpenGWAS](https://gwas.mrcieu.ac.uk) — URL pattern: `https://gwas.mrcieu.ac.uk/files/<id>/<id>.vcf.gz`; 8 AD cohort IDs in `manifest.csv`.                                             |
| `gwas/tables/*.table.gz`                                              | [Zenodo 10.5281/zenodo.19683730](https://doi.org/10.5281/zenodo.19683730) (`gwas.zip`) — or generate locally via `../scripts/vcf_convert/convert_vcf_batch.sh`.                         |
| `liftover/hg19ToHg38.over.chain.gz`                                   | [UCSC Genome Browser](https://hgdownload.soe.ucsc.edu/goldenPath/hg38/liftOver/) — grab `hg19ToHg38.over.chain.gz`.                                                                     |
| `reference/variant_metadata.txt.gz`                                   | [Zenodo 3657902](https://zenodo.org/record/3657902) (1000 Genomes EUR, MAF > 0.01, monoallelic-filtered).                                                                               |
| `reference/reference_panel_1000G/*.parquet`                           | [Zenodo 3657902](https://zenodo.org/record/3657902) — `reference_panel_1000G.tar.gz`.                                                                                                   |
| `reference/gtex_v8_mashr_models/`                                     | [Zenodo 3518299](https://zenodo.org/record/3518299) — `mashr_eqtl.tar` (49 tissues × 2 files).                                                                                          |
| `reference/gtex_v8_expression_mashr_snp_smultixcan_covariance.txt.gz` | [Zenodo 3518299](https://zenodo.org/record/3518299).                                                                                                                                    |
| `regions/eur_ld.bed.gz`                                               | Berisa & Pickrell 2016 — [bitbucket.org/nygcresearch/ldetect-data](https://bitbucket.org/nygcresearch/ldetect-data/src/master/EUR/) (grab `fourier_ls-all.bed` from `EUR/`, then gzip). |
| `harmonized/*.txt.gz`                                                 | [Zenodo 10.5281/zenodo.19683730](https://doi.org/10.5281/zenodo.19683730) (`harmonized.zip`) — or Step 1 local output.                                                                  |
| `imputed/*`                                                           | [Zenodo 10.5281/zenodo.19683730](https://doi.org/10.5281/zenodo.19683730) (`imputed.zip`) — or Step 2 local output.                                                                     |
| `spredixcan/<trait>/*.csv`                                            | [Zenodo 10.5281/zenodo.19683730](https://doi.org/10.5281/zenodo.19683730) (`spredixcan.zip`) — or Step 3 local output.                                                                  |
| `output/smultixcan_*.csv`                                             | [Zenodo 10.5281/zenodo.19683730](https://doi.org/10.5281/zenodo.19683730) (`smultixcan.zip`) — or Step 4 local output.                                                                  |




