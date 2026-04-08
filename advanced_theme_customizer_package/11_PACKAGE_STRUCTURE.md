# Package Structure Blueprint

## Purpose
Define a clean, reusable folder architecture for the advanced customizer package so implementation stays modular and portable across apps.

## Recommended Package Layout
1. lib
2. lib/src
3. lib/src/core
4. lib/src/core/models
5. lib/src/core/resolver
6. lib/src/core/registry
7. lib/src/core/persistence
8. lib/src/core/migration
9. lib/src/core/validation
10. lib/src/core/draft
11. lib/src/panel
12. lib/src/panel/widgets
13. lib/src/panel/controllers
14. lib/src/preview
15. lib/src/integration
16. lib/src/integration/settings_mode
17. lib/src/integration/page_mode
18. lib/src/theme_hooks
19. test
20. test/unit
21. test/widget
22. test/integration
23. example
24. example/lib

## Suggested File Responsibilities
1. lib/advanced_theme_customizer.dart
   Public exports only.
2. lib/src/core/models/style_models.dart
   Scope, target, property, state models.
3. lib/src/core/resolver/style_resolver.dart
   Deterministic style resolution engine.
4. lib/src/core/registry/component_registry.dart
   Component metadata and editable capabilities.
5. lib/src/core/persistence/profile_store.dart
   Save and load committed profiles.
6. lib/src/core/migration/schema_migrator.dart
   v1 to v2 migration logic.
7. lib/src/core/validation/profile_validator.dart
   JSON and rule integrity validation.
8. lib/src/core/draft/draft_session_manager.dart
   Draft lifecycle, apply, discard, undo support.
9. lib/src/panel/customizer_panel.dart
   Built-in panel entry widget.
10. lib/src/panel/controllers/customizer_panel_controller.dart
   Panel interactions and scoped editing state.
11. lib/src/preview/preview_bridge.dart
   Embedded and in-page preview bindings.
12. lib/src/integration/settings_mode/settings_customizer_launcher.dart
   Settings-mode integration helpers.
13. lib/src/integration/page_mode/page_customizer_launcher.dart
   Per-page mode integration helpers.
14. lib/src/theme_hooks/panel_skin_hooks.dart
   Approved skin customizations for host apps.

## Packaging Notes
1. Keep source internals under lib/src and expose stable API from root library.
2. Provide example host app with settings and per-page launch flows.
3. Keep migration and validation heavily unit-tested.
