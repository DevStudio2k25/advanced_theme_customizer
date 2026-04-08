# Risks, Guardrails, and Acceptance

## Key Risks
1. Scope leakage: style intended for one page affects another.
2. Migration break: old profile cannot load into new schema.
3. Resolver ambiguity: conflicting rules produce unstable output.
4. Performance jank during frequent color updates.
5. Invalid JSON causing crashes.

## Guardrails
1. Strict deterministic precedence with tests.
2. Schema version gates and migration fallback.
3. Unknown keys ignored with warning logs.
4. Draft-first transaction model to protect committed state.
5. Bounded undo stack and safe reset operations.
6. Contrast warning system for risky combinations.

## Acceptance Criteria
AC-001: Component-level edits are isolated as configured.
AC-002: Global and scoped precedence works consistently.
AC-003: Draft preview updates instantly and safely.
AC-004: Apply persists, cancel discards, undo restores.
AC-005: Exported JSON re-imports without loss.
AC-006: Imported JSON can be used as app default profile.
AC-007: Panel works in settings mode and per-page mode.
AC-008: Host app can skin panel visuals but cannot break core behavior.
AC-009: Invalid JSON does not crash app.
AC-010: Performance remains acceptable during live editing.

## Test Matrix
1. Platforms: Android, iOS, desktop, web if enabled.
2. Themes: light and dark.
3. Modes: settings panel and per-page panel.
4. Data: valid JSON, partial JSON, malformed JSON, old schema JSON.
