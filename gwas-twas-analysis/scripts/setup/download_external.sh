#!/bin/bash
# =============================================================================
# download_external.sh — Clone third-party repositories needed by the pipeline.
#
#   external/MetaXcan/                — SPrediXcan.py and SMulTiXcan.py
#   external/summary-gwas-imputation/ — gwas_parsing.py, gwas_summary_imputation.py,
#                                       gwas_summary_imputation_postprocess.py
#
# Idempotent: skips anything already cloned.
# =============================================================================
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
EXTERNAL_DIR="$REPO_ROOT/external"
mkdir -p "$EXTERNAL_DIR"

clone_if_missing() {
  local url="$1" dest="$2"
  if [[ -d "$dest/.git" ]]; then
    echo "  [skip] $(basename "$dest") already present"
  else
    echo "  [clone] $url → $dest"
    git clone --depth 1 "$url" "$dest"
  fi
}

echo "=== Cloning external repositories into $EXTERNAL_DIR ==="
clone_if_missing https://github.com/hakyimlab/MetaXcan.git \
                 "$EXTERNAL_DIR/MetaXcan"
clone_if_missing https://github.com/hakyimlab/summary-gwas-imputation.git \
                 "$EXTERNAL_DIR/summary-gwas-imputation"

echo "Done. External tools available at: $EXTERNAL_DIR"
