#!/bin/bash
# =============================================================================
# run_smultixcan.sh — Step 4: cross-tissue gene-level TWAS via MetaXcan's
# SMulTiXcan.py. Combines per-tissue SPrediXcan results into one gene-level file.
#
# Idempotent: skips if --output already exists.
#
# Usage:
#   bash run_smultixcan.sh \
#       --gwas-file         PATH    final imputed GWAS (.txt.gz)
#       --spredixcan-dir    DIR     dir with spredixcan_<trait>_<tissue>.csv files
#       --models-dir        DIR     GTEx mashr models (same as spredixcan step)
#       --snp-covariance    PATH    gtex_v8_expression_mashr_snp_smultixcan_covariance.txt.gz
#       --metaxcan-dir      DIR     root of the MetaXcan repo
#       --trait             ID      trait label embedded in spredixcan filenames
#       --output            PATH    final smultixcan CSV
#
# Example:
#   bash run_smultixcan.sh \
#       --gwas-file       data/gwas/imputed/final_imputed_bbj-a-90.txt.gz \
#       --spredixcan-dir  data/twas/spredixcan/bbj-a-90 \
#       --models-dir      data/reference/gtex_v8_mashr_models \
#       --snp-covariance  data/reference/gtex_v8_expression_mashr_snp_smultixcan_covariance.txt.gz \
#       --metaxcan-dir    external/MetaXcan \
#       --trait           bbj-a-90 \
#       --output          data/twas/smultixcan/smultixcan_bbj-a-90.csv
# =============================================================================
set -euo pipefail

GWAS_FILE=""; SPREDIXCAN_DIR=""; MODELS_DIR=""; SNP_COVARIANCE=""
METAXCAN_DIR=""; TRAIT=""; OUTPUT=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --gwas-file)        GWAS_FILE="$2"; shift 2 ;;
    --spredixcan-dir)   SPREDIXCAN_DIR="$2"; shift 2 ;;
    --models-dir)       MODELS_DIR="$2"; shift 2 ;;
    --snp-covariance)   SNP_COVARIANCE="$2"; shift 2 ;;
    --metaxcan-dir)     METAXCAN_DIR="$2"; shift 2 ;;
    --trait)            TRAIT="$2"; shift 2 ;;
    --output)           OUTPUT="$2"; shift 2 ;;
    -h|--help)          sed -n '2,26p' "$0"; exit 0 ;;
    *) echo "Unknown argument: $1" >&2; exit 1 ;;
  esac
done

for var in GWAS_FILE SPREDIXCAN_DIR MODELS_DIR SNP_COVARIANCE METAXCAN_DIR TRAIT OUTPUT; do
  [[ -n "${!var}" ]] || { echo "ERROR: --${var,,//_/-} is required (see --help)" >&2; exit 1; }
done
[[ -f "$GWAS_FILE" ]]      || { echo "ERROR: $GWAS_FILE not found" >&2; exit 1; }
[[ -d "$SPREDIXCAN_DIR" ]] || { echo "ERROR: $SPREDIXCAN_DIR not a dir" >&2; exit 1; }
[[ -d "$MODELS_DIR" ]]     || { echo "ERROR: $MODELS_DIR not a dir" >&2; exit 1; }
[[ -f "$SNP_COVARIANCE" ]] || { echo "ERROR: $SNP_COVARIANCE not found" >&2; exit 1; }
[[ -f "$METAXCAN_DIR/software/SMulTiXcan.py" ]] || {
  echo "ERROR: $METAXCAN_DIR/software/SMulTiXcan.py missing" >&2; exit 1; }

N_TISSUES=$(ls "$SPREDIXCAN_DIR"/spredixcan_${TRAIT}_*.csv 2>/dev/null | wc -l | tr -d ' ')
[[ "$N_TISSUES" -gt 0 ]] || {
  echo "ERROR: no spredixcan_${TRAIT}_*.csv files in $SPREDIXCAN_DIR" >&2; exit 1; }

# --- Conda env ---
if ! command -v conda >/dev/null 2>&1; then
  source "$HOME/miniconda3/etc/profile.d/conda.sh"
fi

if [[ -f "$OUTPUT" ]]; then
  echo "  [skip] $OUTPUT already exists"; exit 0
fi

mkdir -p "$(dirname "$OUTPUT")"

echo "=== Step 4: SMulTiXcan — Multi-Tissue TWAS ==="
echo "  SPrediXcan tissues: $N_TISSUES"
echo "  Output:             $OUTPUT"

conda run -n metaxcan python "$METAXCAN_DIR/software/SMulTiXcan.py" \
  --models_folder                  "$MODELS_DIR" \
  --models_name_pattern            "mashr_(.*).db" \
  --snp_covariance                 "$SNP_COVARIANCE" \
  --metaxcan_folder                "$SPREDIXCAN_DIR" \
  --metaxcan_filter                "spredixcan_${TRAIT}_(.*).csv" \
  --metaxcan_file_name_parse_pattern "spredixcan_${TRAIT}_(.*).csv" \
  --gwas_file                      "$GWAS_FILE" \
  --snp_column                     panel_variant_id \
  --effect_allele_column           effect_allele \
  --non_effect_allele_column       non_effect_allele \
  --zscore_column                  zscore \
  --keep_non_rsid \
  --model_db_snp_key               varID \
  --cutoff_condition_number        30 \
  --verbosity                      7 \
  --throw \
  --output                         "$OUTPUT"

echo "  [done] $OUTPUT"
