import 'package:advanced_theme_customizer/advanced_theme_customizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const AdvancedComponentRegistry registry = AdvancedComponentRegistry(
    pages: <AdvancedPageDescriptor>[
      AdvancedPageDescriptor(pageId: 'discover', displayName: 'Discover'),
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
      AdvancedComponentDescriptor(
        componentId: 'home.preview.aspect',
        pageId: 'home',
        groupId: 'home.actions',
        componentTypeId: 'preview.aspect',
        displayName: 'Aspect Preview',
        previewBuilder: _buildAspectPreview,
      ),
      AdvancedComponentDescriptor(
        componentId: 'discover.search.input',
        pageId: 'discover',
        componentTypeId: 'search.input',
        displayName: 'Discover Search Input',
      ),
      AdvancedComponentDescriptor(
        componentId: 'discover.tall.preview',
        pageId: 'discover',
        componentTypeId: 'preview.tall',
        displayName: 'Tall Preview',
        previewBuilder: _buildTallPreview,
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

  Widget buildPageHarness(AdvancedCustomizerController controller) {
    return MaterialApp(
      home: Scaffold(body: AdvancedCustomizerPage(controller: controller)),
    );
  }

  Widget buildClosableHarness(
    AdvancedCustomizerController controller,
    VoidCallback onClose,
  ) {
    return MaterialApp(
      home: Scaffold(
        body: AdvancedCustomizerPanel(
          controller: controller,
          onCloseRequested: () async {
            onClose();
          },
        ),
      ),
    );
  }

  testWidgets('page chip updates active page', (WidgetTester tester) async {
    final AdvancedCustomizerController controller = buildController();

    await tester.pumpWidget(buildPanelHarness(controller));

    expect(controller.effectivePageId, 'discover');

    await tester.tap(find.text('home').last);
    await tester.pumpAndSettle();

    expect(controller.activeScope, AdvancedCustomizerScope.page);
    expect(controller.effectivePageId, 'home');
  });

  testWidgets('component preview selection opens style editor', (
    WidgetTester tester,
  ) async {
    final AdvancedCustomizerController controller = buildController();

    controller.setActivePage('home');
    await tester.pumpWidget(buildPanelHarness(controller));

    final Finder componentTile = find.text('Home Primary Button').first;
    await tester.ensureVisible(componentTile);
    await tester.tap(componentTile);
    await tester.pumpAndSettle();

    expect(controller.selectedComponents, <String>{'home.button.primary'});
    expect(find.text('Editing target'), findsOneWidget);
    expect(find.text('Back'), findsOneWidget);
  });

  testWidgets('apply and discard buttons enforce draft semantics', (
    WidgetTester tester,
  ) async {
    final AdvancedCustomizerController controller = buildController();

    controller.setActivePage('home');
    controller.setSelectedComponents(<String>{'home.button.primary'});
    controller.startDraftSession(AdvancedCustomizerScope.page);
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
    expect(appliedColor.toARGB32(), 0xFF112233);

    controller.startDraftSession(AdvancedCustomizerScope.page);
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
    expect(afterDiscard.toARGB32(), 0xFF112233);
  });

  testWidgets('reset component action clears selected draft style', (
    WidgetTester tester,
  ) async {
    final AdvancedCustomizerController controller = buildController();

    controller.setActivePage('home');
    controller.setSelectedComponents(<String>{'home.button.primary'});
    controller.startDraftSession(AdvancedCustomizerScope.page);
    controller.setFill(const Color(0xFFAA0000));

    await tester.pumpWidget(buildPanelHarness(controller));
    await tester.tap(find.text('Style').last);
    await tester.pumpAndSettle();

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

  testWidgets('header close button triggers close callback', (
    WidgetTester tester,
  ) async {
    final AdvancedCustomizerController controller = buildController();
    bool closed = false;

    await tester.pumpWidget(
      buildClosableHarness(controller, () {
        closed = true;
      }),
    );

    await tester.tap(find.byTooltip('Close customizer'));
    await tester.pumpAndSettle();

    expect(closed, isTrue);
  });

  testWidgets('preview builder with aspect ratio renders safely', (
    WidgetTester tester,
  ) async {
    final AdvancedCustomizerController controller = buildController();

    controller.setActivePage('home');
    await tester.pumpWidget(buildPanelHarness(controller));

    final Finder aspectTile = find.text('Aspect Preview').first;
    await tester.ensureVisible(aspectTile);

    expect(tester.takeException(), isNull);
  });

  testWidgets('preview builder with tall content renders safely', (
    WidgetTester tester,
  ) async {
    final AdvancedCustomizerController controller = buildController();

    controller.setActivePage('discover');
    await tester.pumpWidget(buildPanelHarness(controller));

    final Finder tallTile = find.text('Tall Preview').first;
    await tester.ensureVisible(tallTile);
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });

  testWidgets('page variant renders top action icons', (
    WidgetTester tester,
  ) async {
    final AdvancedCustomizerController controller = buildController();

    await tester.pumpWidget(buildPageHarness(controller));

    expect(find.byTooltip(controller.panelStrings.undoLabel), findsOneWidget);
    expect(find.byTooltip(controller.panelStrings.discardLabel), findsOneWidget);
    expect(find.byTooltip(controller.panelStrings.applyLabel), findsOneWidget);
    expect(find.text(controller.panelStrings.applyLabel), findsNothing);
  });
}

Widget _buildAspectPreview(
  BuildContext context,
  AdvancedComponentDescriptor component,
) {
  return Row(
    children: <Widget>[
      AspectRatio(
        aspectRatio: 0.75,
        child: Container(color: Colors.blue),
      ),
      const SizedBox(width: 8),
      const Expanded(child: Text('Preview')),
    ],
  );
}

Widget _buildTallPreview(
  BuildContext context,
  AdvancedComponentDescriptor component,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: List<Widget>.generate(
      10,
      (int index) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Container(
          width: double.infinity,
          height: 24,
          color: index.isEven ? Colors.teal : Colors.blueGrey,
        ),
      ),
    ),
  );
}
