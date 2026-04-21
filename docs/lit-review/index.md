# Atopic Dermatitis — Research Index

_Seeded 2026-04-19 by a team of 5 parallel Claude Haiku research subagents. Each aspect file was authored independently; citations are inline and should be spot-verified before downstream use._

## Why this folder exists

This repo (`bio-drug-repurpose-research`) runs a GWAS/TWAS drug-repurposing pipeline built on S-PrediXcan / MetaXcan. Atopic dermatitis (AD) is a high-value new disease target because (1) large, well-powered GWAS summary statistics are publicly available, (2) the therapeutic landscape has shifted rapidly since 2023 with multiple approvals and late-stage readouts, and (3) genetics-validated targets (IL-13, IL-4R, JAK) already have approved drugs, giving an internal benchmark for repurposing hits from the pipeline.

This index summarizes the five aspect files in this folder and highlights the threads that connect them.

## Aspect files

| File | Scope |
|---|---|
| [mechanism.md](./mechanism.md) | Pathophysiology: Th2/Th22/Th17 cytokine axes, skin barrier (filaggrin, ceramides, claudin), *S. aureus* dysbiosis, IL-31 neuroimmune itch circuit, emerging OX40/OX40L and AhR biology |
| [recent-drugs.md](./recent-drugs.md) | 2024–2026 FDA/EMA approvals, Phase 3 readouts, JAK inhibitor safety, failed programs (cendakimab Phase 3, tezepelumab Phase 2) |
| [genetics-gwas.md](./genetics-gwas.md) | Downloadable AD GWAS summary statistics, priority tissues and genes for TWAS, cross-ancestry portability caveats, rare-variant gaps |
| [repurposing.md](./repurposing.md) | Approved drugs in AD clinical testing, computational signature-reversal hits, genetics-driven target validation, key data resources |
| [ml-methods.md](./ml-methods.md) | Deep-learning (ViT severity scoring, spatial-transcriptomic transformers, GNN drug-target models) and statistical methodology (MR, coloc+SuSiE, TWAS, PTRS, Bayesian NMA) applied to AD |

## Combined executive summary

**Mechanism.** AD is driven by the convergence of immune dysregulation (Th2-acute, Th22/Th17-chronic), epidermal-barrier dysfunction (FLG loss-of-function, shifted ceramide composition), and a neuroimmune itch circuit mediated by IL-31 → IL-31RA on TRPV1+/TRPA1+ nociceptors. 2024–2026 work elevates OX40/OX40L costimulation, AhR signaling, and the mast-cell–neuron axis as tractable upstream targets.

**Recent drugs.** 2024–2025 brought four AD approvals: **lebrikizumab** (IL-13), **nemolizumab** (IL-31Ra), **roflumilast cream** (PDE4), and **tapinarof cream** (AhR). Phase 3 readouts for **rocatinlimab** and **amlitelimab** (anti-OX40 / anti-OX40L) were positive, with amlitelimab's Q12W dosing a notable real-world advantage. **Cendakimab** was discontinued after Phase 3; **tezepelumab** did not advance beyond Phase 2 for AD despite strong asthma data — a reminder that murine TSLP/IL-33 signals do not fully translate to humans.

**Genetics for this repo's pipeline.** The single most actionable asset for AD TWAS work is the 2024 multi-ancestry meta-analysis (56K cases, 101 loci, ancestry-stratified sumstats on FigShare). FinnGen (~20K cases) and Biobank Japan are strong secondary cohorts. Priority TWAS tissues are skin (sun-exposed and non-sun-exposed, GTEx v8) and whole blood; top genes include **FLG**, **OVOL1**, **ACER3**, **IL13/IL4**, and **C11orf30/LRRC32**. Cross-ancestry eQTL weight portability and rare-variant coverage (~20% of heritability) are open caveats.

**Repurposing.** Genetics-validated therapies (anti-IL-13, anti-IL-4R, JAK) are already approved — this gives the pipeline positive controls. Credible repurposing candidates beyond the approved set include **apremilast** (Phase 2 complete), **nintedanib** (preclinical), and broader PDE4 / network-pharmacology-expanded hits from LINCS L1000, Open Targets, DrugBank, DGIdb, and STRING neighborhoods.

**Methods.** For a TWAS-driven repurposing workflow, the most useful additions on top of S-PrediXcan output are: **coloc+SuSiE** on significant genes to filter to shared causal variants, **two-sample MR** on TWAS hits to confirm directionality, **MR-JTI** for causal gene prioritization, **polygenic transcriptome risk scores (PTRS)** for cohort stratification, **TxGNN**-style graph neural networks to map retained genes to marketed drugs, and **Bayesian network meta-analysis** to benchmark nominated candidates against approved biologics/JAKi.

## Cross-aspect threads

1. **IL-13 axis is the most densely validated in AD:** it recurs in mechanism (Th2 cytokines), recent-drugs (dupilumab, tralokinumab, lebrikizumab), genetics (IL13/IL4 risk locus), repurposing (MR-validated target), and methods (two-sample MR as a template for other candidates). Use it as the internal positive control when evaluating new repurposing hits.
2. **OX40/OX40L is the most likely near-term mechanism-to-drug transition** (mechanism.md → recent-drugs.md) and deserves explicit coverage in any upcoming pipeline run.
3. **Skin-barrier biology** (FLG, ceramides) is the strongest non-immune signal — it appears in mechanism, genetics (FLG is the top locus), repurposing (ceramide-restoring topicals), and methods (keratinocyte-specific eQTL for topical-drug prioritization). Consider a skin-only sub-analysis in addition to multi-tissue.
4. **Species-translation gap** (anti-IL-33, anti-TSLP failures in humans despite murine support) argues for prioritizing human-genetics-anchored targets from TWAS/MR over pure mouse-model leads.

## Recommended next steps for this repo

- Download the 2024 multi-ancestry AD sumstats and FinnGen AD sumstats; harmonize per the `scripts/` pipeline.
- Run S-PrediXcan across skin (sun-exposed, not-sun-exposed) and whole-blood GTEx models.
- Layer coloc+SuSiE and MR-JTI on top-TWAS genes.
- Map retained genes to LINCS L1000 / Open Targets / DGIdb for repurposing candidates; benchmark against approved AD drugs as positive controls.
- Flag any non-approved hits overlapping with Phase-2/3 pipeline entries in `recent-drugs.md` as highest-priority follow-up.

## Caveats

- Citations were produced by LLM-driven web search; spot-check URLs, publication years, and efficacy numbers before citing externally.
- "Recent" was scoped to 2024–2026 with landmark older papers retained where critical — do not treat any file as exhaustive.
- None of this replaces a formal systematic review; this folder is a scaffold for pipeline-directed literature work.
