# Versioned development roadmap — side-effect prediction + causal safety analysis

_Companion to `docs/lit-review/side_effect_prediction_causal_analysis_plan.md`. Written 2026-05-01._

## Context

`docs/lit-review/side_effect_prediction_causal_analysis_plan.md` (1,227 lines) lays out a research-grade safety-aware drug-repurposing framework that is much larger than the rule-based annotation we just shipped. It spans:

- **Part A** — Multi-label ML adverse-event prediction (10–15 AE groups, chemical fingerprints + target/pathway/LINCS/network features, baseline LR/XGBoost → GNN)
- **Part B** — Drug-target Mendelian randomization + colocalization (cis-eQTL/pQTL → AE-proxy GWAS)
- **Part C** — Integrated benefit-risk scoring with tier output
- **Part D** — Cytoscape network visualization

What is already shipped (in `drug-repurposing/scripts/safety/`):

- 6-source **rule-based** annotation: Open Targets indications/mechanisms/targets/FDA boxed warnings, SIDER labels, OpenFDA FAERS top-5 + serious%, DILI proxy via OT `drugWarnings.toxicityClass=hepatotoxicity`, GWAS-Catalog ADR variants on target genes, repo lit-review prose.
- Output `results/ranked_candidates_v3_safety.csv` (60 drugs × 40 cols) + `top50_safety_summary_v3.md` with derived `safety_flag ∈ {RED, AMBER, GREEN, UNKNOWN}` and a 1-sentence `safety_summary`.
- This corresponds to **Phase 1 (Dataset construction) + half of Phase 6 (rule-based ranking)** in the research plan.

What is NOT yet built: the ML model, the causal MR layer, the integrated benefit-risk score, the Cytoscape export. This document is the versioned roadmap to get from "rule-based v1 (today)" to the full plan.

## Approach — four releases, each strictly additive

Each release extends the existing scripts-based pipeline pattern (`scripts/safety/{step}.py`, one folder per step, README per folder). Earlier releases' outputs become inputs to later ones. The headline output CSV grows columns; old columns and rule-based flags stay populated so prior consumers don't break.

```
v1 (DONE)        →   v2 (ML AE prediction)   →   v3 (causal MR)   →   v4 (integrated tier)
6-source rules        adds 12 P(AE) columns     adds MR+coloc        adds tier + Cytoscape
ranked_*_safety.csv   ranked_*_v2.csv           ranked_*_v3.csv      ranked_*_v4.csv
```

Versioning rule: **the safety CSV is append-only**. v2 adds `pred_*` columns. v3 adds `mr_*` / `coloc_*` columns. v4 adds `tier`, `benefit_score`, `final_priority` columns. The `safety_flag` from v1 is kept intact in every release as a transparent baseline that ML predictions get compared against.

---

## Safety v1 — rule-based annotation (DONE, 2026-05-01)

Status: shipped. See `drug-repurposing/scripts/safety/README.md`. No further work needed unless any of the following data sources break (DILI proxy substitution doc'd in the README's "DILI proxy" section).

Deliverables (already produced):
- `results/ranked_candidates_v3_safety.csv` (60 rows × 40 cols)
- `results/top50_safety_summary_v3.md`
- `safety_flag` distribution: UNKNOWN 30 / AMBER 16 / RED 12 / GREEN 2

---

## Safety v2 — ML multi-label adverse-event prediction

**Goal**: turn the 1,712-compound MoA-annotated set into a labelled training corpus and predict 12 AE-group probabilities for every candidate (including the BRD-K tool compounds that v1 marked UNKNOWN).

**Maps to**: research-plan Part A + Phases 1–4.

### Data assembly (`scripts/safety_v2/01_build_label_matrix.py`)

Build `data/safety/v2/label_matrix.parquet` of shape `(N_drugs_with_labels, 12_AE_groups)`:

- Source labels: SIDER 4.1 `meddra_freq.tsv.gz` (already cached from v1) + OpenFDA FAERS top-25 reactions per drug (extend v1's per-drug cache from top-10 to top-25; cached responses make this near-free)
- 12 AE groups (per plan §7.1): `infection, herpes_viral, mace, vte, malignancy, ocular, gi_intolerance, hepatic, lipid_metabolic, skin_acne_folliculitis, neuro_sedation, hypersensitivity_isr`
- MedDRA PT → AE-group mapping table at `data/safety/v2/meddra_to_ae_group.tsv`. Hand-curated, ~150 PTs across the 12 groups, sourced from MedDRA SMQ definitions (publicly listed)
- Two label tiers per plan §7.2: `Y_curated` (SIDER ≥1 reported), `Y_signal` (FAERS PRR ≥ 2.0 — disproportionality)

Universe: ~1,200 SIDER drugs intersected with our 1,712 MoA-annotated candidates → expect ~600–900 with at least one positive label (SIDER's 2015 cliff hits us, but ~600 is enough for the 12-group multi-label task).

### Feature construction (`scripts/safety_v2/02_build_features.py`)

Build `data/safety/v2/drug_features.parquet`:

- **Chemical**: RDKit Morgan-2048 fingerprints + 200 mol descriptors. Source: PubChem CID (already cached) → Canonical SMILES via PubChem REST. Skip biologics (no SMILES); flag for biologic-specific feature treatment
- **Target one-hot + family**: Open Targets `target_symbols` from v1 (already cached) → one-hot over union of targets seen, plus 8-class family (`JAK, PDE, IL_R, TNF, HDAC, CDK, MEK, HSP, GPCR, OTHER`)
- **Pathway**: target genes → Reactome pathway membership (Reactome `Ensembl2Reactome.txt` ~5 MB, free)
- **LINCS embedding**: per-drug consensus signature from `cmap-big-table.cmap_lincs_public_views.L1000_Level5_rid` averaged across cells (BigQuery, same dataset as `score_bq.py` step 2). PCA-50 of the 978-landmark consensus matrix
- **Network proximity**: STRING-DB v12 PPI (free, ~3 GB but only need network for query). Compute target → AD TWAS top-30 (already in `rank_candidates.py:41-46`) shortest-path distance + degree centrality
- **Clinical metadata**: `is_topical` (parse from drug indication / formulation), `is_biologic` (Open Targets `drugType`), `max_phase` (already in v1)

### Modeling (`scripts/safety_v2/03_train_models.py`)

Two baselines per plan §9:

- **Logistic regression baseline** with L2 — calibrated, interpretable coefficients
- **XGBoost multi-label** (one classifier per AE group) — better on sparse imbalanced labels

Validation per plan §10.1:
- Random 5-fold drug split (primary)
- **Leave-target-family-out**: hold out all JAK / PDE4 / HDAC / CDK / MEK / HSP separately. This is the key test — does the model predict AE risk for an *unseen* target class? Leave-JAK-out should still flag baricitinib correctly via chemical + LINCS features alone
- AUROC + AUPRC + calibration curve per AE group

Positive-control validation per plan §10.2:
- Predicted P(infection) for {baricitinib, upadacitinib, abrocitinib} should be top-quartile
- Predicted P(ocular) for dupilumab/lebrikizumab should be top-quartile (need to add the 4 anti-IL-13 biologics to candidate set even though they're not in LINCS — for evaluation only)
- Predicted P(gi_intolerance) for apremilast should be top-quartile

### Application (`scripts/safety_v2/04_predict_candidates.py`)

Score the 60 v1 drugs (top-50 + positive controls) + the broader 1,712 MoA-annotated candidates:

- 12 columns of calibrated probabilities `pred_P_<AE_group>`
- 1 column `pred_max_AE` — the AE group with highest probability
- 1 column `pred_high_risk_count` — number of AE groups with `pred_P > 0.7`

Output: `results/ranked_candidates_v3_safety_v2.csv` (extends v1 CSV with 14 new columns; keeps `safety_flag`/`safety_summary` from v1 untouched).

### Reuse from v1
- `data/safety/chembl_map.json` (PubChem CID → ChEMBL)
- `data/safety/sider/meddra_freq.tsv.gz`
- `data/safety/openfda/{name}.json` per-drug caches
- `data/safety/open_targets/{chembl}.json` per-drug caches
- `results/safety/open_targets.csv` (target_symbols, mechanism)
- `results/safety/sider.csv` (sider_n_aes, sider_top5_aes)

### New external dependencies
- Python: `rdkit-pypi`, `xgboost`, `scikit-learn` (already partially in metaxcan env, add via single `pip install`)
- Data downloads (one-time, all free, ≤ 100 MB total): PubChem SMILES batch (REST), Reactome `Ensembl2Reactome.txt`, STRING-DB Homo sapiens v12 (just the human PPI, ~250 MB)

### Verification
- Random 5-fold AUROC ≥ 0.75 on at least 8/12 AE groups
- Leave-JAK-out AUROC ≥ 0.65 on `infection` and `herpes_viral` — proves transfer
- Tofacitinib `pred_P_infection > 0.7` even with leave-JAK-out
- Apremilast `pred_P_gi_intolerance > 0.7`, `pred_P_infection < 0.3`
- ≥45/60 candidates in v1's UNKNOWN bucket get at least one populated `pred_P > 0.5`

### Out of scope for v2
- GNN / Decagon-style graph models (deferred to optional v2.5)
- Polypharmacy AE prediction
- Biologic-specific model (we keep biologics in but note their lower feature coverage)
- MR / colocalization (that's v3)

---

## Safety v3 — drug-target Mendelian randomization

**Goal**: for each candidate's target genes, run cis-MR + colocalization against AE-proxy GWAS to distinguish target-mediated causal risk from confounded pharmacovigilance signal.

**Maps to**: research-plan Part B + Phase 5.

### Instrument selection (`scripts/safety_v3/01_build_instruments.py`)

For each unique target gene from v1's `open_targets.csv` `target_symbols`:

- **cis-eQTL instruments**: GTEx v8 sigQTL (skin / blood / immune cells preferred). Free download `GTEx_Analysis_v8_eQTL.tar` ~1.2 GB
- **cis-pQTL instruments**: UK Biobank Pharma Proteomics Project (UKB-PPP) Olink + deCODE pQTL meta-analysis (free, EBI eQTL Catalogue mirror)
- Filter: |variant - TSS| < 1 Mb, F-stat > 10, prune by LD r² < 0.1 within 500 kb
- Output: `data/safety/v3/instruments/{gene}.tsv` per gene

### Outcome GWAS curation (`scripts/safety_v3/02_curate_outcomes.py`)

Per plan §12.2, AE-proxy GWAS for each AE group:

| AE group | Outcome GWAS | Source |
|---|---|---|
| infection | sepsis (FinnGen R10), pneumonia (UKB) | OpenGWAS / FinnGen |
| MACE | CARDIoGRAMplusC4D 2022 CAD | EBI |
| VTE | Klarin 2019 VTE | EBI |
| malignancy | UKB cancer (any), pan-cancer | OpenGWAS |
| ocular | UKB H00-H59, Hysi 2020 keratoconus | OpenGWAS |
| GI | UKB IBD, dyspepsia | OpenGWAS |
| hepatic | ALT/AST GTEx | OpenGWAS |
| lipid | Graham 2021 LDL/HDL/TG | EBI |

Output: `data/safety/v3/outcomes/{ae_group}.tsv` summary stats. Mostly free / OpenGWAS API-fetched.

### MR + coloc execution (`scripts/safety_v3/03_run_mr.py`)

- IVW (`MendelianRandomization` Python package or `MR-Base` R), Wald-ratio for single-instrument, weighted-median + MR-Egger sensitivity
- Colocalization: `coloc.abf` (PWCoCo wrapper for region-based coloc on summary stats)
- For each (target, AE_group) pair: emit `(beta, se, p, n_snp, coloc_pp4)`

Output: long-form `results/safety_v3/target_mr.csv` with columns `target, ae_group, n_instruments, ivw_beta, ivw_se, ivw_p, egger_p, weighted_median_p, coloc_pp4_h4, interpretation`.

### Annotate candidates (`scripts/safety_v3/04_annotate_safety.py`)

For each candidate: aggregate target-level MR results into 4-column verdict per AE group:
- `mr_<ae>_evidence ∈ {strong_causal, suggestive, no_signal, no_data}`
- `mr_<ae>_direction ∈ {protective, risk, null}`
- `mr_<ae>_pp4` (best coloc PP.H4 across instruments)
- `mr_<ae>_summary` (1-line prose)

Per plan §12.4 interpretation table:
- Strong MR + strong coloc → `strong_causal`
- Strong MR + weak coloc → `suggestive` (LD artifact possible)
- Null MR + null coloc → `no_signal`
- Insufficient instruments → `no_data`

Output: `results/ranked_candidates_v3_safety_v3.csv` (extends v2 CSV with 4 × 12 = 48 new MR columns + 1 summary).

### Reuse from v1/v2
- `target_symbols` per candidate (from v1)
- `pred_P_<AE_group>` predictions (from v2) — used as the comparison anchor

### New external dependencies
- R + `coloc` package OR Python `pycoloc` (single conda env addition)
- Data: GTEx v8 eQTL (~1 GB), pQTL meta (UKB-PPP, ~500 MB), 12 AE-proxy GWAS summary stats (~5 GB total — OpenGWAS API-fetched on demand)

### Verification per plan §10.2
- **JAK1 → infection MR**: weakly significant + non-zero coloc PP.H4 (canonical positive control — published finding)
- **IL6R → infection MR**: rs2228145 IL6R locus, IVW p < 0.05 + coloc PP.H4 > 0.5 (canonical: tocilizumab safety)
- **FLT3 → cardiomyopathy / cytopenia**: ≥1 strong instrument, MR p < 0.05 (matches our v1 ADR-GWAS hit for fedratinib/lestaurtinib)
- For the 30 v1-UNKNOWN candidates with no pharmacovigilance data: ≥10 should get at least one `strong_causal` or `suggestive` MR verdict (proves MR adds signal where FAERS/SIDER are silent)

### Out of scope for v3
- Per-tissue tissue-context MR (skin-specific eQTL only used as preference, not enforced)
- Bidirectional MR (AD → AE phenotype) — only forward target → AE
- Multi-trait MR / MVMR — deferred
- Two-sample-MR-Steiger directionality — included if instruments support, otherwise skipped

---

## Safety v4 — integrated benefit-risk scoring + Cytoscape network

**Goal**: combine the existing connectivity score (v3 BigQuery dot-product), target-AD-genetics support (TWAS), v2 ML predictions, v3 MR causal evidence into a transparent tier output. Export a Cytoscape network of the same.

**Maps to**: research-plan Parts C + D + Phases 6–7.

### Benefit score (`scripts/safety_v4/01_build_benefit_score.py`)

Per plan §14:

- `connectivity_z` — z-score of `median_score` across the 1,712 MoA candidates (already in v3 CSV)
- `twas_target_support` — fraction of candidate's targets that overlap top-30 TWAS meta-analysis genes (already in v1 CSV as `targets_top30_TWAS` boolean; extend to fractional via Stouffer-Z weighted overlap)
- `pathway_relevance` — Reactome enrichment p-value of candidate targets vs AD-relevant pathways (JAK-STAT, IL-13/Th2, IL-1, IL-6, NF-κB, MAPK, antigen presentation)
- `pos_ctrl_similarity` — average chemical/LINCS similarity to top-3 approved AD drugs (excludes self)

`benefit_score = z_normalize(connectivity_z) + 0.5*twas_target_support + 0.5*pathway_relevance + 0.3*pos_ctrl_similarity`

### Risk score (`scripts/safety_v4/02_build_risk_score.py`)

`risk_score`:
- `+2.0` per RED v1 trigger (boxed warning, GWS-significant ADR, fatal AE keyword)
- `+1.0` per AMBER v1 trigger
- `+1.5 * mean(pred_P_<AE>)` from v2 (penalises high-AE-probability profiles)
- `+1.0 * count(MR strong_causal)` from v3
- `+0.5 * count(MR suggestive)` from v3
- `-0.5` if `is_topical` (route penalty reduction)

### Final tier (`scripts/safety_v4/03_assign_tier.py`)

Per plan §15:
- **Tier 1 (clinically plausible)**: `benefit_score > 1.0` AND `risk_score < 1.5` AND `safety_flag != RED`
- **Tier 2 (interesting, needs caution)**: `benefit_score > 0.5` AND `risk_score < 3.0` (excluding Tier 1)
- **Tier 3 (deprioritize)**: `risk_score >= 3.0` OR `safety_flag == RED` AND no Tier-1 override
- **Tier U (insufficient data)**: `safety_flag == UNKNOWN` AND no v2/v3 predictions

Output: `results/ranked_candidates_v3_safety_v4.csv` adds `benefit_score, risk_score, tier, tier_rationale`. Plus a tier-table markdown `results/tier_table_v4.md`.

### Cytoscape export (`scripts/safety_v4/04_export_cytoscape.py`)

Per plan §16:

- **Nodes** (4 types): AD TWAS gene (red/blue by direction), drug target (orange), candidate drug (green; thick border = approved, red border = tier-3), side-effect AE group (purple), pathway (gray)
- **Edges** (5 types): gene-pathway, drug-target, target-AE (only if `mr_<ae>_evidence in {strong_causal, suggestive}`), drug-AE (predicted from v2 with width = `pred_P`), drug-AD-signature (LINCS reversal)

Output: `results/safety_v4/cytoscape_nodes.tsv` + `cytoscape_edges.tsv` + a `style.xml` Cytoscape style file. Manual import in Cytoscape; export `ad_benefit_risk_network.svg` for the paper figure.

### Reuse from v1/v2/v3
- All prior CSVs concatenated; no recomputation
- `safety_flag` from v1 stays as a tier override
- TWAS top-30 list from `rank_candidates.py`
- Approved AD drug list from `POSITIVE_CONTROLS` (already at `rank_candidates.py:35-38`)

### New external dependencies
- None for the CSV outputs (all pure pandas)
- Cytoscape Desktop for the manual import + figure export (already standard tool in the lab; no licensing required, free)

### Verification
- All 10 FDA-approved AD drugs land in Tier 1 or Tier 2 (none in Tier 3 — fail otherwise)
- ≤5 candidates in Tier 1 — strict gate ensures top-tier list is short and high-confidence
- Tier 3 includes most HDAC/CDK/HSP inhibitors (per plan §15 expectation: "broad reversal but poor safety")
- Cytoscape import succeeds and renders ≤500 nodes / ≤1500 edges (readability cap)

### Out of scope for v4
- Wet-lab validation / next-step compound selection (human-in-the-loop)
- Sensitivity analysis across hyperparameters (defer to v4.1 if needed)
- Time-series / longitudinal AE prediction (deferred indefinitely)

---

## Critical files

| Path | Status | Purpose |
|---|---|---|
| `drug-repurposing/scripts/safety/` | **EXISTING (v1)** | rule-based annotation; no changes |
| `drug-repurposing/scripts/safety_v2/` | NEW | ML AE prediction (4 scripts + README + run script) |
| `drug-repurposing/scripts/safety_v3/` | NEW | MR + coloc (4 scripts + README + run script) |
| `drug-repurposing/scripts/safety_v4/` | NEW | benefit-risk integration + Cytoscape (4 scripts + README + run script) |
| `drug-repurposing/data/safety/v2/` | NEW | label matrix, feature parquet, RDKit caches |
| `drug-repurposing/data/safety/v3/` | NEW | per-gene instruments, AE-proxy GWAS summary stats |
| `drug-repurposing/results/ranked_candidates_v3_safety_v2.csv` | NEW | v1 cols + 14 ML pred cols |
| `drug-repurposing/results/ranked_candidates_v3_safety_v3.csv` | NEW | v2 cols + 49 MR cols |
| `drug-repurposing/results/ranked_candidates_v3_safety_v4.csv` | NEW | v3 cols + 4 tier cols (FINAL) |
| `drug-repurposing/results/tier_table_v4.md` | NEW | narrative tier output |
| `drug-repurposing/results/safety_v4/cytoscape_{nodes,edges}.tsv` | NEW | network import |
| `drug-repurposing/scripts/README.md` | EDIT | add v2/v3/v4 step rows |

## Reused functions / patterns

- **Per-step folder + per-step script numbering** — match `safety/` (already shipped)
- **CSV append-only** — every release adds columns, never removes
- **Cached external downloads under `data/safety/v{N}/`** — same idempotency pattern
- **`POSITIVE_CONTROLS`** at `rank_candidates.py:35-38` — reused as ML/MR/tier validation set
- **TWAS top-30 list** at `rank_candidates.py:41-46` — input to v4 benefit-score and v4 Cytoscape
- **BigQuery dataset** `cmap-big-table.cmap_lincs_public_views` — reused by v2 LINCS-embedding step

## Verification (cross-version)

Each release's verification is documented inline above. Cross-cutting checks:

1. **Backward compatibility**: opening `ranked_candidates_v3_safety_v4.csv` with v1's column names succeeds (all 40 v1 cols present, unchanged values).
2. **Idempotency**: `bash scripts/safety_v{N}/run_v{N}.sh` re-runs in <5 min on warm cache for any version.
3. **Positive-control sweep**: tofacitinib's `safety_flag (v1)`, `pred_P_infection (v2)`, `mr_infection_evidence (v3)`, `tier (v4)` should each independently flag it as concerning. If any release fails this, that release's pipeline has a real bug.
4. **Tool-compound detectability**: the 30 v1-UNKNOWN BRD-K compounds should pick up signals in v2 (chemical/target features) and/or v3 (MR on resolved targets) — by v4 ≤10 should still be Tier U (down from 30 in v1).

## Out of scope (deferred beyond v4)

- **Polypharmacy AE prediction** (Decagon-style) — deferred indefinitely; not relevant for monotherapy AD repurposing
- **Biologic-specific feature model** — we keep biologics in but note lower feature coverage; a separate biologic model is a v5 candidate if data allows
- **Time-to-event AE modeling** — deferred; current scope is presence/absence of AE class
- **Wet-lab follow-up** — explicitly out of scope per plan §17
- **Real-time pharmacovigilance feed** — deferred; FAERS quarterly cache is sufficient
- **Multi-trait Mendelian randomization** — deferred; v3 sticks to univariate cis-MR
- **PRISM cytotoxicity filter** — listed in `drug-repurposing/scripts/README.md:147` as an independent v5 candidate (orthogonal to safety v2-v4)

## Suggested release cadence

- **v2**: 3–4 weeks (1 wk label/feature, 1 wk modeling, 1 wk validation, 1 wk write-up). Highest research-novelty release.
- **v3**: 2–3 weeks (most of the time is curating the 12 AE-proxy outcome GWAS; MR/coloc itself is a few hours per gene-AE pair on a laptop).
- **v4**: 1 week (pure integration + Cytoscape; no new data). Probably the easiest release.
- **Total**: ~8 weeks from today (2026-05-01) to a full benefit-risk-tiered ranking with network figure. Aligns with the plan's "MVP in 2–4 weeks" claim if v2 alone is the MVP and v3/v4 are paper extensions.
