import 'package:flutter/material.dart';

import '../advanced_customizer_controller.dart';
import '../core/models/style_models.dart';
import '../core/registry/component_registry.dart';
import 'controllers/customizer_panel_controller.dart';

class AdvancedCustomizerPanel extends StatefulWidget {
  const AdvancedCustomizerPanel({
    super.key,
    required this.controller,
    this.child,
  });

  final AdvancedCustomizerController controller;
  final Widget? child;

  @override
  State<AdvancedCustomizerPanel> createState() =>
      _AdvancedCustomizerPanelState();
}

class _AdvancedCustomizerPanelState extends State<AdvancedCustomizerPanel> {
  double _radius = 12;
  double _borderWidth = 1;

  static const List<Color> _palette = <Color>[
    Color(0xFF1A73E8),
    Color(0xFFD93025),
    Color(0xFF188038),
    Color(0xFFFA7B17),
    Color(0xFF202124),
    Color(0xFFFFFFFF),
  ];

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (BuildContext context, Widget? _) {
        final AdvancedCustomizerController controller = widget.controller;
        final double maxHeight = MediaQuery.sizeOf(context).height * 0.9;
        final Color background =
            controller.panelSkin.backgroundColor ?? Theme.of(context).cardColor;
        final Color headerColor =
            controller.panelSkin.headerColor ??
            Theme.of(context).colorScheme.primary;

        return Material(
          elevation: controller.panelSkin.elevation,
          borderRadius: BorderRadius.circular(
            controller.panelSkin.cornerRadius,
          ),
          color: background,
          child: SizedBox(
            width: double.infinity,
            height: maxHeight,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: headerColor,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(controller.panelSkin.cornerRadius),
                    ),
                  ),
                  child: Text(
                    controller.panelStrings.title,
                    style:
                        controller.panelSkin.headerTextStyle ??
                        Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                  ),
                ),
                if (controller.hasDraftSession)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(controller.panelStrings.unsavedChangesLabel),
                  ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: widget.child ?? _buildPanelContent(controller),
                  ),
                ),
                if (controller.sectionVisibility.showActionsSection)
                  const Divider(height: 1),
                if (controller.sectionVisibility.showActionsSection)
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: _PanelActionBar(controller: controller),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPanelContent(AdvancedCustomizerController controller) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (controller.sectionVisibility.showScopeSection)
          _buildScopeSection(controller),
        if (controller.sectionVisibility.showComponentsSection)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: _buildComponentSection(controller),
          ),
        if (controller.sectionVisibility.showPropertiesSection)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: _buildPropertySection(controller),
          ),
      ],
    );
  }

  Widget _buildScopeSection(AdvancedCustomizerController controller) {
    final List<String> pages = controller.availablePageIds;
    final String? effectivePage = controller.effectivePageId;
    final List<String> componentTypes = _componentTypesForPage(
      controller,
      effectivePage,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          controller.panelStrings.scopeLabel,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<AdvancedCustomizerScope>(
          value: controller.activeScope,
          decoration: const InputDecoration(border: OutlineInputBorder()),
          items: AdvancedCustomizerScope.values
              .map(
                (AdvancedCustomizerScope scope) =>
                    DropdownMenuItem<AdvancedCustomizerScope>(
                      value: scope,
                      child: Text(scope.value),
                    ),
              )
              .toList(growable: false),
          onChanged: (AdvancedCustomizerScope? scope) {
            if (scope != null) {
              controller.setActiveScope(scope);
            }
          },
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: pages.contains(effectivePage) ? effectivePage : null,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: controller.panelStrings.pageLabel,
          ),
          items: pages
              .map(
                (String pageId) => DropdownMenuItem<String>(
                  value: pageId,
                  child: Text(pageId),
                ),
              )
              .toList(growable: false),
          onChanged: (String? pageId) {
            if (pageId != null) {
              controller.setActivePage(pageId);
            }
          },
        ),
        if (controller.availableGroupsForActivePage.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: DropdownButtonFormField<String>(
              value: _groupValueIfValid(controller),
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: controller.panelStrings.groupLabel,
              ),
              items: <DropdownMenuItem<String>>[
                DropdownMenuItem<String>(
                  value: null,
                  child: Text(controller.panelStrings.allGroupsLabel),
                ),
                ...controller.availableGroupsForActivePage
                    .map(
                      (AdvancedComponentGroupDescriptor group) =>
                          DropdownMenuItem<String>(
                            value: group.groupId,
                            child: Text(group.displayName ?? group.groupId),
                          ),
                    )
                    .toList(growable: false),
              ],
              onChanged: controller.setActiveGroup,
            ),
          ),
        if (componentTypes.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: DropdownButtonFormField<String>(
              value: _componentTypeValueIfValid(controller, componentTypes),
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: controller.panelStrings.componentTypeLabel,
              ),
              items: <DropdownMenuItem<String>>[
                DropdownMenuItem<String>(
                  value: null,
                  child: Text(controller.panelStrings.allComponentTypesLabel),
                ),
                ...componentTypes
                    .map(
                      (String componentType) => DropdownMenuItem<String>(
                        value: componentType,
                        child: Text(componentType),
                      ),
                    )
                    .toList(growable: false),
              ],
              onChanged: controller.setActiveComponentType,
            ),
          ),
      ],
    );
  }

  String? _groupValueIfValid(AdvancedCustomizerController controller) {
    final String? active = controller.activeGroupId;
    if (active == null) {
      return null;
    }
    final bool exists = controller.availableGroupsForActivePage.any(
      (AdvancedComponentGroupDescriptor group) => group.groupId == active,
    );
    return exists ? active : null;
  }

  List<String> _componentTypesForPage(
    AdvancedCustomizerController controller,
    String? pageId,
  ) {
    if (pageId == null) {
      return const <String>[];
    }

    final List<AdvancedComponentDescriptor> descriptors = controller
        .config
        .registry
        .forPage(pageId);

    final List<String> output = descriptors
        .map(
          (AdvancedComponentDescriptor descriptor) =>
              descriptor.componentTypeId,
        )
        .whereType<String>()
        .toSet()
        .toList(growable: false);
    output.sort();
    return output;
  }

  String? _componentTypeValueIfValid(
    AdvancedCustomizerController controller,
    List<String> componentTypes,
  ) {
    final String? active = controller.activeComponentTypeId;
    if (active == null) {
      return null;
    }
    return componentTypes.contains(active) ? active : null;
  }

  Widget _buildComponentSection(AdvancedCustomizerController controller) {
    final List<AdvancedComponentDescriptor> components =
        controller.visibleComponents;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          controller.panelStrings.componentsLabel,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        if (components.isEmpty)
          const Text('No registered components for this scope.')
        else
          SizedBox(
            height: 160,
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).dividerColor),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListView.builder(
                itemCount: components.length,
                itemBuilder: (BuildContext context, int index) {
                  final AdvancedComponentDescriptor component =
                      components[index];
                  final String id = component.componentId;
                  final bool selected = controller.selectedComponents.contains(
                    id,
                  );
                  return CheckboxListTile(
                    dense: true,
                    value: selected,
                    title: Text(component.displayName ?? id),
                    subtitle: component.groupId == null
                        ? null
                        : Text('Group: ${component.groupId}'),
                    onChanged: (bool? next) {
                      final Set<String> updated = controller.selectedComponents
                          .toSet();
                      if (next ?? false) {
                        updated.add(id);
                      } else {
                        updated.remove(id);
                      }
                      controller.setSelectedComponents(updated);
                    },
                  );
                },
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPropertySection(AdvancedCustomizerController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          controller.panelStrings.statesLabel,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: kAdvancedCustomizerAllStates
              .map((AdvancedCustomizerState state) {
                return FilterChip(
                  selected: controller.selectedStates.contains(state),
                  label: Text(state.value),
                  onSelected: (bool selected) {
                    final Set<AdvancedCustomizerState> next = controller
                        .selectedStates
                        .toSet();
                    if (selected) {
                      next.add(state);
                    } else {
                      next.remove(state);
                    }
                    controller.setSelectedStates(next);
                  },
                );
              })
              .toList(growable: false),
        ),
        const SizedBox(height: 12),
        _ColorPropertyRow(
          label: controller.panelStrings.fillLabel,
          palette: _palette,
          onColorSelected: controller.setFill,
        ),
        const SizedBox(height: 8),
        _ColorPropertyRow(
          label: controller.panelStrings.borderLabel,
          palette: _palette,
          onColorSelected: controller.setBorder,
        ),
        const SizedBox(height: 8),
        _ColorPropertyRow(
          label: controller.panelStrings.textLabel,
          palette: _palette,
          onColorSelected: controller.setText,
        ),
        const SizedBox(height: 8),
        _ColorPropertyRow(
          label: controller.panelStrings.iconLabel,
          palette: _palette,
          onColorSelected: controller.setIcon,
        ),
        const SizedBox(height: 8),
        Text(controller.panelStrings.radiusLabel),
        Slider(
          value: _radius,
          min: 0,
          max: 40,
          divisions: 40,
          label: _radius.toStringAsFixed(0),
          onChanged: (double value) {
            setState(() {
              _radius = value;
            });
          },
          onChangeEnd: controller.setRadius,
        ),
        const SizedBox(height: 8),
        Text(controller.panelStrings.borderWidthLabel),
        Slider(
          value: _borderWidth,
          min: 0,
          max: 12,
          divisions: 24,
          label: _borderWidth.toStringAsFixed(1),
          onChanged: (double value) {
            setState(() {
              _borderWidth = value;
            });
          },
          onChangeEnd: controller.setBorderWidth,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: <Widget>[
            OutlinedButton(
              onPressed: () {
                if (controller.selectedComponents.isNotEmpty) {
                  controller.copyStyleFrom(controller.selectedComponents.first);
                }
              },
              child: Text(controller.panelStrings.copyLabel),
            ),
            OutlinedButton(
              onPressed: () =>
                  controller.pasteStyleTo(controller.selectedComponents),
              child: Text(controller.panelStrings.pasteLabel),
            ),
            OutlinedButton(
              onPressed: () {
                if (controller.selectedComponents.length == 1) {
                  controller.resetComponent(
                    controller.selectedComponents.first,
                  );
                }
              },
              child: Text(controller.panelStrings.resetComponentLabel),
            ),
            OutlinedButton(
              onPressed: () {
                final String? groupId = controller.activeGroupId;
                if (groupId != null) {
                  controller.resetGroup(groupId);
                }
              },
              child: Text(controller.panelStrings.resetGroupLabel),
            ),
            OutlinedButton(
              onPressed: () {
                final String? pageId = controller.effectivePageId;
                if (pageId != null) {
                  controller.resetPage(pageId);
                }
              },
              child: Text(controller.panelStrings.resetPageLabel),
            ),
            TextButton(
              onPressed: controller.resetProfile,
              child: Text(controller.panelStrings.resetProfileLabel),
            ),
          ],
        ),
      ],
    );
  }
}

class _PanelActionBar extends StatelessWidget {
  const _PanelActionBar({required this.controller});

  final AdvancedCustomizerController controller;

  @override
  Widget build(BuildContext context) {
    final AdvancedCustomizerPanelController panelController =
        AdvancedCustomizerPanelController(controller);

    return Row(
      children: <Widget>[
        OutlinedButton(
          onPressed: panelController.onDiscardPressed,
          child: Text(controller.panelStrings.discardLabel),
        ),
        const SizedBox(width: 8),
        TextButton(
          onPressed: panelController.onUndoPressed,
          child: Text(controller.panelStrings.undoLabel),
        ),
        const Spacer(),
        FilledButton(
          onPressed: panelController.onApplyPressed,
          child: Text(controller.panelStrings.applyLabel),
        ),
      ],
    );
  }
}

class _ColorPropertyRow extends StatelessWidget {
  const _ColorPropertyRow({
    required this.label,
    required this.palette,
    required this.onColorSelected,
  });

  final String label;
  final List<Color> palette;
  final ValueChanged<Color> onColorSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        SizedBox(width: 72, child: Text(label)),
        Expanded(
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: palette
                .map(
                  (Color color) => InkWell(
                    onTap: () => onColorSelected(color),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: color,
                        border: Border.all(
                          color: Theme.of(context).dividerColor,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                )
                .toList(growable: false),
          ),
        ),
      ],
    );
  }
}
