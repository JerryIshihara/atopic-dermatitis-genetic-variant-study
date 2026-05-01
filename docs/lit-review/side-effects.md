# Atopic Dermatitis Drug Side Effects & Safety Profiles

_Synthesized 2026-04-28 from three parallel literature searches. Spot-check citations before externalizing._

Existing coverage in this folder lives inline in [`recent-drugs.md`](./recent-drugs.md) (19 safety mentions, mostly per-drug AE notes inside efficacy paragraphs) and [`repurposing.md`](./repurposing.md) (5 mentions, mostly noting "well-tolerated" without details). This file consolidates both into a single class-organized table with PMID-cited primary sources, and fills the gaps flagged in the inventory pass: rocatinlimab/amlitelimab (OX40 axis), comparative JAK risks, apremilast GI profile, tocilizumab/canakinumab/alemtuzumab translation barriers.

## 1. Approved AD drugs (FDA-approved as of April 2026)

### Anti-cytokine biologics (anti-IL-4Rα / IL-13 / IL-31Rα)

| Drug | Mechanism | Common AEs (>5%) | Serious AEs / boxed warnings | Distinctive signal | Citation |
|---|---|---|---|---|---|
| **Dupilumab** (Dupixent) | Anti-IL-4Rα | Nasopharyngitis, conjunctivitis (5–10%), molluscum (5% peds), injection-site reactions | Hypersensitivity (anaphylaxis, serum sickness, EM); rebound dermatitis on discontinuation | High ocular AE incidence; head-to-head highest dry-eye / vision-blurred signal | [PMID 37205852](https://pubmed.ncbi.nlm.nih.gov/37205852/); [PMC11903887 FAERS analysis](https://pmc.ncbi.nlm.nih.gov/articles/PMC11903887/) |
| **Lebrikizumab** (Ebglyss) | Anti-IL-13 | Conjunctivitis (7.4–7.5%), injection-site reactions (3%) | Keratitis (0.6%); angioedema, urticaria | IL-13 mechanism-linked ocular inflammation; mild-moderate, mostly resolved | [PMID 37195407](https://pubmed.ncbi.nlm.nih.gov/37195407/) — pooled 8-trial integrated analysis |
| **Tralokinumab** (Adbry) | Anti-IL-13 | Nasopharyngitis, conjunctivitis (IRR 3.11), mild ISRs | None — all mild-moderate, comparable to placebo | Lower conjunctivitis than lebrikizumab; clean through 4.5-yr long-term follow-up | [PMID 36082590](https://pubmed.ncbi.nlm.nih.gov/36082590/) — pooled 5-RCT analysis |
| **Nemolizumab** (Nemluvio) | Anti-IL-31Rα | Headache (5–6%), arthralgia, mild AD exacerbation (4%), nummular eczema (3%) | 1–3% serious TEAEs (similar to placebo); no deaths | New mechanism — no infections / malignancies signal yet, but only 12-mo data | [FDA NEMLUVIO label](https://www.accessdata.fda.gov/drugsatfda_docs/label/2024/761391s000lbl.pdf); ARCADIA-1/2 trials |

**Class-level note**: anti-IL-13 agents share a conjunctivitis signal (probably mechanism-mediated via reduced ocular barrier IL-13 tone). Dry eye / facial erythema are more common with biologics than with JAK inhibitors in real-world Spanish cohort data ([recent-drugs.md:167–170](./recent-drugs.md)). No malignancy or thrombosis signal across this class.

### Oral JAK inhibitors

| Drug | Mechanism | Common AEs (>5%) | Boxed warning (FDA 2021) | Distinctive signal | Citation |
|---|---|---|---|---|---|
| **Baricitinib** | JAK1/2 | Upper RTI, nasopharyngitis, ↑CPK, headache | MACE 0.19, stroke 0.11, MI 0.06, PE 0.07, malignancy ex-NMSC 0.39, all-cause death 0.10 (per 100 PY) | Pediatric extension (3.6 yr) clean — no new signals | [PMID 36546346](https://pubmed.ncbi.nlm.nih.gov/36546346/) — 8-trial integrated safety |
| **Upadacitinib** | JAK1 | COVID-19, nasopharyngitis, **acne** (signature AE), upper RTI, ↑CPK, oral herpes | MACE 0.1–0.2, VTE <0.1, malignancy 0.3–0.5, dose-dependent herpes (per 100 PY) | UPA30 > UPA15 for hepatic disorder, neutropenia, ↑CPK | [PMID 41239921](https://pubmed.ncbi.nlm.nih.gov/41239921/) — 6-yr integrated safety |
| **Abrocitinib** | JAK1 | **Nausea (14.6% at 200 mg)**, headache (7.8%), acne (4.7%), herpes simplex, vomiting | Serious infections 2.33, herpes zoster/simplex 2.65, malignancies <0.5, MACE <0.5 (per 100 PY) | GI tolerability (nausea, vomiting) is the dose-limiting AE — common discontinuation driver | [PMID 34406619](https://pubmed.ncbi.nlm.nih.gov/34406619/); [PMC11333678](https://pmc.ncbi.nlm.nih.gov/articles/PMC11333678/) |

**Class-level boxed warning** (FDA 2021): based on the [tofacitinib ORAL Surveillance trial](https://www.fda.gov/safety/medical-product-safety-information/janus-kinase-jak-inhibitors-drug-safety-communication-fda-requires-warnings-about-increased-risk):
- MACE: tofacitinib 0.98/100 PY vs TNFi 0.73 (statistically increased)
- Malignancies: 48% increased risk vs TNFi
- Thrombosis (DVT/PE), serious infections (incl. opportunistic + TB), all-cause mortality
- **Important**: baricitinib, upadacitinib, abrocitinib carry the warning by mechanism class, NOT by direct trial. Comparative head-to-head safety remains poorly characterized — flagged as an open question in [recent-drugs.md:237](./recent-drugs.md).

### Topical agents

| Drug | Mechanism | Common AEs (>5%) | Serious AEs | Distinctive signal | Citation |
|---|---|---|---|---|---|
| **Ruxolitinib cream** | Topical JAK1/2 | Upper RTI (10–11%), nasopharyngitis (9–10%), application-site reactions (3.8%) | None observed in adolescents — no MACE / VTE / malignancies | Minimal systemic exposure rescues the JAK class label; pediatric long-term still maturing | [PMID 38698175](https://pubmed.ncbi.nlm.nih.gov/38698175/) |
| **Roflumilast cream** | Topical PDE4 | Upper RTI (4.1% peds), headache, mild diarrhea/nausea/vomiting | None reported (1-yr open-label) | GI signal much smaller than oral PDE4i (apremilast); ≥91% no/mild application-site irritation | [PMID 39792455](https://pubmed.ncbi.nlm.nih.gov/39792455/) |
| **Tapinarof cream** | AhR agonist | Upper RTI, **folliculitis (~20%, mild self-limiting)**, lower RTI, headache | None; rare urticaria / drug eruption (<1%) | Folliculitis is dose-related but reversible; no systemic signal | [PMID 39269202](https://pubmed.ncbi.nlm.nih.gov/39269202/); [PMC12494503](https://pmc.ncbi.nlm.nih.gov/articles/PMC12494503/) |

## 2. Repurposing candidates (not approved for AD)

### Profile vs. AD-translation viability

| Drug | Original indication | Common AEs | Serious AEs / boxed warning | Translation to AD | Citation |
|---|---|---|---|---|---|
| **Apremilast** (oral PDE4) | Psoriasis, PsA | **Diarrhea 17%, nausea 16%**, nasopharyngitis, headache | Depression 1.78, MACE 0.30, serious infection 1.10 (per 100 pt-yr); **no boxed warning** | GI tolerability (oral PDE4i) is the question for chronic AD use | [PMID 37316690](https://pubmed.ncbi.nlm.nih.gov/37316690/) — 5-yr safety |
| **Nintedanib** (oral RTK) | IPF, progressive fibrosing ILD | **Diarrhea 61–63%**, nausea, ↓appetite | GI perforation 1.0/1000 pt-yr, MI 4.3/1000 pt-yr; no boxed warning | Diarrhea incidence likely prohibitive for chronic benign skin disease | [PMID 35392908 — INBUILD safety](https://pubmed.ncbi.nlm.nih.gov/35392908/) |
| **Low-dose naltrexone (LDN)** | Opioid antagonist (off-label chronic pain) | Vivid dreams, insomnia, nausea, headache (transient, rare) | None severe in 78% of evaluated studies | Excellent tolerability supports translation; mechanism rationale (TLR4 antagonism for neurogenic itch) plausible | [PMID 38301136](https://pubmed.ncbi.nlm.nih.gov/38301136/) |
| **Rupatadine** (H1 + PAF) | Chronic spontaneous urticaria | Somnolence 14%, ~18% any-ADR over 12 mo | None serious | Dual H1/PAF antagonism directly targets pruritus; CSU regulatory precedent useful for AD | [PMID 31196788](https://pubmed.ncbi.nlm.nih.gov/31196788/) |
| **Bilastine** (H1) | CSU, allergic rhinitis | Headache, mild somnolence (lower than cetirizine) | None in refractory CSU trials (2024) | Non-sedating profile favors compliance; H1-only less potent than rupatadine | [Front. Immunol. 2024 — refractory CSU](https://www.frontiersin.org/journals/immunology/articles/10.3389/fimmu.2024.1441478/full) |
| **Saroglitazar** (PPAR α/γ) | Diabetic dyslipidemia | Dyspepsia, gastritis 10–17% (mild) | None; **avoids** classic TZD liabilities (no edema / weight gain / CHF / GFR drop) | PPARγ activation supports anti-inflammatory action; limited dermatology data | [PMID 35776741](https://pubmed.ncbi.nlm.nih.gov/35776741/) |
| **Tocilizumab** (anti-IL-6) | RA | Elevated LFTs, lipid abnormalities | **Boxed warning**: serious infections (163.7/100 pt-yr in RA cohorts), GI perforation | Infection-monitoring burden + chronic-skin-disease risk-benefit unfavorable | [PMID 34538944](https://pubmed.ncbi.nlm.nih.gov/34538944/) |
| **Canakinumab** (anti-IL-1β) | CAPS, sJIA | Infections (pneumonia, tonsillitis) | **Boxed warning**: serious infections; rare MAS reactivation in JIA | IL-1β secondary to IL-4/13 in AD; pediatric MAS precedent limits adult AD use | [PMID 41121260](https://pubmed.ncbi.nlm.nih.gov/41121260/) |
| **Alemtuzumab** (anti-CD52) | MS, B-CLL | Infusion reactions >90%, frequent RTI, lymphopenia | **Boxed warning**: secondary autoimmunity (thyroid 18–26%, ITP 1–3%, anti-GBM 1%); fatal events | Risk profile prohibitive for non-life-threatening skin disease | [PMID 31405369](https://pubmed.ncbi.nlm.nih.gov/31405369/) |
| **BEN-2293** (topical pan-Trk) | First-in-class for AD | Drug was **safe and well-tolerated** | None | Phase 2 missed primary itch / EASI endpoints — failure was efficacy, not safety | [BenevolentAI release, Apr 2023](https://www.benevolent.com/news-and-media/press-releases-and-in-media/benevolentai-announces-top-line-phase-iia-results-its-topical-pan-trk-inhibitor-ben-2293-1-mild-moderate-atopic-dermatitis/) |

## 3. Class take-aways for repurposing prioritization

1. **Anti-IL-13 vs anti-IL-4Rα**: IL-13-only agents (lebrikizumab, tralokinumab) have a cleaner ocular AE profile than dupilumab — relevant when comparing biologic candidates flagged by GWAS-driven repurposing.
2. **Oral JAK inhibitors carry a class boxed warning** that dominates repurposing benefit/risk for chronic, non-life-threatening AD. Topical JAK (ruxolitinib cream) escapes this through low systemic exposure — a useful template for repurposing systemic agents into topical formulations.
3. **Oral PDE4 (apremilast) GI tolerability is the dominant translation barrier**, not class-level safety. Topical PDE4 (roflumilast) sidesteps it cleanly — supporting topical reformulation of any oral repurposing hit where feasible.
4. **Strong-effect biologics from RA/CLL (tocilizumab, canakinumab, alemtuzumab)** carry infection / autoimmunity / fatal-event risks that rule them out for benign chronic disease despite TWAS-implicating their pathways. These should be flagged "do-not-prioritize" if a TWAS hit lands on IL-6 / IL-1β / CD52.
5. **Antihistamines (rupatadine, bilastine), low-dose naltrexone, saroglitazar** show excellent tolerability and mechanism plausibility — these are the highest-priority repurposing candidates from a safety standpoint, even if mechanism evidence in AD is weaker.
6. **BEN-2293's failure underscores** that AI-prioritized novel mechanisms can fail on efficacy at clinically tolerable concentrations even with safe drugs — Trk inhibition wasn't ruled out as a target, just at that dose / formulation.

## 4. Open questions

- No published head-to-head MACE/VTE rate comparison for baricitinib vs upadacitinib vs abrocitinib in AD specifically — the boxed warning is class-applied without trial-level data for any AD indication.
- OX40/OX40L Phase 3 readouts (rocatinlimab, amlitelimab) had positive efficacy, but **AD-specific safety summaries are not yet published** — a significant gap in `recent-drugs.md` to fill once the trials are peer-reviewed.
- Long-term topical JAK (ruxolitinib) systemic absorption in pediatric AD with extensive skin barrier dysfunction remains an open safety question per [recent-drugs.md:242](./recent-drugs.md).
- Apremilast's GI AE profile in AD specifically (vs. its psoriasis benchmark) lacks Phase 3 data — the n=185 Phase 2 didn't break out per-drug AE rates.

## Sources

Primary sources are linked inline above (PMID, PMC, FDA labels, peer-reviewed journals). Secondary sources from the existing lit-review folder: [`recent-drugs.md`](./recent-drugs.md), [`repurposing.md`](./repurposing.md).
