# Architecture and Scope Model

## High-Level Modules
1. Registry Module
   Defines all pages, components, groups, and supported properties or states.
2. Resolver Module
   Merges base theme and scoped overrides deterministically.
3. Profile Store Module
   Persists committed profiles and migration metadata.
4. Draft Session Module
   Manages live editable state before apply.
5. Panel UI Module
   Provides built-in editor, batch operations, and preview controls.
6. Preview Module
   Supports embedded preview and in-page live preview.

## Override Hierarchy and Priority
Final style value resolution order:
1. Base default theme
2. Imported default profile
3. Global override
4. Page override
5. Component-group override
6. Component-type override
7. State-specific override

Higher level near the end has higher priority.

## Target Identity Contract
Each stylable target is identified by:
1. pageId
2. componentTypeId
3. optional componentGroupId
4. optional instanceId for future expansion

Recommended naming examples:
1. login.button.primary
2. login.input.email
3. details.episodeGrid.cell
4. home.banner.continueWatching

## Style Property Contract
Each stylable target may expose:
1. fill
2. border
3. text
4. icon
5. radius
6. borderWidth

Each property can be defined per state:
1. default
2. hover
3. focused
4. active
5. disabled
6. selected
7. error

## Deterministic Merge Rule
Resolver must return one final value per property and state:
1. closest scoped override if present
2. otherwise nearest parent scope value
3. otherwise default profile value
4. otherwise base theme fallback

## Safe Fallback Rules
1. Missing key: fallback to parent or base.
2. Invalid value type: ignore and warn.
3. Unknown scope id: ignore and warn.
4. Unknown property: ignore and warn.

## Extensibility Plan
1. Add typography and spacing only after color and shape system is stable.
2. Keep schema versioning strict to avoid migration breaks.
