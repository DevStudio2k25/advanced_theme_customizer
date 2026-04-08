import 'dart:convert';

import 'package:advanced_theme_customizer/advanced_theme_customizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('draft apply and export produces schema payload', () {
    final AdvancedCustomizerController controller =
        AdvancedCustomizerController();

    controller.setSelectedComponents(<String>{'login.button.primary'});
    controller.startDraftSession(AdvancedCustomizerScope.global);
    controller.setFill(const Color(0xFF1A73E8));

    expect(controller.hasDraftSession, isTrue);
    expect(controller.applyDraft(), isTrue);

    final AdvancedCustomizerExportResult export = controller
        .exportProfileJson();
    expect(export.success, isTrue);
    expect(export.json, isNotNull);

    final Map<String, dynamic> payload =
        jsonDecode(export.json!) as Map<String, dynamic>;
    expect(payload['schemaVersion'], 2);
    expect(payload['rules'], isA<List<dynamic>>());
  });

  test('import replace loads profile and resolves style property', () {
    const String json = '''
{
  "schemaVersion": 2,
  "profile": {
    "id": "custom_001",
    "name": "My Profile",
    "updatedAt": "2026-04-08T12:00:00Z"
  },
  "base": {
    "presetId": "classic"
  },
  "rules": [
    {
      "scope": "global",
      "target": "global",
      "priority": 100,
      "styles": {
        "login.button.primary": {
          "default": {
            "fill": "#FF112233"
          }
        }
      }
    }
  ]
}
''';

    final AdvancedCustomizerController controller =
        AdvancedCustomizerController();

    final AdvancedCustomizerImportResult result = controller.importProfileJson(
      json,
      AdvancedCustomizerImportMode.replace,
    );

    expect(result.success, isTrue);
    expect(controller.committedProfile.id, 'custom_001');

    final Color? resolved =
        controller.resolveProperty(
              'login.button.primary',
              AdvancedCustomizerProperty.fill,
              AdvancedCustomizerState.defaultState,
            )
            as Color?;

    expect(resolved, isNotNull);
    expect(resolved!.value, 0xFF112233);
  });

  test('undo restores previous committed snapshot', () {
    final AdvancedCustomizerController controller =
        AdvancedCustomizerController();
    controller.setSelectedComponents(<String>{'login.button.primary'});

    controller.startDraftSession(AdvancedCustomizerScope.global);
    controller.setFill(const Color(0xFFFF0000));
    controller.applyDraft();

    controller.startDraftSession(AdvancedCustomizerScope.global);
    controller.setFill(const Color(0xFF00FF00));
    controller.applyDraft();

    final Color latest =
        controller.resolveProperty(
              'login.button.primary',
              AdvancedCustomizerProperty.fill,
              AdvancedCustomizerState.defaultState,
            )
            as Color;
    expect(latest.value, 0xFF00FF00);

    expect(controller.undoLastApply(), isTrue);

    final Color restored =
        controller.resolveProperty(
              'login.button.primary',
              AdvancedCustomizerProperty.fill,
              AdvancedCustomizerState.defaultState,
            )
            as Color;
    expect(restored.value, 0xFFFF0000);
  });

  test('page scope takes precedence over global scope', () {
    const String json = '''
{
  "schemaVersion": 2,
  "profile": {
    "id": "scope_profile",
    "name": "Scope Profile",
    "updatedAt": "2026-04-08T12:00:00Z"
  },
  "rules": [
    {
      "scope": "global",
      "target": "global",
      "priority": 100,
      "styles": {
        "login.button.primary": {
          "default": {
            "fill": "#FF0000FF"
          }
        }
      }
    },
    {
      "scope": "page",
      "target": "login",
      "priority": 200,
      "styles": {
        "login.button.primary": {
          "default": {
            "fill": "#FFFF0000"
          }
        }
      }
    }
  ]
}
''';

    final AdvancedCustomizerController controller =
        AdvancedCustomizerController();
    final AdvancedCustomizerImportResult result = controller.importProfileJson(
      json,
      AdvancedCustomizerImportMode.replace,
    );
    expect(result.success, isTrue);

    controller.openCustomizerForPage('login');
    final Color pageScoped =
        controller.resolveProperty(
              'login.button.primary',
              AdvancedCustomizerProperty.fill,
              AdvancedCustomizerState.defaultState,
            )
            as Color;
    expect(pageScoped.value, 0xFFFF0000);

    controller.openGlobalCustomizer();
    final Color globalScoped =
        controller.resolveProperty(
              'login.button.primary',
              AdvancedCustomizerProperty.fill,
              AdvancedCustomizerState.defaultState,
            )
            as Color;
    expect(globalScoped.value, 0xFF0000FF);
  });

  test('requested state falls back to default state property', () {
    const String json = '''
{
  "schemaVersion": 2,
  "profile": {
    "id": "state_fallback",
    "name": "State Fallback",
    "updatedAt": "2026-04-08T12:00:00Z"
  },
  "rules": [
    {
      "scope": "global",
      "target": "global",
      "priority": 100,
      "styles": {
        "login.button.primary": {
          "default": {
            "fill": "#FF123456"
          },
          "disabled": {
            "text": "#FFFFFFFF"
          }
        }
      }
    }
  ]
}
''';

    final AdvancedCustomizerController controller =
        AdvancedCustomizerController();
    final AdvancedCustomizerImportResult result = controller.importProfileJson(
      json,
      AdvancedCustomizerImportMode.replace,
    );
    expect(result.success, isTrue);

    final Color disabledFill =
        controller.resolveProperty(
              'login.button.primary',
              AdvancedCustomizerProperty.fill,
              AdvancedCustomizerState.disabled,
            )
            as Color;
    expect(disabledFill.value, 0xFF123456);
  });

  test('defaults import sets baseline but does not overwrite committed', () {
    const String defaultsJson = '''
{
  "schemaVersion": 2,
  "profile": {
    "id": "defaults_001",
    "name": "Defaults",
    "updatedAt": "2026-04-08T12:00:00Z"
  },
  "rules": [
    {
      "scope": "global",
      "target": "global",
      "priority": 100,
      "styles": {
        "home.banner.primary": {
          "default": {
            "fill": "#FF101010"
          }
        }
      }
    }
  ]
}
''';

    final AdvancedCustomizerController controller =
        AdvancedCustomizerController();
    expect(controller.committedProfile.rules, isEmpty);

    final AdvancedCustomizerImportResult defaultsResult = controller
        .importProfileJson(defaultsJson, AdvancedCustomizerImportMode.defaults);
    expect(defaultsResult.success, isTrue);
    expect(controller.committedProfile.rules, isEmpty);

    final Color baselineFill =
        controller.resolveProperty(
              'home.banner.primary',
              AdvancedCustomizerProperty.fill,
              AdvancedCustomizerState.defaultState,
            )
            as Color;
    expect(baselineFill.value, 0xFF101010);

    controller.setSelectedComponents(<String>{'home.banner.primary'});
    controller.startDraftSession(AdvancedCustomizerScope.global);
    controller.setFill(const Color(0xFFABABAB));
    controller.applyDraft();

    final Color overriddenFill =
        controller.resolveProperty(
              'home.banner.primary',
              AdvancedCustomizerProperty.fill,
              AdvancedCustomizerState.defaultState,
            )
            as Color;
    expect(overriddenFill.value, 0xFFABABAB);
  });

  test('import merge deep-merges style values without dropping siblings', () {
    const String baseJson = '''
{
  "schemaVersion": 2,
  "profile": {
    "id": "merge_base",
    "name": "Merge Base",
    "updatedAt": "2026-04-08T12:00:00Z"
  },
  "rules": [
    {
      "scope": "global",
      "target": "global",
      "priority": 100,
      "styles": {
        "login.button.primary": {
          "default": {
            "fill": "#FF111111",
            "border": "#FF222222"
          }
        }
      }
    }
  ]
}
''';

    const String mergeJson = '''
{
  "schemaVersion": 2,
  "profile": {
    "id": "merge_incoming",
    "name": "Merge Incoming",
    "updatedAt": "2026-04-08T12:01:00Z"
  },
  "rules": [
    {
      "scope": "global",
      "target": "global",
      "priority": 100,
      "styles": {
        "login.button.primary": {
          "default": {
            "fill": "#FF999999"
          }
        }
      }
    }
  ]
}
''';

    final AdvancedCustomizerController controller =
        AdvancedCustomizerController();
    expect(
      controller
          .importProfileJson(baseJson, AdvancedCustomizerImportMode.replace)
          .success,
      isTrue,
    );

    final AdvancedCustomizerImportResult mergeResult = controller
        .importProfileJson(mergeJson, AdvancedCustomizerImportMode.merge);

    expect(mergeResult.success, isTrue);

    final Color fill =
        controller.resolveProperty(
              'login.button.primary',
              AdvancedCustomizerProperty.fill,
              AdvancedCustomizerState.defaultState,
            )
            as Color;
    final Color border =
        controller.resolveProperty(
              'login.button.primary',
              AdvancedCustomizerProperty.border,
              AdvancedCustomizerState.defaultState,
            )
            as Color;

    expect(fill.value, 0xFF999999);
    expect(border.value, 0xFF222222);
  });

  test('schema v1 profile migrates safely to v2 on import', () {
    const String v1Json = '''
{
  "schemaVersion": 1,
  "profileId": "legacy_profile",
  "profileName": "Legacy Profile",
  "presetId": "classic",
  "tokens": {
    "login.button.primary": {
      "fill": "#FF010203",
      "text": "#FFFFFFFF"
    }
  }
}
''';

    final AdvancedCustomizerController controller =
        AdvancedCustomizerController();

    final AdvancedCustomizerImportResult result = controller.importProfileJson(
      v1Json,
      AdvancedCustomizerImportMode.replace,
    );

    expect(result.success, isTrue);
    expect(controller.committedProfile.schemaVersion, 2);
    expect(
      result.warnings.any(
        (String warning) =>
            warning.contains('Migrated schema v1 profile to schema v2'),
      ),
      isTrue,
    );

    final Color fill =
        controller.resolveProperty(
              'login.button.primary',
              AdvancedCustomizerProperty.fill,
              AdvancedCustomizerState.defaultState,
            )
            as Color;
    final Color textColor =
        controller.resolveProperty(
              'login.button.primary',
              AdvancedCustomizerProperty.text,
              AdvancedCustomizerState.defaultState,
            )
            as Color;

    expect(fill.value, 0xFF010203);
    expect(textColor.value, 0xFFFFFFFF);
  });

  test('apply can persist to configured profile store', () async {
    final InMemoryAdvancedCustomizerProfileStore store =
        InMemoryAdvancedCustomizerProfileStore();

    final AdvancedCustomizerController controller =
        AdvancedCustomizerController(
          config: AdvancedCustomizerConfig(profileStore: store),
        );

    controller.setSelectedComponents(<String>{'login.button.primary'});
    controller.startDraftSession(AdvancedCustomizerScope.global);
    controller.setFill(const Color(0xFF123123));
    expect(controller.applyDraft(), isTrue);

    await controller.persistCommittedProfile();
    final String? stored = await store.readCommittedProfileJson();
    expect(stored, isNotNull);
    expect(stored, contains('login.button.primary'));
  });

  test('controller can hydrate committed profile from store', () async {
    final InMemoryAdvancedCustomizerProfileStore store =
        InMemoryAdvancedCustomizerProfileStore();

    final AdvancedCustomizerController writer = AdvancedCustomizerController(
      config: AdvancedCustomizerConfig(profileStore: store),
    );
    writer.setSelectedComponents(<String>{'login.button.primary'});
    writer.startDraftSession(AdvancedCustomizerScope.global);
    writer.setFill(const Color(0xFF334455));
    writer.applyDraft();
    await writer.persistCommittedProfile();

    final AdvancedCustomizerController reader = AdvancedCustomizerController(
      config: AdvancedCustomizerConfig(profileStore: store),
    );
    await reader.hydrateFromStore();

    final Color? hydrated =
        reader.resolveProperty(
              'login.button.primary',
              AdvancedCustomizerProperty.fill,
              AdvancedCustomizerState.defaultState,
            )
            as Color?;

    expect(hydrated, isNotNull);
    expect(hydrated!.value, 0xFF334455);
  });

  test('reset component removes scoped style safely', () {
    final AdvancedCustomizerController controller =
        AdvancedCustomizerController();

    controller.setSelectedComponents(<String>{'login.button.primary'});
    controller.startDraftSession(AdvancedCustomizerScope.global);
    controller.setFill(const Color(0xFFAA0000));
    controller.applyDraft();

    controller.startDraftSession(AdvancedCustomizerScope.global);
    controller.resetComponent('login.button.primary');
    controller.applyDraft();

    final Color? resolved =
        controller.resolveProperty(
              'login.button.primary',
              AdvancedCustomizerProperty.fill,
              AdvancedCustomizerState.defaultState,
            )
            as Color?;
    expect(resolved, isNull);
  });

  test('unknown selected component is ignored with warning', () {
    const AdvancedComponentRegistry registry = AdvancedComponentRegistry(
      components: <AdvancedComponentDescriptor>[
        AdvancedComponentDescriptor(
          componentId: 'login.button.primary',
          pageId: 'login',
        ),
      ],
    );

    final AdvancedCustomizerController controller =
        AdvancedCustomizerController(
          config: const AdvancedCustomizerConfig(registry: registry),
        );

    controller.setSelectedComponents(<String>{
      'login.button.primary',
      'unknown.component',
    });

    expect(controller.selectedComponents, contains('login.button.primary'));
    expect(controller.selectedComponents, isNot(contains('unknown.component')));
    expect(
      controller.runtimeWarnings.any(
        (String warning) => warning.contains('Unknown component id'),
      ),
      isTrue,
    );
  });

  test('low contrast warning is generated for risky fill-text pair', () {
    final AdvancedCustomizerController controller =
        AdvancedCustomizerController();

    controller.setSelectedComponents(<String>{'login.button.primary'});
    controller.startDraftSession(AdvancedCustomizerScope.global);
    controller.setFill(const Color(0xFFFFFFFF));
    controller.setText(const Color(0xFFFFFFFF));

    expect(
      controller.runtimeWarnings.any(
        (String warning) => warning.contains('Low contrast warning'),
      ),
      isTrue,
    );
  });

  test('in-page preview can be enabled and scoped by page', () {
    final AdvancedCustomizerController controller =
        AdvancedCustomizerController();

    expect(controller.inPagePreviewEnabled, isFalse);
    expect(controller.isInPagePreviewActiveFor('home'), isFalse);

    controller.enableInPagePreview(pageId: 'home');
    expect(controller.inPagePreviewEnabled, isTrue);
    expect(controller.inPagePreviewPageId, 'home');
    expect(controller.isInPagePreviewActiveFor('home'), isTrue);
    expect(controller.isInPagePreviewActiveFor('profile'), isFalse);

    controller.disableInPagePreview();
    expect(controller.inPagePreviewEnabled, isFalse);
  });

  testWidgets('preview value widget updates from draft without apply', (
    WidgetTester tester,
  ) async {
    final AdvancedCustomizerController controller =
        AdvancedCustomizerController();

    controller.setSelectedComponents(<String>{'home.button.primary'});

    await tester.pumpWidget(
      MaterialApp(
        home: AdvancedCustomizerPreviewBridge(
          controller: controller,
          child: AdvancedCustomizerResolvedColor(
            componentKey: 'home.button.primary',
            property: AdvancedCustomizerProperty.fill,
            fallbackColor: const Color(0xFF000000),
            builder: (BuildContext context, Color? color) {
              return Text('color:${color?.value ?? 0}');
            },
          ),
        ),
      ),
    );

    expect(find.text('color:4278190080'), findsOneWidget);

    controller.startDraftSession(AdvancedCustomizerScope.global);
    controller.setFill(const Color(0xFF336699));
    await tester.pump();

    expect(find.text('color:4281558681'), findsOneWidget);
  });

  testWidgets('in-page preview container shows live badge only when enabled', (
    WidgetTester tester,
  ) async {
    final AdvancedCustomizerController controller =
        AdvancedCustomizerController();

    await tester.pumpWidget(
      MaterialApp(
        home: AdvancedCustomizerPreviewBridge(
          controller: controller,
          child: AdvancedCustomizerInPagePreviewContainer(
            pageId: 'home',
            child: const SizedBox(width: 10, height: 10),
          ),
        ),
      ),
    );

    expect(find.text('Live Preview'), findsNothing);

    controller.enableInPagePreview(pageId: 'home');
    await tester.pump();

    expect(find.text('Live Preview'), findsOneWidget);
  });

  test('import failure returns structured diagnostics', () {
    final AdvancedCustomizerController controller =
        AdvancedCustomizerController();

    final AdvancedCustomizerImportResult result = controller.importProfileJson(
      '{invalid json',
      AdvancedCustomizerImportMode.replace,
    );

    expect(result.success, isFalse);
    expect(result.errorCode, 'invalid_import');
    expect(
      result.diagnostics.any(
        (AdvancedCustomizerDiagnostic diagnostic) =>
            diagnostic.code ==
            AdvancedCustomizerDiagnosticCode.invalidImportPayload,
      ),
      isTrue,
    );
  });

  test('runtime diagnostics capture typed warning codes', () {
    const AdvancedComponentRegistry registry = AdvancedComponentRegistry(
      components: <AdvancedComponentDescriptor>[
        AdvancedComponentDescriptor(
          componentId: 'login.button.primary',
          pageId: 'login',
        ),
      ],
    );

    final AdvancedCustomizerController controller =
        AdvancedCustomizerController(
          config: const AdvancedCustomizerConfig(registry: registry),
        );

    controller.setSelectedComponents(<String>{'unknown.component'});

    expect(
      controller.runtimeDiagnostics.any(
        (AdvancedCustomizerDiagnostic diagnostic) =>
            diagnostic.code ==
            AdvancedCustomizerDiagnosticCode.unknownComponentId,
      ),
      isTrue,
    );
  });

  test('traceResolvedProperty includes active then default source chain', () {
    const String defaultsJson = '''
{
  "schemaVersion": 2,
  "profile": {
    "id": "defaults_trace",
    "name": "Defaults Trace",
    "updatedAt": "2026-04-08T12:00:00Z"
  },
  "rules": [
    {
      "scope": "global",
      "target": "global",
      "priority": 100,
      "styles": {
        "home.banner.primary": {
          "default": {
            "fill": "#FF445566"
          }
        }
      }
    }
  ]
}
''';

    final AdvancedCustomizerController controller =
        AdvancedCustomizerController();
    controller.importProfileJson(
      defaultsJson,
      AdvancedCustomizerImportMode.defaults,
    );

    final AdvancedStyleResolveTrace trace = controller.traceResolvedProperty(
      'home.banner.primary',
      AdvancedCustomizerProperty.fill,
      AdvancedCustomizerState.defaultState,
    );

    expect(trace.resolved, isTrue);
    expect((trace.value as Color).value, 0xFF445566);
    expect(trace.source, contains('active+default'));
    expect(
      trace.steps.any(
        (AdvancedStyleResolveStep step) => step.source == 'default',
      ),
      isTrue,
    );
  });
}
