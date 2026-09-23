#!/usr/bin/env bash
# ================================================================
# Operation Black Forge — Evidence Integrity & Submission Script
# CIP-A105 CTF 2 | C11/26/EHIT/17332
# Run this from inside your CIP-A105_CTF2_Black-Forge/ directory
# BEFORE submitting. It will:
#   1. Copy key tool output files from ~/openemr_exploit/ and ~/
#   2. Compute SHA256 hashes of all evidence files
#   3. Write evidence_hashes.txt for inclusion in the report
# ================================================================

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASE="$(dirname "$SCRIPT_DIR")"   # CIP-A105_CTF2_Black-Forge/
HASH_FILE="$BASE/evidence_hashes.txt"

echo "============================================================"
echo " Operation Black Forge — Evidence Integrity Script"
echo " $(date '+%Y-%m-%d %H:%M:%S %Z')"
echo "============================================================"

# ── Step 1: Copy tool output files from common Kali locations ──
echo ""
echo "[*] Copying tool output files..."

declare -A COPY_MAP=(
  ["$HOME/full_tcp_scan.txt"]="$BASE/evidence/01_network_discovery/full_tcp_scan.txt"
  ["$HOME/service_scan.txt"]="$BASE/evidence/02_service_enumeration/service_scan.txt"
  ["$HOME/gobuster_root.txt"]="$BASE/evidence/03_web_enumeration/gobuster_root.txt"
  ["$HOME/gobuster_medium.txt"]="$BASE/evidence/03_web_enumeration/gobuster_medium.txt"
  ["$HOME/gobuster_small_php.txt"]="$BASE/evidence/03_web_enumeration/gobuster_small_php.txt"
  ["$HOME/nikto_scan.txt"]="$BASE/evidence/03_web_enumeration/nikto_scan.txt"
  ["$HOME/shellshock_test.txt"]="$BASE/evidence/03_web_enumeration/shellshock_test.txt"
  ["$HOME/openemr_exploit/49742.py"]="$BASE/evidence/04_exploit_research/49742.py"
  ["$HOME/openemr_exploit/admin_hash.txt"]="$BASE/evidence/05_initial_access/admin_hash.txt"
  ["$HOME/openemr_exploit/medical_hash.txt"]="$BASE/evidence/05_initial_access/medical_hash.txt"
  ["$HOME/real_auth_cookies.txt"]="$BASE/evidence/05_initial_access/real_auth_cookies.txt"
)

for src in "${!COPY_MAP[@]}"; do
  dst="${COPY_MAP[$src]}"
  if [ -f "$src" ]; then
    cp "$src" "$dst"
    echo "  [+] Copied: $(basename $src)"
  else
    echo "  [-] Not found (add manually): $src"
  fi
done

# ── Step 2: Compute SHA256 hashes for all evidence files ──
echo ""
echo "[*] Computing SHA256 hashes for all evidence files..."
echo "# Operation Black Forge — Evidence File Hashes" > "$HASH_FILE"
echo "# Generated: $(date '+%Y-%m-%d %H:%M:%S %Z')" >> "$HASH_FILE"
echo "# Student: Abubakar Mahmood Muhammad (C11/26/EHIT/17332)" >> "$HASH_FILE"
echo "# Algorithm: SHA256" >> "$HASH_FILE"
echo "" >> "$HASH_FILE"

find "$BASE/evidence" -type f | sort | while read -r file; do
  hash=$(sha256sum "$file" | awk '{print $1}')
  rel="${file#$BASE/}"
  echo "$hash  $rel" | tee -a "$HASH_FILE"
done

echo ""
echo "[*] Hashes written to: $HASH_FILE"

# ── Step 3: Count evidence files ──
echo ""
echo "[*] Evidence file summary:"
for dir in "$BASE/evidence"/*/; do
  count=$(find "$dir" -type f | wc -l)
  echo "  $(basename $dir): $count file(s)"
done

echo ""
echo "[*] Report files:"
for f in "$BASE/report"/*.html "$BASE/report"/*.pdf 2>/dev/null; do
  [ -f "$f" ] && echo "  $(basename $f)"
done

echo ""
echo "[*] Submission checklist:"
echo "  [ ] BlackForge_Technical_Report.html — complete and reviewed"
echo "  [ ] Annex_B_Operator_Activity_Log.html — timestamps accurate"
echo "  [ ] evidence_hashes.txt — SHA256 hashes computed"
echo "  [ ] All screenshots added to correct evidence sub-folders"
echo "  [ ] statement.inc.php webshell cleared from target"
echo "  [ ] CIP-A105-CTF2-CLEAN-BASELINE snapshot still available"
echo "  [ ] README.txt reviewed"
echo ""
echo "  Run final zip command:"
echo "  cd \$(dirname \"$BASE\") && zip -r CIP-A105_CTF2_Black-Forge_submission.zip CIP-A105_CTF2_Black-Forge/"
echo ""
echo "============================================================"
echo " Script complete."
echo "============================================================"
