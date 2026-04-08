import 'package:flutter/material.dart';

import '../advanced_customizer_controller.dart';
import '../core/models/style_models.dart';

class AdvancedCustomizerPreviewBridge
    extends InheritedNotifier<AdvancedCustomizerController> {
  const AdvancedCustomizerPreviewBridge({
    super.key,
    required AdvancedCustomizerController controller,
    required Widget child,
  }) : super(notifier: controller, child: child);

  static AdvancedCustomizerController? maybeOf(BuildContext context) {
    final AdvancedCustomizerPreviewBridge? bridge = context
        .dependOnInheritedWidgetOfExactType<AdvancedCustomizerPreviewBridge>();
    return bridge?.notifier;
  }

  static AdvancedCustomizerController of(BuildContext context) {
    final AdvancedCustomizerController? controller = maybeOf(context);
    assert(
      controller != null,
      'No AdvancedCustomizerPreviewBridge found in context.',
    );
    return controller!;
  }
}

typedef AdvancedCustomizerPreviewBuilder<T> =
    Widget Function(BuildContext context, T? value);

class AdvancedCustomizerPreviewValue extends StatelessWidget {
  const AdvancedCustomizerPreviewValue({
    super.key,
    this.controller,
    required this.componentKey,
    required this.property,
    this.state = AdvancedCustomizerState.defaultState,
    this.groupId,
    this.componentTypeId,
    this.fallbackValue,
    required this.builder,
  });

  final AdvancedCustomizerController? controller;
  final String componentKey;
  final AdvancedCustomizerProperty property;
  final AdvancedCustomizerState state;
  final String? groupId;
  final String? componentTypeId;
  final dynamic fallbackValue;
  final AdvancedCustomizerPreviewBuilder<dynamic> builder;

  @override
  Widget build(BuildContext context) {
    final AdvancedCustomizerController effectiveController =
        controller ?? AdvancedCustomizerPreviewBridge.of(context);

    return AnimatedBuilder(
      animation: effectiveController,
      builder: (BuildContext context, Widget? _) {
        final dynamic resolved = effectiveController.resolveProperty(
          componentKey,
          property,
          state,
          groupId: groupId,
          componentTypeId: componentTypeId,
        );

        return RepaintBoundary(
          child: builder(context, resolved ?? fallbackValue),
        );
      },
    );
  }
}

class AdvancedCustomizerResolvedColor extends StatelessWidget {
  const AdvancedCustomizerResolvedColor({
    super.key,
    this.controller,
    required this.componentKey,
    required this.property,
    this.state = AdvancedCustomizerState.defaultState,
    this.groupId,
    this.componentTypeId,
    this.fallbackColor,
    required this.builder,
  });

  final AdvancedCustomizerController? controller;
  final String componentKey;
  final AdvancedCustomizerProperty property;
  final AdvancedCustomizerState state;
  final String? groupId;
  final String? componentTypeId;
  final Color? fallbackColor;
  final AdvancedCustomizerPreviewBuilder<Color> builder;

  @override
  Widget build(BuildContext context) {
    return AdvancedCustomizerPreviewValue(
      controller: controller,
      componentKey: componentKey,
      property: property,
      state: state,
      groupId: groupId,
      componentTypeId: componentTypeId,
      fallbackValue: fallbackColor,
      builder: (BuildContext context, dynamic value) {
        return builder(context, value as Color?);
      },
    );
  }
}

class AdvancedCustomizerResolvedDouble extends StatelessWidget {
  const AdvancedCustomizerResolvedDouble({
    super.key,
    this.controller,
    required this.componentKey,
    required this.property,
    this.state = AdvancedCustomizerState.defaultState,
    this.groupId,
    this.componentTypeId,
    this.fallbackValue,
    required this.builder,
  });

  final AdvancedCustomizerController? controller;
  final String componentKey;
  final AdvancedCustomizerProperty property;
  final AdvancedCustomizerState state;
  final String? groupId;
  final String? componentTypeId;
  final double? fallbackValue;
  final AdvancedCustomizerPreviewBuilder<double> builder;

  @override
  Widget build(BuildContext context) {
    return AdvancedCustomizerPreviewValue(
      controller: controller,
      componentKey: componentKey,
      property: property,
      state: state,
      groupId: groupId,
      componentTypeId: componentTypeId,
      fallbackValue: fallbackValue,
      builder: (BuildContext context, dynamic value) {
        final double? parsed = (value is num)
            ? value.toDouble()
            : (value as double?);
        return builder(context, parsed);
      },
    );
  }
}

class AdvancedCustomizerInPagePreviewContainer extends StatelessWidget {
  const AdvancedCustomizerInPagePreviewContainer({
    super.key,
    this.controller,
    required this.pageId,
    required this.child,
    this.showPreviewBadge = true,
  });

  final AdvancedCustomizerController? controller;
  final String pageId;
  final Widget child;
  final bool showPreviewBadge;

  @override
  Widget build(BuildContext context) {
    final AdvancedCustomizerController effectiveController =
        controller ?? AdvancedCustomizerPreviewBridge.of(context);

    return AnimatedBuilder(
      animation: effectiveController,
      builder: (BuildContext context, Widget? _) {
        final bool active = effectiveController.isInPagePreviewActiveFor(
          pageId,
        );
        if (!active) {
          return child;
        }

        return Stack(
          children: <Widget>[
            RepaintBoundary(child: child),
            if (showPreviewBadge)
              Positioned(
                right: 8,
                top: 8,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    child: Text(
                      'Live Preview',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
