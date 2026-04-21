#!/bin/bash
# =============================================================================
# run_impute.sh — Step 2: GWAS summary-statistic imputation.
#
# Runs summary-gwas-imputation's gwas_summary_imputation.py across all
# 22 × SUB_BATCHES = 220 (chr, sub_batch) combinations for a single trait.
# Idempotent: skips any (chr, batch) whose output file already exists.
#
# Usage:
#   bash run_impute.sh \
#       --gwas-file      PATH    harmonized GWAS (.txt.gz, hg38)
#       --ld-regions     PATH    eur_ld.bed.gz (LD block coordinates)
#       --parquet-dir    DIR     dir with chr{1..22}.variants.parquet + variant_metadata.parquet
#       --impute-script  PATH    gwas_summary_imputation.py
#       --output-dir     DIR     where to write chr${chr}_batch${batch}.txt.gz
#       [--sub-batches   N]      default 10  (22 × N = total jobs)
#       [--n-jobs        N]      parallel local workers, default 2
#       [--chromosome    C]      run only one chr (1..22); default: all
#       [--batch         B]      run only one sub-batch (0..SUB_BATCHES-1); default: all
#
# Example:
#   bash run_impute.sh \
#       --gwas-file     data/gwas/harmonized/harmonized_bbj-a-90.txt.gz \
#       --ld-regions    data/reference/eur_ld.bed.gz \
#       --parquet-dir   data/reference/reference_panel_1000G \
#       --impute-script external/summary-gwas-imputation/src/gwas_summary_imputation.py \
#       --output-dir    data/gwas/imputed/bbj-a-90
# =============================================================================
set -euo pipefail

# --- Defaults ---
GWAS_FILE=""; LD_REGIONS=""; PARQUET_DIR=""; IMPUTE_SCRIPT=""; OUTPUT_DIR=""
SUB_BATCHES=10; N_JOBS=2; ONLY_CHR=""; ONLY_BATCH=""

# --- Parse flags ---
while [[ $# -gt 0 ]]; do
  case "$1" in
    --gwas-file)      GWAS_FILE="$2"; shift 2 ;;
    --ld-regions)     LD_REGIONS="$2"; shift 2 ;;
    --parquet-dir)    PARQUET_DIR="$2"; shift 2 ;;
    --impute-script)  IMPUTE_SCRIPT="$2"; shift 2 ;;
    --output-dir)     OUTPUT_DIR="$2"; shift 2 ;;
    --sub-batches)    SUB_BATCHES="$2"; shift 2 ;;
    --n-jobs)         N_JOBS="$2"; shift 2 ;;
    --chromosome)     ONLY_CHR="$2"; shift 2 ;;
    --batch)          ONLY_BATCH="$2"; shift 2 ;;
    -h|--help)        sed -n '2,31p' "$0"; exit 0 ;;
    *) echo "Unknown argument: $1" >&2; exit 1 ;;
  esac
done

# --- Validate ---
for var in GWAS_FILE LD_REGIONS PARQUET_DIR IMPUTE_SCRIPT OUTPUT_DIR; do
  [[ -n "${!var}" ]] || { echo "ERROR: --${var,,//_/-} is required (see --help)" >&2; exit 1; }
done
for f in "$GWAS_FILE" "$LD_REGIONS" "$IMPUTE_SCRIPT"; do
  [[ -f "$f" ]] || { echo "ERROR: not found: $f" >&2; exit 1; }
done
[[ -d "$PARQUET_DIR" ]] || { echo "ERROR: not a dir: $PARQUET_DIR" >&2; exit 1; }
[[ -f "$PARQUET_DIR/variant_metadata.parquet" ]] || {
  echo "ERROR: $PARQUET_DIR/variant_metadata.parquet missing" >&2; exit 1; }

mkdir -p "$OUTPUT_DIR"

# --- Conda env ---
if ! command -v conda >/dev/null 2>&1; then
  source "$HOME/miniconda3/etc/profile.d/conda.sh"
fi
CONDA_BASE="$(conda info --base)"
PY="$CONDA_BASE/envs/gwasimputation/bin/python"
[[ -x "$PY" ]] || { echo "ERROR: $PY missing — run setup/setup_env.sh" >&2; exit 1; }

TOTAL=$(( 22 * SUB_BATCHES ))
echo "=== Step 2: GWAS Summary Imputation ==="
echo "  Total jobs: $TOTAL  (22 chromosomes × $SUB_BATCHES batches)"
echo "  Parallel:   $N_JOBS"
echo "  Output dir: $OUTPUT_DIR"

# --- Per-job runner ---
run_job() {
  local chr="$1" batch="$2"
  local out="$OUTPUT_DIR/chr${chr}_batch${batch}.txt.gz"
  if [[ -f "$out" ]]; then
    echo "  [skip] chr${chr} batch${batch}"; return
  fi
  echo "  [run ] chr${chr} batch${batch}"
  "$PY" "$IMPUTE_SCRIPT" \
    -by_region_file           "$LD_REGIONS" \
    -gwas_file                "$GWAS_FILE" \
    -parquet_genotype         "$PARQUET_DIR/chr${chr}.variants.parquet" \
    -parquet_genotype_metadata "$PARQUET_DIR/variant_metadata.parquet" \
    -window                   100000 \
    -parsimony                7 \
    -chromosome               "$chr" \
    -regularization           0.1 \
    -frequency_filter         0.01 \
    -sub_batches              "$SUB_BATCHES" \
    -sub_batch                "$batch" \
    --standardise_dosages \
    -output                   "$out"
}
export -f run_job
export GWAS_FILE LD_REGIONS PARQUET_DIR IMPUTE_SCRIPT OUTPUT_DIR SUB_BATCHES PY

# --- Emit (chr,batch) job list, filtered if --chromosome/--batch set ---
{
  for chr in $(seq 1 22); do
    [[ -n "$ONLY_CHR" && "$chr" != "$ONLY_CHR" ]] && continue
    for batch in $(seq 0 $(( SUB_BATCHES - 1 ))); do
      [[ -n "$ONLY_BATCH" && "$batch" != "$ONLY_BATCH" ]] && continue
      echo "$chr $batch"
    done
  done
} | xargs -P "$N_JOBS" -n 2 bash -c 'run_job "$@"' _

echo ""
echo "=== Imputation complete. Results in: $OUTPUT_DIR ==="
