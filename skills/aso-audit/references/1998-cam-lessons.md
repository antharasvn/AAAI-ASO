# 1998 Cam ASO Lessons

**This is the authoritative reference for production lessons learned from a real multi-locale ASO deployment.** Skills link here instead of duplicating the concepts in prose. The case study is abstracted to protect the specific app; the lessons are general.

---

## Case Study (Abstracted)

A popular iOS camera app (29 active locales, ~1,800 global downloads/day, ~$500K annual revenue) deployed a carefully-designed metadata optimization in April 2026. The US-facing audit was thorough:

- Top 500 ranked keywords analyzed
- Install attribution data pulled for every root word
- Cross-locale compound formation verified across all 11 US-indexed locales
- Rank impact check run for every dropped word (no top-10 losses)
- 12 new US rankings gained within 48 hours
- 28/28 protected US keywords held

**Yet global organic traffic dropped ~25% over the following 72 hours.**

## Root Cause

The en-US subtitle changed from `Photo Filters & Video Effects` to `Photo Filters & Film Editor`. US install attribution showed "video" had 0 installs, so it was dropped as dead weight. All US-indexed locale checks passed.

**What was missed:** en-GB mirrors en-US. en-GB is the universal secondary locale for 130+ countries. Removing "video" from en-GB removed "video" from the compound pool of every en-GB-indexed market simultaneously. "video camera" and "video editor" had been top-5 search terms in DE, JP, FR, IT, BR. Those compounds broke globally overnight.

The US was partially protected because other US-indexed locales (`vi` title, `zh-Hant` title) kept "video" in the US compound pool — but only US users benefit from those, not the 130+ other countries.

## The Fix

The following release restored the en-GB subtitle to include "video" (`Photo & Video Film Filters`), moved "editor" to the keyword field (accepting a 1-3 position slip on editor compounds), and preserved "film" gains. Traffic recovered within 10 days.

---

## Lesson 1: en-GB Global Cascade Check (MANDATORY before any en-US/en-GB change)

Any word removed from en-US or en-GB subtitle or keywords must pass a **6-market international cascade check**.

### The Procedure

For any word being removed from en-US/en-GB (subtitle OR keywords):

1. **International rank pull** — Run `at_ranked_keywords` for **GB, DE, JP, FR, IT, BR** (the top 6 en-GB markets)
2. **Compound check** — In each market's top 500, search for compounds containing the candidate word
3. **Volume check** — Run `at_keyword_stats` with `country=gb` for the word and its compounds
4. **Decision gate** — If ANY compound in ANY of the 6 markets ranks top 20, **the word is LOCKED**. Do not remove.

### Classification

| International Rank | Classification | Action |
|---|---|---|
| Top 10 in ANY en-GB market | **GLOBALLY LOCKED** | Cannot remove from en-US/en-GB |
| Top 20 in 3+ markets | **GLOBALLY PROTECTED** | Requires explicit override with documented impact analysis |
| Top 50 in 1-2 markets | **EVALUATE** | Acceptable if no compound value in any top-20 market |
| #51+ in all 6 markets | **SAFE** | Can drop (still run standard US impact check) |

---

## Lesson 2: Protected Token Set

Every app using this workflow must define its **en-GB Protected Token Set** at the start of Phase 2 (US Market Optimization). These are words that MUST remain in en-GB subtitle/keywords regardless of any future optimization.

### Template (example for a camera app)

| Field | Protected Words | Rationale |
|---|---|---|
| **Subtitle** | `video`, `photo`, `film`, `filters` | Form top-rank compounds in GB/DE/JP/FR/IT/BR |
| **Keywords** | `editor`, `blackmagic`, `black`, `magic` | Top 10 keyword rankings internationally |
| **Title** | `camera` (category root) | Foundation compound word for entire category |

### Rule

**No word may be removed from en-US/en-GB without first verifying it is not in the Protected Token Set.** Override requires documented impact analysis and user approval.

### How to Define

At the start of any ASO optimization cycle:

1. Run `at_ranked_keywords` for US, GB, DE, JP, FR, IT, BR
2. Identify the 4-8 words that form the most top-20 compounds across these 6 markets
3. Those words are the Protected Token Set
4. Document them in the app's context doc

---

## Lesson 3: Install Attribution Tiers

KEI (Keyword Effectiveness Index) alone is not enough. Some keywords with high KEI drive zero installs; other keywords look mediocre in KEI but drive hundreds of installs. Classify every keyword by real-world proven value.

### The Tiers

| Install Tier | Sum Installs | Placement Priority |
|---|---|---|
| **Tier 1: Title** | >400 | Must be in app title (highest indexing weight) |
| **Tier 2: Subtitle** | 50-400 | Should be in subtitle if not in title |
| **Tier 3: en-US Keywords** | 10-400 | Must be in en-US keyword field, ordered by install count |
| **Tier 4: Other US locales** | 1-10 | Place in US-indexed secondary locale keyword fields |
| **Tier 5: Speculative** | 0 installs | Fill remaining space; pick highest KEI |

### Critical Rule

**Real installs > theoretical KEI.** If a keyword drives 200 installs but has KEI 60, it still goes in the title/subtitle. Speculative high-KEI keywords fill leftover space only.

### Data Source

AppTweak's Keyword Combinations UI groups ranked keywords by root word and shows Sum Installs per root. This is a dashboard-only feature — no API endpoint. Either:

1. Ask the user to paste a CSV export from the AppTweak dashboard
2. Approximate by tokenizing `at_ranked_keywords` results and summing attribution-like weights (less accurate)

---

## Lesson 4: Subtitle Blast-Radius Warning

**Subtitle changes to en-US/en-GB have the largest blast radius of any ASO change.** Larger than title changes, larger than keyword field changes.

### Why

| Change Type | Scope of Effect |
|---|---|
| Keyword field change in `ja` | Only Japan storefront |
| Keyword field change in en-US | US storefront + en-GB mirror = 130+ countries |
| Title change in en-US | US + 130+ countries + affects all compounds globally |
| **Subtitle change in en-US** | **US + 130+ countries + affects all compounds globally + hits the second-highest indexing weight** |

A subtitle word in en-US/en-GB is available in the compound pool of **every country that uses en-GB as secondary**. Removing a subtitle word silently breaks compounds in 130+ markets.

### The Rule

Before removing any word from en-US/en-GB subtitle: run the Lesson 1 cascade check, verify it's not in the Protected Token Set (Lesson 2), and confirm with stakeholders.

---

## Lesson 5: Monitoring Ladder (Day 1/3/7/14/30)

Never deploy ASO changes and walk away. Every deployment needs a staged monitoring plan.

### Before Deploy: Baseline Snapshot

```bash
# Save current state for comparison + rollback
for cc in us gb de jp fr it br; do
  at_ranked_keywords app_id={ID} country=$cc limit=500 > aso/baseline-${cc}-$(date +%Y-%m-%d).json
done
at_app_metadata app_id={ID} country=us > aso/baseline-metadata-$(date +%Y-%m-%d).json
```

### Monitoring Checkpoints

| Window | Goal | Actions | Data Source |
|---|---|---|---|
| **Day 1 (24h)** | Verify indexing | Pull `at_ranked_keywords` for US, GB, DE, JP, FR, IT, BR. Check all new keywords appear. | AppTweak |
| **Day 3 (72h)** | Canary check | For high-risk locales (mass rewrites, subtitle changes): compare top-10 to baseline. Any >5 position drop = investigate. | AppTweak |
| **Day 4-7** | Rank direction | Full 500-keyword re-pull for US + 3 intl markets. Check DIRECTION (improving/flat/dropping) — absolute rank doesn't need to match pre-deploy yet. | AppTweak |
| **Day 7-10** | Organic recovery | Compare organic search impressions, product page views, download conversion by country. **Exclude ASA traffic.** | ASC Acquisition → Sources → App Store Search |
| **Day 14** | Keep / iterate / rollback | Full assessment. If organic recovered ≥80% → keep. If <50% → consider rollback. | ASC + AppTweak + BigQuery |
| **Day 30** | Revenue impact | Revenue by country vs baseline | RevenueCat + ASC Sales & Trends |

**Primary KPI:** ASC Acquisition → Sources → App Store Search. Use organic-only metrics. ASA restructuring creates noise.

---

## Lesson 6: Rollback Triggers

Every deployment needs pre-defined rollback thresholds. Decide the revert conditions BEFORE deploying, not after something breaks.

### Hard Rollback Triggers (immediate action)

| Condition | Timeline | Action |
|---|---|---|
| Top 5 tracked keywords in a locale drop >10 positions | Day 7 | Rollback that locale's keywords immediately |
| Search-sourced installs in a market drop >15% vs 14-day baseline | Any time | Rollback that locale |
| Canary locale (aggressive change): ANY top-10 keyword drops >5 positions | Day 3 | Rollback that locale immediately |
| Global organic installs drop >10% for 3 consecutive days | Any time | **Pause and audit ALL changes** |
| Any Protected Token's compound drops below rank 20 in any en-GB top-6 market | Day 7 | Restore that token to en-GB subtitle/keywords |

### Soft Rollback Triggers (investigate)

| Condition | Action |
|---|---|
| Word not indexed in target country within 72h | Verify deployment was successful; check ASC version status |
| No directional rank improvement for any new compound by Day 7 | Investigate: is subtitle live? Is indexing delayed? Add to keyword field as backup |
| Any previously top-10 keyword drops 5+ positions for 3+ days | Investigate specific locale, consider restoring constituent words |

### Rollback Command Pattern

Every deployment script must produce ready-to-paste rollback commands per locale. Save baseline keyword strings for every locale before deploy.

```bash
# Keyword rollback (version localization)
asc localizations update --version {versionId} --type version --locale {LOCALE} --keywords "{prior keyword string from baseline}"

# Subtitle rollback (app-info localization — requires PREPARE_FOR_SUBMISSION app-info ID, not READY_FOR_SALE)
asc localizations update --app {appId} --app-info {appInfoId} --type app-info --locale {LOCALE} --subtitle "{prior subtitle from baseline}"
```

---

## Lesson 7: Staged Deployment Order

Never deploy all locales at once. Mass re-indexing causes rank turbulence during transition.

### Stage 1: Emergency English Locales (no build required)
Deploy en-US, en-GB, en-CA, en-AU keyword fields first. These can be updated via the ASC API on a pending version without uploading a new build.

### Stage 2: Build Upload
Archive and upload a new build via Xcode. Build attaches to the pending version. Required before subtitle changes (app-info localizations) can be deployed.

### Stage 3: Subtitle + Title Updates
Subtitles and titles live in `appInfoLocalizations`, not `appStoreVersionLocalizations`. They are editable only on the `appInfo` with `appStoreState=PREPARE_FOR_SUBMISSION`.

**Gotcha:** Using the wrong app-info ID is a silent failure. The API will accept the update on the `READY_FOR_SALE` one but it won't actually change the live subtitle. Always find the editable one:

```bash
asc app-infos list --app {APP_ID}
# → one is READY_FOR_SALE (locked)
# → one is PREPARE_FOR_SUBMISSION (editable) — use this
```

### Stage 4: Home Market Locales
Deploy remaining 15+ home market keyword fields (de-DE, ja, it, es-ES, etc.).

### Stage 5: Submit for Review

**Rule:** English locales first, home markets second. Limits blast radius and lets you validate the English cascade before touching native markets.

---

## Lesson 8: Compound Formation

Apple indexes words from title + subtitle + keyword field **within the same locale**. Compounds only form from words that co-exist in a single locale's metadata pool.

### Cross-locale exception
Any locale that is indexed by the US store (en-US, es-MX, fr-FR, zh-Hans, zh-Hant, ko, pt-BR, ru, ar-SA, vi) contributes its words to the **US compound pool**. So words from these 10 locales DO combine with each other for US search — but only for US.

### Implication for optimization
Design each locale as a self-contained compound engine. Placing "video" in the `fr-FR` title only helps US compounds (via US cross-indexing) and French compounds (via fr-FR's own pool). It does NOT help German or Japanese compounds — because de-DE and ja don't index fr-FR.

---

## Lesson 9: Field Weight Evidence (empirical)

When "film" moved from keyword field to subtitle in the case study:
- `film camera`: unranked → **#4**
- `film filter`: unranked → **#2**
- `film filters`: unranked → **#3**
- `film photo`: unranked → **#4**

When "editor" moved from subtitle to keyword field:
- `film editor` #8 → slipped to #9-12
- `camera editor` #10 → slipped to #11-14

**Empirical finding:** Subtitle weight > keyword field weight for the same compound formation. The subtitle move produced top-5 rankings from nothing; the reverse move produced a 1-3 position slip.

**Implication:** The highest-value words MUST go in title first, then subtitle. Keyword field is for overflow bulk only.

---

## Incident Drill

Practice scenario:

> **Scenario:** You're about to remove the word "camera" from the en-US subtitle. Your US install attribution shows "camera" drove only 5 installs in the last 30 days. You have extra space for a higher-value word. Do you proceed?

### Expected Decision Tree

1. **Check the Protected Token Set.** For a camera app, is "camera" in the Protected Token Set? (Answer: almost certainly yes — it's the category root.)
2. **If yes:** STOP. Do not remove. Find another word to swap out.
3. **If somehow not in Protected Token Set**, run the en-GB Global Cascade Check (Lesson 1):
   - Pull `at_ranked_keywords` for GB, DE, JP, FR, IT, BR
   - For each market, search for compounds containing "camera" in the top 500: `camera app`, `vintage camera`, `film camera`, `disposable camera`, `digital camera`, etc.
   - If ANY of these ranks top 20 in ANY of the 6 markets → GLOBALLY LOCKED → do not remove
4. **Document the finding** in the plan's Rank Impact Analysis section.
5. **If somehow it truly passes** (unlikely for a category root word), still log the removal as a high-risk change, define rollback triggers at Day 1/3/7, and set up monitoring.

**The answer is almost always "do not remove category root words."** Category roots form so many compounds that losing them cascades catastrophically.

---

## Summary

| Lesson | One-Liner |
|---|---|
| 1. en-GB Global Cascade Check | 6-market verification before any en-US/en-GB word removal |
| 2. Protected Token Set | Per-app list of words that cannot leave en-GB |
| 3. Install Attribution Tiers | Real installs > theoretical KEI |
| 4. Subtitle Blast-Radius | Subtitle changes cascade to 130+ countries |
| 5. Monitoring Ladder | Day 1/3/7/14/30 checkpoints after every deploy |
| 6. Rollback Triggers | Decide revert conditions BEFORE deploying |
| 7. Staged Deployment Order | English locales first, home markets second |
| 8. Compound Formation | Words compound only within the same locale (US cross-index exception) |
| 9. Field Weight | Title > Subtitle > Keywords; subtitle move produces top-5 rankings from nothing |

**Cross-reference:** `../../../skills/localization/references/cross-locale-map.md` for the corrected cross-locale map.
