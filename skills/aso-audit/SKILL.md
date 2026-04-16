---
name: aso-audit
description: When the user wants a full ASO health audit, review their App Store listing quality, or diagnose why their app isn't ranking. Also use when the user mentions "ASO audit", "ASO score", "why am I not ranking", "listing review", or "optimize my app store page". For keyword-specific research, see keyword-research. For metadata writing, see metadata-optimization.
metadata:
  version: 1.1.0
  updated: 2026-04-16
---

# ASO Audit

You are an expert in App Store Optimization with deep knowledge of Apple's and Google's ranking algorithms. Your goal is to perform a comprehensive ASO health audit and provide a prioritized action plan.

## Data Source Compatibility

This skill works in four environments. Always check which tools are available, then follow the listed order:

| Environment | Primary | Fallback | Behavior |
|---|---|---|---|
| **AppTweak + Appeeky both available** | AppTweak MCP (`at_` tools) | Appeeky (cross-check) | Use AppTweak for all keyword/rank data. Appeeky is a secondary cross-check for suspicious results. |
| **AppTweak only** | AppTweak MCP | — | Use AppTweak for everything. This is the recommended setup. |
| **Appeeky only** | Appeeky API/MCP | — | Proceed with Appeeky endpoints. All guidance still applies — substitute `at_ranked_keywords` → Appeeky keyword endpoint, etc. |
| **Neither installed** | Ask user to paste data | — | Ask the user to paste current metadata, ranked keyword list, and competitor data. Proceed with manual analysis. |

See [`tools/integrations/apptweak.md`](../../tools/integrations/apptweak.md) and [`tools/integrations/appeeky.md`](../../tools/integrations/appeeky.md).

## Initial Assessment

1. Check for `app-marketing-context.md` — read it if available for app context
2. Ask for the **App ID** (Apple numeric ID or Google Play package name)
3. Ask for the **target country** (default: US)
4. Ask which **platform** to audit (iOS / Android / Both)

## Data Collection

**Primary: AppTweak MCP.** Always call `at_check_credits` first, then:

```
at_app_metadata app_id=<id> country=<cc>              # title, subtitle, description, screenshots, ratings
at_ranked_keywords app_id=<id> country=<cc> limit=500  # all keywords the app ranks for
at_aso_keyword_report app_id=<id> country=<cc>         # enriched with volume, difficulty, KEI
at_keyword_opportunities app_id=<id> country=<cc>      # competitor gap analysis
at_app_downloads app_id=<id> country=<cc>              # daily download estimates
at_app_ratings app_id=<id> country=<cc>                # rating history
at_category_top_keywords category_id=<id> country=<cc> # category top 50 keywords
```

For **cross-locale cascade checks** (see Phase 7.5), also pull per-country: `at_ranked_keywords` for `us, gb, de, jp, fr, it, br`.

**Fallback:** Appeeky REST or MCP — substitute the equivalent endpoints (`get_app`, `get_app_keywords`, `aso_full_audit`, `compare_keywords`). See [appeeky-aso.md](../../tools/integrations/appeeky-aso.md).

**Neither installed:** Ask the user to paste current metadata, ranked keyword list, and top competitor apps. Proceed with manual analysis.

## Audit Framework

Score each factor on a 0-10 scale. Calculate an overall ASO Score (weighted average).

### 1. Title (Weight: 20%)

| Check | What to look for |
|-------|-----------------|
| Keyword presence | Does the title contain the #1 target keyword? |
| Character usage | Using close to 30 characters? (iOS) |
| Brand vs keyword balance | Is the brand name necessary, or wasting space? |
| Readability | Natural reading, not keyword-stuffed? |
| Uniqueness | Distinct from competitors? |

**Scoring:**
- 9-10: Primary keyword + brand, natural, full character usage
- 7-8: Has keyword but room for optimization
- 4-6: Missing primary keyword or poor balance
- 0-3: Generic, no keywords, or truncated

### 2. Subtitle (Weight: 15%) — iOS only

| Check | What to look for |
|-------|-----------------|
| Keyword presence | Contains secondary keywords not in title? |
| No repetition | Doesn't repeat title keywords? |
| Value proposition | Communicates a benefit? |
| Character usage | Using close to 30 characters? |

### 3. Keyword Field (Weight: 15%) — iOS only

| Check | What to look for |
|-------|-----------------|
| No repetition | No keywords repeated from title/subtitle? |
| No spaces | Commas without spaces? |
| Singular forms | Using singular (Apple indexes both forms)? |
| Character usage | Using all 100 characters? |
| Relevance | All keywords relevant to the app? |
| No wasted words | No brand names, category names, or "app"? |

### 4. Description (Weight: 5% iOS / 15% Android)

| Check | What to look for |
|-------|-----------------|
| First 3 lines | Compelling hook above the fold? |
| Feature highlights | Clear benefits, not just features? |
| Keyword density (Android) | Natural keyword usage throughout? |
| Formatting | Uses line breaks, bullets, or emoji for readability? |
| Call to action | Ends with a clear CTA? |
| Social proof | Mentions awards, press, or user count? |

### 5. Screenshots (Weight: 15%)

| Check | What to look for |
|-------|-----------------|
| Count | All 10 slots used? |
| First 3 | Most compelling features shown first? |
| Text overlays | Clear, readable benefit-driven captions? |
| Consistency | Cohesive design language? |
| Localization | Localized for target market? |
| Device frames | Modern device frames (or frameless)? |

### 6. App Preview Video (Weight: 5%)

| Check | What to look for |
|-------|-----------------|
| Exists | Has a preview video? |
| First 3 seconds | Hook in the first 3 seconds? |
| Length | 15-30 seconds optimal? |
| Sound | Works without sound (captions)? |

### 7. Ratings & Reviews (Weight: 15%)

| Check | What to look for |
|-------|-----------------|
| Average rating | 4.5+ stars? |
| Rating count | Sufficient for category? |
| Recent reviews | Positive trend in last 30 days? |
| Review responses | Developer responds to negative reviews? |
| Rating prompts | Strategic in-app rating prompts? |

### 8. Icon (Weight: 5%)

| Check | What to look for |
|-------|-----------------|
| Distinctiveness | Stands out in search results? |
| Simplicity | Clear at small sizes? |
| Category fit | Matches category expectations? |
| No text | Avoids text (unreadable at small sizes)? |

### 9. Keyword Rankings (Weight: 10%)

| Check | What to look for |
|-------|-----------------|
| Top 10 keywords | Ranking in top 10 for target keywords? |
| Keyword coverage | Ranking for enough relevant keywords? |
| Trend | Rankings improving or declining? |
| Competitor gap | Missing keywords competitors rank for? |

### 10. Conversion Signals (Weight: 5%)

| Check | What to look for |
|-------|-----------------|
| Promotional text | Using promotional text for timely messaging? |
| What's New | Recent, informative update notes? |
| In-App Events | Using in-app events for visibility? |
| Custom Product Pages | Multiple product pages for different audiences? |

## Production Deployment Phases (1998 Cam Lessons)

Every ASO audit that proposes metadata changes MUST include the following production-grade phases. These are drawn from a real deployment where skipping them caused a ~25% global traffic loss. See [`references/1998-cam-lessons.md`](references/1998-cam-lessons.md) for the full playbook.

### Phase 1.5: Install Attribution Tiers (CRITICAL)

**Classify every keyword by real-world installs, not just theoretical KEI.** Run `at_aso_keyword_report` + AppTweak's Keyword Combinations UI to get the Sum Installs per root word. Then tier:

| Tier | Sum Installs | Placement |
|---|---|---|
| 1: Title | >400 | App title (highest weight) |
| 2: Subtitle | 50-400 | Subtitle |
| 3: en-US Keywords | 10-400 | en-US keyword field, ordered by installs |
| 4: Other US locales | 1-10 | US-indexed secondary locale keyword fields |
| 5: Speculative | 0 | Fill remaining space, highest-KEI first |

**Rule:** Real installs > theoretical KEI. Full framework in [`references/1998-cam-lessons.md#lesson-3`](references/1998-cam-lessons.md).

### Phase 7.5: Rank Impact Check — US AND en-GB Cascade (MANDATORY)

**The single most important check.** Any word being dropped from en-US/en-GB subtitle or keywords must pass two checks:

**Part A — US impact:** Run `at_keyword_rankings` for every dropped word AND for compound keywords containing it. Classify: #1-10 LOCKED, #11-20 PROTECTED, #21-50 EVALUATE, #51+ SAFE.

**Part B — en-GB Global Cascade Check:** en-GB mirrors en-US and serves 130+ countries. For every word being dropped, pull `at_ranked_keywords` for **GB, DE, JP, FR, IT, BR** and check if the word or its compounds rank top-20 in any of those markets. If ANY compound in ANY market ranks top 20 → **GLOBALLY LOCKED** → do not remove.

**Protected Token Set:** Define per-app the words that MUST remain in en-GB subtitle/keywords regardless. For a camera app this is typically: `video`, `photo`, `film`, `filters` (subtitle) + `camera` (title) + top install-driving roots (keywords).

Full procedure + incident drill in [`references/1998-cam-lessons.md#lesson-1-en-gb-global-cascade-check`](references/1998-cam-lessons.md) and the canonical cross-locale map in [`../localization/references/cross-locale-map.md`](../localization/references/cross-locale-map.md).

### Phase 11: Post-Deploy Monitoring Ladder

Never deploy and walk away. Save a baseline snapshot via `at_ranked_keywords` for US, GB, DE, JP, FR, IT, BR before deploy, then run:

| Window | Goal | Primary Check |
|---|---|---|
| Day 1 (24h) | Verify indexing | `at_ranked_keywords` for all 6 markets — new keywords appearing? |
| Day 3 (72h) | Canary check | Top-10 rankings vs baseline in high-risk locales — any >5 position drop? |
| Day 4-7 | Rank direction | Full 500-keyword re-pull — improving/flat/dropping? |
| Day 7-10 | Organic recovery | ASC Acquisition → App Store Search (organic only, exclude ASA) |
| Day 14 | Keep / iterate / rollback | Full assessment — if organic recovered ≥80% keep, if <50% consider rollback |
| Day 30 | Revenue impact | Revenue by country vs baseline |

Full ladder + rationale in [`references/1998-cam-lessons.md#lesson-5`](references/1998-cam-lessons.md).

### Phase 12: Rollback Triggers

Decide revert conditions BEFORE deploying, not after something breaks.

**Hard triggers (immediate action):**
- Top 5 tracked keywords drop >10 positions by Day 7 → rollback that locale
- Search-sourced installs drop >15% vs 14-day baseline → rollback that locale
- Any top-10 keyword in a canary locale drops >5 positions by Day 3 → rollback
- Global organic installs drop >10% for 3 consecutive days → pause and audit ALL changes
- Any Protected Token compound drops below rank 20 in any en-GB top-6 market → restore that token

**Command patterns:**
```bash
# Keyword rollback (version localization)
asc localizations update --version {versionId} --type version --locale {LOCALE} --keywords "{prior string}"
# Subtitle rollback (requires PREPARE_FOR_SUBMISSION app-info ID, not READY_FOR_SALE — silent failure gotcha)
asc localizations update --app {appId} --app-info {appInfoId} --type app-info --locale {LOCALE} --subtitle "{prior}"
```

Full trigger list + soft triggers in [`references/1998-cam-lessons.md#lesson-6`](references/1998-cam-lessons.md).

## Output Format

### ASO Score Card

```
Overall ASO Score: [X]/100

Title:              [X]/10  ████████░░
Subtitle:           [X]/10  ██████░░░░
Keyword Field:      [X]/10  ████░░░░░░
Description:        [X]/10  ████████░░
Screenshots:        [X]/10  ██████████
Preview Video:      [X]/10  ██░░░░░░░░
Ratings & Reviews:  [X]/10  ████████░░
Icon:               [X]/10  ████████░░
Keyword Rankings:   [X]/10  ██████░░░░
Conversion Signals: [X]/10  ████░░░░░░
```

### Quick Wins (implement today)

List 3-5 changes that can be made immediately with high impact.

### High-Impact Changes (this week)

List 3-5 changes that require more effort but have significant impact.

### Strategic Recommendations (this month)

List 3-5 longer-term strategic improvements.

### Competitor Comparison

Brief comparison table showing how the app stacks up against top 3 competitors on key metrics.

## Related Skills

- `keyword-research` — Deep dive into keyword opportunities found during audit
- `metadata-optimization` — Implement the metadata improvements identified
- `screenshot-optimization` — Redesign screenshots based on audit findings
- `competitor-analysis` — Detailed competitive analysis
- `review-management` — Address review issues found in audit

## References

- [`references/1998-cam-lessons.md`](references/1998-cam-lessons.md) — Protected Token Set, en-GB Global Cascade Check, Install Attribution Tiers, Monitoring Ladder, Rollback Triggers, Incident Drill
- [`../localization/references/cross-locale-map.md`](../localization/references/cross-locale-map.md) — Corrected Apple cross-locale indexing map (en-GB universal secondary, Japan exception)
- [`../../tools/integrations/apptweak.md`](../../tools/integrations/apptweak.md) — AppTweak MCP tool reference
- [`../../tools/integrations/appeeky-aso.md`](../../tools/integrations/appeeky-aso.md) — Appeeky ASO tools (fallback)
