#!/bin/bash
# =============================================================================
# run_merge.sh — Step 2b (merge): combine the 220 per-batch imputation outputs
# plus the original harmonized GWAS into a single final file.
#
# Wraps summary-gwas-imputation's gwas_summary_imputation_postprocess.py.
# Idempotent: skips if --output already exists.
#
# Usage:
#   bash run_merge.sh \
#       --gwas-file           PATH    harmonized GWAS (.txt.gz, hg38)
#       --imputed-dir         DIR     dir containing chr*_batch*.txt.gz (from run_impute.sh)
#       --postprocess-script  PATH    gwas_summary_imputation_postprocess.py
#       --output              PATH    final merged .txt.gz
#       [--sub-batches        N]      expected batches per chr (default 10)
#
# Example:
#   bash run_merge.sh \
#       --gwas-file          data/gwas/harmonized/harmonized_bbj-a-90.txt.gz \
#       --imputed-dir        data/gwas/imputed/bbj-a-90 \
#       --postprocess-script external/summary-gwas-imputation/src/gwas_summary_imputation_postprocess.py \
#       --output             data/gwas/imputed/final_imputed_bbj-a-90.txt.gz
# =============================================================================
set -euo pipefail

GWAS_FILE=""; IMPUTED_DIR=""; POSTPROCESS_SCRIPT=""; OUTPUT=""; SUB_BATCHES=10

while [[ $# -gt 0 ]]; do
  case "$1" in
    --gwas-file)            GWAS_FILE="$2"; shift 2 ;;
    --imputed-dir)          IMPUTED_DIR="$2"; shift 2 ;;
    --postprocess-script)   POSTPROCESS_SCRIPT="$2"; shift 2 ;;
    --output)               OUTPUT="$2"; shift 2 ;;
    --sub-batches)          SUB_BATCHES="$2"; shift 2 ;;
    -h|--help)              sed -n '2,23p' "$0"; exit 0 ;;
    *) echo "Unknown argument: $1" >&2; exit 1 ;;
  esac
done

for var in GWAS_FILE IMPUTED_DIR POSTPROCESS_SCRIPT OUTPUT; do
  [[ -n "${!var}" ]] || { echo "ERROR: --${var,,//_/-} is required (see --help)" >&2; exit 1; }
done
[[ -f "$GWAS_FILE" ]] || { echo "ERROR: $GWAS_FILE not found" >&2; exit 1; }
[[ -f "$POSTPROCESS_SCRIPT" ]] || { echo "ERROR: $POSTPROCESS_SCRIPT not found" >&2; exit 1; }
[[ -d "$IMPUTED_DIR" ]] || { echo "ERROR: $IMPUTED_DIR not a dir" >&2; exit 1; }

# --- Conda env ---
if ! command -v conda >/dev/null 2>&1; then
  source "$HOME/miniconda3/etc/profile.d/conda.sh"
fi

if [[ -f "$OUTPUT" ]]; then
  echo "  [skip] $OUTPUT already exists"
  exit 0
fi

EXPECTED=$(( 22 * SUB_BATCHES ))
FOUND=$(find "$IMPUTED_DIR" -name "chr*_batch*.txt.gz" 2>/dev/null | wc -l | tr -d ' ')
echo "=== Step 2b: Merge imputed batches ==="
echo "  Found $FOUND / $EXPECTED batch files in $IMPUTED_DIR"
if [[ "$FOUND" -lt "$EXPECTED" ]]; then
  echo "  WARNING: fewer batches than expected; proceeding anyway."
fi

mkdir -p "$(dirname "$OUTPUT")"

conda run -n gwasimputation python "$POSTPROCESS_SCRIPT" \
  -gwas_file "$GWAS_FILE" \
  -folder    "$IMPUTED_DIR" \
  -pattern   "chr[0-9]+_batch[0-9]+\.txt\.gz" \
  -parsimony 7 \
  -output    "$OUTPUT"

echo "  [done] merged → $OUTPUT"
