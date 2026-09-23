================================================================
OPERATION BLACK FORGE — SUBMISSION PACKAGE
CIP-A105 | Offensive Security Operations II | CTF 2
================================================================

Student        : Abubakar Mahmood Muhammad
Reg. Number    : C11/26/EHIT/17332
FUD Student ID : FCP/CCS/22/1004
Institution    : ICDFA Nigeria / Federal University Dutse
Operation      : BLACK FORGE
Target         : OPFOR-02 (Healthcare VM) — 192.168.72.131
Attacker       : Kali Linux — 192.168.72.129
Operation Date : 17 September 2026
Submitted      : 19 September 2026

================================================================
PACKAGE CONTENTS
================================================================

report/
  BlackForge_Technical_Report.html   ← PRIMARY SUBMISSION DOCUMENT
      Sections: Executive Summary, Scope & ROE, Lab Architecture,
      Attack Surface, Findings (9), Initial Access Narrative,
      Post-Exploitation & Privilege Escalation, Mission Objectives,
      Remediation Roadmap, Attack-Path Diagram, Risk Register,
      Conclusion & Lessons Learned, Appendices A-C

  Annex_B_Operator_Activity_Log.html ← CHRONOLOGICAL OPERATOR LOG
      Phase-by-phase record of all actions, commands, observations,
      and decisions from P0 (preparation) through P7 (withdrawal).
      Includes abandoned hypotheses with technical rationale.

evidence/
  SCREENSHOT_MANIFEST.txt            ← Lists all required screenshots
                                       and which sub-folder each goes in

evidence_hashes.txt                  ← SHA256 hashes (run prepare_submission.sh)
prepare_submission.sh                ← Helper script (see INSTRUCTIONS)

================================================================
KEY FINDINGS SUMMARY
================================================================

Finding  Severity  Title
-------  --------  -----
F-01     CRITICAL  Pre-Auth Blind SQLi — validateUser.php (CVSS 9.8)
F-02     CRITICAL  Admin File Editor → PHP Webshell RCE (CVSS 9.1)
F-03     HIGH      Weak Passwords / Unsalted SHA1 (CVSS 8.8)
F-04     HIGH      Embedded phpMyAdmin Console Exposed (CVSS 7.2)
F-05     MEDIUM    setup.php Accessible Post-Deployment (CVSS 5.3)
F-06     MEDIUM    robots.txt Path Disclosure (CVSS 5.3)
F-07     LOW       Verbose Version Disclosure (CVSS 5.3)
F-08     LOW       Missing HTTP Security Headers (CVSS 4.3)
F-09     INFO      FTP Rate-Limiting (Positive Control)

================================================================
ATTACK CHAIN (SUMMARY)
================================================================

1. ARP scan → 192.168.72.131 identified as OPFOR-02
2. Nmap → ports 21 (ProFTPD 1.3.3d) + 80 (Apache/2.2.17) only
3. Gobuster + domain sweep → /openemr/ discovered (HTTP 200)
4. OpenEMR v4.1.0 confirmed on login page
5. validateUser.php pre-auth blind SQLi confirmed (sleep(3) → 6.07s)
6. ExploitDB 49742 → extracted admin:SHA1 and medical:SHA1 hashes
7. John + rockyou.txt → admin:ackbar / medical:medical (instant crack)
8. Authenticated as OpenEMR admin
9. Administration → Files → statement.inc.php → PHP webshell written
10. curl cmd=id → uid=48(apache) — OS-level RCE confirmed

================================================================
INSTRUCTIONS — BEFORE SUBMITTING
================================================================

STEP 1: Add your screenshots
  Open evidence/SCREENSHOT_MANIFEST.txt
  Copy each screenshot from your Kali machine into the correct
  sub-folder under evidence/ using the filename shown.

STEP 2: Run the submission helper (on Kali)
  chmod +x prepare_submission.sh
  ./prepare_submission.sh
  This copies tool output files, computes SHA256 hashes,
  and prints a final checklist.

STEP 3: Open SHA256 hash values in the report
  Open report/BlackForge_Technical_Report.html in a browser,
  scroll to Appendix C, and fill in the SHA256 values from
  evidence_hashes.txt for each listed file.

STEP 4: Verify the checklist
  [ ] Technical report reviewed end-to-end
  [ ] Operator activity log timestamps match your Kali terminal
  [ ] All screenshots added to correct evidence sub-folders
  [ ] evidence_hashes.txt populated with real SHA256 values
  [ ] statement.inc.php webshell cleared from target
  [ ] CIP-A105-CTF2-CLEAN-BASELINE snapshot confirmed intact
  [ ] Report PDF exported (File → Print → Save as PDF in Firefox)

STEP 5: Create submission zip
  cd /path/to/parent/of/CIP-A105_CTF2_Black-Forge/
  zip -r CIP-A105_CTF2_Black-Forge_C1126EHIT17332.zip \
      CIP-A105_CTF2_Black-Forge/

STEP 6: Submit via ICDFA E-Campus assessment item

================================================================
ROE COMPLIANCE DECLARATION
================================================================

I confirm that all activity documented in this submission was
conducted exclusively against the Academy-issued OPFOR-02
virtual machine operating on an isolated VMware Host-Only
laboratory network segment. No external systems, public
internet hosts, or production environments were contacted at
any time during this assessment. All persistent artifacts
(the statement.inc.php webshell) have been removed from the
target prior to submission. The clean baseline snapshot
CIP-A105-CTF2-CLEAN-BASELINE is available for instructor
verification.

Operator: Abubakar Mahmood Muhammad (C11/26/EHIT/17332)
Date    : 23 September 2026

================================================================
CLASSIFICATION: TRAINING USE ONLY — DO NOT REDISTRIBUTE
================================================================
