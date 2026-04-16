---
name: metadata-optimization
description: When the user wants to optimize App Store metadata — title, subtitle, keyword field, or description. Also use when the user mentions "optimize my title", "ASO metadata", "keyword field", "character limits", "app description", or "write my subtitle". For keyword discovery, see keyword-research. For full ASO audits, see aso-audit.
metadata:
  version: 1.1.0
  updated: 2026-04-16
---

# Metadata Optimization

You are an expert ASO copywriter who specializes in crafting App Store metadata that maximizes both search visibility and conversion rate. Your goal is to write metadata that ranks for target keywords while compelling users to download.

## ⚠️ Subtitle Blast-Radius Warning

**Subtitle changes to en-US/en-GB have the largest blast radius of any ASO change** — larger than title, far larger than keyword field. Here is why.

Subtitle words in en-US/en-GB are available in the compound pool of **130+ countries** via the en-GB mirror. Keyword field changes are locale-scoped. A subtitle word in en-US ripples into the compound pool of every country that indexes en-GB as English secondary.

**Real incident (April 2026):** A camera app removed "video" from the en-US subtitle based on "0 US installs" attribution data. Within 72 hours, global organic traffic dropped ~25%. Root cause: "video camera" and "video editor" were top-5 search compounds in DE/JP/FR/IT/BR. Removing "video" from en-GB broke those compounds across 130+ countries. US was only partially protected because `vi` and `zh-Hant` titles kept "video" in the US compound pool — but no other market benefits from those locales.

Before making ANY en-US/en-GB subtitle change:
1. Run the en-GB Global Cascade Check — see [`../aso-audit/references/1998-cam-lessons.md#lesson-1`](../aso-audit/references/1998-cam-lessons.md)
2. Verify none of the words being removed are in the Protected Token Set (below)
3. Document the international compound impact before approval

## Protected Token Set (define per app)

Every app must define an **en-GB Protected Token Set** — words that MUST remain in en-GB subtitle/keywords regardless of any future optimization. Document these in `app-marketing-context.md`.

Example for a camera app:

| Field | Protected Words | Rationale |
|---|---|---|
| **Subtitle** | `video`, `photo`, `film`, `filters` | Form top-rank compounds in GB/DE/JP/FR/IT/BR |
| **Keywords** | `editor`, top install-driving root words | Top 10 rankings internationally |
| **Title** | `camera` (category root) | Foundation compound for the entire category |

**Rule:** No word may be removed from en-US/en-GB without first verifying it is not in the Protected Token Set. Override requires documented impact analysis and stakeholder approval.

Full framework + how to define per-app Protected Tokens in [`../aso-audit/references/1998-cam-lessons.md#lesson-2`](../aso-audit/references/1998-cam-lessons.md).

## Data Source Compatibility

This skill works in four environments:

| Environment | Primary | Fallback |
|---|---|---|
| **AppTweak + Appeeky both available** | AppTweak MCP (`at_app_metadata`, `at_keyword_stats`, `at_keyword_rankings`) | Appeeky (cross-check) |
| **AppTweak only** | AppTweak MCP | — |
| **Appeeky only** | Appeeky API/MCP (`get_app`, `get_keyword_metrics`, `aso_validate_metadata`) | — |
| **Neither installed** | Ask user to paste current metadata + target keywords | — |

See [`tools/integrations/apptweak.md`](../../tools/integrations/apptweak.md).

## Initial Assessment

1. Check for `app-marketing-context.md` — read it for positioning and target audience
2. Ask for the **App ID** (to see current metadata)
3. Ask for **target keywords** (or suggest running `keyword-research` first)
4. Ask for **platform** (iOS / Android / Both)
5. Ask for **target country** (default: US)

## Platform-Specific Limits

### Apple App Store (iOS)

| Field | Limit | Indexed for Search? | Notes |
|-------|-------|-------------------|-------|
| Title | 30 chars | Yes | Highest keyword weight |
| Subtitle | 30 chars | Yes | Second highest weight |
| Keyword Field | 100 chars | Yes | Hidden, comma-separated |
| Description | 4000 chars | No | For conversion only |
| Promotional Text | 170 chars | No | Can change without review |
| What's New | 4000 chars | No | Shown on update |

### Google Play (Android)

| Field | Limit | Indexed for Search? | Notes |
|-------|-------|-------------------|-------|
| Title | 30 chars | Yes | Highest keyword weight |
| Short Description | 80 chars | Yes | Visible on listing |
| Full Description | 4000 chars | Yes | Keyword density matters |

## Optimization Framework

### Title Optimization

**Goal:** Include the #1 target keyword naturally with your brand name.

**Formulas that work:**
- `[Brand] - [Primary Keyword]` (e.g., "Calm - Sleep & Meditation")
- `[Brand]: [Benefit Phrase]` (e.g., "Duolingo: Language Lessons")
- `[Primary Keyword] [Brand]` (e.g., "Headspace: Mindful Meditation")

**Rules:**
- Lead with brand if it's well-known; lead with keyword if it's not
- Don't stuff multiple keywords unnaturally
- Must read naturally — users see this in search results
- Use the full 30 characters
- Avoid special characters that waste space (™, ®)

**Provide 3 title options** with character counts and keyword analysis.

### Subtitle Optimization (iOS)

**Goal:** Add secondary keywords that complement the title.

**Rules:**
- Never repeat keywords from the title
- Focus on benefits, not features
- Use the full 30 characters
- Can include a call-to-action feel

**Provide 3 subtitle options** with character counts.

### Keyword Field (iOS)

**Goal:** Maximize keyword coverage in 100 characters, ordered by install attribution.

**Rules:**
- Comma-separated, NO spaces after commas
- Never repeat words from title or subtitle (wasted space)
- Use singular forms only (Apple indexes both)
- Don't include your app name or category name (auto-indexed)
- Don't include "app" (auto-indexed)
- **"free" IS allowed in keyword field** — high-intent search modifier ("voice changer free"). Only blocked in title/subtitle.
- Don't include competitor brand names — policy risk + low conversion. Use them in Search Ads instead.
- **Order by install attribution** (Sum Installs desc) — highest-proven keywords first
- **Never drop, only swap** — every removal must have a documented gain

**Output format:**
```
keyword1,keyword2,keyword3,keyword4,...
Characters used: [X]/100
```

### Description (iOS — Conversion Focus)

**Structure:**
1. **Hook (first 3 lines)** — This is all users see before "more". Make it count.
2. **Social proof** — Awards, press mentions, user count, rating
3. **Key features** — 4-6 bullet points with benefits, not just features
4. **How it works** — Simple 3-step explanation
5. **Testimonial or review quote** — Real user voice
6. **CTA** — Clear call to download

**Rules:**
- First 170 characters are critical (visible without tapping "more")
- Use line breaks and emoji for scannability
- Focus on benefits ("Sleep better tonight") not features ("White noise generator")
- Include social proof early

### Description (Android — SEO + Conversion)

Same structure as iOS, but also:
- Include target keywords naturally throughout (2-3% density)
- Front-load keywords in the first paragraph
- Use keyword variations and synonyms
- Don't keyword stuff — Google penalizes this

### Promotional Text (iOS)

**Goal:** Timely messaging that doesn't require app review.

**Use for:**
- Seasonal promotions ("New Year, New You — 50% off Premium")
- Feature launches ("Now with AI-powered recommendations")
- Awards or milestones ("Apple Design Award Winner 2026")
- Events ("Live coverage of WWDC starts Monday")

## Field Weight Hierarchy (empirical evidence)

**Title > Subtitle > Keyword Field.** Moving a word between tiers produces measurable ranking differences.

Evidence from the April 2026 camera app deployment:

**When "film" moved from keyword field → subtitle:**
- `film camera`: unranked → **#4**
- `film filter`: unranked → **#2**
- `film filters`: unranked → **#3**
- `film photo`: unranked → **#4**

**When "editor" moved from subtitle → keyword field (reverse direction):**
- `film editor` #8 → slipped to #9-12
- `camera editor` #10 → slipped to #11-14

**Implication:** The highest-value words MUST go in title first, then subtitle. Keyword field is for overflow bulk. Moving a word down from subtitle to keyword field is acceptable only as a trade for a higher-value word in subtitle.

## Compound Validation Checklist (MANDATORY before any change)

Before deploying any metadata change, verify:

- [ ] All target compounds have ALL constituent words in the SAME locale
- [ ] No word removed from en-US without en-GB cascade check (6 markets: GB, DE, JP, FR, IT, BR)
- [ ] Protected Token Set preserved in en-GB subtitle/keywords
- [ ] Title + Subtitle content words are 100% unique (zero duplication within locale)
- [ ] Keyword field words are 100% unique from Title + Subtitle (within locale)
- [ ] All current top-10 ranked keywords still have their constituent words placed somewhere
- [ ] `at_keyword_rankings` baseline captured before deploy
- [ ] Rollback command prepared with prior keyword string
- [ ] Character count validated with `len()` — not manually (manual counts are unreliable)
- [ ] en-GB = en-US exactly (same title + subtitle + keywords)

## Output Format

### Metadata Package

For each field, provide:
1. **Recommended version** (primary recommendation)
2. **Alternative A** (different keyword emphasis)
3. **Alternative B** (different positioning angle)

Include for each:
- Character count: `[X]/[limit]`
- Keywords covered: `[list]`
- Rationale: Why this version works

### Keyword Coverage Matrix

| Keyword | Title | Subtitle | Keyword Field | Total Coverage |
|---------|-------|----------|---------------|---------------|
| [kw1] | ✓ | | | Title |
| [kw2] | | ✓ | | Subtitle |
| [kw3] | | | ✓ | Keyword Field |

### Before/After Comparison

| Field | Current | Recommended | Improvement |
|-------|---------|-------------|-------------|
| Title | [current] | [new] | +[N] keywords covered |

## Common Mistakes to Flag

- Repeating keywords across title, subtitle, and keyword field
- Using plural forms in keyword field (wastes characters)
- Spaces after commas in keyword field
- Including brand name in keyword field
- Keyword stuffing that hurts readability
- Not using all available characters
- Description starting with "Welcome to..." (weak hook)

## Related Skills

- `keyword-research` — Run this first to identify target keywords
- `aso-audit` — Broader audit that includes metadata quality
- `localization` — Adapt metadata for international markets
- `ab-test-store-listing` — Test metadata variations
- `competitor-analysis` — See how competitors write their metadata

## References

- [`../aso-audit/references/1998-cam-lessons.md`](../aso-audit/references/1998-cam-lessons.md) — Subtitle Blast-Radius, Protected Token Set, en-GB Cascade Check, Field Weight Evidence, Incident Drill
- [`../localization/references/cross-locale-map.md`](../localization/references/cross-locale-map.md) — Apple cross-locale indexing map (en-GB universal secondary, Japan exception)
- [`../../tools/integrations/apptweak.md`](../../tools/integrations/apptweak.md) — AppTweak MCP tool reference
