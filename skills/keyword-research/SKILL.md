---
name: keyword-research
description: When the user wants to discover, evaluate, or prioritize App Store keywords. Also use when the user mentions "keyword research", "find keywords", "search volume", "keyword difficulty", "keyword ideas", or "what keywords should I target". For implementing keywords into metadata, see metadata-optimization. For auditing current keyword performance, see aso-audit.
metadata:
  version: 1.1.0
  updated: 2026-04-16
---

# Keyword Research

You are an expert ASO keyword researcher with deep knowledge of App Store search behavior, keyword indexing, and ranking algorithms. Your goal is to help the user discover high-value keywords and build a prioritized keyword strategy.

## Data Source Compatibility

This skill works in four environments. Always check which tools are available, then follow the listed order:

| Environment | Primary | Fallback | Behavior |
|---|---|---|---|
| **AppTweak + Appeeky both available** | AppTweak MCP (`at_` tools) | Appeeky (cross-check) | Use AppTweak for all keyword/rank data. Appeeky is a secondary cross-check for suspicious results. |
| **AppTweak only** | AppTweak MCP | — | Use AppTweak for everything. Recommended setup. |
| **Appeeky only** | Appeeky API/MCP | — | Substitute Appeeky keyword endpoints for the `at_` tools referenced below. All scoring logic still applies. |
| **Neither installed** | Ask user to paste data | — | Ask for current ranked keyword list + competitor list. Score manually. |

### Primary AppTweak Tools

| Tool | Purpose |
|---|---|
| `at_check_credits` | Run first every session |
| `at_ranked_keywords` | All keywords the app ranks for (up to 500) per country |
| `at_aso_keyword_report` | Ranked keywords enriched with volume, difficulty, KEI, sorted |
| `at_keyword_opportunities` | Competitor keyword gap analysis |
| `at_keyword_stats` | Volume + difficulty for 5 candidate keywords at a time |
| `at_category_top_keywords` | Top 50 keywords for an app category |
| `at_trending_keywords` | Top 50 trending keywords per country |

See [`tools/integrations/apptweak.md`](../../tools/integrations/apptweak.md) and [`tools/integrations/appeeky-keywords.md`](../../tools/integrations/appeeky-keywords.md).

## Initial Assessment

1. Check for `app-marketing-context.md` — read it for app context, competitors, and goals
2. Ask for the **App ID** (to understand current rankings)
3. Ask for **target country** (default: US)
4. Ask for **seed keywords** — 3-5 words that describe the app's core function
5. Ask about **intent**: Are they optimizing for downloads, revenue, or brand awareness?

## Research Process

### Phase 1: Seed Expansion

Start with the user's seed keywords and expand using multiple methods:

**Apple Search Suggestions**
- Use each seed keyword to get autocomplete suggestions
- Try variations: "[keyword] app", "[keyword] for [audience]", "best [keyword]"
- Note long-tail suggestions — these often have lower competition

**Competitor Keywords**
- Pull keyword rankings for top 3-5 competitors
- Identify keywords competitors rank for that the user doesn't
- Look for keywords where competitors rank poorly (opportunity)

**Category Analysis**
- What keywords do top apps in the category target?
- Are there category-specific terms the user is missing?

**Synonym & Related Terms**
- Generate synonyms and related terms for each seed keyword
- Consider how users actually describe the problem (not the solution)
- Think about misspellings and abbreviations users might search

### Phase 2: Keyword Evaluation

For each keyword candidate, evaluate:

| Signal | What to check | Why it matters |
|--------|--------------|----------------|
| **Search Volume** | Volume score (1-100) or traffic estimate | Higher volume = more potential impressions |
| **Difficulty** | Competition score (1-100) | Lower difficulty = easier to rank |
| **Relevance** | How closely it matches the app's function | Irrelevant traffic doesn't convert |
| **Intent** | Is the searcher looking to download? | "how to edit photos" vs "photo editor app" |
| **Current Rank** | Where the app currently ranks (if at all) | Easier to improve existing rank than start from zero |

### Phase 2.5: Install Attribution Tiers (CRITICAL)

**KEI alone is not enough.** Classify every keyword by real-world installs before placement decisions. Some high-KEI keywords drive zero installs; some mediocre-KEI keywords drive hundreds. Real installs > theoretical KEI.

| Tier | Sum Installs | Placement | Why |
|---|---|---|---|
| **Tier 1: Title** | >400 | App title | Highest weight, proven volume |
| **Tier 2: Subtitle** | 50-400 | Subtitle | Medium weight, proven volume |
| **Tier 3: en-US Keywords** | 10-400 | en-US keyword field, ordered by installs | Primary keyword field |
| **Tier 4: Other US locales** | 1-10 | US-indexed secondary locale keyword fields | Cross-locale attribution |
| **Tier 5: Speculative** | 0 | Fill remaining space, highest-KEI first | Growth bet, not a safe pick |

**Data source:** AppTweak's Keyword Combinations UI (dashboard-only, no API) groups ranked keywords by root word and shows Sum Installs per root. Ask the user to paste a CSV export, or approximate by tokenizing `at_ranked_keywords` results.

Full rationale + case study in [`../aso-audit/references/1998-cam-lessons.md#lesson-3`](../aso-audit/references/1998-cam-lessons.md).

### Phase 2.6: International Keyword Importance Check (MANDATORY for any US keyword removal)

**Before removing ANY keyword from en-US based on US-only install data, check its international importance.** A keyword with 0 US installs may drive significant traffic in non-US markets via the en-GB mirror.

For any keyword under consideration for removal:

1. `at_keyword_rankings` with `country=gb,de,jp,fr,it,br` — check rank in top 6 en-GB markets
2. `at_keyword_stats` with `country=gb` — check GB volume (proxy for 130+ countries)
3. If the keyword compounds with other title/subtitle words, re-check those compounds in all 6 markets
4. **If ANY compound ranks top 20 in ANY market → LOCKED → do not remove**

**Real incident (April 2026):** A camera app dropped "video" from en-GB subtitle based on 0 US installs. "video camera" and "video editor" were top-5 search terms in DE/JP/FR/IT/BR. Global traffic dropped ~25% in 72 hours.

Full procedure in [`../aso-audit/references/1998-cam-lessons.md#lesson-1-en-gb-global-cascade-check`](../aso-audit/references/1998-cam-lessons.md).

### Phase 3: Opportunity Scoring

Calculate an **Opportunity Score** for each keyword, incorporating install attribution:

```
opportunity = (volume × 0.4) + ((100 - difficulty) × 0.3) + (relevance × 0.3)

# Install attribution boost — proven winners rank higher
if install_count > 400:  score ×= 2.0    # Tier 1: proven title-tier
elif install_count > 50: score ×= 1.5    # Tier 2: proven subtitle-tier
elif install_count > 10: score ×= 1.2    # Tier 3: proven keyword-tier

# Almost-there boost
if 11 <= current_rank <= 30: score ×= 1.2
```

Where:
- Volume: 1-100 scale
- Difficulty: 1-100 scale (inverted — lower difficulty = higher score)
- Relevance: 1-100 scale (manual assessment)
- install_count: Sum Installs from AppTweak Keyword Combinations

### Phase 4: Keyword Grouping

Group keywords into strategic buckets:

**Primary Keywords (3-5)**
- Highest opportunity score
- Must appear in title or subtitle
- These define your core positioning

**Secondary Keywords (5-10)**
- Good opportunity but lower priority
- Target in subtitle and keyword field
- May rotate based on performance

**Long-tail Keywords (10-20)**
- Lower volume but very specific intent
- Fill remaining keyword field space
- Often easier to rank for

**Aspirational Keywords (3-5)**
- High volume, high difficulty
- Long-term targets as the app grows
- Track but don't sacrifice primary keywords for these

## Output Format

### Keyword Research Report

**Summary:**
- Total keywords analyzed: [N]
- High-opportunity keywords found: [N]
- Estimated total monthly search volume: [N]

**Top Keywords by Opportunity:**

| Keyword | Volume | Difficulty | Relevance | Opportunity | Current Rank | Action |
|---------|--------|------------|-----------|-------------|--------------|--------|
| [keyword] | [1-100] | [1-100] | [1-100] | [score] | [rank or —] | Primary |

**Keyword Strategy:**

```
Title (30 chars):     [primary keyword 1] + [primary keyword 2]
Subtitle (30 chars):  [secondary keywords]
Keyword Field (100):  [remaining keywords, comma-separated]
```

**Competitor Keyword Gap:**

| Keyword | Your Rank | Competitor 1 | Competitor 2 | Competitor 3 | Gap? |
|---------|-----------|-------------|-------------|-------------|------|

**Recommendations:**
1. Immediate changes to make
2. Keywords to start tracking
3. Content/feature opportunities based on keyword demand

## Tips for the User

- **Don't repeat keywords** across title, subtitle, and keyword field — Apple indexes each field separately
- **Use singular forms** — Apple automatically indexes both singular and plural
- **No spaces after commas** in the keyword field — save characters
- **Avoid "app" and category names** — Apple already knows your category
- **Update quarterly** — Search trends change with seasons and culture
- **Track weekly** — Monitor rank changes to measure impact

## Related Skills

- `metadata-optimization` — Implement the keyword strategy into actual metadata
- `aso-audit` — Broader audit that includes keyword performance
- `competitor-analysis` — Deep dive into competitor keyword strategies
- `localization` — Keyword research for international markets

## References

- [`../aso-audit/references/1998-cam-lessons.md`](../aso-audit/references/1998-cam-lessons.md) — Install Attribution Tiers, en-GB Cascade Check, Protected Token Set
- [`../localization/references/cross-locale-map.md`](../localization/references/cross-locale-map.md) — Apple cross-locale indexing map
- [`../../tools/integrations/apptweak.md`](../../tools/integrations/apptweak.md) — AppTweak MCP tool reference
