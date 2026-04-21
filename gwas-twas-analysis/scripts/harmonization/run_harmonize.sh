#!/bin/bash
# =============================================================================
# run_harmonize.sh — Step 1: GWAS coordinate harmonization (hg19 → hg38) and
# column standardization via summary-gwas-imputation's gwas_parsing.py.
#
# Output goes to  <gwas-twas-analysis>/data/harmonized/harmonized_<trait>.txt.gz
# (override the parent dir with --output-dir if needed).
#
# Usage:
#   bash run_harmonize.sh \
#       --trait          ID      OpenGWAS ID; used in output filename
#       --gwas-file      PATH    input .table.gz (standardized columns, hg19)
#       --liftover       PATH    hg19ToHg38.over.chain.gz
#       --snp-metadata   PATH    variant_metadata.txt.gz (reference panel)
#       --gwas-parsing   PATH    gwas_parsing.py (from summary-gwas-imputation)
#       [--output-dir    DIR]    default: <analysis>/data/harmonized
#       [--sample-size   N]      default: NA
#       [--n-cases       N]      default: NA
#
# Example:
#   bash run_harmonize.sh \
#       --trait         bbj-a-90 \
#       --gwas-file     data/gwas/tables/bbj-a-90.table.gz \
#       --liftover      data/liftover/hg19ToHg38.over.chain.gz \
#       --snp-metadata  data/reference/variant_metadata.txt.gz \
#       --gwas-parsing  external/summary-gwas-imputation/src/gwas_parsing.py \
#       --sample-size   212036
# =============================================================================
set -euo pipefail

# scripts/harmonization/run_harmonize.sh → gwas-twas-analysis/
ANALYSIS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
DEFAULT_OUTPUT_DIR="$ANALYSIS_DIR/data/harmonized"

# --- Defaults ---
GWAS_FILE=""; LIFTOVER=""; SNP_METADATA=""; GWAS_PARSING=""
OUTPUT_DIR="$DEFAULT_OUTPUT_DIR"; SAMPLE_SIZE="NA"; N_CASES="NA"; TRAIT=""

# --- Parse flags ---
while [[ $# -gt 0 ]]; do
  case "$1" in
    --trait)         TRAIT="$2"; shift 2 ;;
    --gwas-file)     GWAS_FILE="$2"; shift 2 ;;
    --liftover)      LIFTOVER="$2"; shift 2 ;;
    --snp-metadata)  SNP_METADATA="$2"; shift 2 ;;
    --gwas-parsing)  GWAS_PARSING="$2"; shift 2 ;;
    --output-dir)    OUTPUT_DIR="$2"; shift 2 ;;
    --sample-size)   SAMPLE_SIZE="$2"; shift 2 ;;
    --n-cases)       N_CASES="$2"; shift 2 ;;
    -h|--help)       sed -n '2,28p' "$0"; exit 0 ;;
    *) echo "Unknown argument: $1" >&2; exit 1 ;;
  esac
done

# --- Validate ---
for var in TRAIT GWAS_FILE LIFTOVER SNP_METADATA GWAS_PARSING; do
  [[ -n "${!var}" ]] || { echo "ERROR: --${var,,} is required (see --help)" >&2; exit 1; }
done
for f in "$GWAS_FILE" "$LIFTOVER" "$SNP_METADATA" "$GWAS_PARSING"; do
  [[ -f "$f" ]] || { echo "ERROR: not found: $f" >&2; exit 1; }
done

OUTPUT="$OUTPUT_DIR/harmonized_${TRAIT}.txt.gz"

# --- Conda env ---
if ! command -v conda >/dev/null 2>&1; then
  source "$HOME/miniconda3/etc/profile.d/conda.sh"
fi

mkdir -p "$OUTPUT_DIR"

if [[ -f "$OUTPUT" ]]; then
  echo "  [skip] $TRAIT — $OUTPUT already exists"
  exit 0
fi

echo "  [run]  $TRAIT  (n=$SAMPLE_SIZE, cases=$N_CASES)"
echo "    in:  $GWAS_FILE"
echo "    out: $OUTPUT"

conda run -n gwasimputation python "$GWAS_PARSING" \
  -gwas_file              "$GWAS_FILE" \
  -output                 "$OUTPUT" \
  -liftover               "$LIFTOVER" \
  --chromosome_format \
  -snp_reference_metadata "$SNP_METADATA" METADATA \
  -output_column_map variant_id         variant_id \
  -output_column_map non_effect_allele  non_effect_allele \
  -output_column_map effect_allele      effect_allele \
  -output_column_map effect_size        effect_size \
  -output_column_map pvalue             pvalue \
  -output_column_map chromosome         chromosome \
  -output_column_map position           position \
  -output_column_map zscore             zscore \
  -output_column_map standard_error     standard_error \
  --insert_value sample_size "$SAMPLE_SIZE" \
  --insert_value n_cases     "$N_CASES" \
  -output_order variant_id panel_variant_id chromosome position \
                effect_allele non_effect_allele frequency pvalue zscore \
                effect_size standard_error sample_size n_cases

echo "  [done] $TRAIT → $OUTPUT"
