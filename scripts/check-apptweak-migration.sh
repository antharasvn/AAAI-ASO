#!/bin/bash
#
# check-apptweak-migration.sh
#
# Semantic validation gate for the v1.1.0 AppTweak + 1998 Cam lessons migration.
# Runs after validate-skills.sh. Asserts that required tokens exist in specific
# skills and that forbidden phrases are removed.
#
# Exit codes:
#   0 — all assertions passed
#   1 — one or more assertions failed
#
# Usage: bash scripts/check-apptweak-migration.sh
#

set -u

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SKILLS_DIR="$REPO_ROOT/skills"
TOOLS_DIR="$REPO_ROOT/tools"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

ERRORS=0
CHECKS=0

pass() { echo -e "${GREEN}✓${NC} $1"; CHECKS=$((CHECKS + 1)); }
fail() { echo -e "${RED}✗${NC} $1"; ERRORS=$((ERRORS + 1)); CHECKS=$((CHECKS + 1)); }

require_contains() {
  local file="$1"
  local pattern="$2"
  local description="$3"
  if [ ! -f "$file" ]; then
    fail "$description (file missing: $file)"
    return
  fi
  if grep -q -i "$pattern" "$file"; then
    pass "$description"
  else
    fail "$description (pattern '$pattern' not found in $file)"
  fi
}

forbid_contains() {
  local file="$1"
  local pattern="$2"
  local description="$3"
  if [ ! -f "$file" ]; then
    fail "$description (file missing: $file)"
    return
  fi
  if grep -q -i "$pattern" "$file"; then
    fail "$description (forbidden pattern '$pattern' still present in $file)"
  else
    pass "$description"
  fi
}

echo "=== AppTweak Migration Semantic Check (v1.1.0) ==="
echo ""

# ---------- Required files exist ----------
echo "-- Required files --"
test -f "$TOOLS_DIR/integrations/apptweak.md" && pass "tools/integrations/apptweak.md exists" || fail "tools/integrations/apptweak.md missing"
test -f "$SKILLS_DIR/localization/references/cross-locale-map.md" && pass "localization/references/cross-locale-map.md exists" || fail "cross-locale-map.md missing"
test -f "$SKILLS_DIR/aso-audit/references/1998-cam-lessons.md" && pass "aso-audit/references/1998-cam-lessons.md exists" || fail "1998-cam-lessons.md missing"
test -f "$REPO_ROOT/scripts/snippets/compatibility-contract.md" && pass "scripts/snippets/compatibility-contract.md exists" || fail "compatibility-contract.md missing"
test -f "$REPO_ROOT/CHANGELOG.md" && pass "CHANGELOG.md exists" || fail "CHANGELOG.md missing"
echo ""

# ---------- ASO-core 5: required tokens ----------
echo "-- aso-audit SKILL.md required tokens --"
F="$SKILLS_DIR/aso-audit/SKILL.md"
require_contains "$F" "Data Source Compatibility" "compatibility contract present"
require_contains "$F" "en-GB" "en-GB mentioned"
require_contains "$F" "Protected Token" "Protected Token Set concept"
require_contains "$F" "Cascade" "Cascade check"
require_contains "$F" "Monitoring Ladder\|Phase 11" "Monitoring Ladder / Phase 11"
require_contains "$F" "Rollback Trigger\|Phase 12" "Rollback Triggers / Phase 12"
require_contains "$F" "at_ranked_keywords" "AppTweak at_ranked_keywords reference"
require_contains "$F" "1998-cam-lessons" "link to 1998-cam-lessons.md"
require_contains "$F" "version: 1.1.0" "version bumped to 1.1.0"
echo ""

echo "-- keyword-research SKILL.md required tokens --"
F="$SKILLS_DIR/keyword-research/SKILL.md"
require_contains "$F" "Data Source Compatibility" "compatibility contract present"
require_contains "$F" "Install Attribution" "Install Attribution Tiers"
require_contains "$F" "International Keyword" "International Keyword Importance Check"
require_contains "$F" "at_aso_keyword_report\|at_ranked_keywords" "AppTweak tool reference"
require_contains "$F" "version: 1.1.0" "version bumped to 1.1.0"
echo ""

echo "-- metadata-optimization SKILL.md required tokens --"
F="$SKILLS_DIR/metadata-optimization/SKILL.md"
require_contains "$F" "Data Source Compatibility" "compatibility contract present"
require_contains "$F" "Protected Token" "Protected Token Set"
require_contains "$F" "Blast-Radius\|Blast Radius" "Subtitle Blast-Radius warning"
require_contains "$F" "Field Weight" "Field Weight Evidence"
require_contains "$F" "Compound Validation" "Compound Validation Checklist"
require_contains "$F" "at_keyword_stats\|at_app_metadata" "AppTweak tool reference"
require_contains "$F" "version: 1.1.0" "version bumped to 1.1.0"
echo ""

echo "-- localization SKILL.md required tokens --"
F="$SKILLS_DIR/localization/SKILL.md"
require_contains "$F" "Data Source Compatibility" "compatibility contract present"
require_contains "$F" "en-GB" "en-GB mentioned"
require_contains "$F" "universal secondary" "en-GB as universal secondary"
require_contains "$F" "Japan" "Japan exception mentioned"
require_contains "$F" "cross-locale-map" "link to cross-locale-map.md"
require_contains "$F" "Staged Deployment\|Stage 1" "Staged Deployment Patterns"
require_contains "$F" "Cascade Check" "en-GB Cascade Check section"
require_contains "$F" "4-Category\|4 Category" "4-Category Locale Architecture"
require_contains "$F" "at_ranked_keywords\|at_app_metadata" "AppTweak tool reference"
require_contains "$F" "version: 1.1.0" "version bumped to 1.1.0"
echo ""

echo "-- competitor-analysis SKILL.md required tokens --"
F="$SKILLS_DIR/competitor-analysis/SKILL.md"
require_contains "$F" "Data Source Compatibility" "compatibility contract present"
require_contains "$F" "at_app_metadata\|at_keyword_opportunities" "AppTweak tool reference"
require_contains "$F" "en-GB" "en-GB mentioned"
require_contains "$F" "Cascade" "en-GB Cascade awareness"
require_contains "$F" "version: 1.1.0" "version bumped to 1.1.0"
echo ""

# ---------- Secondary 5: version + AppTweak ----------
echo "-- Secondary skills version + AppTweak refs --"
for skill in android-aso apple-search-ads app-icon-optimization seasonal-aso competitor-tracking; do
  F="$SKILLS_DIR/$skill/SKILL.md"
  if [ -f "$F" ]; then
    if grep -q "version: 1.1.0" "$F"; then
      pass "$skill version bumped to 1.1.0"
    else
      fail "$skill version NOT bumped"
    fi
    if grep -q -i "apptweak\|at_" "$F"; then
      pass "$skill references AppTweak"
    else
      fail "$skill does not reference AppTweak"
    fi
  else
    fail "$skill SKILL.md missing"
  fi
done
echo ""

# ---------- Forbidden phrases ----------
echo "-- Forbidden phrases in updated skills --"
UPDATED_SKILLS="aso-audit keyword-research metadata-optimization localization competitor-analysis android-aso apple-search-ads app-icon-optimization seasonal-aso competitor-tracking"

for skill in $UPDATED_SKILLS; do
  F="$SKILLS_DIR/$skill/SKILL.md"
  [ -f "$F" ] || continue
  # Forbid phrases that indicate Appeeky is still listed as primary
  forbid_contains "$F" "If Appeeky MCP or API is available" "$skill — no legacy 'If Appeeky' conditional"
done
echo ""

# ---------- marketplace.json ----------
echo "-- marketplace.json --"
MF="$REPO_ROOT/.claude-plugin/marketplace.json"
if python3 -m json.tool "$MF" > /dev/null 2>&1; then
  pass "marketplace.json is valid JSON"
else
  fail "marketplace.json is NOT valid JSON"
fi
require_contains "$MF" "\"version\": \"1.1.0\"" "marketplace.json version 1.1.0"
require_contains "$MF" "30 ASO and app marketing skills" "marketplace.json description updated to 30 skills"
# Check that all 30 skills are listed (count via grep)
SKILL_COUNT=$(grep -c '"./skills/' "$MF" || true)
if [ "$SKILL_COUNT" = "30" ]; then
  pass "marketplace.json lists all 30 skills"
else
  fail "marketplace.json lists $SKILL_COUNT skills (expected 30)"
fi
echo ""

# ---------- Intentionally unchanged files ----------
echo "-- Intentionally unchanged files (sanity check) --"
# asc-metrics should NOT contain AppTweak (out of scope)
if grep -q -i "apptweak" "$SKILLS_DIR/asc-metrics/SKILL.md" 2>/dev/null; then
  fail "asc-metrics unexpectedly contains AppTweak (should be unchanged)"
else
  pass "asc-metrics unchanged (no AppTweak references)"
fi
# README should NOT contain AppTweak
if grep -q -i "apptweak" "$REPO_ROOT/README.md" 2>/dev/null; then
  fail "README.md unexpectedly contains AppTweak (should be unchanged)"
else
  pass "README.md unchanged (brand-owned)"
fi
echo ""

# ---------- Summary ----------
echo "=== Summary ==="
echo "Checks: $CHECKS"
echo "Errors: $ERRORS"

if [ "$ERRORS" -eq 0 ]; then
  echo -e "${GREEN}✓ All semantic assertions passed.${NC}"
  exit 0
else
  echo -e "${RED}✗ $ERRORS assertion(s) failed.${NC}"
  exit 1
fi
