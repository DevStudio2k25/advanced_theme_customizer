import 'package:flutter/material.dart';

import '../advanced_customizer_controller.dart';
import '../core/models/style_models.dart';
import '../core/registry/component_registry.dart';
import '../preview/preview_bridge.dart';
import 'controllers/customizer_panel_controller.dart';

part 'customizer_panel_theme.dart';
part 'customizer_panel_primitives.dart';
part 'customizer_panel_widgets_tab.dart';
part 'customizer_panel_style_tab.dart';

enum _PanelTab { widgets, style }

class AdvancedCustomizerPage extends StatelessWidget {
  const AdvancedCustomizerPage({
    super.key,
    required this.controller,
    this.child,
    this.onCloseRequested,
  });

  final AdvancedCustomizerController controller;
  final Widget? child;
  final Future<void> Function()? onCloseRequested;

  @override
  Widget build(BuildContext context) {
    return AdvancedCustomizerPanel(
      controller: controller,
      expandToFill: true,
      useHeaderActions: true,
      showBottomActions: false,
      compactHeader: true,
      onCloseRequested: onCloseRequested,
      child: child,
    );
  }
}

class AdvancedCustomizerPanel extends StatefulWidget {
  const AdvancedCustomizerPanel({
    super.key,
    required this.controller,
    this.child,
    this.onCloseRequested,
    this.expandToFill = false,
    this.useHeaderActions = false,
    this.showBottomActions = true,
    this.compactHeader = false,
  });

  final AdvancedCustomizerController controller;
  final Widget? child;
  final Future<void> Function()? onCloseRequested;
  final bool expandToFill;
  final bool useHeaderActions;
  final bool showBottomActions;
  final bool compactHeader;

  @override
  State<AdvancedCustomizerPanel> createState() =>
      _AdvancedCustomizerPanelState();
}

class _AdvancedCustomizerPanelState extends State<AdvancedCustomizerPanel> {
  late final TextEditingController _componentSearchController;

  static const List<Color> _palette = <Color>[
    Color(0xFF5EE6FF),
    Color(0xFF8B5CF6),
    Color(0xFFFF6B6B),
    Color(0xFFFFB84D),
    Color(0xFF41D392),
    Color(0xFFF4F7FB),
  ];

  String _componentQuery = '';
  _PanelTab _activeTab = _PanelTab.widgets;
  double _radius = 12;
  double _borderWidth = 1;
  AdvancedCustomizerProperty _activeColorProperty =
      AdvancedCustomizerProperty.fill;

  @override
  void initState() {
    super.initState();
    _componentSearchController = TextEditingController()
      ..addListener(_onComponentSearchChanged);
  }

  @override
  void dispose() {
    _componentSearchController
      ..removeListener(_onComponentSearchChanged)
      ..dispose();
    super.dispose();
  }

  void _onComponentSearchChanged() {
    final String next = _componentSearchController.text.trim().toLowerCase();
    if (next == _componentQuery) {
      return;
    }
    setState(() {
      _componentQuery = next;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (BuildContext context, Widget? _) {
        final AdvancedCustomizerController controller = widget.controller;
        final _PanelThemeData panelTheme = _PanelThemeData.fromController(
          controller,
        );
        final AdvancedCustomizerPanelController panelController =
            AdvancedCustomizerPanelController(controller);

        return Theme(
          data: panelTheme.buildTheme(Theme.of(context)),
          child: Material(
            elevation: widget.expandToFill ? 0 : controller.panelSkin.elevation,
            borderRadius: BorderRadius.circular(
              controller.panelSkin.cornerRadius,
            ),
            color: panelTheme.background,
            child: Container(
              width: double.infinity,
              height: widget.expandToFill
                  ? double.infinity
                  : MediaQuery.sizeOf(context).height * 0.92,
              decoration: BoxDecoration(
                color: panelTheme.background,
                borderRadius: BorderRadius.circular(
                  widget.expandToFill ? 0 : controller.panelSkin.cornerRadius,
                ),
              ),
              child: Column(
                children: <Widget>[
                  _PanelHeader(
                    controller: controller,
                    panelController: panelController,
                    panelTheme: panelTheme,
                    onCloseRequested: widget.onCloseRequested,
                    useHeaderActions: widget.useHeaderActions,
                    compactHeader: widget.compactHeader,
                  ),
                  if (controller.hasDraftSession)
                    _UnsavedChangesStrip(
                      label: controller.panelStrings.unsavedChangesLabel,
                      panelTheme: panelTheme,
                    ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 14, 18, 0),
                    child: _PanelTabs(
                      activeTab: _activeTab,
                      onChanged: (_PanelTab tab) {
                        setState(() {
                          _activeTab = tab;
                        });
                      },
                      panelTheme: panelTheme,
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.fromLTRB(
                        18,
                        widget.compactHeader ? 12 : 18,
                        18,
                        18,
                      ),
                      child:
                          widget.child ?? _buildPanelContent(controller, panelTheme),
                    ),
                  ),
                  if (controller.sectionVisibility.showActionsSection &&
                      widget.showBottomActions)
                    Divider(height: 1, color: panelTheme.outline),
                  if (controller.sectionVisibility.showActionsSection &&
                      widget.showBottomActions)
                    Padding(
                      padding: const EdgeInsets.all(14),
                      child: _PanelActionBar(
                        controller: controller,
                        panelTheme: panelTheme,
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPanelContent(
    AdvancedCustomizerController controller,
    _PanelThemeData panelTheme,
  ) {
    if (_activeTab == _PanelTab.widgets) {
      return _WidgetCanvasTab(
        controller: controller,
        panelTheme: panelTheme,
        searchController: _componentSearchController,
        searchQuery: _componentQuery,
        components: _filteredComponents(controller),
        selectedComponentId: _selectedComponentId(controller),
        onPageSelected: (String pageId) {
          controller.setActiveScope(AdvancedCustomizerScope.page);
          controller.setActivePage(pageId);
          final String? selectedComponentId = _selectedComponentId(controller);
          if (selectedComponentId != null) {
            final AdvancedComponentDescriptor? selected = controller
                .config
                .registry
                .byId(selectedComponentId);
            if (selected?.pageId != pageId) {
              controller.setSelectedComponents(const <String>{});
            }
          }
        },
        onComponentSelected: (AdvancedComponentDescriptor component) {
          _selectComponent(controller, component);
        },
      );
    }

    final AdvancedComponentDescriptor? component = _selectedComponent(controller);
    return _StyleTab(
      controller: controller,
      panelTheme: panelTheme,
      component: component,
      activeColorProperty: _activeColorPropertyForCurrentComponent(controller),
      currentColor: component == null
          ? _palette.first
          : _resolvedColorFor(
              controller,
              component.componentId,
              _activeColorPropertyForCurrentComponent(controller),
            ),
      radius: _radius,
      borderWidth: _borderWidth,
      swatches: _palette,
      propertyLabel: (AdvancedCustomizerProperty property) =>
          _propertyLabel(controller, property),
      onBackPressed: () {
        setState(() {
          _activeTab = _PanelTab.widgets;
        });
      },
      onColorPropertySelected: (AdvancedCustomizerProperty property) {
        setState(() {
          _activeColorProperty = property;
        });
      },
      onColorChanged: (Color color) {
        _applyColorForProperty(
          controller,
          _activeColorPropertyForCurrentComponent(controller),
          color,
        );
      },
      onRadiusChanged: (double value) {
        setState(() {
          _radius = value;
        });
      },
      onRadiusChangeEnd: controller.setRadius,
      onBorderWidthChanged: (double value) {
        setState(() {
          _borderWidth = value;
        });
      },
      onBorderWidthChangeEnd: controller.setBorderWidth,
    );
  }

  void _selectComponent(
    AdvancedCustomizerController controller,
    AdvancedComponentDescriptor component,
  ) {
    final AdvancedCustomizerProperty nextProperty =
        _firstEditableColorProperty(component);
    final double resolvedRadius =
        _resolvedNumericFor(
              controller,
              component.componentId,
              AdvancedCustomizerProperty.radius,
            ) ??
            12;
    final double resolvedBorderWidth =
        _resolvedNumericFor(
              controller,
              component.componentId,
              AdvancedCustomizerProperty.borderWidth,
            ) ??
            1;

    setState(() {
      _activeTab = _PanelTab.style;
      _activeColorProperty = nextProperty;
      _radius = resolvedRadius;
      _borderWidth = resolvedBorderWidth;
    });

    controller.setActiveScope(AdvancedCustomizerScope.page);
    controller.setActivePage(component.pageId);
    controller.setSelectedComponents(<String>{component.componentId});
  }

  AdvancedComponentDescriptor? _selectedComponent(
    AdvancedCustomizerController controller,
  ) {
    final String? componentId = _selectedComponentId(controller);
    if (componentId == null) {
      return null;
    }
    return controller.config.registry.byId(componentId);
  }

  AdvancedCustomizerProperty _activeColorPropertyForCurrentComponent(
    AdvancedCustomizerController controller,
  ) {
    final AdvancedComponentDescriptor? component = _selectedComponent(controller);
    if (component == null) {
      return AdvancedCustomizerProperty.fill;
    }
    final List<AdvancedCustomizerProperty> editableProperties =
        _editableColorProperties(component);
    if (editableProperties.contains(_activeColorProperty)) {
      return _activeColorProperty;
    }
    return _firstEditableColorProperty(component);
  }

  List<AdvancedCustomizerProperty> _editableColorProperties(
    AdvancedComponentDescriptor component,
  ) {
    return <AdvancedCustomizerProperty>[
      AdvancedCustomizerProperty.fill,
      AdvancedCustomizerProperty.border,
      AdvancedCustomizerProperty.text,
      AdvancedCustomizerProperty.icon,
    ].where(component.editableProperties.contains).toList(growable: false);
  }

  AdvancedCustomizerProperty _firstEditableColorProperty(
    AdvancedComponentDescriptor component,
  ) {
    final List<AdvancedCustomizerProperty> properties =
        _editableColorProperties(component);
    return properties.isEmpty
        ? AdvancedCustomizerProperty.fill
        : properties.first;
  }

  AdvancedCustomizerState _activePreviewState(
    AdvancedCustomizerController controller,
  ) {
    for (final AdvancedCustomizerState state in kAdvancedCustomizerAllStates) {
      if (controller.selectedStates.contains(state)) {
        return state;
      }
    }
    return AdvancedCustomizerState.defaultState;
  }

  Color _resolvedColorFor(
    AdvancedCustomizerController controller,
    String componentId,
    AdvancedCustomizerProperty property,
  ) {
    final Color? resolved =
        controller.resolveProperty(
              componentId,
              property,
              _activePreviewState(controller),
            )
            as Color?;
    return resolved ?? _palette.first;
  }

  double? _resolvedNumericFor(
    AdvancedCustomizerController controller,
    String componentId,
    AdvancedCustomizerProperty property,
  ) {
    final dynamic resolved = controller.resolveProperty(
      componentId,
      property,
      _activePreviewState(controller),
    );
    return resolved is num ? resolved.toDouble() : null;
  }

  void _applyColorForProperty(
    AdvancedCustomizerController controller,
    AdvancedCustomizerProperty property,
    Color color,
  ) {
    switch (property) {
      case AdvancedCustomizerProperty.fill:
        controller.setFill(color);
      case AdvancedCustomizerProperty.border:
        controller.setBorder(color);
      case AdvancedCustomizerProperty.text:
        controller.setText(color);
      case AdvancedCustomizerProperty.icon:
        controller.setIcon(color);
      case AdvancedCustomizerProperty.radius:
      case AdvancedCustomizerProperty.borderWidth:
        break;
    }
  }

  String _propertyLabel(
    AdvancedCustomizerController controller,
    AdvancedCustomizerProperty property,
  ) {
    switch (property) {
      case AdvancedCustomizerProperty.fill:
        return controller.panelStrings.fillLabel;
      case AdvancedCustomizerProperty.border:
        return controller.panelStrings.borderLabel;
      case AdvancedCustomizerProperty.text:
        return controller.panelStrings.textLabel;
      case AdvancedCustomizerProperty.icon:
        return controller.panelStrings.iconLabel;
      case AdvancedCustomizerProperty.radius:
        return controller.panelStrings.radiusLabel;
      case AdvancedCustomizerProperty.borderWidth:
        return controller.panelStrings.borderWidthLabel;
    }
  }

  List<AdvancedComponentDescriptor> _filteredComponents(
    AdvancedCustomizerController controller,
  ) {
    return controller.visibleComponents
        .where((AdvancedComponentDescriptor component) {
          if (_componentQuery.isEmpty) {
            return true;
          }
          final String label =
              '${component.displayName ?? ''} ${component.componentId}'
                  .toLowerCase();
          return label.contains(_componentQuery);
        })
        .toList(growable: false);
  }

  String? _selectedComponentId(AdvancedCustomizerController controller) {
    if (controller.selectedComponents.isEmpty) {
      return null;
    }
    return controller.selectedComponents.first;
  }
}

