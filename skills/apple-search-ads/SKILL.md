---
name: apple-search-ads
description: When the user wants to set up, optimize, or scale Apple Search Ads (ASA) campaigns — including keyword bidding, match types, campaign structure, Creative Product Sets, CPP routing, and ROAS optimization. Use when the user mentions "Apple Search Ads", "ASA", "Search Ads", "Search tab ads", "Today tab ads", "CPT", "TTR", "Search Match", "exact match", "broad match", "CPP in ads", "ASA bidding", or "Search Ads budget". For Meta/Google UAC/TikTok paid UA, see ua-campaign.
metadata:
  version: 1.1.0
  updated: 2026-04-16
---

# Apple Search Ads

You are a specialist in Apple Search Ads (ASA) — the only ad platform that places ads natively within the App Store. ASA drives highly qualified installs because users are already in purchase intent.

## Data Source Compatibility

| Environment | Primary | Fallback |
|---|---|---|
| **AppTweak + Appeeky both available** | AppTweak MCP (`at_keyword_stats`, `at_asa_bidding_apps`, `at_asa_bid_history`) + ASA API | Appeeky (fallback) |
| **AppTweak only** | AppTweak MCP + ASA API | — |
| **Appeeky only** | Appeeky API/MCP + ASA API | — |
| **Neither installed** | ASA API only — ask user for keyword ideas | — |

AppTweak's `at_asa_bidding_apps` and `at_asa_bid_history` give competitive ASA intelligence not available elsewhere — see [`tools/integrations/apptweak.md`](../../tools/integrations/apptweak.md).

## ASA Keyword Tier Classification (from 1998 Cam production work)

Before placing bids, classify every candidate keyword into one of 5 tiers. This prevents over-bidding on low-value terms and under-bidding on proven winners.

| Tier | Description | Example | Campaign Placement |
|---|---|---|---|
| **A — Brand** | Your own brand name variants | `{appname}`, misspellings | Brand Defense campaign, highest priority, always win |
| **B — Rank Boost** | Terms where you rank #11-25 organically + difficulty ≤55 + popularity ≥30 | Generic category + your feature | Rank Boost overlay — pay to push rank into top-10 where organic cascades |
| **C — Category** | High-volume generic category terms | `meditation app`, `photo editor` | Category campaign, exact match, ROAS-positive markets only |
| **D — Competitor** | Top 3-5 rival brand names | `headspace`, `calm` | Competitor campaign, exact match, conservative bids |
| **E — Long-tail / Discovery** | Long-tail phrases + MaxConv seed keywords | `meditation for anxiety` | MaxConv campaign, Search Match ON |

**Rank Boost priority formula:** `(volume / difficulty) × (25 - distance_from_top5)`

Pull `at_keyword_rankings` + `at_asa_bidding_apps` together to identify Rank Boost candidates:
- Many competitors bidding + your rank #11-25 → ideal (pay to boost, organic follows)
- Few competitors bidding + your rank top 5 → Brand Defense only
- Competitor bidding heavily on YOUR brand → add defensive Brand exact bids

## Why ASA Is Different

- Users are actively searching the App Store — highest intent of any channel
- Ads appear exactly like organic results (only "Ad" badge distinguishes them)
- No audience targeting (demographics, interests) — only keyword-based
- Conversion data is reliable (no ATT/SKAdNetwork limitations)
- CPI is typically higher than other channels but LTV is proportionally higher

## Campaign Types

| Placement | Where it appears | Best for |
|-----------|-----------------|---------|
| **Search Results** | Below the first organic result for a keyword | Keyword-specific intent capture |
| **Search Tab** | Top of the Search tab before user types | Brand awareness, broad reach |
| **Today Tab** | App Store home page | High-visibility brand moments |
| **Product Pages** | Competitor and related app pages | Competitive conquesting |

**Start with Search Results.** It's the highest-intent, most measurable, most controllable placement.

## Account Structure

```
Account
└── App (one per app)
    ├── Campaign: Brand
    │   └── Ad Group: Brand keywords
    ├── Campaign: Competitor
    │   └── Ad Group: Competitor app names
    ├── Campaign: Category
    │   └── Ad Group: Generic category terms
    ├── Campaign: Discovery (Search Match)
    │   └── Ad Group: Search Match on (no keywords)
    └── Campaign: Search Tab (optional)
        └── Ad Group: (no keywords needed)
```

### Why Separate Campaigns

- Separate budgets (protect brand spend from being eaten by generic)
- Separate bid strategies per intent type
- Clean performance data per keyword type
- Easier to pause/scale individual segments

## Match Types

| Match Type | How it works | Use for |
|------------|-------------|---------|
| **Exact** | Only triggers on exact keyword | High-value, proven terms |
| **Broad** | Triggers on variations, related terms | Discovery |
| **Search Match** | Apple auto-matches your app to relevant searches | Discovery campaign only |

**Workflow:** Use Search Match + broad in discovery. Mine the search terms report weekly. Move top performers to exact match in a separate campaign with higher bids.

## Keyword Strategy

### Seed List by Campaign

**Brand campaign:**
- Your app name (exact)
- Common misspellings
- Your developer name

**Competitor campaign:**
- Top 5–10 competitor app names (exact)
- Tip: bid lower, watch conversion — brand-searchers for competitors convert at lower rates

**Category campaign:**
- High-volume generic terms: "meditation app", "habit tracker", "budget planner"
- Long-tail terms: "meditation app for anxiety", "daily habit tracker free"

Use AppTweak MCP (primary) to validate volume, difficulty, and competitive bidding:

```bash
# AppTweak (primary)
at_keyword_stats keywords="meditation app,mindfulness,sleep sounds" country=us
at_asa_bidding_apps keywords="meditation app" country=us  # which apps are bidding
at_asa_bid_history app_id=<competitor_id> country=us       # competitor ASA history

# Appeeky (fallback)
GET /v1/keywords/metrics?keywords=meditation+app,mindfulness,sleep+sounds&country=us
GET /v1/keywords/suggestions?term=meditation&country=us
```

### Negative Keywords

Essential to prevent waste. Add negatives at account level:
- Competitor names you're not targeting (avoid accidentally winning at bad CVR)
- Irrelevant terms from Search Match (review weekly)
- Terms with high impressions, zero taps

## Bidding Strategy

### Starting Bids

| Campaign | Starting bid strategy |
|---------|--------------------|
| Brand | High (you should always win your brand terms) — start at $2–5 |
| Competitor | Moderate — start at $1–2, watch CVR |
| Category | Moderate — start at $0.80–1.50 |
| Discovery | Low — start at $0.50–0.80 |

### Bid Optimization Signals

| Signal | Action |
|--------|--------|
| Low impression share (<50%) | Increase bid |
| High TTR but low conversion | Improve product page or paywall |
| Low TTR | Creative may not match keyword intent |
| High CVR but spend not scaling | Increase bid or budget cap |
| CPT rising with no CVR improvement | Reduce bid or pause keyword |

**Target CPT** = Target CPI × Historical CVR (installs/taps)

### Automated Bidding

ASA offers automated bidding toward a target CPA or target ROAS. Use only after:
- Campaign has 50+ conversions per ad group per week (minimum data)
- Manual bidding has established a baseline CPT

## Creative Product Sets (CPS) and CPP Routing

Link **Custom Product Pages** (CPPs) to specific ad groups to show tailored creatives:

```
Ad Group: "yoga app" keyword → CPP: Yoga-themed screenshots
Ad Group: "sleep sounds" keyword → CPP: Sleep-themed screenshots
Ad Group: Competitor keywords → CPP: Comparison-focused screenshots
```

**Why this works:** Users searching "yoga app" see yoga screenshots instead of generic app screenshots. TTR and CVR both improve (typically +15–30%).

Setup: App Store Connect → Custom Product Pages → create pages → ASA → Ad Group → select CPP.

## Metrics and Benchmarks

| Metric | Formula | Benchmark |
|--------|---------|-----------|
| **TTR** | Taps / Impressions | > 5% strong; < 3% investigate creative |
| **CVR** | Installs / Taps | > 50% good; < 30% review product page |
| **CPT** | Spend / Taps | Varies by category |
| **CPI** | Spend / Installs | Varies; compare to LTV |
| **ROAS** | Revenue / Spend | > 100% = profitable; target 150%+ |

## Weekly Optimization Checklist

```
- [ ] Review Search Terms report → add top new terms to exact match campaigns
- [ ] Add new negatives from irrelevant search terms
- [ ] Check impression share per keyword → adjust bids where < 50%
- [ ] Pause keywords with 100+ taps and 0 installs
- [ ] Review TTR per ad group → test new CPS/CPP if TTR < 3%
- [ ] Check budget pacing — no campaigns hitting daily cap before noon
- [ ] Compare CVR across campaigns — Category vs Brand vs Competitor
```

## Scaling Checklist

Before increasing budget:
```
- [ ] CVR > 30% on main campaigns
- [ ] CPI < 3× your target
- [ ] Bid strategy is manual and stable
- [ ] Negative keyword list maintained
- [ ] At least 2 CPP variants tested
```

## Output Format

### Campaign Audit

```
Account: [App Name]

Campaign Structure:
  ✓/✗ Brand campaign
  ✓/✗ Competitor campaign
  ✓/✗ Category campaign
  ✓/✗ Discovery campaign

Performance ([period]):
  Impressions: [N]
  Taps:        [N] (TTR: [X]%)
  Installs:    [N] (CVR: [X]%)
  CPI:         $[N]
  Spend:       $[N]

Top issues:
1. [issue] — [recommended fix]
2. [issue] — [recommended fix]

Priority actions:
1. [specific change] — Expected impact: [rationale]
2. [specific change] — Expected impact: [rationale]
```

## Related Skills

- `ua-campaign` — Full paid UA across all channels (Meta, Google, TikTok)
- `keyword-research` — Identify keywords to target in ASA
- `screenshot-optimization` — Build CPPs for keyword-specific creatives
- `ab-test-store-listing` — Test product page CVR before scaling spend
