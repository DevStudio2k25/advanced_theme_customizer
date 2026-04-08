# Public API Contract

## API Design Goals
1. Host integration should be simple.
2. Core behavior must remain protected.
3. Extension hooks should allow skin and scope config without functional mutation.

## Primary Public Types
1. AdvancedCustomizerController
2. AdvancedCustomizerConfig
3. AdvancedCustomizerPanel
4. AdvancedCustomizerScope
5. AdvancedCustomizerProfile
6. AdvancedCustomizerImportResult
7. AdvancedCustomizerExportResult

## Core Public Methods
1. openGlobalCustomizer()
2. openCustomizerForPage(pageId)
3. startDraftSession(scope)
4. applyDraft()
5. discardDraft()
6. undoLastApply()
7. exportProfileJson()
8. importProfileJson(json, mode)
9. setDefaultProfileJson(json)
10. lockTargets(targetIds)
11. unlockTargets(targetIds)

## Scope and Selection API
1. setActivePage(pageId)
2. setSelectedComponents(componentIds)
3. setSelectedStates(states)
4. setSelectedProperties(properties)

## Style Editing API
1. setFill(color)
2. setBorder(color)
3. setText(color)
4. setIcon(color)
5. setRadius(value)
6. setBorderWidth(value)
7. copyStyleFrom(componentId)
8. pasteStyleTo(componentIds)

## Panel Skin API
1. setPanelSkin(skinConfig)
2. setPanelStrings(localizedStrings)
3. setPanelSectionVisibility(visibilityConfig)

## Protected Behavior Rules
Host app must not override:
1. Resolver precedence order.
2. Draft transaction semantics.
3. Validation and migration guards.
4. Import and export data integrity checks.

## Error Handling Contract
1. Invalid import returns structured error with non-destructive fallback.
2. Unknown component ids are reported but ignored safely.
3. Invalid property values are dropped with warning details.

## Versioning Contract
1. Breaking API changes require major version bump.
2. Schema changes require migration path before release.
