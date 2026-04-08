# Advanced Theme Customizer

A Flutter package for advanced, scope-aware UI customization with safe editing semantics.

It provides a built-in customizer panel, deterministic style resolution, draft/apply/discard/undo workflow, JSON import and export, migration support, and host integration helpers for both global settings mode and per-page mode.

## Key capabilities

- Global, page, group, and component-type scope targeting
- Style channels: fill, border, text, icon, radius, borderWidth
- State-aware values: default, hover, focused, active, disabled, selected, error
- Draft-first editing with apply, discard, and bounded undo history
- JSON profile import and export with replace, merge, and defaults modes
- Schema migration (v1 -> v2) and runtime diagnostics
- Built-in panel with skinnable visual hooks and protected core behavior
- Live preview bridge for in-panel and in-page preview workflows

## Installation

Add the package to your app:

```yaml
dependencies:
	advanced_theme_customizer: ^0.1.1
```

## Quick start

### 1) Define a registry

```dart
const AdvancedComponentRegistry registry = AdvancedComponentRegistry(
	pages: <AdvancedPageDescriptor>[
		AdvancedPageDescriptor(pageId: 'home', displayName: 'Home'),
	],
	groups: <AdvancedComponentGroupDescriptor>[
		AdvancedComponentGroupDescriptor(
			groupId: 'home.actions',
			pageId: 'home',
			displayName: 'Home Actions',
		),
	],
	components: <AdvancedComponentDescriptor>[
		AdvancedComponentDescriptor(
			componentId: 'home.button.primary',
			pageId: 'home',
			groupId: 'home.actions',
			componentTypeId: 'button.primary',
			displayName: 'Home Primary Button',
		),
	],
);
```

### 2) Create a controller

```dart
final AdvancedCustomizerController controller = AdvancedCustomizerController(
	config: AdvancedCustomizerConfig(registry: registry),
);
```

### 3) Wrap your app for preview-aware widgets

```dart
AdvancedCustomizerPreviewBridge(
	controller: controller,
	child: MaterialApp(home: HomePage(controller: controller)),
)
```

### 4) Launch the built-in panel

```dart
// Global settings mode
await openSettingsModeCustomizer<void>(
	context: context,
	controller: controller,
);

// Per-page mode
await openPageModeCustomizer<void>(
  context: context,
  controller: controller,
  pageId: 'home',
);

// Adaptive mode (bottom sheet on mobile, dialog on desktop/tablet)
await openAdaptiveSettingsModeCustomizer<void>(
  context: context,
  controller: controller,
);

await openAdaptivePageModeCustomizer<void>(
  context: context,
  controller: controller,
  pageId: 'home',
);
```

## Editing semantics

The package enforces a draft-first safety model:

1. Start a draft session.
2. Apply style edits (preview updates immediately).
3. Commit with apply, or revert with discard.
4. Undo restores the previous committed snapshot.

Committed state is protected from accidental mutation while draft edits are in progress.

## JSON operations

Use controller APIs for profile portability:

```dart
final AdvancedCustomizerExportResult export = controller.exportProfileJson();

final AdvancedCustomizerImportResult replaceResult = controller.importProfileJson(
	jsonString,
	AdvancedCustomizerImportMode.replace,
);

final AdvancedCustomizerImportResult mergeResult = controller.importProfileJson(
	jsonString,
	AdvancedCustomizerImportMode.merge,
);

final AdvancedCustomizerImportResult defaultsResult = controller.importProfileJson(
	jsonString,
	AdvancedCustomizerImportMode.defaults,
);
```

Invalid payloads fail safely with diagnostics and non-destructive fallback behavior.

## Panel customization hooks

You can theme panel visuals without changing locked behavior:

```dart
controller.setPanelSkin(
	const AdvancedCustomizerPanelSkin(
		cornerRadius: 16,
		elevation: 4,
	),
);

controller.setPanelStrings(
	const AdvancedCustomizerPanelStrings(title: 'Customize UI'),
);

controller.setPanelSectionVisibility(
	const AdvancedCustomizerSectionVisibility(
		showScopeSection: true,
		showComponentsSection: true,
		showPropertiesSection: true,
		showActionsSection: true,
	),
);
```

## Example and tests

- A complete host integration sample is available in `example/lib/main.dart`.
- Run the demo app:

```bash
cd example
flutter pub get
flutter run
```

- Unit and widget tests are in `test/`.

Run tests:

```bash
flutter test
```

## License and contribution policy

- This project is source-available and not open-source.
- You can use and modify it for internal use.
- You can contribute changes through the official upstream repository.
- You cannot redistribute or republish this package (or modified copies) without explicit written permission.

Important version note:

- Version 0.1.0 was already released under MIT.
- From version 0.1.1 onward, this repository uses the restricted source-available license in [LICENSE](LICENSE).
