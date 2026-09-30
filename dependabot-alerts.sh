#!/bin/bash
########################################################################
# List (default) or dismiss open Dependabot alerts for muquit/mrdialog.
# Requires GITHUB_TOKEN (or gh login) with 'repo' scope.
#
#   ./dependabot-alerts.sh            # list open alerts (read-only)
#   ./dependabot-alerts.sh dismiss    # dismiss all open alerts
# Sep-29-2026 
########################################################################
set -euo pipefail

REPO="muquit/mrdialog"
REASON="not_used"   # fix_started | inaccurate | no_bandwidth | not_used | tolerable_risk
COMMENT="Dev-only transitive dependency via juwelier; not shipped with the gem."

alerts=$(gh api "repos/$REPO/dependabot/alerts?state=open&per_page=100" \
  --jq '.[] | "\(.number)\t\(.security_advisory.severity)\t\(.dependency.package.name)\t\(.security_advisory.cve_id)"')

if [ -z "$alerts" ]; then
  echo "No open alerts."
  exit 0
fi

echo "$alerts"

if [ "${1:-}" = "dismiss" ]; then
  echo
  echo "$alerts" | cut -f1 | while read -r n; do
    gh api -X PATCH "repos/$REPO/dependabot/alerts/$n" \
      -f state=dismissed -f dismissed_reason="$REASON" -f dismissed_comment="$COMMENT" \
      --jq '"dismissed #\(.number): \(.state)"'
  done
fi
