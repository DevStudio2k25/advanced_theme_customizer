part of 'customizer_panel.dart';

class _StyleTab extends StatelessWidget {
  const _StyleTab({
    required this.controller,
    required this.panelTheme,
    required this.component,
    required this.activeColorProperty,
    required this.currentColor,
    required this.radius,
    required this.borderWidth,
    required this.swatches,
    required this.propertyLabel,
    required this.onBackPressed,
    required this.onColorPropertySelected,
    required this.onColorChanged,
    required this.onRadiusChanged,
    required this.onRadiusChangeEnd,
    required this.onBorderWidthChanged,
    required this.onBorderWidthChangeEnd,
  });

  final AdvancedCustomizerController controller;
  final _PanelThemeData panelTheme;
  final AdvancedComponentDescriptor? component;
  final AdvancedCustomizerProperty activeColorProperty;
  final Color currentColor;
  final double radius;
  final double borderWidth;
  final List<Color> swatches;
  final String Function(AdvancedCustomizerProperty property) propertyLabel;
  final VoidCallback onBackPressed;
  final ValueChanged<AdvancedCustomizerProperty> onColorPropertySelected;
  final ValueChanged<Color> onColorChanged;
  final ValueChanged<double> onRadiusChanged;
  final ValueChanged<double> onRadiusChangeEnd;
  final ValueChanged<double> onBorderWidthChanged;
  final ValueChanged<double> onBorderWidthChangeEnd;

  @override
  Widget build(BuildContext context) {
    final AdvancedComponentDescriptor? target = component;
    if (target == null) {
      return _PanelSurfaceCard(
        panelTheme: panelTheme,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _PanelSectionTitle(
              title: 'No widget selected',
              panelTheme: panelTheme,
            ),
            const SizedBox(height: 18),
            FilledButton.icon(
              onPressed: onBackPressed,
              icon: const Icon(Icons.grid_view_rounded),
              label: const Text('Open widget canvas'),
            ),
          ],
        ),
      );
    }

    final List<AdvancedCustomizerProperty> editableColorProperties =
        <AdvancedCustomizerProperty>[
          AdvancedCustomizerProperty.fill,
          AdvancedCustomizerProperty.border,
          AdvancedCustomizerProperty.text,
          AdvancedCustomizerProperty.icon,
        ].where(target.editableProperties.contains).toList(growable: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _PanelSurfaceCard(
          panelTheme: panelTheme,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _PanelSectionTitle(
                title: target.displayName ?? target.componentId,
                panelTheme: panelTheme,
                trailing: TextButton.icon(
                  onPressed: onBackPressed,
                  icon: const Icon(Icons.arrow_back_rounded),
                  label: const Text('Back'),
                ),
              ),
              const SizedBox(height: 16),
              _PreviewViewport(
                controller: controller,
                panelTheme: panelTheme,
                component: target,
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: panelTheme.surfaceRaised,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: panelTheme.outline),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Editing target',
                      style: TextStyle(
                        color: panelTheme.textPrimary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Page: ${target.pageId}',
                      style: TextStyle(color: panelTheme.textMuted),
                    ),
                    if (target.groupId != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          'Group: ${target.groupId}',
                          style: TextStyle(color: panelTheme.textMuted),
                        ),
                      ),
                    if (target.componentTypeId != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          'Type: ${target.componentTypeId}',
                          style: TextStyle(color: panelTheme.textMuted),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _PanelSurfaceCard(
          panelTheme: panelTheme,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _PanelSectionTitle(
                title: 'Style',
                panelTheme: panelTheme,
              ),
              const SizedBox(height: 16),
              Text(
                controller.panelStrings.statesLabel,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: panelTheme.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: target.editableStates.map((AdvancedCustomizerState state) {
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
                }).toList(growable: false),
              ),
              if (editableColorProperties.isNotEmpty) ...<Widget>[
                const SizedBox(height: 18),
                Text(
                  'Color target',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: panelTheme.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: editableColorProperties
                      .map((AdvancedCustomizerProperty property) {
                    return ChoiceChip(
                      selected: activeColorProperty == property,
                      label: Text(propertyLabel(property)),
                      onSelected: (_) => onColorPropertySelected(property),
                    );
                  }).toList(growable: false),
                ),
                const SizedBox(height: 14),
                _UnifiedColorPicker(
                  color: currentColor,
                  swatches: swatches,
                  panelTheme: panelTheme,
                  onChanged: onColorChanged,
                ),
              ],
              if (target.editableProperties.contains(
                AdvancedCustomizerProperty.radius,
              )) ...<Widget>[
                const SizedBox(height: 16),
                Text(
                  controller.panelStrings.radiusLabel,
                  style: TextStyle(
                    color: panelTheme.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Slider(
                  value: radius,
                  min: 0,
                  max: 40,
                  divisions: 40,
                  label: radius.toStringAsFixed(0),
                  onChanged: onRadiusChanged,
                  onChangeEnd: onRadiusChangeEnd,
                ),
              ],
              if (target.editableProperties.contains(
                AdvancedCustomizerProperty.borderWidth,
              )) ...<Widget>[
                const SizedBox(height: 8),
                Text(
                  controller.panelStrings.borderWidthLabel,
                  style: TextStyle(
                    color: panelTheme.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Slider(
                  value: borderWidth,
                  min: 0,
                  max: 12,
                  divisions: 24,
                  label: borderWidth.toStringAsFixed(1),
                  onChanged: onBorderWidthChanged,
                  onChangeEnd: onBorderWidthChangeEnd,
                ),
              ],
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: <Widget>[
                  OutlinedButton(
                    onPressed: () => controller.copyStyleFrom(target.componentId),
                    child: Text(controller.panelStrings.copyLabel),
                  ),
                  OutlinedButton(
                    onPressed: () =>
                        controller.pasteStyleTo(<String>{target.componentId}),
                    child: Text(controller.panelStrings.pasteLabel),
                  ),
                  OutlinedButton(
                    onPressed: () => controller.resetComponent(target.componentId),
                    child: Text(controller.panelStrings.resetComponentLabel),
                  ),
                  if (controller.effectivePageId != null)
                    OutlinedButton(
                      onPressed: () =>
                          controller.resetPage(controller.effectivePageId!),
                      child: Text(controller.panelStrings.resetPageLabel),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: controller.resetProfile,
                child: Text(controller.panelStrings.resetProfileLabel),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
