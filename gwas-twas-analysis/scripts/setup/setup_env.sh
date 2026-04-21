#!/bin/bash
# =============================================================================
# setup_env.sh — Install Miniconda (if missing) and create the two conda
# environments used by the pipeline:
#
#   metaxcan         — SPrediXcan + SMulTiXcan (MetaXcan framework)
#   gwasimputation   — GWAS summary-statistic imputation
#
# Both environments are pinned to Python 3.9 for pyarrow / numpy compatibility
# with the upstream tools.
# =============================================================================
set -euo pipefail

MINICONDA_DIR="$HOME/miniconda3"

# --- Install Miniconda if absent ---
if ! command -v conda &>/dev/null && [[ ! -f "$MINICONDA_DIR/etc/profile.d/conda.sh" ]]; then
  echo "=== Installing Miniconda ==="
  case "$(uname -s)" in
    Darwin)
      case "$(uname -m)" in
        arm64) url="https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-arm64.sh" ;;
        *)     url="https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh" ;;
      esac ;;
    Linux) url="https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh" ;;
    *) echo "Unsupported OS: $(uname -s)" >&2; exit 1 ;;
  esac
  curl -fsSL "$url" -o /tmp/miniconda.sh
  bash /tmp/miniconda.sh -b -u -p "$MINICONDA_DIR"
  rm /tmp/miniconda.sh

  SHELL_RC="$HOME/.bashrc"; [[ "$SHELL" == */zsh ]] && SHELL_RC="$HOME/.zshrc"
  grep -q "miniconda3/etc/profile.d/conda.sh" "$SHELL_RC" 2>/dev/null || \
    echo "source $MINICONDA_DIR/etc/profile.d/conda.sh" >> "$SHELL_RC"
fi

# --- Make conda available in this shell ---
source "$MINICONDA_DIR/etc/profile.d/conda.sh"

# --- Create environments (idempotent) ---
create_env() {
  local name="$1" ; shift
  if conda env list | awk '{print $1}' | grep -qx "$name"; then
    echo "  [skip] env '$name' already exists"
  else
    echo "  [create] env '$name'"
    conda create -y -n "$name" python=3.9
    conda run -n "$name" pip install --quiet "$@"
  fi
}

echo "=== Creating conda environments ==="
create_env metaxcan        numpy pandas scipy h5py cyvcf2 pyliftover
create_env gwasimputation  numpy pandas scipy h5py pyliftover pyarrow

echo ""
echo "Done. Activate with:  conda activate metaxcan   # or gwasimputation"
