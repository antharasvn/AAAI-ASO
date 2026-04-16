# Apple Cross-Locale Indexing Map

**This is the authoritative cross-locale reference for all ASO skills in this repo.** Skills link here instead of duplicating the map in prose.

Canonical source: https://developer.apple.com/help/app-store-connect/reference/app-information/app-store-localizations

---

## The Two Critical Facts

1. **en-GB is the universal secondary locale for 130+ countries** — NOT en-US. Every non-US English-speaking market, plus every non-English market that uses English as a fallback (DE, FR, IT, ES, BR, NL, SE, PL, TR, and 120+ more) indexes en-GB as their English secondary.

2. **US indexes 10 locales total** — en-US + 9 secondaries (es-MX, fr-FR, zh-Hans, zh-Hant, ko, pt-BR, ru, ar-SA, vi) = **1,000 keyword chars** (100 per locale) + 600 title/subtitle chars = **1,600 indexable chars for US search**.

## The Japan Exception

**Japan is the only market that uses en-US (not en-GB) as its English secondary.** A Japanese user sees `ja` + `en-US`. Every other non-US market sees the native locale + `en-GB`.

**Implication:** If you optimize `ja` metadata, the US keyword field cascades into Japanese search. Do NOT duplicate English keywords between `ja` and `en-US` unnecessarily; plan them as a unit.

## Cross-Localization Map

| Storefront | Primary Locale | Indexed Secondaries | Total KW Chars |
|---|---|---|---|
| **US** | en-US | es-MX, fr-FR, zh-Hans, zh-Hant, ko, pt-BR, ru, ar-SA, vi | 1,000 |
| **UK** | en-GB | — | 100 |
| **Japan** | ja | **en-US** (exception) | 200 |
| **Germany** | de-DE | en-GB | 200 |
| **France** | fr-FR | en-GB | 200 |
| **Italy** | it | en-GB | 200 |
| **Spain** | es-ES | ca, en-GB | 300 |
| **Brazil** | pt-BR | en-GB | 200 |
| **Mexico** | es-MX | en-GB | 200 |
| **Korea** | ko | en-GB | 200 |
| **China** | zh-Hans | en-GB | 200 |
| **Taiwan** | zh-Hant | en-GB | 200 |
| **Hong Kong** | zh-Hant | en-GB | 200 |
| **Netherlands** | nl-NL | en-GB | 200 |
| **Sweden** | sv | en-GB | 200 |
| **Canada** | en-CA | fr-CA | 200 |
| **Australia** | en-AU | en-GB | 200 |
| **India** | en-GB | hi + 9 regional (ta, te, mr, bn, gu, kn, ml, pa, ur) | 1,200 |
| **Switzerland** | de-DE, fr-FR, it | en-GB | 400 |
| **Belgium** | nl-NL, fr-FR | en-GB | 300 |
| **130+ other countries** | native | en-GB | varies |

## 4-Category Locale Architecture

When planning a multi-locale metadata push, classify every locale into one of four buckets:

| Category | Count (typical) | Locales | Strategy |
|---|---|---|---|
| **US-indexed** | 11 | en-US + es-MX, fr-FR, zh-Hans, zh-Hant, ko, pt-BR, ru, ar-SA, vi (+ en-GB mirror) | English keywords maximizing US search compounds. No word duplication across these 11. |
| **Global English** | 1 | en-GB | Mirror en-US exactly — 130+ countries cascade from this. |
| **Non-US English** | 2 | en-CA (mirrors en-US), en-AU (expansion bucket for relocated words) | Use to carry extra words that conflict with en-US but preserve US indexing. |
| **Home market** | 15+ | de-DE, ja, it, es-ES, pt-PT, nl-NL, sv, pl, tr, id, ms, th, hi, he, uk + new locales (ca, cs, da, el, fi, hr, hu, no, ro, sk) | Native-language keywords. en-GB secondary provides English coverage. |

## Cross-Localization Rules

1. **en-GB = en-US always** — mirror title, subtitle, and keywords exactly. No exceptions.
2. **No word duplication within a single storefront's indexed locales** — e.g., within the US 10-locale unit.
3. **Different storefronts can overlap freely** — fr-FR and fr-CA vocabulary overlap is fine (different storefronts).
4. **en-US gets the highest-value keywords regardless of duplication** — global reach via en-GB cascade outweighs marginal char waste.
5. **Japan plan must account for en-US as secondary** — ja sees en-US, not en-GB.
6. **Minimize re-indexing turbulence** — stagger locale rewrites; don't rewrite 14+ locales simultaneously. Apple's search index takes 2-4 weeks to stabilize.
7. **Brand name stays in Latin script** — never transliterate into Cyrillic, Arabic, CJK, etc. Only the descriptive portion of the title is translated.
8. **Same title across all English locales** (en-US, en-GB, en-CA, en-AU) — brand consistency + en-GB cascade.

## Why This Map Matters

Getting the cross-locale map wrong can cost ~25% of global organic traffic in 72 hours. The 1998 Cam team experienced exactly this in April 2026 when they removed a subtitle word from en-GB without running a cascade check (see `../../aso-audit/references/1998-cam-lessons.md`). The fix took a new App Store submission cycle.

**Any en-US/en-GB change requires the en-GB Global Cascade Check** — the 6-market verification documented in `../../aso-audit/references/1998-cam-lessons.md#the-en-gb-global-cascade-check`.
