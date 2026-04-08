# Panel and Integration Modes

## Panel Ownership Model
1. Package provides full customization panel UI and behavior.
2. Core panel functionality is locked and cannot be altered by host app.
3. Host app can skin panel visuals only through approved theming hooks.

## What Developer Can Customize
1. Panel surface and typography style tokens.
2. Header branding and app-specific labels.
3. Which pages are exposed to end users.
4. Which components or properties are editable or locked.
5. Launch points for opening panel.

## What Developer Cannot Customize
1. Resolver merge algorithm behavior.
2. Draft, apply, cancel, undo core transaction rules.
3. Import and export data integrity checks.
4. Security validation on profile payload.

## Integration Mode A: Settings Mode
Use case:
1. Full app-level customization center.
Flow:
1. Open panel from app settings.
2. User selects page and component from panel.
3. User edits and previews in panel.
4. Apply commits changes.

## Integration Mode B: Per-Page Mode
Use case:
1. Contextual editing on current page only.
Flow:
1. Developer shows customize button on page.
2. Panel opens pre-scoped to that page.
3. User edits only relevant components.
4. User previews instantly and applies.

## Required Host APIs
1. openCustomizerGlobal()
2. openCustomizerForPage(pageId)
3. lockTargets(targetIds)
4. setPanelSkin(skinConfig)
5. importDefaultProfile(json)

## UX Guardrails
1. Show unsaved changes indicator in panel.
2. Prevent accidental close without discard or apply decision.
3. Provide reset actions at multiple levels.
