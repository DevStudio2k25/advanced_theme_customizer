# Advanced Theme Customizer Package Plan

Last updated: 2026-04-08
Status: Planning baseline created

## Objective
Create a reusable package that gives very advanced app customization with strict safety:
- page-wise and component-wise style control
- live preview while editing
- draft, apply, cancel, undo workflow
- JSON-first import/export model
- developer can theme panel look, but cannot break panel functionality

## Locked Decisions From Discussion
1. Scope target: all pages supported by package model.
2. Granularity target: page plus component-type control in v1 foundation.
3. Preview modes: both embedded preview panel and in-page edit mode.
4. Apply flow: draft, apply, cancel, undo.
5. Group operations: fill, border, text or icon, state-wise apply, copy style and paste style.
6. Integration modes: full settings panel mode and per-page customize button mode.

## Document Reading Order
1. 01_PRODUCT_VISION.md
2. 02_REQUIREMENTS_FUNCTIONAL.md
3. 03_ARCHITECTURE_AND_SCOPE_MODEL.md
4. 04_JSON_CONTRACT.md
5. 05_PANEL_AND_INTEGRATION_MODES.md
6. 06_LIVE_PREVIEW_AND_DRAFT_FLOW.md
7. 07_ROADMAP_AND_MILESTONES.md
8. 08_RISKS_GUARDRAILS_AND_ACCEPTANCE.md
9. 09_IMPLEMENTATION_CHECKLIST.md
10. 10_DECISIONS_LOCK.md
11. 11_PACKAGE_STRUCTURE.md
12. 12_PUBLIC_API_CONTRACT.md
13. 13_HOST_INTEGRATION_FLOW.md

## Planning Output Expected
After these docs, team should be able to:
1. scaffold package modules without requirement ambiguity
2. implement deterministic resolver and schema migration safely
3. integrate package into any Flutter app with minimal app-level changes
4. validate behavior using clear acceptance checks
