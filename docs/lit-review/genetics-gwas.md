# Atopic Dermatitis — Genetics, GWAS & TWAS

## Overview

Atopic dermatitis (AD) is a complex inflammatory skin disease with substantial genetic contribution. Recent multi-ancestry GWAS meta-analyses (2023–2025) have identified 81–101 independent risk loci, expanding from 31 loci identified in the landmark 2015 Paternoster EAGLE consortium study. The genetic architecture reflects contributions from barrier dysfunction (FLG, OVOL1), immune regulation (IL13, IL4, HLA), and systemic processes. SNP-based heritability estimates range 5.6–7.1%, with 20%+ heritability attributable to rare variants. TWAS and single-cell eQTL studies increasingly leverage tissue-specific (skin, immune cell) expression quantitative loci to prioritize causal genes for drug repurposing pipelines.

## Key GWAS findings (2024–2026 + landmarks)

### Major Meta-Analyses
- **2024 Multi-ancestry meta-analysis** (56,146 cases / 602,280 controls across 12 cohorts, 5 ancestries): Identified **101 independent risk loci** including 16 novel; included FinnGen (20,115 cases), UK Biobank, CHOP, EAGLE, Biobank Japan; fine-mapping and QTL colocalization applied; keratinocyte functional validation showed evidence for epidermal barrier mechanisms (Paternoster et al., Nature Communications, June 2024 preprint / April 2025 publication)
- **2023 European + multi-ancestry GWAS** (discovery N = 1,086,394; replication N = 3,604,027): Identified **81 loci (29 novel)** in European-only analysis; 10 additional multi-ancestry loci (3 novel); highlighted systemic immune regulation (Nature Communications, 2023)
- **2025 Transcriptome-wide analysis** (N = 864,982 Europeans): Identified **176 gene-tissue associations covering 126 unique genes**, including 53 previously unreported; leveraged skin sun-exposed (n=517), non-sun-exposed (n=602), and whole blood (n=670) eQTL panels; used adaptive PRS methods (OTTERS pipeline) (Cell Reports Genetics & Genomics Advances, February 2025)

### Landmark Study
- **2015 Paternoster EAGLE consortium** (21,399 cases / 95,464 controls in discovery; 32,059 cases / 228,628 controls in replication; multi-ancestry): Identified **10 new loci, bringing total to 31**; included populations of European, African, Japanese, and Latino ancestry (Nature Genetics, 2015)

### Top Replicated Loci
- **FLG** (filaggrin): Consistently strongest barrier-function locus across ancestry groups
- **HLA region**: Major immune-associated signal; ancestry-specific alleles
- **IL13** / **IL4**: TH2 pathway; IL-13 down-regulates OVOL1-FLG axis via IL4 cooperation
- **OVOL1**: Master regulator of FLG expression; protective variants stabilize barrier
- **RAD50**, **TSLP region** (5q22), **C11orf30 / LRRC32**: Immune-related loci identified in multiple GWAS
- **ACER3** (alkaline ceramidase): Sphingolipid metabolism; skin barrier-specific eQTL enrichment

## Publicly available AD GWAS summary statistics

| Dataset | Ancestry | N (cases/controls) | Access URL | Notes |
|---|---|---|---|---|
| **2024 multi-ancestry meta-analysis** | EUR/ASN/AFR/AMR | 56,146 / 602,280 | https://plus.figshare.com/articles/dataset/Atopic_Dermatitis_GWAS_meta-analysis_summary_statistics/25551810 | 12 cohorts, 101 loci, ancestry-stratified sumstats available (EUR, ASN, AFR) |
| **2023 EAGLE European + multi-ancestry** | EUR (primary); multi-ancestry | ~1.1M / 3.6M | GCST90244787, GCST90244788 (GWAS Catalog) | 81 loci European, 91 total; GWAS Catalog accessions |
| **FinnGen (R8/R10)** | European (Finnish) | 20,115 / 146,275 | https://r8.risteys.finngen.fi/phenocode/L12_ATOPIC | L12_ATOPIC; included in 2024 meta-analysis; apply for non-partner access |
| **Biobank Japan** | East Asian (Japanese) | 4,296 / 163,807 | Included in 2024 meta-analysis; check BBJ portal | SAIGE analysis; ICD-10 L20 definition |
| **UK Biobank** | EUR (primary) | Included in meta-analyses | openGWAS (finn-b-L12_DERMATITISECZEMA) | Query via gwas.mrcieu.ac.uk |
| **EAGLE Consortium (Paternoster 2015)** | Multi-ancestry | 21,399 / 95,464 | http://data.bris.ac.uk/data/dataset/28uchsdpmub118uex26ylacqm (DOI: 10.5523/bris.28uchsdpmub118uex26ylacqm) | Landmark pre-2024 study; Bristol repository |
| **OpenGWAS (IEU)** | Various | Various | https://gwas.mrcieu.ac.uk/datasets/bbj-a-90/ (atopic dermatitis); https://gwas.mrcieu.ac.uk/datasets/finn-b-L12_DERMATITISECZEMA/ | Harmonized, query-ready; bbj-a-90 (BBJ AD), FinnGen dermatitis-eczema |

**Key download tips for TWAS:**
- Preferred: FigShare 2024 meta-analysis sumstats (full ancestry-stratified files)
- Backup: GWAS Catalog accessions GCST90244787/8 (2023 EAGLE study)
- Check: FinnGen Risteys & OpenGWAS for harmonized formats compatible with MetaXcan

## TWAS / eQTL / colocalization insights

### Transcriptome-wide association studies in AD
- **S-PrediXcan framework**: Identified 175 genes (72 unique) at Bonferroni threshold in prior studies; increasingly replaced by adaptive polygenic methods
- **OTTERS pipeline** (2025): Adaptive PRS-based TWAS on 864,982 Europeans identified 176 gene-tissue pairs (126 genes); outperformed clumping & thresholding; 53 genes novel (not in prior TWAS)
- **Tissue-specific prioritization**:
  - **Skin (sun-exposed & non-sun-exposed)**: Primary driver; cis-regulated genes of GWAS signals mainly over-expressed in skin
  - **Whole blood**: Secondary but important for immune-driven loci (IL13, HLA, T-cell pathway genes)
  - **GTEx v8**: eQTL weights from skin & blood commonly used; GTEx v7 (sun-exposed & non-sun-exposed skin, whole blood) employed in prior studies

### QTL colocalization
- **Systematic coloc (>95% posterior probability)**: Compiled 297 cis-QTL maps (eQTL, sQTL, mQTL, pQTL) for comprehensive causal link identification
- **Key findings**: Protective alleles show differential expression effects between skin and blood eQTLs; indicates tissue-type-specific regulatory mechanisms
- **Caution**: ~75% of TWAS colocalization hits may be noncausal due to correlated gene expression; robust fine-mapping (SUSIE, DAP-G) recommended

### Genes prioritized for drug repurposing
- **Barrier function genes** (skin eQTL enriched): FLG, OVOL1, ACER3 (ceramidase), filaggrin-processing enzymes
- **Immune checkpoint targets**: IL13, IL4, IL31, OX40 (TNFRSF4), TSLP pathway genes
- **Cell-type specific**: T-cell enrichment (Th2, Th17, Treg) dominant; dendritic cells and inflammatory DCs; secondary enrichment in keratinocytes
- **SMR / S-MultiXcan**: Applied via CTG-VL platform for systematic prioritization across cohorts

### Single-cell eQTL relevance (emerging)
- **Lesional skin** (single-cell RNA-seq): Expansion of CD1A+ FCER1A+ inflammatory dendritic cells; tissue-resident memory T cells (CD69+ CD103+); IL13+ IL22+ T cells > IFNG+ (type 2 bias)
- **Immune profiling**: Increased Th2, reduced NK cells (compromised cytotoxicity); Type 2 innate lymphoid cell (ILC2) proportion correlates with disease severity
- **Integrative TWAS**: eQTL panels from 9 tissues used to cover systemic features; single-cell eQTL data increasingly incorporated (e.g., keratinocyte subtype-specific expression)

## Heritability & PRS

### SNP-based heritability
- **European cohorts** (LDSC): SNP-h2 ≈ 5.6% (intercept = 1.042); ranges 0.6–7.1% across different ancestries/datasets
- **Liability scale** (population prevalence 0.15): Estimates applied in multi-ancestry meta-analyses
- **Rare variants**: ~20% of AD heritability attributable to rare exonic variants (exome studies); justifies inclusion of exome-based rare variant burdens in integrated models

### Polygenic risk scores
- **Standard PRS**: Primarily developed & validated in European ancestry populations; limited cross-ancestry portability
- **Polygenic transcriptome risk scores (PTRS)** (2025): Superior cross-ancestry performance vs. traditional PRS in other traits; tested in AD but clinical utility in diverse ancestries remains unverified
- **Clinical phenotypes**: Most PRS studies predict binary case/control status; association with disease severity/age-of-onset still developing
- **Cross-ancestry gap**: Ancestry-specific molecular mechanisms suspected to limit PTRS clinical utility in non-European populations; recommend population-specific validation

## Mendelian randomization & comorbidities

### Bidirectional MR relationships
- **Atopic comorbidities** (asthma, allergic rhinitis, food allergy): Strong observational associations; MR findings suggest **limited bidirectional causal evidence**
- **Mental health disorders** (depression, anxiety, bipolar disorder): Observational studies report strong associations; **MR meta-analyses find little evidence of causality in either direction**; confounding (socioeconomic, inflammatory) likely explains observational correlation
- **Implications for repurposing**: Intervening on AD presentation unlikely to improve mental health; psychiatric comorbidities may be independent outcomes requiring separate management

### Genetic overlap
- **Shared loci across allergic diseases**: Structural equation modeling reveals common genetic architecture across AD, asthma, allergic rhinitis
- **HLA and immune regulatory loci**: Pleiotropic effects on multiple allergic/immune traits

## Notable papers

| Title | Year | Venue | URL |
|---|---|---|---|
| Integration of GWAS, QTLs and keratinocyte functional assays reveals molecular mechanisms of atopic dermatitis | 2025 | Nature Communications | https://www.nature.com/articles/s41467-025-58310-7 |
| Transcriptome-wide analyses delineate the genetic architecture of expression variation in atopic dermatitis | 2025 | Cell Reports Genetics & Genomics Advances | https://www.cell.com/hgg-advances/fulltext/S2666-2477(25)00025-9 |
| Multi-ancestry Genome-Wide Association Meta-Analysis Identifies Novel Loci in Atopic Dermatitis | 2024 (preprint June) / 2025 (published) | Nature Communications | https://www.medrxiv.org/content/10.1101/2024.06.17.24308897v1 / https://pmc.ncbi.nlm.nih.gov/articles/PMC11213042/ |
| European and multi-ancestry genome-wide association meta-analysis of atopic dermatitis highlights importance of systemic immune regulation | 2023 | Nature Communications | https://www.nature.com/articles/s41467-023-41180-2 |
| Multi-ancestry genome-wide association study of 21,000 cases and 95,000 controls identifies new risk loci for atopic dermatitis | 2015 | Nature Genetics | https://www.nature.com/articles/ng.3424 |
| Integrative transcriptome-wide analysis of atopic dermatitis for drug repositioning | 2022 | Communications Biology | https://www.nature.com/articles/s42003-022-03564-w |
| Polygenic transcriptome risk scores enhance predictive accuracy in atopic dermatitis | 2025 | Journal of Translational Medicine | https://link.springer.com/article/10.1186/s12967-025-06570-8 |
| Mendelian Randomization Studies in Atopic Dermatitis: A Systematic Review | 2023 | Journal of Investigative Dermatology | https://www.sciencedirect.com/science/article/pii/S0022202X2303052X |
| Triangulating Molecular Evidence to Prioritize Candidate Causal Genes at Established Atopic Dermatitis Loci | 2022 | Nature Immunology | https://pmc.ncbi.nlm.nih.gov/articles/PMC8592116/ |
| The IL-13-OVOL1-FLG axis in atopic dermatitis | 2019 | Allergy & Immunology Reviews | https://pmc.ncbi.nlm.nih.gov/articles/PMC6856930/ |
| Mendelian randomization studies in atopic dermatitis: causal insights across omics layers | 2026 | Frontiers in Immunology | https://www.frontiersin.org/journals/immunology/articles/10.3389/fimmu.2026.1717812/full |
| Rare variant analysis in eczema identifies exonic variants in DUSP1, NOTCH4 and SLC9A4 | 2021 | Nature Communications | https://www.nature.com/articles/s41467-021-26783-x |

## Open questions

- **Cross-ancestry validation of TWAS hits**: Most eQTL panels and TWAS weights derived from European populations; skin eQTL portability to African, Asian, Latin American populations remains poorly characterized
- **Rare variant and structural variant contribution**: Whole-genome sequencing in large AD cohorts pending; impact on TWAS power unclear
- **Tissue-specific causality in keratinocytes vs. immune cells**: Single-cell eQTL data for AD skin & immune cells still nascent; future integration into TWAS framework will refine cell-type-specific causal genes
- **PTRS clinical utility in diverse ancestries**: Promise of polygenic transcriptome risk scores not yet validated for clinical phenotypes (disease severity, response to therapy) in non-European populations
- **Age-of-onset and disease endotypes**: Genetic architecture of early-onset vs. adult-onset AD incompletely characterized; subphenotype-specific GWAS may reveal distinct biology
- **Drug target prioritization within loci**: Fine-mapping and colocalization reduce loci to ~10–15 candidate genes per region; functional validation (CRISPR, small molecules) still required for most targets
- **Mendelian randomization on intermediate phenotypes**: Causal links between AD and biomarkers (IgE, Type 2 cytokines, barrier function markers) remain underexplored

## Sources

- [European and multi-ancestry genome-wide association meta-analysis of atopic dermatitis highlights importance of systemic immune regulation](https://www.nature.com/articles/s41467-023-41180-2)
- [Multi-ancestry Genome-Wide Association Meta-Analysis Identifies Novel Loci in Atopic Dermatitis (Nature Communications, 2025)](https://pmc.ncbi.nlm.nih.gov/articles/PMC11213042/)
- [Integration of GWAS, QTLs and keratinocyte functional assays reveals molecular mechanisms of atopic dermatitis](https://www.nature.com/articles/s41467-025-58310-7)
- [Transcriptome-wide analyses delineate the genetic architecture of expression variation in atopic dermatitis](https://www.cell.com/hgg-advances/fulltext/S2666-2477(25)00025-9)
- [Multi-ancestry genome-wide association study of 21,000 cases and 95,000 controls identifies new risk loci for atopic dermatitis (Paternoster 2015)](https://www.nature.com/articles/ng.3424)
- [Integrative transcriptome-wide analysis of atopic dermatitis for drug repositioning](https://www.nature.com/articles/s42003-022-03564-w)
- [Polygenic transcriptome risk scores enhance predictive accuracy in atopic dermatitis](https://link.springer.com/article/10.1186/s12967-025-06570-8)
- [Mendelian Randomization Studies in Atopic Dermatitis: A Systematic Review](https://www.sciencedirect.com/science/article/pii/S0022202X2303052X)
- [Triangulating Molecular Evidence to Prioritize Candidate Causal Genes at Established Atopic Dermatitis Loci](https://pmc.ncbi.nlm.nih.gov/articles/PMC8592116/)
- [The IL-13-OVOL1-FLG axis in atopic dermatitis](https://pmc.ncbi.nlm.nih.gov/articles/PMC6856930/)
- [Rare variant analysis in eczema identifies exonic variants in DUSP1, NOTCH4 and SLC9A4](https://www.nature.com/articles/s41467-021-26783-x)
- [EAGLE Eczema Consortium GWAS Summary Statistics (Bristol Data Portal)](http://data.bris.ac.uk/data/dataset/28uchsdpmub118uex26ylacqm)
- [Atopic Dermatitis GWAS meta-analysis summary statistics (FigShare)](https://plus.figshare.com/articles/dataset/Atopic_Dermatitis_GWAS_meta-analysis_summary_statistics/25551810)
- [FinnGen Atopic Dermatitis Phenotype (Risteys)](https://r8.risteys.finngen.fi/phenocode/L12_ATOPIC)
- [IEU OpenGWAS Project](https://gwas.mrcieu.ac.uk/datasets/bbj-a-90/)
- [Mendelian randomization studies in atopic dermatitis: causal insights across omics layers](https://www.frontiersin.org/journals/immunology/articles/10.3389/fimmu.2026.1717812/full)
