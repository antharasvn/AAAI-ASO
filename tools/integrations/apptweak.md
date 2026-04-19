# AppTweak MCP Integration

**Primary data source for keyword and rank intelligence across ASO skills.**

AppTweak is the recommended provider for keyword research, rank tracking, competitor analysis, and market intelligence. It offers deeper historical data and broader international coverage than other ASO APIs.

## When to Use AppTweak

| Workflow | Primary Source |
|---|---|
| Keyword discovery + volume/difficulty | AppTweak |
| Rank tracking (500 keywords per app per country) | AppTweak |
| Competitor gap analysis | AppTweak |
| Historical rank / volume time series | AppTweak |
| Category top keywords | AppTweak |
| ASA bidding intelligence | AppTweak |
| Install attribution tiers (via Keyword Combinations UI) | AppTweak |
| First-party App Store Connect data (downloads, revenue, subscriptions) | Appeeky Connect (separate product, see `appeeky-connect.md`) |

## Store Support

All tools support **both iOS (App Store) and Android (Google Play)**:

| Store | `device` param | `app_id` format | Example |
|---|---|---|---|
| **iOS** (default) | `"iphone"` or `"ipad"` | Numeric Apple ID | `"544007664"` |
| **Android** | `"android_phone"` or `"android_tablet"` | Package name | `"com.spotify.music"` |

**iOS-only tools:** `at_asa_bidding_apps` and `at_asa_bid_history` (Apple Search Ads has no Android equivalent).

All other tools work for both stores — just pass the appropriate `device` and `app_id` format.

## Setup

1. Sign up at [apptweak.com](https://www.apptweak.com) and obtain an API key
2. Install the AppTweak MCP server (see official AppTweak MCP docs for the latest install method)
3. Add the MCP server to your Claude Code configuration:
   ```json
   {
     "mcpServers": {
       "apptweak": {
         "command": "apptweak-mcp",
         "env": { "APPTWEAK_API_KEY": "your-key" }
       }
     }
   }
   ```
4. Verify installation by running `at_check_credits` — should return remaining credits

**Rate limit:** 60 requests per 10-second window (managed by client).

## Tools Reference

All AppTweak MCP tools are prefixed with `at_`. The following tools are referenced by skills in this repo:

### Keyword Tools

| Tool | Returns | Cost | Used By |
|---|---|---|---|
| `at_ranked_keywords` | All keywords an app ranks for (up to 500), with ranking, volume, relevance score | 100-500 credits | aso-audit, keyword-research, competitor-analysis, localization, competitor-tracking |
| `at_aso_keyword_report` | **Composite** — ranked keywords enriched with volume, difficulty, KEI, sorted | ~100 + 5/keyword | keyword-research, aso-audit |
| `at_keyword_opportunities` | **Composite** — keywords competitors rank for that you don't | ~700 credits | keyword-research, competitor-analysis, aso-audit |
| `at_keyword_stats` | Volume + difficulty for specific keywords (max 5 per call) | 5/keyword | keyword-research, metadata-optimization, apple-search-ads |
| `at_keyword_rankings` | Historical rank per keyword per app (30-day window) | 3/keyword/30d | aso-audit (Phase 7.5 cascade check), metadata-optimization |
| `at_keyword_volume_history` | Daily volume history per keyword | 10/30d | seasonal-aso |
| `at_trending_keywords` | Top 50 trending keywords per country | 30 credits | seasonal-aso, keyword-research |
| `at_category_top_keywords` | Top 50 keywords for a category | 20 credits | keyword-research, aso-audit |
| `at_live_search` | Top apps ranking for a term right now | 3 credits | competitor-analysis |

### App Tools

| Tool | Returns | Cost | Used By |
|---|---|---|---|
| `at_app_metadata` | Title, subtitle, description, screenshots, `customers_also_bought` | 1 credit | aso-audit, competitor-analysis, metadata-optimization, localization |
| `at_app_downloads` | Daily download estimates per country | 75 + 25/30d | aso-audit, competitor-analysis, localization |
| `at_app_ratings` | Rating history with breakdown | 2 credits | aso-audit |
| `at_app_reviews` | Filtered user reviews | 5 credits | aso-audit, competitor-analysis |
| `at_metadata_changes` | History of metadata updates (useful for competitor tracking) | 10 credits | competitor-tracking |

### ASA Intelligence Tools

| Tool | Returns | Cost | Used By |
|---|---|---|---|
| `at_asa_bidding_apps` | Which apps are bidding on a given keyword | 30/30d | apple-search-ads, competitor-tracking |
| `at_asa_bid_history` | Historical ASA bidding activity for an app | 100 credits | apple-search-ads, competitor-tracking |

### Utility

| Tool | Returns | Cost |
|---|---|---|
| `at_check_credits` | Remaining API credits | Free — always call first |

**For the complete tool catalogue** (including parameters, full response schemas, and country code support), see the official AppTweak MCP docs. Only tools used by skills in this repo are listed above — this keeps the surface area reviewable.

## Recommended Workflow

```bash
# 1. Always check credits first
at_check_credits

# 2. Get current baseline
at_app_metadata app_id=1450480287 country=us
at_ranked_keywords app_id=1450480287 country=us limit=500

# 3. Enrich with scoring
at_aso_keyword_report app_id=1450480287 country=us

# 4. Find competitor gaps
at_keyword_opportunities app_id=1450480287 country=us max_competitors=10

# 5. For international markets, repeat per country
at_ranked_keywords app_id=1450480287 country=gb limit=500
at_ranked_keywords app_id=1450480287 country=de limit=500
# ... etc
```

**Budget guidance:** A full single-market audit costs ~2,000-3,000 credits. Full 6-market en-GB cascade check costs ~3,500-5,000 credits. Budget accordingly for plans on limited AppTweak subscriptions.

## Cross-Reference with Appeeky

Appeeky remains a supported fallback for keyword/rank data. See `appeeky.md` for Appeeky's endpoints. **Appeeky Connect** (first-party ASC sync for your own app's downloads/revenue/subscriptions) is unchanged — it is a distinct product feature not replaced by AppTweak.

When both AppTweak and Appeeky are available, use AppTweak as primary and Appeeky as a secondary cross-check for suspicious results (divergent rank readings, volume outliers, etc.).

## Related Documents

- `scripts/snippets/compatibility-contract.md` — the Data Source Compatibility block used in every skill
- `skills/localization/references/cross-locale-map.md` — corrected cross-locale map (en-GB as universal secondary)
- `skills/aso-audit/references/1998-cam-lessons.md` — production lessons including the en-GB Global Cascade Check procedure
