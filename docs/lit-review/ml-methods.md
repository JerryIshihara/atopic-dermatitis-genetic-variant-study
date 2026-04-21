# Atopic Dermatitis — Deep Learning & Statistical Methodology

## Overview

Computational methods have become central to AD research, spanning image-based disease quantification, multi-omics integration, and causal inference for drug target identification. Recent advances (2024–2026) combine classical GWAS/TWAS architectures with foundation models, graph neural networks, and Bayesian meta-analysis to prioritize therapeutic targets and predict patient trajectories. This document surveys methods most applicable to transcriptome-wide association pipelines (S-PrediXcan, FUSION) and their downstream analysis.

## Deep learning applications

### Imaging & severity scoring

- **Vision Transformer & CNN automation**: Vision-Language Models (VLMs) and Convolutional Neural Networks (ResNet, GoogLeNet, VGG) trained on skin photographs automatically predict EASI, SCORAD, and IGA scores at dermatologist-level performance. Recent 2025 work demonstrates VLM superiority in grading AD severity from clinical images.
  - Refs: [Automated severity scoring of atopic dermatitis patients by a deep neural network](https://www.nature.com/articles/s41598-021-85489-8); [Vision-Language Models and Automated Grading of Atopic Dermatitis](https://arxiv.org/html/2505.17835)

### Single-cell & spatial transcriptomics

- **Transformer architectures for scRNA-seq & spatial data**: Deep learning surveys (2025, *Briefings in Bioinformatics*) review transformer-based approaches for single-cell and spatial transcriptomics, with AD-specific applications identifying inflammatory fibroblast, macrophage, and T-cell interactions via ligand-receptor inference on spatial coordinates.
  - Refs: [Deep Learning in Single-Cell and Spatial Transcriptomics Data Analysis: Advances and Challenges from a Data Science Perspective](https://academic.oup.com/bib/article/26/2/bbaf136/8106554); [Spatial transcriptomics combined with single-cell RNA-sequencing unravels the complex inflammatory cell network in atopic dermatitis](https://pubmed.ncbi.nlm.nih.gov/37312623/)

- **Cell-type annotation & spatial mapping**: Integration of spatial and single-cell data enables identification of COL18A1+ fibroblasts, CCL13/CCL18+ M2 macrophages, and LAMP3+ dendritic cells, revealing cell–cell crosstalk networks critical for therapeutic target discovery.

### Drug-target & repurposing models

- **Graph Neural Networks (GNNs)**: DTD-GNN and TxGNN (trained on medical knowledge graphs using metric learning) rank drug–disease pairs; GCNs and GATs aggregate neighborhood information for drug-target interaction prediction. GNN-based repurposing applied to ~17,000 diseases (not yet routinely AD-specific), but framework transferable.
  - Refs: [Drug repurposing based on the DTD-GNN graph neural network](https://pmc.ncbi.nlm.nih.gov/articles/PMC11165810/); [An interpretable geometric graph neural network for enhancing the generalizability of drug–target interaction prediction](https://pmc.ncbi.nlm.nih.gov/articles/PMC12659342/); [A foundation model for clinician-centered drug repurposing](https://www.nature.com/articles/s41591-024-03233-x)

### NLP & multimodal

- **EHR phenotyping & clinical trial recruitment**: Transformer-based NLP models identify AD cohorts from EHRs; 2024 study validates automated patient phenotyping to accelerate trial enrollment. LLM analysis of medical literature and trial outcomes outperforms expert GP responses on AD questions.
  - Refs: [Patient Phenotyping for Atopic Dermatitis With Transformers and Machine Learning](https://formative.jmir.org/2024/1/e52200); [Advancements in artificial intelligence for atopic dermatitis: diagnosis, treatment, and patient management](https://www.tandfonline.com/doi/full/10.1080/07853890.2025.2484665); [Natural language processing in dermatology: A systematic literature review and state of the art](https://pmc.ncbi.nlm.nih.gov/articles/PMC11587683/)

- **Multimodal patient trajectories**: Integration of dermatology images + EHR structured data (e.g., EASI scores, medication history) enables early flare prediction (not yet published specifically for AD; general framework emerging).

## Statistical methodology

### Mendelian randomization

- **Two-sample MR & bidirectional inference**: Multiple recent studies (2024–2025) apply two-sample MR to identify causal relationships between AD and comorbidities (psychiatric disorders, obesity, asthma, heart failure, rheumatoid arthritis, conjunctivitis). Systematic review and individual studies confirm body mass index, gut microbiota, IL-18 signaling, and GERD as causal for AD; AD causal for several downstream phenotypes.
  - Refs: [Mendelian Randomization Studies in Atopic Dermatitis: A Systematic Review](https://pubmed.ncbi.nlm.nih.gov/37977498/); [Mendelian randomization studies in atopic dermatitis: causal insights across omics layers](https://www.frontiersin.org/journals/immunology/articles/10.3389/fimmu.2026.1717812/full); [Bidirectional Relationship Between Atopic Dermatitis and Psychiatric Comorbidities](https://pubmed.ncbi.nlm.nih.gov/40375535/); [Causal relationships between atopic dermatitis and psychiatric disorders: a bidirectional two-sample Mendelian randomization study](https://link.springer.com/article/10.1186/s12888-023-05478-1)

- **Proteome-wide MR**: Comprehensive proteome MR study identified 17 proteins with colocalization evidence (coloc, PPH4 86–100%) for AD risk: CD33, ECM1, IL6R, IL6ST, LTA, RARRES2, SERPINC1, and others. Framework applicable post-TWAS for protein-level causal prioritization.
  - Refs: [Identifying novel risk targets in inflammatory skin diseases by comprehensive proteome-wide Mendelian randomization study](https://doi.org/10.1093/postmj/qgaf032)

### Colocalization & fine-mapping

- **Coloc + SuSiE post-TWAS**: Recent AD TWAS (2025) integrates colocalization to pinpoint shared causal variants between eQTLs and AD GWAS signals. Proteome-wide AD study yielded 17 colocalized proteins (PPH4 > 86%), suggesting coloc workflow is feasible post-S-PrediXcan output to filter gene–disease pairs.
  - Refs: Above proteome-wide MR study; [Transcriptome-wide analyses delineate the genetic architecture of expression variation in atopic dermatitis](https://www.cell.com/hgg-advances/fulltext/S2666-2477(25)00025-9)

### TWAS methods applied to AD

- **S-PrediXcan & tissue-specificity**: Recent 2025 study applied S-PrediXcan across 7 tissues (sun-exposed skin, non-sun-exposed skin, whole blood, etc.), identifying 175 genes (72 unique) at Bonferroni P < 5.79 × 10⁻⁷. OTTERS pipeline (2025) extends PrediXcan using multiple eQTL assumptions.
  - Refs: [Polygenic transcriptome risk scores enhance predictive accuracy in atopic dermatitis](https://link.springer.com/article/10.1186/s12967-025-06570-8); [Transcriptome-wide analyses delineate the genetic architecture of expression variation in atopic dermatitis](https://www.cell.com/hgg-advances/fulltext/S2666-2477(25)00025-9)

- **Integration with drug repurposing**: One 2022 study combined TWAS with network pharmacology and functional analysis to nominate repositioning candidates for AD. TWAS-identified genes serve as entry points for drug–gene interaction networks.
  - Refs: [Integrative transcriptome-wide analysis of atopic dermatitis for drug repositioning](https://www.nature.com/articles/s42003-022-03564-w)

### PRS & cross-ancestry

- **Polygenic Transcriptome Risk Scores (PTRSs)**: 2025 study constructed AD PTRSs from tissue-enriched eQTLs, combining PRS and single-tissue PTRSs. In 256,888 Europeans (10,816 cases), combined PRS+PTRS achieved c-statistic 0.646 (95% CI: 0.634–0.656), outperforming either alone.
  - Refs: [Polygenic transcriptome risk scores enhance predictive accuracy in atopic dermatitis](https://link.springer.com/article/10.1186/s12967-025-06570-8)

- **Cross-ancestry generalizability**: Gene-expression-based PTRSs theoretically more portable across ancestry than genomic PRS (shared regulatory logic across populations), but practical validation in non-European cohorts remains limited. One study notes reduced PRS portability; PTRS framework may improve cross-ancestry prediction.
  - Refs: [Polygenic risk score portability for common diseases across genetically diverse populations](https://link.springer.com/article/10.1186/s40246-024-00664-y)

### Multi-trait & meta-analysis

- **Network meta-analysis of biologics**: Living systematic review (2024–2025) using Bayesian network meta-analysis with random-effects models compares lebrikizumab, dupilumab, and JAK inhibitors. Between-study priors informed by Cochrane meta-analyses (n=14,886) to handle network sparsity.
  - Refs: [Systemic Immunomodulatory Treatments for Atopic Dermatitis: Living Systematic Review and Network Meta-Analysis Update](https://pubmed.ncbi.nlm.nih.gov/39018058/); [Comparative Efficacy of Targeted Systemic Therapies for Moderate to Severe Atopic Dermatitis: Systematic Review and Network Meta-analysis](https://link.springer.com/article/10.1007/s13555-022-00721-1)

- **Bayesian approaches**: Model-based meta-analysis of RCTs using Bayesian fixed/random-effects frameworks; not yet combined with causal inference, but framework amenable to target-trial emulation post-TWAS.

## Methods most relevant to this repo's TWAS pipeline

For integration into S-PrediXcan / MetaXcan workflows:

1. **Immediate post-TWAS layer**: Apply **coloc or coloc+SuSiE** to TWAS-prioritized genes using eQTL summary statistics and AD GWAS variants. Retain genes with PPH4 > 0.8 (high colocalization).

2. **Causal filtering**: Implement **two-sample MR** (MR-Egger for slope pleiotropy check) on TWAS gene–expression associations to confirm directionality (e.g., is genetically predicted IL6R expression causal for AD, or reverse?).

3. **Protein-level validation**: Link TWAS genes to proteome-wide MR catalog (17 AD-colocalized proteins) to prioritize targetable proteins.

4. **Graph neural networks**: Map colocalized TWAS genes to drug-target-disease networks (GNN models, TxGNN) to nominate repurposing candidates.

5. **Clinical stratification**: Use tissue-specific PTRS scores from TWAS-derived eQTLs to stratify patients (e.g., IL-4/IL-13 pathway vs. JAK/STAT signature) for precision medicine assignment in trials.

6. **Trial meta-analysis**: Post-nomination, layer Bayesian network meta-analysis to compare nominated therapies in published RCTs.

## Notable papers

| Title | Year | Venue | Method | URL |
|---|---|---|---|---|
| Mendelian Randomization Studies in Atopic Dermatitis: A Systematic Review | 2023 | *J Invest Dermatol* | MR systematic review | https://pubmed.ncbi.nlm.nih.gov/37977498/ |
| Polygenic transcriptome risk scores enhance predictive accuracy in atopic dermatitis | 2025 | *J Transl Med* | PTRS + PRS | https://link.springer.com/article/10.1186/s12967-025-06570-8 |
| Transcriptome-wide analyses delineate the genetic architecture of expression variation in atopic dermatitis | 2025 | *HGG Advances* | TWAS, OTTERS | https://www.cell.com/hgg-advances/fulltext/S2666-2477(25)00025-9 |
| Mendelian randomization studies in atopic dermatitis: causal insights across omics layers | 2026 | *Front Immunol* | MR multi-omics | https://www.frontiersin.org/journals/immunology/articles/10.3389/fimmu.2026.1717812/full |
| Integrative transcriptome-wide analysis of atopic dermatitis for drug repositioning | 2022 | *Commun Biol* | TWAS + drug networks | https://www.nature.com/articles/s42003-022-03564-w |
| Identifying novel risk targets in inflammatory skin diseases by comprehensive proteome-wide Mendelian randomization study | 2025 | *Postgrad Med J* | Proteome MR + coloc | https://doi.org/10.1093/postmj/qgaf032 |
| Deep Learning in Single-Cell and Spatial Transcriptomics Data Analysis: Advances and Challenges from a Data Science Perspective | 2025 | *Brief Bioinform* | Transformer survey | https://academic.oup.com/bib/article/26/2/bbaf136/8106554 |
| Patient Phenotyping for Atopic Dermatitis With Transformers and Machine Learning | 2024 | *JMIR Formative Res* | NLP phenotyping | https://formative.jmir.org/2024/1/e52200 |
| Vision-Language Models and Automated Grading of Atopic Dermatitis | 2025 | arXiv | VLM imaging | https://arxiv.org/html/2505.17835 |
| Systemic Immunomodulatory Treatments for Atopic Dermatitis: Living Systematic Review and Network Meta-Analysis Update | 2024 | *JACI* | Bayesian NMA | https://pubmed.ncbi.nlm.nih.gov/39018058/ |

## Open questions

- **MR-JTI for gene–drug interaction**: Joint test of interplay (MR-JTI) not yet applied to AD TWAS genes; potential for detecting gene–drug interaction effects in trials.
- **Cross-ancestry TWAS**: Most AD TWAS limited to European ancestry; development of shared eQTL reference panels (non-European skin) needed.
- **Temporal dynamics**: Multimodal models combining images + EHR to predict flare 1–4 weeks ahead remain proof-of-concept; deployment in prospective cohorts needed.
- **Graph NN validation**: DTD-GNN and TxGNN outputs for AD have not yet been prospectively validated in clinical trials.
- **MTAG / multi-phenotype TWAS**: Joint TWAS of AD + asthma/allergic rhinitis to capture pleiotropy; few published examples.

## Sources

- https://pubmed.ncbi.nlm.nih.gov/37977498/
- https://www.frontiersin.org/journals/immunology/articles/10.3389/fimmu.2026.1717812/full
- https://doi.org/10.1093/postmj/qgaf032
- https://pubmed.ncbi.nlm.nih.gov/40375535/
- https://link.springer.com/article/10.1186/s12888-023-05478-1
- https://pmc.ncbi.nlm.nih.gov/articles/PMC11165810/
- https://pmc.ncbi.nlm.nih.gov/articles/PMC12659342/
- https://www.nature.com/articles/s41591-024-03233-x
- https://formative.jmir.org/2024/1/e52200
- https://www.tandfonline.com/doi/full/10.1080/07853890.2025.2484665
- https://pmc.ncbi.nlm.nih.gov/articles/PMC11587683/
- https://www.nature.com/articles/s41598-021-85489-8
- https://arxiv.org/html/2505.17835
- https://academic.oup.com/bib/article/26/2/bbaf136/8106554
- https://pubmed.ncbi.nlm.nih.gov/37312623/
- https://link.springer.com/article/10.1186/s12967-025-06570-8
- https://www.cell.com/hgg-advances/fulltext/S2666-2477(25)00025-9
- https://www.nature.com/articles/s42003-022-03564-w
- https://link.springer.com/article/10.1186/s40246-024-00664-y
- https://pubmed.ncbi.nlm.nih.gov/39018058/
- https://link.springer.com/article/10.1007/s13555-022-00721-1
