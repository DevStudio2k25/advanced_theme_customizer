# Host Integration Flow

## Goal
Provide a consistent integration blueprint for developers using this package in any app.

## Step-by-Step Integration
1. Add package dependency in host app.
2. Initialize AdvancedCustomizerConfig with registry and defaults.
3. Register pages and component targets.
4. Load optional default JSON profile.
5. Add settings launcher for global customizer mode.
6. Add optional per-page customize button launchers.
7. Wire preview bridge for live updates.
8. Persist committed profiles.

## Mode A: Settings Integration
1. Add settings tile or menu action.
2. Call openGlobalCustomizer().
3. Allow full page and component browsing.

## Mode B: Page Integration
1. Add customize button on a page.
2. Call openCustomizerForPage(pageId).
3. Lock panel to page scope for focused editing.

## Runtime Safety
1. Keep functional UI actions independent from style editor.
2. Use lockTargets for non-editable business-critical visuals.
3. Use validation result logs to monitor malformed imports.

## Data Operations
1. Export profile JSON for user backup and sharing.
2. Import profile JSON with replace or merge strategy.
3. Set approved profile JSON as app default when needed.

## Deployment Notes
1. Test with empty registry fallback.
2. Test with partial profile imports.
3. Test performance under rapid style updates.
4. Verify no page-scope leakage across unrelated screens.
