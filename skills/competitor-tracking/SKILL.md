---
name: competitor-tracking
description: When the user wants to monitor competitor apps on an ongoing basis — tracking metadata changes, keyword shifts, screenshot updates, rating trends, or new features. Use when the user mentions "competitor monitoring", "track competitors", "competitor alert", "competitor changed their title", "watch a competitor app", "competitor weekly report", "competitive intelligence", or "what changed in competitor's listing". For a one-time deep competitive analysis, see competitor-analysis. For market-wide chart movements, see market-movers.
metadata:
  version: 1.1.0
  updated: 2026-04-16
---

# Competitor Tracking

You set up and run ongoing competitor surveillance — catching metadata changes, keyword shifts, rating drops, and new feature launches before they impact your rankings.

## One-Time Analysis vs Ongoing Tracking

| | `competitor-analysis` skill | This skill (`competitor-tracking`) |
|---|---|---|
| **Frequency** | One-time deep dive | Weekly/monthly recurring |
| **Output** | Strategy document | Change log + alerts |
| **Focus** | Gap analysis, positioning | What changed and why it matters |
| **Data** | Snapshot | Delta (before vs after) |

## Setup: Define Your Watchlist

1. Check for `app-marketing-context.md`
2. Ask: **Who are your top 3–5 competitors?** (get App IDs if possible)
3. Ask: **How often do you want to review?** (weekly recommended)
4. Ask: **What are you most concerned about?** (keywords, ratings, creative, pricing)

## Data Source Compatibility

| Environment | Primary | Fallback |
|---|---|---|
| **AppTweak + Appeeky both available** | AppTweak MCP (`at_app_metadata`, `at_ranked_keywords`, `at_metadata_changes`, `at_asa_bid_history`) | Appeeky |
| **AppTweak only** | AppTweak MCP | — |
| **Appeeky only** | Appeeky API/MCP | — |
| **Neither installed** | Manual checks via App Store screenshots + user input | — |

### en-GB Cascade Awareness (CRITICAL for multi-market tracking)

When tracking competitors, **always pull their en-GB metadata specifically**, not just en-US. en-GB is the universal secondary locale for 130+ countries; what a competitor keeps in en-GB reveals their global compound strategy.

**Tracking checklist per competitor (weekly):**

1. `at_app_metadata country=us` — primary market
2. `at_app_metadata country=gb` — **the global compound foundation** (watch for changes here especially)
3. `at_metadata_changes country=us` — automated change detection
4. `at_ranked_keywords country=gb` — are they gaining/losing compounds in en-GB cascade markets?
5. For top 3 competitors, also: `at_ranked_keywords country=de` + `country=jp` + `country=fr` — where their en-GB cascade is landing

**What to watch for:**
- Competitor adds a permanent category root word (e.g., "video") to their en-GB subtitle → they just gained compound traffic in 130+ markets
- Competitor removes a Protected Token from en-GB → they're about to lose 10-25% of global organic traffic (the 1998 Cam mistake — see [`../aso-audit/references/1998-cam-lessons.md`](../aso-audit/references/1998-cam-lessons.md))

### Identify Competitors

Use AppTweak MCP (primary) to identify competitors if unknown:

```bash
# AppTweak (primary)
at_app_metadata app_id=<your_id> country=us  # check customers_also_bought
at_live_search term="meditation" country=us  # top apps for the term
at_keyword_opportunities app_id=<your_id> country=us  # auto-finds competitors + gap analysis

# Appeeky (fallback)
GET /v1/keywords/ranks?keyword=meditation&country=us&limit=10
GET /v1/apps/:id/intelligence  # check competitors array
```

## What to Track

### Metadata Changes

Check weekly using AppTweak (primary) or Appeeky (fallback):

```bash
# AppTweak (primary) — per country, essential for en-GB cascade tracking
at_app_metadata app_id=<competitor_id> country=us
at_app_metadata app_id=<competitor_id> country=gb
at_metadata_changes app_id=<competitor_id> country=us  # automated change log

# Appeeky (fallback)
GET /v1/apps/:id  # title, subtitle, description
```

Watch for:
- **Title changes** — new keyword being targeted, repositioning
- **Subtitle changes** — testing new hooks or keywords
- **Description changes** — messaging strategy shift (Google Play especially)
- **Screenshot updates** — new creative direction or A/B test winner shipped

### Keyword Ranking Changes

```bash
# AppTweak (primary)
at_ranked_keywords app_id=<competitor_id> country=us limit=500
at_ranked_keywords app_id=<competitor_id> country=gb limit=500  # en-GB cascade view
at_keyword_rankings app_ids=<competitor_id> keywords="<shared keyword>" country=us

# Appeeky (fallback)
GET /v1/apps/:id/keywords  # their ranking keywords
GET /v1/keywords/ranks?keyword=[shared keyword]  # who's ranking where
```

Watch for:
- Keywords they're newly ranking for (they optimized for this — should you?)
- Keywords they dropped (opportunity to capture)
- A competitor jumping above you for a shared keyword

### Ratings and Reviews

```bash
GET /v1/apps/:id/reviews?sort=recent&limit=20
GET /v1/apps/:id  # current rating
```

Watch for:
- Rating drop (they shipped a bad update — opportunity to highlight your stability)
- Surge of 1-stars around a specific complaint (user pain point you could solve)
- New positive reviews praising a feature you don't have

### Chart Positions

```bash
GET /v1/market/movers?genre=[genre_id]&country=us
GET /v1/categories/:id/top?country=us&limit=25
```

Watch for:
- A competitor entering or exiting top 10 in your category
- New competitor entering your space from a chart rise

### Pricing and Paywall

Manually check every 4–6 weeks:
- Trial length changes
- Price changes (lower = aggressive growth; higher = LTV optimization)
- New paywall format or plans

## Weekly Competitive Report Template

Run this analysis every Monday:

```
Competitive Update — Week of [Date]

Apps tracked: [list names]

CHANGES DETECTED:
━━━━━━━━━━━━━━━━━
[Competitor Name]
  Metadata: [changed / no change]
    → [specific change if any]
  Top keywords: [gained X / lost Y / stable]
  Rating: [X.X → X.X] ([+/-N] ratings this week)
  Chart position: [#N → #N in category]
  New reviews theme: [if notable]

[Repeat per competitor]

OPPORTUNITIES IDENTIFIED:
1. [Competitor X dropped keyword Y — consider targeting it]
2. [Competitor X has surge of complaints about Z — your strength]
3. [Competitor X raised price — positioning opportunity]

THREATS:
1. [Competitor X now ranks #3 for [keyword] — we're at #8]
2. [New entrant spotted: [name] — check their metadata]

ACTION ITEMS:
1. [Specific response to a change]
2. [Keyword to target based on competitor gap]
```

## Monthly Deep-Dive Triggers

Run a full `competitor-analysis` when:
- A competitor jumps 10+ positions in the category chart
- A competitor changes their title (signals major repositioning)
- A new competitor enters the top 10 in your category
- Your ranking drops on a keyword a competitor recently targeted

## Automation Options

### Manual (recommended for small teams)

Set a calendar reminder. Run the AppTweak tool calls above. Fill the template.

### Semi-automated

Build a script that calls AppTweak (or Appeeky as fallback) weekly and diffs results. Store results weekly and diff with the previous week's output.

### AppTweak MCP (in Claude/Cursor) — primary

Ask your agent each Monday:

```
"Run a competitor check on apps [ID1], [ID2], [ID3]. For each, pull 
at_app_metadata for country=us AND country=gb, at_metadata_changes 
for the last week, and at_ranked_keywords country=us (limit=500). 
Compare to last week's snapshot and flag any changes."
```

The agent will use `at_app_metadata`, `at_ranked_keywords`, `at_metadata_changes`, `at_app_reviews`, and `at_asa_bid_history` to produce the report.

### Appeeky MCP (fallback)

Equivalent Appeeky MCP tools: `get_app`, `get_app_keywords`, `get_app_reviews`. See [`../../tools/integrations/appeeky-aso.md`](../../tools/integrations/appeeky-aso.md).

## Competitive Response Playbook

| What changed | Response |
|-------------|---------|
| Competitor targets your #1 keyword in title | Defend: check your metadata is fully optimized; consider increasing ASA bids |
| Competitor drops a keyword you share | Opportunity: double down, increase bid in ASA |
| Competitor upgrades screenshots | Audit yours — are they still best in category? |
| Competitor rating drops below 4.0 | Mention your rating in promotional text while gap is visible |
| Competitor launches a feature you don't have | Note for roadmap; meanwhile highlight your differentiating strengths |
| New competitor enters top 10 | Run full `competitor-analysis` on them |

## Related Skills

- `competitor-analysis` — Deep one-time competitive strategy
- `keyword-research` — Act on the keyword gaps you find
- `market-movers` — Catch chart-level competitor movements automatically
- `apple-search-ads` — Respond to competitor keyword moves with ASA bids

## References

- [`../aso-audit/references/1998-cam-lessons.md`](../aso-audit/references/1998-cam-lessons.md) — Protected Token Set, en-GB Cascade Check (know what a competitor removing from en-GB means)
- [`../localization/references/cross-locale-map.md`](../localization/references/cross-locale-map.md) — Cross-locale indexing map
- [`../../tools/integrations/apptweak.md`](../../tools/integrations/apptweak.md) — AppTweak MCP tool reference
- `aso-audit` — Run on yourself after finding competitive gaps
