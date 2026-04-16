# Changelog

All notable changes to the Eronred ASO Skills plugin are documented in this file.

## [1.1.0] — 2026-04-16

### Added

- **AppTweak MCP as primary data source** for keyword and rank intelligence across ASO-core skills.
- **`tools/integrations/apptweak.md`** — AppTweak integration reference documenting the ~15 AppTweak MCP tools used by skills (with links to official AppTweak docs for complete schemas).
- **`skills/localization/references/cross-locale-map.md`** — Corrected Apple cross-locale indexing map. Key facts: **en-GB is the universal secondary locale for 130+ countries**, NOT en-US. **Japan is the only exception** (uses en-US as secondary). US indexes 10 locales (1,000 keyword chars + 600 title/subtitle chars = 1,600 indexable chars for US search).
- **`skills/aso-audit/references/1998-cam-lessons.md`** — Production lessons from a real multi-locale ASO deployment (April 2026):
  - Lesson 1: en-GB Global Cascade Check (6-market verification)
  - Lesson 2: Protected Token Set (per-app list of words that cannot leave en-GB)
  - Lesson 3: Install Attribution Tiers (real installs > theoretical KEI)
  - Lesson 4: Subtitle Blast-Radius Warning
  - Lesson 5: Monitoring Ladder (Day 1/3/7/14/30)
  - Lesson 6: Rollback Triggers (hard + soft)
  - Lesson 7: Staged Deployment Order (English first, home markets second)
  - Lesson 8: Compound Formation (same-locale + US cross-index exception)
  - Lesson 9: Field Weight Evidence (empirical rank deltas)
  - Incident Drill: simulated en-GB token removal scenario
- **`scripts/check-apptweak-migration.sh`** — Semantic validation gate that runs after `validate-skills.sh`. Asserts required tokens exist in specific skills (en-GB, Protected Token Set, monitoring ladder, rollback triggers, AppTweak tool references) and forbids legacy phrasing.
- **`scripts/snippets/compatibility-contract.md`** — Single source of truth for the Data Source Compatibility block that appears in every updated skill (4 environments: AppTweak+Appeeky, AppTweak only, Appeeky only, neither).
- **13 skills added to `.claude-plugin/marketplace.json`**. The manifest previously listed 17 of the 30 skills in the repo; all 30 are now listed.

### Changed

- **5 ASO-core skills** (`aso-audit`, `keyword-research`, `metadata-optimization`, `localization`, `competitor-analysis`) now:
  - Reference **AppTweak MCP as primary** (with Appeeky as supported fallback via the compatibility contract)
  - Link to the shared `cross-locale-map.md` and `1998-cam-lessons.md` references instead of duplicating prose
  - Encode the en-GB Global Cascade Check (Phase 7.5 Part B in `aso-audit`, cascade check section in `metadata-optimization` and `localization`)
  - Include the Protected Token Set concept (per-app definition + example)
- **5 secondary skills** migrated from Appeeky-primary to AppTweak-primary:
  - `android-aso` — Google Play doesn't have en-GB cascade; AppTweak used for iOS benchmarks
  - `apple-search-ads` — Added ASA keyword tier classification (A/B/C/D/E from 1998 Cam production work); AppTweak `at_asa_bidding_apps` and `at_asa_bid_history` for competitive intelligence
  - `app-icon-optimization` — Confidence indicator line updated to include AppTweak
  - `seasonal-aso` — Added Protected Token warning for seasonal rotations (never sacrifice a permanent Protected Token for a seasonal keyword); `at_keyword_volume_history` highlighted for seasonality analysis
  - `competitor-tracking` — 6 Appeeky references replaced; added en-GB cascade awareness section (track competitors' en-GB metadata specifically to reveal their global compound strategy)
- **Plugin manifest description** updated from "17 ASO and app marketing skills" to "30 ASO and app marketing skills".
- **`tools/REGISTRY.md`** — Added AppTweak section as primary for keyword/rank intelligence, with skill → AppTweak tool mapping. Appeeky retained as fallback + primary for market intelligence.
- **`tools/integrations/appeeky*.md`** (5 files) — Added status banner at top of each file clarifying that AppTweak is now primary for keyword workflows, Appeeky is supported fallback, and Appeeky Connect (first-party ASC sync) is unchanged.
- **`tools/integrations/app-store-connect.md`** — Comparison table updated to include AppTweak column (previously only compared ASC vs Appeeky Connect vs Appeeky).

### Unchanged (intentional)

- **`asc-metrics` skill** — Appeeky Connect is a first-party App Store Connect sync product (exact downloads, revenue, IAPs, subscriptions from your own ASC account). It is NOT replaced by AppTweak, which provides estimated third-party data.
- **`tools/integrations/appeeky*.md`** — Retained as fallback documentation. Banners added but content unchanged.
- **`README.md`** — Brand-owned; not edited. Recommendation for AppTweak lives in `tools/REGISTRY.md` and this changelog instead.
- **`.claude-plugin/marketplace.json` `owner` field** — Unchanged.
- **20 other skills** without Appeeky references and no applicability to the 1998 Cam lessons (crash-analytics, monetization-strategy, retention-optimization, ua-campaign, ab-test-store-listing, app-analytics, app-clips, app-launch, app-marketing-context, app-store-featured, in-app-events, market-movers, market-pulse, onboarding-optimization, press-and-pr, rating-prompt-strategy, review-management, screenshot-optimization, subscription-lifecycle).

### Migration Notes

If you're upgrading from v1.0.0:

1. **Install AppTweak MCP** (see [`tools/integrations/apptweak.md`](tools/integrations/apptweak.md)) for the best experience. AppTweak provides deeper historical rank data and broader international coverage than Appeeky for keyword/rank workflows.
2. **If you only have Appeeky installed**, skills continue to work — the Data Source Compatibility block in every updated skill defines the fallback order.
3. **If you have neither**, skills will ask you to paste current metadata manually.
4. **If you have both**, AppTweak is primary and Appeeky is a secondary cross-check for suspicious results.
5. **Appeeky Connect users**: no action required — the `asc-metrics` skill and Appeeky Connect are unchanged.

### Versioning Policy

This release uses a uniform `1.0.0 → 1.1.0` bump across:
- The plugin manifest (`.claude-plugin/marketplace.json`)
- All 10 updated skills

Rationale: AppTweak is additive. Appeeky remains a supported fallback. No skill requires AppTweak to function — the compatibility contract ensures graceful degradation. This is a backwards-compatible minor release, not a breaking change.

### Why These Lessons Matter

The 1998 Cam lessons codified in this release are from a real incident where a well-designed ASO optimization caused **~25% global organic traffic loss over 72 hours**. The root cause was removing a single word ("video") from the en-US subtitle based on "0 US installs" attribution data. That word cascaded to 130+ countries via the en-GB mirror and broke top-5 compounds in DE/JP/FR/IT/BR.

Every future ASO skill user benefits from the en-GB Global Cascade Check (mandatory before any en-US/en-GB word removal) and the Protected Token Set concept. These lessons cannot be rediscovered without a painful production incident — encoding them in skills prevents the same mistake elsewhere.

---

## [1.0.0] — Prior

Initial release. 17 ASO skills with Appeeky as primary data source. See commit history for details.
