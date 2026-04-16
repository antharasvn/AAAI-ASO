---
name: localization
description: When the user wants to localize their App Store listing for international markets. Also use when the user mentions "localization", "translate my app", "international markets", "expand to new countries", "localize metadata", or "which countries should I target". For keyword research in specific markets, see keyword-research. For metadata writing, see metadata-optimization.
metadata:
  version: 1.1.0
  updated: 2026-04-16
---

# App Store Localization

You are an expert in App Store internationalization and localization strategy. Your goal is to help the user expand to new markets by localizing their App Store presence effectively.

## Data Source Compatibility

This skill works in four environments:

| Environment | Primary | Fallback |
|---|---|---|
| **AppTweak + Appeeky both available** | AppTweak MCP (`at_ranked_keywords` per country, `at_app_metadata` per country, `at_app_downloads` per country) | Appeeky (cross-check) |
| **AppTweak only** | AppTweak MCP | — |
| **Appeeky only** | Appeeky API/MCP (per-country endpoints) | — |
| **Neither installed** | Ask user to paste per-country keyword lists + market data | — |

See [`tools/integrations/apptweak.md`](../../tools/integrations/apptweak.md).

## ⚠️ The Two Facts You Must Know

1. **en-GB is the universal secondary locale for 130+ countries** — NOT en-US. The UK, plus every non-English market that uses English as a fallback (DE, FR, IT, ES, BR, NL, SE, PL, TR, and 120+ more), indexes en-GB as secondary. Uploading en-GB metadata causes a cascade across all of them.
2. **Japan is the ONLY exception** — Japan uses en-US as secondary (not en-GB). Every other non-US market uses en-GB.

**Implication:** en-GB keyword choices cascade globally. A single word removed from en-GB subtitle can break compounds in 130+ markets simultaneously (see the April 2026 camera app incident in [`../aso-audit/references/1998-cam-lessons.md`](../aso-audit/references/1998-cam-lessons.md) — 25% global traffic drop in 72 hours).

Full corrected cross-locale map (28 storefronts) in [`references/cross-locale-map.md`](references/cross-locale-map.md).

## Initial Assessment

1. Check for `app-marketing-context.md` — read it for current markets and languages
2. Ask for the **App ID** (to see current localizations)
3. Ask: **Is the app itself localized** (UI, content) or just the store listing?
4. Ask: **Which markets** are they considering?
5. Ask: **Budget** — professional translation or AI-assisted?

## Market Prioritization

### The 4-Category Locale Architecture

Every locale falls into one of four buckets. Design your deploy plan around these categories, NOT individual countries.

| Category | Count | Locales | Strategy |
|---|---|---|---|
| **US-indexed** | 11 | en-US + es-MX, fr-FR, zh-Hans, zh-Hant, ko, pt-BR, ru, ar-SA, vi (+ en-GB mirror) | English keywords maximizing US search compounds. No word duplication across these 11. |
| **Global English** | 1 | en-GB | **Mirror en-US exactly** — 130+ countries cascade from this. |
| **Non-US English** | 2 | en-CA (mirrors en-US), en-AU (expansion bucket) | Carry extra words that conflict with en-US but preserve US indexing. |
| **Home market** | 15+ | de-DE, ja, it, es-ES, pt-PT, nl-NL, sv, pl, tr, id, ms, th, hi, he, uk + new locales | Native-language keywords. en-GB secondary provides English coverage (Japan uses en-US). |

Full table of 28 storefronts with indexed locales and KW char budgets in [`references/cross-locale-map.md`](references/cross-locale-map.md).

### Tier 1 Markets (highest ROI for most apps)

| Market | Primary Locale | English Secondary | Notes |
|---|---|---|---|
| United States | en-US | — | US indexes 10 locales = 1,000 KW chars + 600 title/subtitle chars |
| United Kingdom | en-GB | — | en-GB mirrors en-US exactly. Serves 130+ countries as cascade. |
| Germany | de-DE | en-GB | Largest EU market. en-GB cascades for English compounds. |
| **Japan** | ja | **en-US (exception!)** | The only non-US market using en-US as secondary. Plan `ja` + `en-US` as a unit. |
| France | fr-FR | en-GB | fr-FR ALSO participates in US 10-locale cross-indexing |
| South Korea | ko | en-GB | ko ALSO participates in US 10-locale cross-indexing |
| China | zh-Hans | en-GB | zh-Hans ALSO participates in US 10-locale cross-indexing. Needs ICP for app itself. |
| Taiwan/HK | zh-Hant | en-GB | zh-Hant ALSO participates in US 10-locale cross-indexing |
| Brazil | pt-BR | en-GB | pt-BR ALSO participates in US 10-locale cross-indexing |
| Canada | en-CA, fr-CA | — | Own storefront with dual English+French |
| Australia | en-AU | en-GB | Own storefront; en-GB as secondary |

### Tier 2 Markets

Spain (es-ES + ca + en-GB), Italy (it + en-GB), Netherlands (nl-NL + en-GB), Sweden (sv + en-GB), Russia (ru + en-GB), Mexico (es-MX + en-GB — but es-MX is US-indexed!), India (en-GB + hi + 9 regional = 1,200 KW chars), Indonesia (id + en-GB), Turkey (tr + en-GB), Saudi Arabia (ar-SA + en-GB — but ar-SA is US-indexed!)

### How to Choose

Evaluate each market on:

| Factor | Weight | How to assess |
|--------|--------|--------------|
| Market size | 30% | iPhone user base in country |
| Competition | 25% | How many localized competitors? |
| Effort | 20% | Translation complexity, cultural distance |
| Revenue potential | 15% | ARPU in the market |
| Strategic fit | 10% | Does your app solve a local need? |

## Localization Checklist

### Metadata Localization

For each target market:

- [ ] **Title** (30 chars) — Localized with market-specific keywords
- [ ] **Subtitle** (30 chars) — Localized with local keywords
- [ ] **Keyword field** (100 chars) — Completely new research per market
- [ ] **Description** (4000 chars) — Translated and culturally adapted
- [ ] **Promotional text** (170 chars) — Localized for local events/seasons
- [ ] **What's New** — Translated for each update
- [ ] **Screenshots** — Text overlays translated, culturally appropriate imagery
- [ ] **App Preview Video** — Subtitles or localized version

### Critical: Keywords Are NOT Translations

**The biggest localization mistake:** Translating English keywords directly.

Instead:
1. Run `keyword-research` for each target market separately
2. Understand how locals search (different terms, different intent)
3. Use local autocomplete suggestions
4. Check what local competitors use in their metadata

**Example:**
- English keyword: "budget tracker"
- German: "Haushaltsbuch" (household book) — NOT "Budget Tracker"
- Japanese: "家計簿" (household ledger) — completely different concept
- Spanish: "control de gastos" (expense control) — different framing

### Cultural Adaptation

| Element | What to check |
|---------|--------------|
| Screenshots | Currency symbols, date formats, number formats |
| Colors | Cultural color associations (red = luck in China, danger in West) |
| Imagery | Diverse representation, culturally appropriate |
| Tone | Formal vs informal varies by culture |
| Features | Highlight features relevant to local needs |
| Social proof | Use local press, local user counts if possible |
| Pricing | Local pricing expectations (purchasing power parity) |

## Localization Workflow

### Phase 1: Research (per market)

1. Analyze top 10 apps in your category in the target market
2. Run keyword research with local seed terms
3. Identify local competitors and their positioning
4. Understand local App Store trends

### Phase 2: Translation & Adaptation

**For metadata (title, subtitle, keywords):**
- Use native speakers with ASO knowledge (not just translators)
- Provide context: "This is an App Store title, must include [keyword]"
- Review with keyword data — does the translation include high-volume terms?

**For description:**
- Professional translation with cultural adaptation
- Not word-for-word — adapt examples, references, humor
- Maintain the same persuasive structure

**For screenshots:**
- Translate text overlays
- Adjust UI language if app is localized
- Consider local design preferences

### Phase 3: Launch & Monitor

1. Submit localized metadata
2. Monitor keyword rankings in each market (weekly)
3. Track conversion rate by country
4. Iterate based on performance data

Full monitoring ladder (Day 1/3/7/14/30) + hard/soft rollback triggers in [`../aso-audit/references/1998-cam-lessons.md#lesson-5`](../aso-audit/references/1998-cam-lessons.md).

## ⚠️ en-GB Global Cascade Check (MANDATORY before any en-US/en-GB change)

Any word removed from en-US or en-GB subtitle or keywords must pass the **6-market cascade check**. en-GB mirrors en-US and serves 130+ countries. Removing a word silently breaks compounds everywhere.

### Procedure

1. **Pull international rankings:** `at_ranked_keywords` for **GB, DE, JP, FR, IT, BR** (the top 6 en-GB markets)
2. **Compound search:** In each market's top 500, search for compounds containing the word
3. **Volume check:** `at_keyword_stats` with `country=gb` for the word + its compounds
4. **Decision:** If ANY compound in ANY market ranks top 20 → **LOCKED** → do not remove

### Classification

| International Rank | Classification | Action |
|---|---|---|
| Top 10 in ANY market | GLOBALLY LOCKED | Cannot remove |
| Top 20 in 3+ markets | GLOBALLY PROTECTED | Requires documented override |
| Top 50 in 1-2 markets | EVALUATE | Acceptable if no top-20 compound value |
| #51+ in all 6 markets | SAFE | Can drop (still run standard US check) |

Full procedure + incident drill in [`../aso-audit/references/1998-cam-lessons.md#lesson-1-en-gb-global-cascade-check`](../aso-audit/references/1998-cam-lessons.md).

## Staged Deployment Patterns (proven on 1998 Cam, April 2026)

Never deploy all locales at once — mass re-indexing causes 2-4 weeks of rank turbulence. Stage the deploy in 5 steps:

### Stage 1: Emergency English (no build required)

Deploy `en-US`, `en-GB`, `en-CA`, `en-AU` keyword fields first. These can be updated via the ASC API on a pending version without uploading a new build — ideal for emergency recovery from an en-GB cascade loss.

### Stage 2: Build Upload

Archive and upload a new build via Xcode. Required before subtitle changes (app-info localizations) can be deployed.

### Stage 3: Subtitle + Title Updates

Subtitles and titles live in `appInfoLocalizations`, not `appStoreVersionLocalizations`. They are editable ONLY on the `appInfo` with `appStoreState=PREPARE_FOR_SUBMISSION`.

**Silent failure gotcha:** The API will accept a subtitle update on the `READY_FOR_SALE` app-info but won't actually change anything. Always find the editable one:

```bash
asc app-infos list --app {APP_ID}
# → one is READY_FOR_SALE (locked, silent-fail target)
# → one is PREPARE_FOR_SUBMISSION (editable) — use this
```

### Stage 4: Home Market Keyword Fields

Deploy remaining 15+ home market keyword fields (de-DE, ja, it, es-ES, etc.).

### Stage 5: Submit for Review

**Rule:** English locales first, home markets second. Limits blast radius and lets you validate the en-GB cascade before touching native markets.

Full deployment patterns + validation rules + 409 bug handling in [`../aso-audit/references/1998-cam-lessons.md#lesson-7`](../aso-audit/references/1998-cam-lessons.md).

## Output Format

### Localization Plan

For each recommended market:

```
## [Country] — [Language]

Priority: [High/Medium/Low]
Estimated effort: [hours/days]
Expected impact: [download increase estimate]

Keywords (top 10):
| Keyword | Volume | Difficulty | English equivalent |
|---------|--------|------------|-------------------|

Metadata:
- Title: [localized title] ([X]/30 chars)
- Subtitle: [localized subtitle] ([X]/30 chars)
- Keywords: [localized keyword field] ([X]/100 chars)

Cultural notes:
- [specific adaptations needed]
```

### Market Prioritization Matrix

| Market | Size | Competition | Effort | Revenue | Score | Priority |
|--------|------|-------------|--------|---------|-------|----------|

## Related Skills

- `keyword-research` — Run for each target market
- `metadata-optimization` — Write localized metadata
- `screenshot-optimization` — Localize screenshot designs
- `competitor-analysis` — Analyze local competitors

## References

- [`references/cross-locale-map.md`](references/cross-locale-map.md) — Corrected Apple cross-locale indexing map (en-GB universal secondary, Japan exception, 28 storefronts)
- [`../aso-audit/references/1998-cam-lessons.md`](../aso-audit/references/1998-cam-lessons.md) — en-GB Cascade Check, Protected Token Set, Monitoring Ladder, Rollback Triggers, Staged Deployment Patterns, Incident Drill
- [`../../tools/integrations/apptweak.md`](../../tools/integrations/apptweak.md) — AppTweak MCP tool reference
