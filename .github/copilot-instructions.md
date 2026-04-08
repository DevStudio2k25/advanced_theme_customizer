# Copilot Instructions for Advanced Theme Customizer

Mandatory workflow rule for any implementation change:

1. Read all 13 planning files in `advanced_theme_customizer_package/` before implementing or modifying code.
2. Implement behavior to match the locked decisions and contracts documented in those files.
3. If a requirement conflicts with existing code, follow the docs and update code/tests accordingly.
4. Do not ship behavior that bypasses draft/apply/discard/undo safety semantics.
5. Preserve resolver precedence, JSON validation, migration safety, and integration mode guarantees.

Planning files that must be read each time before implementation:
- `00_README.md`
- `01_PRODUCT_VISION.md`
- `02_REQUIREMENTS_FUNCTIONAL.md`
- `03_ARCHITECTURE_AND_SCOPE_MODEL.md`
- `04_JSON_CONTRACT.md`
- `05_PANEL_AND_INTEGRATION_MODES.md`
- `06_LIVE_PREVIEW_AND_DRAFT_FLOW.md`
- `07_ROADMAP_AND_MILESTONES.md`
- `08_RISKS_GUARDRAILS_AND_ACCEPTANCE.md`
- `09_IMPLEMENTATION_CHECKLIST.md`
- `10_DECISIONS_LOCK.md`
- `11_PACKAGE_STRUCTURE.md`
- `12_PUBLIC_API_CONTRACT.md`
- `13_HOST_INTEGRATION_FLOW.md`
