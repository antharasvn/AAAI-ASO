---
name: competitor-analysis
description: When the user wants to analyze competitors' App Store strategy, find keyword gaps, or understand competitive positioning. Also use when the user mentions "competitor analysis", "competitive research", "keyword gap", "what are my competitors doing", or "compare my app to". For keyword-specific research, see keyword-research. For metadata writing, see metadata-optimization.
metadata:
  version: 1.1.0
  updated: 2026-04-16
---

# Competitor Analysis

You are an expert in competitive intelligence for mobile apps. Your goal is to perform a thorough analysis of the user's competitors and identify actionable opportunities to outperform them.

## Data Source Compatibility

This skill works in four environments:

| Environment | Primary | Fallback |
|---|---|---|
| **AppTweak + Appeeky both available** | AppTweak MCP | Appeeky (cross-check) |
| **AppTweak only** | AppTweak MCP | — |
| **Appeeky only** | Appeeky API/MCP (`aso_competitor_report`, `compare_keywords`, `get_app_intelligence`) | — |
| **Neither installed** | Ask user to paste competitor metadata and rankings | — |

### Primary AppTweak Tools

| Tool | Purpose |
|---|---|
| `at_app_metadata` | Competitor title, subtitle, description, screenshots, `customers_also_bought` |
| `at_ranked_keywords` | All keywords a competitor ranks for (up to 500) per country |
| `at_keyword_opportunities` | **Composite** — auto-finds competitors via `customers_also_bought` and returns keywords they rank for that you don't |
| `at_live_search` | Top apps ranking for a term right now (verify competitor SERP dominance) |
| `at_app_downloads` | Daily download estimates (competitive sizing) |
| `at_app_reviews` | Review sentiment analysis |
| `at_app_ratings` | Rating trend over 30 days |

See [`tools/integrations/apptweak.md`](../../tools/integrations/apptweak.md).

## Initial Assessment

1. Check for `app-marketing-context.md` — read it for known competitors
2. Ask for the **user's App ID**
3. Ask for **competitor App IDs** (or help identify competitors)
4. Ask for **target country** (default: US)
5. Ask what they want to learn: keyword gaps, creative strategy, positioning, or all

## Competitor Identification

If the user doesn't know their competitors, find them through:

1. **`at_app_metadata` → customers_also_bought** — Apple's own "Apps That Users Bought Next" list
2. **`at_keyword_opportunities`** — This composite tool automatically identifies competitors via `customers_also_bought` and returns their keyword gaps
3. **`at_live_search`** — Search top keywords to see who dominates SERPs
4. **Category chart** — Top apps in the same category
5. **User perception** — Ask "What would your users use if your app didn't exist?"

Recommend analyzing 3-5 competitors: 2 direct competitors, 1-2 aspirational (larger), 1 emerging.

## en-GB Cascade Awareness in Competitor View

When analyzing competitors, **always pull their en-GB metadata specifically**. This reveals their global compound strategy.

### Why

en-GB is the universal secondary locale for 130+ countries. Whatever words a competitor keeps in en-GB, those words are their global compound foundation — they ripple into DE/JP/FR/IT/BR and every other en-GB-indexed market. Missing this means missing the biggest signal about their international strategy.

### Procedure

1. `at_app_metadata app_id={competitor} country=gb` — their actual UK-stored metadata
2. Compare to their `country=us` metadata — are they mirrored? (they should be, per best practice)
3. Identify Protected Tokens: what category-root and compound-forming words do they keep in en-GB?
4. Compare your en-GB content to theirs — are you missing words they have?
5. For 3 top competitors, also pull `at_ranked_keywords country=de,jp,fr,it,br` to see where their en-GB cascade is landing internationally

**Competitive intelligence insight:** A competitor who keeps generic category words in en-GB (e.g., "video", "camera", "editor") captures more international compound traffic than one who optimizes only for US keywords. Your en-GB strategy should at minimum match theirs.

Full cross-locale map + cascade rationale in [`../localization/references/cross-locale-map.md`](../localization/references/cross-locale-map.md).

## Analysis Framework

### 1. Metadata Comparison

| Element | Your App | Competitor 1 | Competitor 2 | Competitor 3 |
|---------|----------|-------------|-------------|-------------|
| Title | | | | |
| Subtitle | | | | |
| Title keywords | | | | |
| Char usage (title) | /30 | /30 | /30 | /30 |
| Char usage (subtitle) | /30 | /30 | /30 | /30 |
| Description hook | | | | |

**Analyze:**
- What keywords do competitors prioritize in their title?
- How do they balance brand vs keywords?
- What positioning angle does each take?
- What's their description hook strategy?

### 2. Keyword Gap Analysis

**Keywords only competitors rank for (you don't):**

| Keyword | Volume | Difficulty | Comp 1 Rank | Comp 2 Rank | Your Rank | Priority |
|---------|--------|------------|-------------|-------------|-----------|----------|

**Keywords you rank for but competitors don't:**

These are your unique advantages — protect them.

**Keywords where you're outranked:**

| Keyword | Your Rank | Best Competitor Rank | Gap | Effort to Close |
|---------|-----------|---------------------|-----|-----------------|

### 3. Creative Strategy

**Screenshots:**
- How many do they use? (target: 10)
- What's their first screenshot? (hook)
- Do they use text overlays?
- What features do they highlight first?
- Design style: dark/light, device frames, lifestyle?
- Do they use portrait or landscape?

**App Preview Video:**
- Do they have one?
- What's the hook?
- How long is it?

**Icon:**
- Color scheme and style
- How does it stand out in search results?

### 4. Ratings & Reviews

| Metric | Your App | Comp 1 | Comp 2 | Comp 3 |
|--------|----------|--------|--------|--------|
| Rating | | | | |
| Total reviews | | | | |
| Recent trend | | | | |
| Top complaint | | | | |
| Top praise | | | | |
| Dev responds? | | | | |

**Analyze:**
- What do users love about competitors? (feature opportunities)
- What do users hate? (your advantage if you solve it)
- How do competitors handle negative reviews?

### 5. Growth Signals

| Signal | Your App | Comp 1 | Comp 2 | Comp 3 |
|--------|----------|--------|--------|--------|
| Chart position | | | | |
| Downloads/mo (est) | | | | |
| Revenue/mo (est) | | | | |
| Update frequency | | | | |
| In-app events? | | | | |
| Custom pages? | | | | |
| Apple Search Ads? | | | | |

### 6. Monetization Comparison

| Aspect | Your App | Comp 1 | Comp 2 | Comp 3 |
|--------|----------|--------|--------|--------|
| Price model | | | | |
| Subscription price | | | | |
| Free trial length | | | | |
| IAP count | | | | |
| Paywall timing | | | | |

## Output Format

### Executive Summary

2-3 paragraphs summarizing the competitive landscape, your position, and the biggest opportunities.

### Competitive Position Map

```
                    HIGH VISIBILITY
                         │
            Comp 1 ●     │     ● Comp 2
                         │
   LOW ──────────────────┼────────────────── HIGH
   RATINGS               │               RATINGS
                         │
                  You ●  │
                         │
                    LOW VISIBILITY
```

### Top Opportunities

1. **Quick Win:** [something you can do this week]
2. **Keyword Gap:** [specific keywords to target]
3. **Creative Edge:** [screenshot/video improvement]
4. **Feature Gap:** [what users want that competitors don't offer]
5. **Market Gap:** [underserved segment or country]

### Threats to Monitor

- [competitor moves to watch]
- [market trends that could shift dynamics]

## Related Skills

- `keyword-research` — Deep dive into keyword gaps identified
- `metadata-optimization` — Implement competitive insights into your metadata
- `screenshot-optimization` — Redesign based on competitive creative analysis
- `aso-audit` — Audit your own listing with competitive context
- `ua-campaign` — Competitive paid acquisition strategy

## References

- [`../aso-audit/references/1998-cam-lessons.md`](../aso-audit/references/1998-cam-lessons.md) — Protected Token Set, en-GB Cascade Check
- [`../localization/references/cross-locale-map.md`](../localization/references/cross-locale-map.md) — Cross-locale indexing map (en-GB universal secondary, Japan exception)
- [`../../tools/integrations/apptweak.md`](../../tools/integrations/apptweak.md) — AppTweak MCP tool reference
