# Changelog

## 0.1.1 — 2026-11-02

- Enforce string/collection limits on evaluated intermediate values before parent expressions consume them.
- Check concatenation size before allocation and input string size during conversion.
- Add regressions for len consuming oversized strings, nested concatenation, template entry, join, input limits, exact boundaries and UTF-16 lengths.


## 0.1.0 — 2026-10-30

- Initial portable JSON-e interpreter: 16 operators, 20 builtins, expression parsing and template scopes.
- Strict JSON types, deterministic clock injection, resource budgets and structured batch errors.
- All 1,175 pinned upstream specification cases, explicit security/limit checks and three end-to-end workflows.
- MPL-2.0 reference attribution and Chinese installation/API/compatibility documentation.
