import 'package:advanced_theme_customizer/advanced_theme_customizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
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
      AdvancedComponentDescriptor(
        componentId: 'home.button.secondary',
        pageId: 'home',
        groupId: 'home.actions',
        componentTypeId: 'button.secondary',
        displayName: 'Home Secondary Button',
      ),
    ],
  );

  AdvancedCustomizerController buildController() {
    return AdvancedCustomizerController(
      config: const AdvancedCustomizerConfig(registry: registry),
    );
  }

  Widget buildPanelHarness(AdvancedCustomizerController controller) {
    return MaterialApp(
      home: Scaffold(body: AdvancedCustomizerPanel(controller: controller)),
    );
  }

  testWidgets('panel scope dropdown updates controller scope', (
    WidgetTester tester,
  ) async {
    final AdvancedCustomizerController controller = buildController();

    await tester.pumpWidget(buildPanelHarness(controller));

    expect(controller.activeScope, AdvancedCustomizerScope.global);

    final Finder scopeField = find.byWidgetPredicate(
      (Widget widget) =>
          widget is DropdownButtonFormField<AdvancedCustomizerScope>,
    );
    expect(scopeField, findsOneWidget);

    await tester.tap(scopeField);
    await tester.pumpAndSettle();
    await tester.tap(find.text('page').last);
    await tester.pumpAndSettle();

    expect(controller.activeScope, AdvancedCustomizerScope.page);
  });

  testWidgets('component checkbox selection updates selectedComponents', (
    WidgetTester tester,
  ) async {
    final AdvancedCustomizerController controller = buildController();

    await tester.pumpWidget(buildPanelHarness(controller));

    final Finder checkboxTile = find.text('Home Primary Button').first;
    await tester.ensureVisible(checkboxTile);
    await tester.tap(checkboxTile);
    await tester.pumpAndSettle();

    expect(controller.selectedComponents, contains('home.button.primary'));
  });

  testWidgets('component type dropdown updates active component type', (
    WidgetTester tester,
  ) async {
    final AdvancedCustomizerController controller = buildController();

    await tester.pumpWidget(buildPanelHarness(controller));

    final Finder stringDropdowns = find.byWidgetPredicate(
      (Widget widget) => widget is DropdownButtonFormField<String>,
    );
    expect(stringDropdowns, findsNWidgets(3));

    await tester.tap(stringDropdowns.last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('button.secondary').last);
    await tester.pumpAndSettle();

    expect(controller.activeComponentTypeId, 'button.secondary');
  });

  testWidgets('apply and discard buttons enforce draft semantics', (
    WidgetTester tester,
  ) async {
    final AdvancedCustomizerController controller = buildController();

    controller.setSelectedComponents(<String>{'home.button.primary'});
    controller.startDraftSession(AdvancedCustomizerScope.global);
    controller.setFill(const Color(0xFF112233));

    await tester.pumpWidget(buildPanelHarness(controller));

    expect(
      find.text(controller.panelStrings.unsavedChangesLabel),
      findsOneWidget,
    );

    final Finder applyButton = find.text(controller.panelStrings.applyLabel);
    await tester.ensureVisible(applyButton);
    await tester.tap(applyButton);
    await tester.pumpAndSettle();

    expect(controller.hasDraftSession, isFalse);
    final Color appliedColor =
        controller.resolveProperty(
              'home.button.primary',
              AdvancedCustomizerProperty.fill,
              AdvancedCustomizerState.defaultState,
            )
            as Color;
    expect(appliedColor.value, 0xFF112233);

    controller.startDraftSession(AdvancedCustomizerScope.global);
    controller.setFill(const Color(0xFF334455));
    await tester.pumpAndSettle();

    final Finder discardButton = find.text(
      controller.panelStrings.discardLabel,
    );
    await tester.ensureVisible(discardButton);
    await tester.tap(discardButton);
    await tester.pumpAndSettle();

    final Color afterDiscard =
        controller.resolveProperty(
              'home.button.primary',
              AdvancedCustomizerProperty.fill,
              AdvancedCustomizerState.defaultState,
            )
            as Color;
    expect(afterDiscard.value, 0xFF112233);
  });

  testWidgets('reset component action clears selected draft style', (
    WidgetTester tester,
  ) async {
    final AdvancedCustomizerController controller = buildController();

    controller.setSelectedComponents(<String>{'home.button.primary'});
    controller.startDraftSession(AdvancedCustomizerScope.global);
    controller.setFill(const Color(0xFFAA0000));

    await tester.pumpWidget(buildPanelHarness(controller));

    final Finder resetComponentButton = find.text(
      controller.panelStrings.resetComponentLabel,
    );
    await tester.ensureVisible(resetComponentButton);
    await tester.tap(resetComponentButton);
    await tester.pumpAndSettle();

    final Color? resolvedAfterReset =
        controller.resolveProperty(
              'home.button.primary',
              AdvancedCustomizerProperty.fill,
              AdvancedCustomizerState.defaultState,
            )
            as Color?;

    expect(resolvedAfterReset, isNull);
  });
}
