# Research Plan: Side-Effect Prediction and Causal Safety Analysis for Atopic Dermatitis Drug Repurposing

## 0. One-Sentence Summary

This project extends the current atopic dermatitis (AD) drug-repurposing pipeline from **transcriptomic candidate discovery** to **benefit-risk-aware candidate prioritization** by integrating side-effect prediction, pharmacovigilance evidence, drug-target genetics, Mendelian randomization, and network visualization.

---

## 1. Background and Motivation

The current AD genetic-variant and drug-repurposing project follows a pipeline similar to:

```text
AD GWAS / TWAS / disease expression signature
→ LINCS L1000 / CMap drug perturbation reversal
→ candidate drugs
→ literature-based safety annotation
```

This is a reasonable exploratory drug-repurposing direction. LINCS L1000 / Connectivity Map is designed to compare disease-associated gene-expression signatures with drug-induced perturbation signatures, which makes it useful for transcriptomic drug repurposing and mechanism discovery. The LINCS L1000 resource contains large-scale perturbational expression profiles across compounds, genetic perturbations, and cell contexts.

However, the existing safety component is mostly **manual annotation**. For example, JAK inhibitors are annotated with infection / herpes / MACE / VTE warnings; biologics are annotated with ocular adverse events or injection-site reactions; PDE4 inhibitors are annotated with gastrointestinal tolerability issues. This is useful, but it is not yet a systematic **side-effect prediction** or **causal safety analysis** framework.

The proposed extension asks a stronger question:

> For AD drug-repurposing candidates identified from genetic, transcriptomic, and perturbational evidence, can we predict adverse-event profiles and distinguish target-mediated causal safety risks from non-causal pharmacovigilance associations?

This is important because AD is a chronic disease. A candidate drug can have a strong disease-signature reversal score but still be clinically unsuitable if it carries systemic infection, malignancy, cardiovascular, thrombotic, ocular, gastrointestinal, or hepatic risks.

---

## 2. Overall Objective

Build a **safety-aware AD drug-repurposing framework** that integrates:

```text
1. AD disease biology
   GWAS / TWAS / disease expression / pathway enrichment

2. Drug perturbation evidence
   LINCS L1000 / CMap reversal score

3. Side-effect prediction
   SIDER / FAERS / FDA labels / drug targets / chemical fingerprints / transcriptomic signatures

4. Causal safety analysis
   drug-target Mendelian randomization / colocalization / phenome-wide safety scan

5. Final prioritization
   benefit score + predicted safety risk + causal safety evidence + clinical feasibility
```

The final output should not be a simple list of high-reversal drugs. It should be a structured table and network showing:

```text
candidate drug
→ AD biological rationale
→ LINCS reversal evidence
→ drug target / pathway support
→ predicted adverse-event profile
→ causal evidence for target-mediated risk
→ final clinical feasibility tier
```

---

## 3. Core Research Questions

### RQ1. Can we predict adverse-event profiles for AD repurposing candidates?

For each candidate drug, predict probabilities for AD-relevant adverse-event groups:

| AE group | Why relevant for AD repurposing |
|---|---|
| Serious infection | immune modulation, JAK inhibitors, biologics, IL-1 / IL-6 axis drugs |
| Herpes / viral infection | JAK inhibitors and immune pathway modulation |
| MACE / cardiovascular events | oral JAK inhibitor class concern |
| Venous thromboembolism | oral JAK inhibitor class concern |
| Malignancy | chronic immune modulation |
| Ocular adverse events | IL-4 / IL-13 / dupilumab-like biology |
| GI intolerance | PDE4 inhibitors, nintedanib-like candidates |
| Hepatic abnormality | systemic kinase / immune drugs |
| Lipid abnormality | JAK / IL-6 axis drugs |
| Acne / skin infection | JAK inhibitor-associated skin effects |
| Sedation / neuropsychiatric effects | antihistamine-like or CNS-active candidates |
| Hypersensitivity / injection-site reaction | biologics and injectable drugs |

### RQ2. Which predicted side effects are likely target-mediated?

Observed side effects can arise from several mechanisms:

```text
target-mediated pharmacology
off-target effects
confounding by indication
polypharmacy
reporting bias
disease severity
dose / route / formulation differences
```

The causal analysis will ask whether genetic proxies for modulation of the drug target are associated with adverse-event-related phenotypes.

### RQ3. Does safety-aware ranking improve candidate prioritization?

LINCS / CMap can rank broad transcriptional perturbagens such as HDAC, CDK, HSP, or MEK inhibitors highly. These may be mechanistically interesting but clinically unsuitable for chronic AD. The proposed framework should separate:

```text
clinically plausible candidates
vs
mechanistically interesting but risky candidates
vs
strong reversal but low-feasibility candidates
```

---

## 4. Data Sources

### 4.1 Therapeutic benefit side

| Data source | Role in pipeline |
|---|---|
| AD GWAS summary statistics | disease genetic association |
| S-PrediXcan / S-MultiXcan TWAS | genetically regulated gene-expression evidence |
| AD lesional vs non-lesional skin expression datasets | disease-state expression signature |
| LINCS L1000 / CMap | perturbational drug signature and reversal score |
| Drug target databases | link drugs to genes, proteins, and pathways |
| Pathway resources | JAK-STAT, Th2, IL-18, IL-1, IL-6, antigen presentation, barrier biology |

### 4.2 Side-effect label sources

| Source | Use |
|---|---|
| SIDER | curated drug-side-effect labels from package inserts |
| FAERS | post-marketing pharmacovigilance signals |
| FDA / EMA labels | serious warnings, boxed warnings, label-level adverse reactions |
| ClinicalTrials.gov / trial reports | adverse-event frequencies when available |
| MedDRA | standard adverse-event terminology and hierarchy |

Important interpretation rule:

```text
SIDER / FDA labels = relatively curated safety labels
FAERS = signal source, not causal ground truth
```

FAERS is useful for signal detection but cannot establish causality. FDA explicitly cautions that a report does not prove that the suspected drug caused the event, because the event may relate to underlying disease, concomitant drugs, or other reasons.

### 4.3 Drug feature sources

| Feature type | Examples |
|---|---|
| Chemical features | SMILES, Morgan fingerprints, MACCS keys, molecular descriptors |
| Target features | DrugBank / ChEMBL / DGIdb targets |
| Pathway features | Reactome / KEGG / GO pathway membership |
| Transcriptomic features | LINCS L1000 perturbation vector or pathway-level perturbation scores |
| Network features | PPI centrality, target degree, distance to AD genes, distance to AE-associated genes |
| Clinical features | topical vs systemic route, biologic vs small molecule, approval status, chronic-use feasibility |

---

## 5. Overall Study Design

```text
AD disease signature
        ↓
LINCS / CMap reversal scoring
        ↓
AD candidate drug list
        ↓
Drug features:
  chemical + target + pathway + transcriptomic + network + clinical metadata
        ↓
Multi-label side-effect prediction
        ↓
Predicted AE risk vector per candidate drug
        ↓
Causal safety analysis:
  drug-target MR + colocalization + phenotype scan
        ↓
Integrated benefit-risk ranking
        ↓
Cytoscape network:
  AD genes → pathways → drug targets → drugs → side effects
```

---

# Part A — Side-Effect Prediction

## 6. Prediction Task Definition

### 6.1 Input

For each drug `d`, construct a feature vector:

```text
X_d = [
  chemical fingerprint,
  target gene features,
  pathway features,
  LINCS perturbation embedding,
  drug class / MoA,
  route / systemic exposure,
  PPI-network features
]
```

### 6.2 Output

A multi-label adverse-event vector:

```text
Y_d = [
  infection,
  herpes,
  MACE,
  VTE,
  malignancy,
  ocular_AE,
  GI_intolerance,
  hepatic_AE,
  lipid_abnormality,
  acne_or_skin_infection,
  sedation,
  hypersensitivity,
  ...
]
```

This is a **multi-label classification** problem because one drug can have many adverse effects.

---

## 7. Label Engineering

### 7.1 Use grouped AE labels first

Do not start by predicting thousands of MedDRA preferred terms. The first version should predict 10–15 clinically interpretable AE groups.

Example mapping:

```text
MedDRA preferred terms:
  pneumonia
  cellulitis
  sepsis
  upper respiratory tract infection
  opportunistic infection
        ↓
AE group:
  serious_or_relevant_infection
```

Recommended first-pass AE groups:

| Group | Example terms |
|---|---|
| Infection | serious infection, pneumonia, cellulitis, opportunistic infection |
| Herpes / viral infection | herpes zoster, herpes simplex, viral infection |
| Cardiovascular | myocardial infarction, stroke, MACE |
| Thrombosis | DVT, PE, VTE |
| Malignancy | lymphoma, skin cancer, malignancy |
| Ocular | conjunctivitis, keratitis, dry eye |
| GI | nausea, diarrhea, vomiting, abdominal pain |
| Hepatic | ALT increase, AST increase, drug-induced liver injury |
| Lipid / metabolic | hyperlipidemia, cholesterol increase |
| Skin-specific | acne, folliculitis, skin infection |
| Neuro / sedation | somnolence, dizziness, sedation |
| Hypersensitivity | anaphylaxis, hypersensitivity, injection-site reaction |

### 7.2 Build two label tiers

```text
Y_curated:
  SIDER / FDA label adverse reactions

Y_signal:
  FAERS disproportionality signals
```

Recommended use:

```text
Train primary model on Y_curated.
Use Y_signal as weak labels, sensitivity analysis, or external validation.
```

---

## 8. Feature Engineering

### 8.1 Chemical features

For small molecules:

```text
SMILES
→ RDKit
→ Morgan fingerprint / MACCS keys / molecular descriptors
```

Useful for predicting:

```text
GI intolerance
hepatic toxicity
CNS sedation
off-target-like adverse effects
```

Limitation:

```text
Chemical fingerprints do not naturally represent antibodies / biologics.
```

For biologics, use target, pathway, and MoA features instead.

### 8.2 Target features

Map each drug to target genes:

```text
drug → target gene(s)
```

Construct:

```text
target one-hot vector
target family vector:
  JAK / PDE / IL receptor / TNF / HDAC / CDK / MEK / HSP / GPCR

pathway vector:
  JAK-STAT / Th2 / IL-1 / IL-6 / NF-kB / MAPK / antigen presentation
```

These are likely the most important features for AD because many safety profiles are target-class related.

### 8.3 LINCS transcriptomic features

For drugs with L1000 profiles:

```text
drug perturbation expression vector
```

Possible representations:

```text
top-k up/down genes
PCA / UMAP embedding of LINCS profiles
pathway-level enrichment scores
consensus signature across cell lines
cell-line-specific signatures
```

### 8.4 Network features

Construct a graph:

```text
drug — target — PPI network — AD TWAS genes / immune genes / AE genes
```

Features:

```text
distance to AD genes
distance to infection-related genes
distance to cardiovascular genes
target degree
target betweenness
immune-pathway centrality
```

---

## 9. Modeling Strategy

### 9.1 Baseline 1: rule-based safety classifier

Before machine learning, build a transparent baseline:

```text
if target family = JAK:
    infection risk = high
    herpes risk = high
    lab abnormality risk = medium/high

if target family = broad HDAC/CDK:
    chronic AD feasibility = low

if route = topical:
    systemic risk is downweighted
```

This baseline is important because it is interpretable and can catch obvious mechanism-level risks.

### 9.2 Baseline 2: multi-label logistic regression / tree model

First machine-learning model:

```text
Input:
  chemical fingerprint
  target features
  pathway features
  drug class
  LINCS embedding

Output:
  AE group probabilities
```

Candidate models:

```text
multi-label logistic regression
random forest
XGBoost / LightGBM
calibrated classifier
```

For each AE group:

```text
P(AE_group | drug features)
```

Evaluation metrics:

```text
AUROC
AUPRC
calibration curve
top-k recall
leave-drug-class-out validation
```

AUPRC is especially important because adverse-event labels are sparse.

### 9.3 Model 3: knowledge graph / GNN

A later-stage graph model can be formulated as link prediction.

Graph nodes:

```text
drug
gene/protein target
pathway
side effect
disease
```

Edges:

```text
drug-target
protein-protein interaction
drug-side_effect
gene-pathway
drug-disease indication
AD_gene evidence
```

Task:

```text
predict missing drug-side_effect edges
```

This is conceptually related to Decagon-style drug-side-effect graph modeling, but the first version should focus on single-drug adverse-event prediction rather than polypharmacy side effects.

---

## 10. Evaluation Design

### 10.1 Avoid only random splits

A random drug split may overestimate performance because similar drugs can appear in both train and test.

Use several evaluation modes:

```text
1. Random drug split
2. Leave-drug-class-out split
3. Leave-target-family-out split
4. Temporal split, if label dates are available
```

Most important stress tests for this project:

```text
leave-JAK-out
leave-PDE4-out
leave-biologic-out
leave-kinase-inhibitor-out
```

### 10.2 Positive controls

Known AD or AD-relevant drugs should show expected safety patterns:

| Drug / class | Expected safety signal |
|---|---|
| Dupilumab | ocular AE, injection-site reaction, hypersensitivity |
| Lebrikizumab / tralokinumab | ocular AE |
| Baricitinib / upadacitinib / abrocitinib | infection, herpes, MACE / VTE warning class |
| Ruxolitinib cream | lower systemic risk than oral JAK inhibitors |
| Apremilast | GI intolerance |
| Topical PDE4 inhibitors | local irritation and lower systemic GI burden |
| Antihistamines | sedation, depending on generation and CNS penetration |

### 10.3 Negative or low-priority controls

For chronic AD, the following should usually be downranked:

```text
broad HDAC inhibitors
CDK inhibitors
HSP inhibitors
oncology cytotoxics
strong systemic immunosuppressants with serious infection / malignancy risk
```

---

# Part B — Causal Safety Analysis

## 11. Why causal analysis is needed

Pharmacovigilance databases answer:

```text
Was an adverse event reported with this drug?
```

They do not directly answer:

```text
Would modulating this target causally increase adverse-event risk?
```

This matters because observed safety signals can be driven by:

```text
confounding by indication
underlying disease severity
concomitant medications
reporting bias
dose or route differences
true target-mediated pharmacology
off-target effects
```

Causal analysis helps distinguish **observed association** from **target-mediated risk plausibility**.

---

## 12. Drug-Target Mendelian Randomization

### 12.1 Basic concept

For a target gene `G`, use genetic variants that affect expression or protein level of `G` as instruments.

Example:

```text
cis-eQTL for JAK1 expression
or
cis-pQTL for IL6R protein level
        ↓
proxy for target modulation
        ↓
test association with adverse-event outcome GWAS
```

This estimates:

```text
Does genetically altered target activity associate with an AE-related phenotype?
```

Mendelian randomization has been proposed as a way to predict unintended drug effects by using genetic variation as a proxy for target perturbation.

### 12.2 Required data

| Data | Role |
|---|---|
| cis-eQTL | proxy for gene-expression modulation |
| cis-pQTL | proxy for protein-level modulation; often better for drug targets |
| outcome GWAS | adverse-event proxy phenotype |
| AD GWAS | benefit-side comparison |
| colocalization summary statistics | test whether QTL and outcome share causal variant |

Outcome GWAS examples:

```text
infection susceptibility
asthma / allergic traits
cardiovascular disease
venous thromboembolism
lipids
liver enzymes
cancer risk
IBD
ocular phenotypes, if available
```

### 12.3 MR methods

For each drug target:

```text
target gene → cis instruments → outcome GWAS
```

Methods:

```text
Wald ratio for single instrument
IVW for multiple instruments
weighted median
MR-Egger, if enough instruments
outlier checks
Steiger directionality
```

For drug-target MR, prioritize **cis instruments near the target gene** rather than genome-wide instruments, because cis instruments reduce horizontal pleiotropy and are more interpretable as target proxies.

### 12.4 Colocalization

MR can be misleading if the QTL and outcome GWAS signal are merely in linkage disequilibrium rather than sharing the same causal variant.

Add colocalization:

```text
coloc(target eQTL or pQTL, adverse-event GWAS)
```

Interpretation:

| MR result | Colocalization result | Interpretation |
|---|---|---|
| Significant | Strong coloc | more credible target-mediated risk |
| Significant | No coloc | possible LD artifact or pleiotropy |
| Not significant | No coloc | no clear evidence |
| Not significant | Strong coloc but weak power | possible weak or context-specific signal |

---

## 13. Causal Benefit-Risk Matrix

For each target / drug, estimate:

```text
benefit evidence:
  target modulation → lower AD risk or reverses AD signature

risk evidence:
  target modulation → higher AE-related phenotype risk
```

Candidate interpretation matrix:

| Category | Meaning |
|---|---|
| High benefit / low causal risk | strong candidate |
| High benefit / manageable risk | candidate with monitoring |
| High benefit / high causal risk | mechanism interesting but clinically risky |
| Low benefit / high risk | deprioritize |
| Strong reversal / no genetic support | exploratory only |

Examples:

```text
JAK inhibition:
  benefit: high
  risk: infection / herpes / lab abnormalities likely
  conclusion: effective but requires route, dose, and safety control

PDE4 inhibition:
  benefit: moderate
  risk: GI intolerance
  conclusion: plausible, tolerability-limited

HDAC inhibition:
  benefit: transcriptomic reversal may be high
  risk: broad systemic toxicity
  conclusion: low chronic-AD feasibility

IL-4R / IL-13 axis:
  benefit: high
  risk: ocular AE
  conclusion: clinically validated with mechanism-specific AE monitoring
```

---

# Part C — Integration with AD Drug Repurposing

## 14. Integrated scoring framework

For each drug `d`, compute:

```text
BenefitScore(d):
  LINCS reversal score
  + AD TWAS target support
  + pathway relevance
  + positive-control similarity

SafetyRiskScore(d):
  predicted AE probabilities
  + FAERS disproportionality signals
  + label warning severity
  + causal MR support for AE risk

ClinicalFeasibilityScore(d):
  route
  chronic-use suitability
  approval status
  systemic exposure
  drug class
```

Final priority score:

```text
PriorityScore(d)
=
BenefitScore(d)
- λ × SafetyRiskScore(d)
+ γ × ClinicalFeasibilityScore(d)
```

However, the final output should not be a single opaque score. It should be a transparent table:

| Drug | Reversal | AD genetics support | Predicted AE risk | Causal safety evidence | Feasibility | Tier |
|---|---:|---:|---|---|---|---|
| Drug A | high | high | low/moderate | weak | good | Tier 1 |
| Drug B | high | low | high | strong | poor | Tier 3 |
| Drug C | moderate | high | manageable | moderate | good | Tier 2 |

---

## 15. Candidate tiers

### Tier 1: clinically plausible candidates

Definition:

```text
AD-relevant mechanism
+ acceptable predicted safety
+ no strong causal safety red flag
+ feasible route / dose / chronic-use profile
```

Potential examples:

```text
PDE4-related candidates
topical JAK-like candidates
selected antihistamine / itch-related candidates
barrier or anti-inflammatory candidates
LDN-like immunomodulatory candidates
```

### Tier 2: mechanistically interesting but needs caution

Definition:

```text
good reversal or pathway relevance
but moderate safety uncertainty or route limitations
```

Potential examples:

```text
MEK / HSP / selected kinase candidates
metabolic nuclear receptor drugs
immune modulators with limited AD data
```

### Tier 3: deprioritize for chronic AD

Definition:

```text
strong reversal but poor safety, broad cytotoxicity, or strong causal risk
```

Potential examples:

```text
HDAC inhibitors
CDK inhibitors
oncology cytotoxics
strong systemic immunosuppressants
alemtuzumab-like candidates
```

---

# Part D — Network Visualization with Cytoscape

## 16. Network design

Create a Cytoscape network:

```text
AD TWAS genes
→ pathways
→ drug targets
→ candidate drugs
→ predicted side effects
```

Node types:

| Node type | Visual encoding |
|---|---|
| AD gene | red/blue by TWAS direction |
| Drug target | orange |
| Candidate drug | green |
| Side effect | purple |
| Pathway | gray |
| Approved AD drug | thick border |
| High-risk candidate | red border |

Edges:

| Edge | Meaning |
|---|---|
| gene-pathway | pathway membership |
| drug-target | known pharmacological target |
| target-side effect | causal / MR-supported risk |
| drug-side effect | predicted or reported AE |
| drug-AD signature | LINCS reversal support |

This will make the project interpretable as a gene-target-drug-side-effect network rather than only a ranking table.

---

# Part E — Implementation Plan

## 17. Suggested repo structure

```text
side_effect_prediction/
  data/
    raw/
      sider/
      faers/
      drugbank/
      lincs/
    processed/
      drugs_master.csv
      side_effect_labels.csv
      drug_features.parquet
      ad_candidate_drugs.csv

  notebooks/
    01_build_side_effect_labels.ipynb
    02_build_drug_features.ipynb
    03_train_baseline_models.ipynb
    04_evaluate_ad_candidates.ipynb
    05_causal_safety_mr_summary.ipynb
    06_cytoscape_network_export.ipynb

  src/
    labels.py
    features.py
    train.py
    evaluate.py
    causal.py
    scoring.py
    cytoscape_export.py

  results/
    ae_prediction_metrics.csv
    ad_candidate_safety_scores.csv
    benefit_risk_ranking.csv
    cytoscape_nodes.csv
    cytoscape_edges.csv

  docs/
    side_effect_prediction_plan.md
    causal_safety_analysis.md
```

---

## 18. Phase-by-phase timeline

### Phase 1 — Dataset construction

Goal:

```text
Create a drug × AE label matrix and a candidate-drug table.
```

Tasks:

```text
1. Standardize drug names:
   LINCS perturbagen name
   SIDER drug name
   DrugBank / ChEMBL ID
   FDA label name

2. Build AE group mapping:
   MedDRA PT → AE group

3. Build label matrix:
   drug × AE_group

4. Build candidate-drug list:
   from AD LINCS repurposing results
```

Deliverables:

```text
drugs_master.csv
side_effect_labels.csv
ad_candidate_drugs.csv
```

### Phase 2 — Feature construction

Goal:

```text
Build ML-ready drug features.
```

Tasks:

```text
1. RDKit chemical fingerprints for small molecules
2. Target one-hot and pathway features
3. LINCS transcriptomic embeddings
4. PPI / network proximity features
5. Route / class / approval metadata
```

Deliverable:

```text
drug_features.parquet
```

### Phase 3 — Baseline side-effect prediction

Goal:

```text
Train interpretable multi-label classifiers.
```

Tasks:

```text
1. Logistic regression baseline
2. XGBoost / LightGBM model
3. Evaluate random split and leave-class-out split
4. Calibrate predicted probabilities
5. Explain features with coefficients or SHAP
```

Deliverables:

```text
model_metrics.csv
ae_prediction_report.md
```

### Phase 4 — Apply to AD candidates

Goal:

```text
Predict AE profiles for all AD repurposing candidates.
```

Tasks:

```text
1. Score candidate drugs
2. Compare with known AD positive controls
3. Identify high-benefit / low-risk candidates
4. Deprioritize broad toxic perturbagens
```

Deliverable:

```text
ad_candidate_safety_scores.csv
```

### Phase 5 — Causal safety analysis

Goal:

```text
Test whether predicted AE risks are genetically supported.
```

Tasks:

```text
1. Select target genes for top candidates
2. Collect cis-eQTL / pQTL instruments
3. Run MR against AE-proxy GWAS traits
4. Run colocalization
5. Summarize target-mediated risk evidence
```

Deliverables:

```text
target_mr_results.csv
target_coloc_results.csv
causal_safety_summary.md
```

### Phase 6 — Integrated benefit-risk ranking

Goal:

```text
Combine therapeutic and safety evidence.
```

Tasks:

```text
1. Normalize LINCS reversal score
2. Add TWAS / pathway target support
3. Add predicted AE risk
4. Add causal safety flags
5. Produce final tiered ranking
```

Deliverables:

```text
benefit_risk_ranking.csv
candidate_tier_table.md
```

### Phase 7 — Network visualization

Goal:

```text
Generate Cytoscape-ready network.
```

Tasks:

```text
1. Build nodes and edges table
2. Export to Cytoscape
3. Apply style
4. Export figure
```

Deliverables:

```text
cytoscape_nodes.csv
cytoscape_edges.csv
ad_benefit_risk_network.svg
```

---

# Part F — Expected Results

## 19. Expected scientific output

Expected outputs:

```text
1. A reproducible safety-aware AD drug-repurposing pipeline

2. A multi-label side-effect prediction model for AD candidate drugs

3. A causal safety matrix linking drug targets to AE-related phenotypes

4. A tiered candidate ranking:
   not just “most reversed”,
   but “most plausible and safest”

5. A network visualization connecting:
   TWAS genes, pathways, drug targets, drugs, and side effects
```

Expected conceptual finding:

> Some drugs may strongly reverse an AD disease signature but remain poor chronic-treatment candidates because their predicted or genetically supported safety risk is high.

This is likely to affect broad perturbagens such as HDAC, CDK, HSP, MEK, or cytotoxic oncology-like candidates.

---

# Part G — Main Limitations

## 20. FAERS bias

FAERS has reporting bias, confounding by indication, duplicate reports, stimulated reporting, and no clean denominator. It should be treated as a pharmacovigilance signal source, not causal truth.

Mitigation:

```text
Use FAERS only as weak signal or external validation.
Prefer SIDER / FDA labels for primary supervised labels.
```

## 21. SIDER incompleteness

SIDER is useful but biased toward marketed drugs and known label events.

Mitigation:

```text
Use grouped AE labels.
Validate against known AD drug safety profiles.
Add FAERS and label evidence where possible.
```

## 22. LINCS cell-line mismatch

LINCS profiles are often generated in cancer or immortalized cell lines, not AD skin, keratinocytes, T cells, or skin organoids.

Mitigation:

```text
Use LINCS as perturbational evidence, not clinical efficacy proof.
Add AD lesional expression and TWAS as biological filters.
Downweight non-skin-relevant broad cytotoxic signatures.
```

## 23. MR proxy limitation

Genetic variants represent lifelong partial target modulation, whereas drugs have dose, timing, route, and off-target pharmacology.

Mitigation:

```text
Interpret MR as target-mediated plausibility, not exact clinical drug effect.
Use pQTL when possible.
Run colocalization.
Compare direction with known pharmacology.
```

## 24. Biologics are harder to model

Chemical fingerprints work for small molecules, not antibodies or other biologics.

Mitigation:

```text
Use target, pathway, and MoA features for biologics.
Train separate small-molecule and biologic models if enough data.
```

---

# Part H — Minimal MVP Version

A realistic 2–4 week MVP:

```text
1. Take top 100–300 AD LINCS candidate drugs.

2. Map them to:
   SIDER labels
   drug targets
   drug classes
   LINCS reversal scores

3. Define 10 AE groups:
   infection, herpes, MACE, VTE, malignancy, ocular, GI, hepatic, lipid, sedation

4. Train:
   logistic regression / XGBoost

5. Apply to AD candidates.

6. Output:
   benefit-risk table
   Cytoscape network
```

MVP title:

> Safety-aware prioritization of transcriptomic drug-repurposing candidates for atopic dermatitis

This version is already stronger than a manual side-effect table because it makes the safety evaluation reproducible and extensible.

---

# Part I — Proposal-Ready Abstract

We will extend transcriptomic drug repurposing for atopic dermatitis by integrating adverse-event prediction and target-mediated causal safety analysis. Candidate drugs identified through LINCS L1000 disease-signature reversal will be annotated with chemical, target, pathway, transcriptomic, network, and clinical-route features. A multi-label adverse-event prediction model will estimate clinically relevant safety risks, including infection, thromboembolic, cardiovascular, ocular, gastrointestinal, hepatic, malignancy-related, and hypersensitivity adverse events. To distinguish pharmacovigilance association from plausible target-mediated causality, we will perform drug-target Mendelian randomization and colocalization using cis-eQTL / pQTL instruments and GWAS outcomes for adverse-event proxy traits. The final output will be a benefit-risk ranking framework and an interpretable Cytoscape network linking AD TWAS genes, drug targets, candidate compounds, and predicted or causally supported adverse effects.

---

## References

1. Subramanian, A. et al. **A Next Generation Connectivity Map: L1000 Platform and the First 1,000,000 Profiles.** *Cell* 2017. https://www.cell.com/cell/fulltext/S0092-8674(17)31309-0
2. Kuhn, M. et al. **The SIDER database of drugs and side effects.** *Nucleic Acids Research* 2016. https://pmc.ncbi.nlm.nih.gov/articles/PMC4702794/
3. FDA. **FAERS Public Dashboard FAQ.** https://fis.fda.gov/extensions/FPD-FAQ/FPD-FAQ.html
4. Walker, V. M. et al. **Mendelian randomization: a novel approach for the prediction of adverse drug events and drug repurposing opportunities.** *International Journal of Epidemiology* 2017. https://pmc.ncbi.nlm.nih.gov/articles/PMC5837479/
5. Zitnik, M. et al. **Modeling polypharmacy side effects with graph convolutional networks.** *Bioinformatics* 2018. https://academic.oup.com/bioinformatics/article/34/13/i457/5045770
6. Nguyen, P. A. et al. **Phenotypes associated with genes encoding drug targets are predictive of clinical trial side effects.** *Nature Communications* 2019. https://www.nature.com/articles/s41467-019-09407-3
