# Compatibility Contract Snippet

This file is the single source of truth for the Data Source Compatibility block that appears in every updated ASO skill. Inline this verbatim near the top of each skill body.

---

## Data Source Compatibility

This skill is designed to work in four environments. Always check which tools are available, then follow the listed order:

| Environment | Primary | Fallback | Behavior |
|---|---|---|---|
| **AppTweak + Appeeky both available** | AppTweak MCP (`at_` tools) | Appeeky (cross-check) | Use AppTweak for all keyword/rank data. Appeeky is a secondary cross-check for suspicious results. |
| **AppTweak only** | AppTweak MCP | — | Use AppTweak for everything. This is the recommended setup. |
| **Appeeky only** | Appeeky API/MCP | — | Proceed with Appeeky endpoints. All guidance still applies — substitute `at_ranked_keywords` → Appeeky keyword endpoint, etc. |
| **Neither installed** | Ask user to paste data | — | Ask the user to paste current metadata, ranked keyword list, and competitor data. Proceed with manual analysis. |

See `tools/integrations/apptweak.md` for AppTweak setup. See `tools/integrations/appeeky.md` for Appeeky setup. Appeeky Connect (first-party ASC sync) is unchanged — see `tools/integrations/appeeky-connect.md`.
