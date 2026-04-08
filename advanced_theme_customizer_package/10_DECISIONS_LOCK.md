# Decisions Lock

Date: 2026-04-08
Status: Locked unless explicitly revised

## Product Scope Decisions
1. Package-first development.
2. Advanced customization as core package purpose.
3. Visual customization only, no business logic mutation.

## Capability Decisions
1. Component-level styling control is mandatory.
2. Color channels must include fill, border, text, and icon.
3. Shape controls must include corner radius and border width.
4. State-wise control must be supported.

## Panel Decisions
1. Customization panel is provided by package itself.
2. Developer can theme-match panel visuals.
3. Developer cannot change protected panel core behavior.

## Integration Decisions
1. Settings integration mode supported.
2. Per-page customize entry mode supported.
3. Both modes must support live preview.

## Data Decisions
1. System is JSON-driven.
2. Full JSON export must be supported.
3. Developer can import JSON and ship as default theme profile.
4. Schema versioning and migration are mandatory.

## Editing Decisions
1. Draft-first edit flow.
2. Apply, cancel or discard, and undo support mandatory.
3. Group apply and style copy or paste support mandatory.
