# Atopic Dermatitis — Drug Repurposing Candidates

## Overview

Atopic dermatitis (AD) represents a significant repurposing opportunity due to: (1) high disease burden and inadequate control with current standard-of-care therapies (topical corticosteroids, calcineurin inhibitors); (2) well-characterized GWAS-identified genetic architecture (>90 loci) mapping to immune regulation and barrier function, enabling genetics-driven target discovery; (3) established preclinical and clinical signatures from lesional/non-lesional skin biopsies enabling computational approaches (Connectivity Map, network pharmacology); (4) growing clinical validation of immunomodulatory repurposing (JAK inhibitors from rheumatoid arthritis, monoclonal antibodies from other immune diseases); and (5) unmet needs in pediatric AD and treatment-resistant disease. The convergence of GWAS/TWAS insights, computational drug-disease signature reversal, and existing biomarker-driven diagnostics positions AD as a tractable repurposing pipeline.

## Approved drugs in AD clinical testing

| Drug | Original Indication | AD Trial Status | MoA Relevant to AD | Source |
|---|---|---|---|---|
| Baricitinib | Rheumatoid arthritis | **FDA approved 2023** for mod-severe AD | JAK1/2 inhibitor; blocks IL-6, GM-CSF signaling | [JAMA Dermatology](https://jamanetwork.com/journals/jamadermatology/fullarticle/2771084) |
| Tofacitinib | Rheumatoid arthritis, UC, psoriatic arthritis | **Phase 2 clinical** (open-label, n=6) for mod-severe AD | Pan-JAK (predominantly JAK1/3) | [ScienceDirect](https://www.sciencedirect.com/science/article/abs/pii/S1081120623000753) |
| Lebrikizumab | Mild-moderate AD, asthma | **FDA approved 2024** for mod-severe AD; Phase 3 completed | Anti-IL-13 mAb (selective for IL-4Rα/IL-13Rα1) | [NEJM](https://www.nejm.org/doi/full/10.1056/NEJMoa2206714) |
| Tralokinumab | Asthma | **FDA approved 2023** for mod-severe AD; Phase 3 completed | Anti-IL-13 mAb (targets both IL-13Rα1 and IL-13Rα2) | [Allergy 2023](https://onlinelibrary.wiley.com/doi/10.1111/all.15811) |
| Roflumilast | Plaque psoriasis (topical) | **FDA approved July 2024** for mild-mod AD | PDE4 inhibitor; reduces cAMP-dependent inflammation | [Dermatology Times](https://www.dermatologytimes.com/view/highlighting-major-breakthroughs-for-atopic-dermatitis-and-psoriasis-in-2025) |
| Tapinarof | Plaque psoriasis | **FDA approved Dec 2024** for mod-severe AD (≥2y) | Aryl hydrocarbon receptor (AhR) agonist | [GlobalRPH](https://globalrph.com/2026/04/new-treatments-for-atopic-dermatitis-in-2026-why-more-options-might-be-making-your-choice-harder/) |
| Nemolizumab | First-in-class | **FDA approved Dec 2024** for mod-severe AD (≥12y) | Anti-IL-31 mAb; targets key pruritus cytokine | [GlobalRPH](https://globalrph.com/2026/04/new-treatments-for-atopic-dermatitis-in-2026-why-more-options-might-be-making-your-choice-harder/) |
| Apremilast | Psoriasis, psoriatic arthritis, behçet's | **Phase 2 completed (185 patients)** for AD | PDE4 inhibitor; suppresses IL-4 on keratinocytes | [JAAD 2017](https://www.jaad.org/article/S0190-9622(17)30379-1/fulltext); [Frontiers Pharmacology 2025](https://www.frontiersin.org/journals/pharmacology/articles/10.3389/fphar.2025.1633426/full) |
| Nintedanib | Idiopathic pulmonary fibrosis | **Preclinical (animal model)** for oxazolone-induced dermatitis | RTK inhibitor (VEGFR1/2, FGFR1/2); attenuates Th2, reduces angiogenesis | [Scientific Reports 2020](https://www.nature.com/articles/s41598-020-61424-1) |
| Low-dose naltrexone (LDN) | Chronic pain, immunomodulation | **Small open-label data** for itch; topical naltrexone 1% showed 29% improvement at 2 weeks in severe AD | Opioid antagonist; increases κ>μ receptor expression; blocks TLR4 | [JAAD 2025](https://www.jaad.org/article/S0190-9622(25)02812-9/abstract); [LDN Research Trust](https://ldnresearchtrust.org/low-dose-naltrexone-atopic-dermatitis-news) |
| Bilastine | Chronic spontaneous urticaria | **Not formally tested in AD**, but shown superior H1 antagonism in vitro | Second-generation H1 antihistamine; fastest onset vs. rupatadine/desloratadine | [PubMed](https://pubmed.ncbi.nlm.nih.gov/27659218/) |
| Rupatadine | Chronic spontaneous urticaria, pruritus | **Clinical benefit shown** (n=132 patients, ≥66 with AD) for itch reduction | H1 antagonist + PAF receptor antagonist; 10–20 mg doses effective long-term | [Journal of Dermatological Science 2019](https://www.jdsjournal.com/article/S0923-1811(19)30146-X/fulltext) |
| Saroglitazar | Diabetic dyslipidemia | **Under investigation** for AD (preclinical) | Dual PPARα/γ agonist; anti-inflammatory without corticosteroid AE | [Frontiers Allergy 2026](https://www.frontiersin.org/journals/allergy/articles/10.3389/falgy.2026.1780908/full) |
| BEN-2293 (pan-Trk inhibitor) | BenevolentAI in-house discovery | **Phase 2 terminated**; did NOT meet efficacy endpoints for itch/inflammation despite safety | Neurotrophic kinase inhibitor; designed for AD via AI | [pharmaphorum](https://pharmaphorum.com/news/benevolentai-lead-atopic-dermatitis-drug-misses-mark) |

## Computational / signature-based repurposing hits

### Network Pharmacology & Gene Prioritization from GWAS

- **Methodology**: Integrated GWAS catalog AD risk SNPs (n=70) → functional annotation filtering (6 criteria: missense, eQTL, KO phenotypes, GO, KEGG, PID association) → identified 27 "biological AD risk genes" → STRING database expansion to 76 drug target genes → mapping to DrugBank/TTD → identified 53 candidate drugs, **10 with clinical/preclinical AD evidence**.
  
- **Top candidates validated**:
  - **JAK inhibitors** (baricitinib, tofacitinib, ruxolitinib, upadacitinib, momelotinib, filgotinib, fedratinib)
  - **IL-13 monoclonal antibodies** (lebrikizumab, tralokinumab)
  - **IL-6 antagonist** (tocilizumab)
  - **IL-1β antagonist** (canakinumab)
  - **IL-4Rα antagonist** (pitrakinra)
  - **Method successfully re-identified dupilumab** (FDA-approved), validating approach.
  
- **Citation**: [Frontiers Immunology 2021](https://www.frontiersin.org/journals/immunology/articles/10.3389/fimmu.2021.724277/full); [PMC](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC8548825/)

### Mendelian Randomization & Multi-Omic Prioritization

- **Methodology**: Combine GWAS signals + eQTL/pQTL colocalization + single-cell transcriptomics → identify **32 causal druggable genes** for AD, 12 with strong colocalization evidence.
  
- **Key druggable targets identified**:
  - CD52 (alemtuzumab available)
  - IL2RA (daclizumab available)
  - TNF axis (TNF inhibitors)
  - **Neuromedin B** (novel target, validated via MR + PCR in AD lesional skin)
  - RARRES2, SERPINC1, ECM1 (14 top-tier targets)
  
- **Citation**: [Frontiers Immunology 2026](https://www.frontiersin.org/journals/immunology/articles/10.3389/fimmu.2026.1717812/full); [Single-cell MR study](https://www.sciencedirect.com/science/article/abs/pii/S1567576926001748)

### LINCS L1000 / Connectivity Map (Signature Reversal)

- **Methodology**: Query AD lesional skin transcriptomic signature against LINCS L1000 reference library (~1M L1000 profiles across ~20K compounds, ~50 cell lines) → rank drugs by connectivity score (−1 = perfect reversal, +1 = perfect similarity) → lower scores = better disease reversal candidates.
  
- **Status**: Proof-of-concept framework established; specific AD-derived query signatures and top-ranked candidates **not yet published** in peer-reviewed literature. However, tools (L1000CDS2, metaLINCS R package) are available for community use.
  
- **Citation**: [Briefings Bioinformatics 2021](https://academic.oup.com/bib/article/22/6/bbab161/6278144) (methodology review); [metaLINCS package](https://academic.oup.com/bioinformaticsadvances/article/2/1/vbac064/6694866); [Important caveat: Nature Scientific Reports 2021](https://www.nature.com/articles/s41598-021-97005-z) noted limited reproducibility in drug repositioning studies using CMap alone — integration with orthogonal evidence critical.

---

## Genetics-driven target validation

### GWAS & Mendelian Randomization Evidence

**IL-13 and IL-4R pathways**:
- Th2 cells secrete IL-13, IL-31, IL-4 → core AD pathophysiology.
- GWAS identified IL13, IL4R loci; MR studies confirm **causal** relationship with AD risk.
- **Clinical validation**: Lebrikizumab (anti-IL-13) and tralokinumab (anti-IL-13) now FDA-approved for mod-severe AD; GWAS-based drug discovery successfully predicted both agents.

**Systemic immune regulation genes**:
- Recent 2023–2024 GWAS meta-analyses identified **91–101 AD loci** across multi-ancestry cohorts (56K+ cases, 600K+ controls).
- Fine-mapping + QTL colocalization linked genes to keratinocyte barrier function (FLG, SPINK5, KLK7), immune activation (IL-33, IL-22, JAK1/2/TYK2), and Th2 differentiation (STAT6, GATA3).
- **Actionable insight**: TYK2 inhibitors now in Phase 2 for AD; OX40-OX40L inhibitors expected 2026.

**Citation**: [Nature Communications 2023](https://www.nature.com/articles/s41467-023-41180-2); [medRxiv June 2024](https://www.medrxiv.org/content/10.1101/2024.06.17.24308897v1); [Cell HGG Advances 2025](https://www.cell.com/hgg-advances/fulltext/S2666-2477(25)00025-9)

---

## Data resources (for downstream repurposing work in this repo)

### Gene Expression & Transcriptomics Databases

- **GEO (Gene Expression Omnibus)**: https://www.ncbi.nlm.nih.gov/geo/
  - **GSE36842, GSE32924, GSE16161, GSE5667, GSE6012**: Curated AD microarray cohorts (127 samples, 80 AD biopsies) identifying 89 consensus AD gene expression signatures (89ADGES).
  - **GSE157194**: 166 high-throughput RNA-seq profiles of lesional/non-lesional AD skin (n=57 patients).
  - **GSE65832**: RNA-seq atopic dermatitis transcriptome profiling.
  - **Cross-disease harmonized dataset**: [Scientific Data 2020](https://www.nature.com/articles/s41597-020-00696-8) — 39 transcriptomics datasets (1,677 samples) for psoriasis and AD, standardized for comparative analyses.
  - **Relevance**: Enables creation of AD disease query signatures for LINCS L1000 connectivity mapping.

### Drug-Gene Interaction & Target Databases

- **DrugBank**: https://www.drugbank.ca/
  - 13K+ drugs linked to ~6K genes; includes mechanism of action, approved indications, trials.
  - **Relevance**: Maps AD risk genes to marketed/investigational drugs.

- **DGIdb 5.0**: https://dgidb.org/
  - Drug-gene interaction database (3 gene sources, 17 druggable sources, 6 drug sources).
  - Aggregates Drugs@FDA, ChemIDplus, HemOnc, RxNorm, HGNC.
  - **Relevance**: Screens for drug-target interactions among AD GWAS/MR-identified genes.

### Transcriptomic Signature Platforms

- **LINCS L1000 Connectivity Map**: https://maayanlab.cloud/Harmonizome/resource/LINCS+L1000+Connectivity+Map
  - ~1 million L1000 profiles (20K compounds, ~50 cell lines, dose-response).
  - **Tools**: L1000CDS2 (characteristic direction search engine), metaLINCS (R package for stratified mapping).
  - **Relevance**: Gold-standard for signature reversal-based repurposing; reproducibility improved by multi-omic integration.

- **iLINCS (Integrated Network-Based Cellular Signatures)**: https://ilincs.org/ (if accessible)
  - Disease expression profile repository; allows querying against LINCS signatures.

### Drug Target & Pathway Databases

- **Open Targets Platform**: https://platform.opentargets.org/
  - Integrates GWAS evidence, clinical data, functional genomics, and drug labels.
  - **For AD**: GWAS locus-to-gene widget, 102K+ clinical reports for 2,592 diseases.
  - **Relevance**: Visualize target-disease evidence; prioritize druggable AD targets (e.g., IL-13, IL-22, IL-33, JAK1/TYK2, OX40-OX40L).

- **Therapeutic Target Database (TTD)**: https://db.idrblab.net/ttd/
  - ~3,500 drug targets; curated clinical & preclinical trial data.
  - **Relevance**: Cross-reference GWAS/MR-identified genes with approved/investigational drugs.

### Structural Variant & Regulatory Annotation

- **GWAS Catalog**: https://www.ebi.ac.uk/gwas/
  - >300K published GWAS associations; AD subset includes >90 loci.
  - **Relevance**: Starting point for AD risk gene prioritization.

- **STRING Database**: https://string-db.org/
  - Protein-protein interaction network; used for expanding AD risk genes → drug target genes.
  - **Relevance**: Network propagation to identify co-functionally connected druggable targets.

---

## Notable papers

| Title | Year | Venue | URL |
|---|---|---|---|
| Drug Repurposing for Atopic Dermatitis by Integration of Gene Networking and Genomic Information | 2021 | Frontiers in Immunology | [https://www.frontiersin.org/journals/immunology/articles/10.3389/fimmu.2021.724277/full](https://www.frontiersin.org/journals/immunology/articles/10.3389/fimmu.2021.724277/full) |
| Integrative network analysis suggests prioritised drugs for atopic dermatitis | 2024 | Journal of Translational Medicine | [https://translational-medicine.biomedcentral.com/articles/10.1186/s12967-024-04879-4](https://translational-medicine.biomedcentral.com/articles/10.1186/s12967-024-04879-4) |
| European and multi-ancestry genome-wide association meta-analysis of atopic dermatitis highlights importance of systemic immune regulation | 2023 | Nature Communications | [https://www.nature.com/articles/s41467-023-41180-2](https://www.nature.com/articles/s41467-023-41180-2) |
| Multi-ancestry Genome-Wide Association Meta-Analysis Identifies Novel Loci in Atopic Dermatitis | 2024 | Nature Genetics / medRxiv | [https://www.medrxiv.org/content/10.1101/2024.06.17.24308897v1](https://www.medrxiv.org/content/10.1101/2024.06.17.24308897v1) |
| Transcriptome-wide analyses delineate the genetic architecture of expression variation in atopic dermatitis | 2025 | Cell HGG Advances | [https://www.cell.com/hgg-advances/fulltext/S2666-2477(25)00025-9](https://www.cell.com/hgg-advances/fulltext/S2666-2477(25)00025-9) |
| A Next Generation Connectivity Map: L1000 Platform and the First 1,000,000 Profiles | 2017 | Cell Systems | [https://pubmed.ncbi.nlm.nih.gov/29195078/](https://pubmed.ncbi.nlm.nih.gov/29195078/) |
| Reconciling multiple connectivity scores for drug repurposing | 2021 | Briefings in Bioinformatics | [https://academic.oup.com/bib/article/22/6/bbab161/6278144](https://academic.oup.com/bib/article/22/6/bbab161/6278144) |
| metaLINCS: an R package for meta-level analysis of LINCS L1000 drug signatures using stratified connectivity mapping | 2022 | Bioinformatics Advances | [https://academic.oup.com/bioinformaticsadvances/article/2/1/vbac064/6694866](https://academic.oup.com/bioinformaticsadvances/article/2/1/vbac064/6694866) |
| IL-13 inhibition in the treatment of atopic dermatitis – new and emerging biologic agents | 2024 | Therapeutic Advances in Chronic Disease | [https://journals.sagepub.com/doi/10.1177/03000605241286832](https://journals.sagepub.com/doi/10.1177/03000605241286832) |
| Two Phase 3 Trials of Lebrikizumab for Moderate-to-Severe Atopic Dermatitis | 2023 | New England Journal of Medicine | [https://www.nejm.org/doi/full/10.1056/NEJMoa2206714](https://www.nejm.org/doi/full/10.1056/NEJMoa2206714) |
| Apremilast treatment of atopic dermatitis and other chronic eczematous dermatoses | 2017 | JAAD | [https://www.jaad.org/article/s0190-9622(17)30379-1/fulltext](https://www.jaad.org/article/s0190-9622(17)30379-1/fulltext) |
| Low-dose naltrexone for treatment of dermatologic conditions: A clinical review | 2025 | JAAD | [https://www.jaad.org/article/S0190-9622(25)02812-9/abstract](https://www.jaad.org/article/S0190-9622(25)02812-9/abstract) |
| An In-depth Review of the Off-label Use of Apremilast in Dermatology | 2025 | Therapeutic Advances in Chronic Disease | [https://journals.sagepub.com/doi/full/10.1177/0976500X241303186](https://journals.sagepub.com/doi/full/10.1177/0976500X241303186) |
| Machine learning reveals distinct gene signature profiles in lesional and nonlesional regions of inflammatory skin diseases | 2022 | Science Advances | [https://www.science.org/doi/10.1126/sciadv.abn4776](https://www.science.org/doi/10.1126/sciadv.abn4776) |
| Neuromedin B identified as a therapeutic target for atopic dermatitis: evidence from Mendelian randomization and PCR validation | 2024 | Frontiers in Medicine | [https://www.frontiersin.org/journals/medicine/articles/10.3389/fmed.2025.1660249/full](https://www.frontiersin.org/journals/medicine/articles/10.3389/fmed.2025.1660249/full) |
| Efficacy and safety of baricitinib combined with topical corticosteroids for treatment of moderate to severe atopic dermatitis: A randomized clinical trial | 2020 | JAMA Dermatology | [https://jamanetwork.com/journals/jamadermatology/fullarticle/2771084](https://jamanetwork.com/journals/jamadermatology/fullarticle/2771084) |
| PPARγ: a key orchestrator of epidermal barrier, immune responses, and lipid metabolism in atopic dermatitis pathogenesis and therapy | 2026 | Frontiers in Allergy | [https://www.frontiersin.org/journals/allergy/articles/10.3389/falgy.2026.1780908/full](https://www.frontiersin.org/journals/allergy/articles/10.3389/falgy.2026.1780908/full) |
| Nintedanib ameliorates animal model of dermatitis | 2020 | Scientific Reports | [https://www.nature.com/articles/s41598-020-61424-1](https://www.nature.com/articles/s41598-020-61424-1) |

---

## Open questions

- **Which AD-specific query signatures (lesional vs. non-lesional vs. dynamic flare) perform best in LINCS L1000 connectivity mapping for robust repurposing hits?** Current literature describes methodology but lacks systematic comparison of signature designs.

- **Do PPAR-γ agonists (e.g., saroglitazar) overcome systemic safety liabilities (weight gain, fluid retention, cardiovascular risk) of thiazolidinediones in long-term AD trials?** Preclinical data promising; clinical translation stalled.

- **Why did BenevolentAI's BEN-2293 (pan-Trk inhibitor) fail on itch/inflammation endpoints despite preclinical neurotrophic signaling rationale?** Post-mortem mechanistic analysis needed to avoid repeating failures.

- **Can rupatadine's dual H1/PAF antagonism be leveraged for combination therapy with dupilumab or JAK inhibitors for refractory pruritus?** Open clinical question.

- **Which Mendelian randomization-identified targets (RARRES2, SERPINC1, ECM1, neuromedin B) are tractable for small-molecule or biologic development, and do existing drugs modulate them?**

- **Are anti-staphylococcal strategies (mupirocin, antiseptics) actually repurposable, or does increasing resistance render them obsolete for AD management?** Clinical utility declining; need for alternatives.

- **How well do network pharmacology-identified JAK inhibitors other than baricitinib (tofacitinib, ruxolitinib, fedratinib) translate to AD clinical efficacy and safety?** Individual agent validation needed beyond theoretical predictions.

---

## Sources

- [JAMA Dermatology (2020) — Baricitinib + topical corticosteroids RCT](https://jamanetwork.com/journals/jamadermatology/fullarticle/2771084)
- [NEJM (2023) — Lebrikizumab Phase 3 AD trials](https://www.nejm.org/doi/full/10.1056/NEJMoa2206714)
- [Allergy (2023) — Tralokinumab clinical outcomes](https://onlinelibrary.wiley.com/doi/10.1111/all.15811)
- [Dermatology Times (2025) — 2025 AD breakthroughs](https://www.dermatologytimes.com/view/highlighting-major-breakthroughs-for-atopic-dermatitis-and-psoriasis-in-2025)
- [GlobalRPH (2026) — New AD treatments 2026](https://globalrph.com/2026/04/new-treatments-for-atopic-dermatitis-in-2026-why-more-options-might-be-making-your-choice-harder/)
- [Frontiers Immunology (2021) — Drug repurposing via gene networking](https://www.frontiersin.org/journals/immunology/articles/10.3389/fimmu.2021.724277/full)
- [Journal of Translational Medicine (2024) — Integrative network analysis prioritized drugs](https://translational-medicine.biomedcentral.com/articles/10.1186/s12967-024-04879-4)
- [Nature Communications (2023) — Multi-ancestry GWAS meta-analysis](https://www.nature.com/articles/s41467-023-41180-2)
- [medRxiv (2024) — Multi-ancestry GWAS identifies novel loci](https://www.medrxiv.org/content/10.1101/2024.06.17.24308897v1)
- [Cell HGG Advances (2025) — Transcriptome-wide analyses](https://www.cell.com/hgg-advances/fulltext/S2666-2477(25)00025-9)
- [Cell Systems (2017) — LINCS L1000 platform](https://pubmed.ncbi.nlm.nih.gov/29195078/)
- [Briefings in Bioinformatics (2021) — Reconciling connectivity scores](https://academic.oup.com/bib/article/22/6/bbab161/6278144)
- [Bioinformatics Advances (2022) — metaLINCS R package](https://academic.oup.com/bioinformaticsadvances/article/2/1/vbac064/6694866)
- [Therapeutic Advances in Chronic Disease (2024) — IL-13 inhibition review](https://journals.sagepub.com/doi/10.1177/03000605241286832)
- [JAAD (2017) — Apremilast treatment of atopic dermatitis](https://www.jaad.org/article/s0190-9622(17)30379-1/fulltext)
- [JAAD (2025) — Low-dose naltrexone clinical review](https://www.jaad.org/article/S0190-9622(25)02812-9/abstract)
- [Therapeutic Advances in Chronic Disease (2025) — Off-label apremilast review](https://journals.sagepub.com/doi/full/10.1177/0976500X241303186)
- [Science Advances (2022) — Machine learning gene signatures](https://www.science.org/doi/10.1126/sciadv.abn4776)
- [Frontiers in Medicine (2024) — Neuromedin B MR validation](https://www.frontiersin.org/journals/medicine/articles/10.3389/fmed.2025.1660249/full)
- [ScienceDirect (2019) — Rupatadine long-term safety in Japanese patients](https://www.jdsjournal.com/article/S0923-1811(19)30146-X/fulltext)
- [Nature Scientific Reports (2020) — Nintedanib in animal dermatitis model](https://www.nature.com/articles/s41598-020-61424-1)
- [Frontiers in Allergy (2026) — PPARγ in AD pathogenesis](https://www.frontiersin.org/journals/allergy/articles/10.3389/falgy.2026.1780908/full)
- [Frontiers in Pharmacology (2025) — Apremilast narrative review](https://www.frontiersin.org/journals/pharmacology/articles/10.3389/fphar.2025.1633426/full)
- [pharmaphorum (2024) — BenevolentAI BEN-2293 Phase 2 failure](https://pharmaphorum.com/news/benevolentai-lead-atopic-dermatitis-drug-misses-mark)
- [LDN Research Trust — Low-dose naltrexone and AD news](https://ldnresearchtrust.org/low-dose-naltrexone-atopic-dermatitis-news)
- [Gene Expression Omnibus (GEO)](https://www.ncbi.nlm.nih.gov/geo/)
- [Scientific Data (2020) — Harmonized transcriptomics datasets](https://www.nature.com/articles/s41597-020-00696-8)
- [DrugBank](https://www.drugbank.ca/)
- [DGIdb 5.0](https://dgidb.org/)
- [Open Targets Platform](https://platform.opentargets.org/)
- [LINCS L1000 Connectivity Map](https://maayanlab.cloud/Harmonizome/resource/LINCS+L1000+Connectivity+Map)
- [L1000CDS2 Tool](https://maayanlab.cloud/L1000CDS2/)
- [STRING Database](https://string-db.org/)
- [GWAS Catalog](https://www.ebi.ac.uk/gwas/)
- [Frontiers in Immunology (2026) — Mendelian randomization studies](https://www.frontiersin.org/journals/immunology/articles/10.3389/fimmu.2026.1717812/full)
- [Nature Scientific Reports (2021) — Limited CMap reproducibility caveat](https://www.nature.com/articles/s41598-021-97005-z)
