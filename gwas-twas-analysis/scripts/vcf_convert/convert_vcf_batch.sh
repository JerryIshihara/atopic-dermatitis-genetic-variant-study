#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 2 ]]; then
  echo "Usage: $0 <input_dir> <output_dir>"
  echo "  input_dir   Directory containing *.vcf.gz files"
  echo "  output_dir  Directory for converted *.table.gz files"
  exit 1
fi

INDIR="$1"
OUTDIR="$2"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

mkdir -p "$OUTDIR"

for vcf in "$INDIR"/*.vcf.gz; do
  base="${vcf##*/}"; base="${base%.vcf.gz}"
  out="$OUTDIR/${base}.table.gz"
  if [[ -f "$out" ]]; then
    echo "SKIP exists: $(basename "$out")"
    continue
  fi
  echo "Convert: $(basename "$vcf") -> $(basename "$out")"
  python3 "$SCRIPT_DIR/vcf_to_table.py" "$vcf" "$out"
done

# z≈ES/SE
first=$(ls "$OUTDIR"/*.table.gz | head -n 1)
echo "Sample head: $(basename "$first")"
gunzip -c "$first" | head
echo "Check z≈ES/SE:"
gunzip -c "$first" | awk -F'\t' '
NR==1{for(i=1;i<=NF;i++) h[$i]=i; next}
$h["effect_size"]!="NA" && $h["standard_error"]!="NA" && $h["standard_error"]!="0" {
  calc=$h["effect_size"]/$h["standard_error"]; print "z=", $h["zscore"], "calc=", calc; exit
}'
