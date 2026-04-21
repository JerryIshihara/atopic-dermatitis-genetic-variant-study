# Atopic Dermatitis Genetic Variant Study

Transcriptome-Wide Association Study (TWAS) of **atopic dermatitis (AD)** across **8 public GWAS cohorts** (European, East Asian, Aboriginal Australian), using GTEx v8 mashr prediction models and the MetaXcan framework.

## Datasets

Eight AD GWAS summary statistics sourced from OpenGWAS. See [`gwas-twas-analysis/manifest.csv`](gwas-twas-analysis/manifest.csv).

| OpenGWAS ID | Population | Year | Sample size |
|---|---|---|---|
| `bbj-a-90` | East Asian (BBJ) | 2019 | 212,036 |
| `ebi-a-GCST90018564` | East Asian | 2021 | 168,103 |
| `ebi-a-GCST90018784` | European | 2021 | 481,299 |
| `ebi-a-GCST90027161` | European | 2021 | 796,661 |
| `finn-b-L12_ATOPIC` | European (FinnGen) | 2021 | — |
| `finn-b-ATOPIC_STRICT` | European (FinnGen, strict definition) | 2021 | — |
| `finn-b-ATOPIC_STRICT_REIMB` | European (FinnGen, strict + reimbursement) | 2021 | — |
| `ieu-b-5145` | Aboriginal Australian (females) | 2023 | 864,982 |

## Pipeline (5 steps)

```
Raw GWAS (hg19 VCF)  ─[Step 1: harmonize]─>  GRCh38 tabular
                                                   │
                                         [Step 2: impute]
                                                   │
                                            220 batches
                                                   │
                                         [Step 3: merge]
                                                   │
                                      Imputed summary statistics
                                                   │
                                   [Step 4: S-PrediXcan × 49 tissues]
                                                   │
                                     49 tissue result files
                                                   │
                                   [Step 5: S-MultiXcan cross-tissue]
                                                   │
                                      Gene-level associations
```

Step 2 (imputation) is the expensive step — ~1,100 jobs total (8 traits × 22 chromosomes × 10 sub-batches = 1,760 max; we run the 5 previously-unfinished traits only on the cloud in practice). Deployed on GCP as 24 × `n2-standard-8` VMs with a Filestore NFS job queue; see [`gwas-twas-analysis/scripts/twas/deploy/`](gwas-twas-analysis/scripts/twas/deploy/).

## Results

Per-trait gene-level multi-tissue p-values are in [`gwas-twas-analysis/smultixcan/`](gwas-twas-analysis/smultixcan/) — 8 CSVs × ~22,300 genes.

Per-trait single-tissue SPrediXcan results (49 tissues × 8 traits = 392 CSVs, ~720 MB total) are not checked in; regenerate locally by running Step 4.

### Headline findings (bbj-a-90, East Asian)

34 genome-wide significant genes. Top hits cluster at:
- **Chromosome 2 IL cluster**: `IL18RAP`, `IL18R1`, `IL1RL1` (established AD loci)
- **Chromosome 6 MHC**: `HLA-DRB1`, `HLA-DQA1`, `HLA-DPB1`, `MICA`, `PSORS1C2`, `CCHCR1`, `POU5F1`
- **Complement**: `C2`, `C4B`
- **Others**: `RNF5` (p = 1.5×10⁻³¹ — top), `GLB1`, `SLC9A4`, `TCF19`

See [`notebooks/01_bbj_analysis.ipynb`](notebooks/01_bbj_analysis.ipynb) for the full walkthrough.

## Repository layout

```
.
├── README.md
├── gwas-twas-analysis/
│   ├── manifest.csv                    — 8 datasets metadata
│   ├── smultixcan/                     — 8 × gene-level CSVs (~47 MB)
│   └── scripts/
│       ├── twas/                       — harmonize → impute → merge → SPrediXcan → SMulTiXcan
│       │   ├── config.sh, run_*.sh
│       │   ├── steps/                  — run_step{1..5}_*.sh
│       │   └── deploy/                 — GCP spin-up + autonomous launch + teardown
│       └── gwas/                       — OpenGWAS VCF → standardized table
└── notebooks/
    └── 01_bbj_analysis.ipynb           — full TWAS walkthrough for bbj-a-90
```

## How to reproduce

```bash
# 1. Set up conda envs (metaxcan + gwasimputation)
bash gwas-twas-analysis/scripts/twas/setup_env.sh

# 2. Download OpenGWAS VCFs
bash gwas-twas-analysis/scripts/gwas/download_opengwas_ad.sh

# 3. Convert VCFs to standardized table format
bash gwas-twas-analysis/scripts/gwas/convert_vcf_batch.sh

# 4. Run the full TWAS pipeline
bash gwas-twas-analysis/scripts/twas/run_all_ad.sh
```

For cloud-autonomous imputation (Step 2) on GCP:

```bash
bash gwas-twas-analysis/scripts/twas/deploy/gcp_deploy_multi.sh <trait1> <trait2> ...
```

See [`gwas-twas-analysis/scripts/twas/deploy/`](gwas-twas-analysis/scripts/twas/deploy/) for the scale-up, async-launch, and download/teardown helpers.

## Data availability

- **GTEx v8 mashr prediction models**: [Zenodo 3518299](https://zenodo.org/record/3518299)
- **1000 Genomes LD reference panel**: [Zenodo 3657902](https://zenodo.org/record/3657902)
- **OpenGWAS summary statistics**: https://gwas.mrcieu.ac.uk

## Citation

If you use this work, cite the underlying MetaXcan framework (Barbeira et al. 2018) and the individual GWAS studies listed in `manifest.csv`.
