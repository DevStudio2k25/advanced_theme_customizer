part of 'customizer_panel.dart';

class _PanelHeader extends StatelessWidget {
  const _PanelHeader({
    required this.controller,
    required this.panelController,
    required this.panelTheme,
    this.onCloseRequested,
    this.useHeaderActions = false,
    this.compactHeader = false,
  });

  final AdvancedCustomizerController controller;
  final AdvancedCustomizerPanelController panelController;
  final _PanelThemeData panelTheme;
  final Future<void> Function()? onCloseRequested;
  final bool useHeaderActions;
  final bool compactHeader;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16, compactHeader ? 10 : 14, 16, 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[panelTheme.headerStart, panelTheme.headerEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(controller.panelSkin.cornerRadius),
        ),
        border: Border(bottom: BorderSide(color: panelTheme.outline)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: panelTheme.accentSoft,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: panelTheme.outlineStrong),
                  ),
                  child: Text(
                    'Theme Studio',
                    style: TextStyle(
                      color: panelTheme.textPrimary,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
                SizedBox(height: compactHeader ? 4 : 8),
                Text(
                  controller.panelStrings.title,
                  style:
                      controller.panelSkin.headerTextStyle ??
                      Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: panelTheme.textPrimary,
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: <Widget>[
              if (useHeaderActions)
                _HeaderActionIcon(
                  icon: Icons.undo_rounded,
                  tooltip: controller.panelStrings.undoLabel,
                  panelTheme: panelTheme,
                  onPressed: panelController.onUndoPressed,
                ),
              if (useHeaderActions)
                _HeaderActionIcon(
                  icon: Icons.close_rounded,
                  tooltip: controller.panelStrings.discardLabel,
                  panelTheme: panelTheme,
                  onPressed: panelController.onDiscardPressed,
                ),
              if (useHeaderActions)
                _HeaderActionIcon(
                  icon: Icons.check_rounded,
                  tooltip: controller.panelStrings.applyLabel,
                  panelTheme: panelTheme,
                  onPressed: panelController.onApplyPressed,
                  emphasize: true,
                ),
              if (onCloseRequested != null)
                _HeaderActionIcon(
                  icon: Icons.arrow_forward_rounded,
                  tooltip: 'Close customizer',
                  panelTheme: panelTheme,
                  onPressed: () async {
                    await onCloseRequested!.call();
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeaderActionIcon extends StatelessWidget {
  const _HeaderActionIcon({
    required this.icon,
    required this.tooltip,
    required this.panelTheme,
    required this.onPressed,
    this.emphasize = false,
  });

  final IconData icon;
  final String tooltip;
  final _PanelThemeData panelTheme;
  final VoidCallback onPressed;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      tooltip: tooltip,
      style: IconButton.styleFrom(
        backgroundColor: emphasize ? panelTheme.accent : panelTheme.surfaceRaised,
        foregroundColor: emphasize
            ? const Color(0xFF07111F)
            : panelTheme.textPrimary,
        side: BorderSide(
          color: emphasize ? panelTheme.accent : panelTheme.outlineStrong,
        ),
      ),
      icon: Icon(icon, size: 18),
    );
  }
}

class _UnsavedChangesStrip extends StatelessWidget {
  const _UnsavedChangesStrip({
    required this.label,
    required this.panelTheme,
  });

  final String label;
  final _PanelThemeData panelTheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      color: panelTheme.accentSoft,
      child: Row(
        children: <Widget>[
          Icon(Icons.edit_note_rounded, size: 18, color: panelTheme.accent),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: panelTheme.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _PanelTabs extends StatelessWidget {
  const _PanelTabs({
    required this.activeTab,
    required this.onChanged,
    required this.panelTheme,
  });

  final _PanelTab activeTab;
  final ValueChanged<_PanelTab> onChanged;
  final _PanelThemeData panelTheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: panelTheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: panelTheme.outline),
      ),
      child: Row(
        children: _PanelTab.values.map((_PanelTab tab) {
          final bool selected = tab == activeTab;
          final String label = tab == _PanelTab.widgets ? 'Widgets' : 'Style';
          final IconData icon = tab == _PanelTab.widgets
              ? Icons.grid_view_rounded
              : Icons.tune_rounded;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: InkWell(
                onTap: () => onChanged(tab),
                borderRadius: BorderRadius.circular(14),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 160),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: selected ? panelTheme.accentSoft : Colors.transparent,
                    borderRadius: BorderRadius.circular(14),
                    border: selected
                        ? Border.all(color: panelTheme.outlineStrong)
                        : null,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        icon,
                        size: 18,
                        color: selected
                            ? panelTheme.textPrimary
                            : panelTheme.textMuted,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        label,
                        style: TextStyle(
                          color: selected
                              ? panelTheme.textPrimary
                              : panelTheme.textMuted,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(growable: false),
      ),
    );
  }
}

class _PanelSurfaceCard extends StatelessWidget {
  const _PanelSurfaceCard({
    required this.child,
    required this.panelTheme,
  });

  final Widget child;
  final _PanelThemeData panelTheme;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: panelTheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(padding: const EdgeInsets.all(12), child: child),
    );
  }
}

class _PanelSectionTitle extends StatelessWidget {
  const _PanelSectionTitle({
    required this.title,
    required this.panelTheme,
    this.trailing,
  });

  final String title;
  final _PanelThemeData panelTheme;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: panelTheme.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        if (trailing != null) ...<Widget>[
          const SizedBox(width: 12),
          trailing!,
        ],
      ],
    );
  }
}

class _PageChip extends StatelessWidget {
  const _PageChip({
    required this.label,
    required this.selected,
    required this.panelTheme,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final _PanelThemeData panelTheme;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? panelTheme.accentSoft : panelTheme.surfaceRaised,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: selected ? panelTheme.accent : panelTheme.outlineStrong,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? panelTheme.textPrimary : panelTheme.textMuted,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _ComponentPreviewCard extends StatelessWidget {
  const _ComponentPreviewCard({
    required this.controller,
    required this.panelTheme,
    required this.component,
    required this.selected,
    required this.onTap,
  });

  final AdvancedCustomizerController controller;
  final _PanelThemeData panelTheme;
  final AdvancedComponentDescriptor component;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: selected ? panelTheme.accentSoft : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? panelTheme.accent : panelTheme.outline,
            width: selected ? 1.4 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _PreviewViewport(
              controller: controller,
              panelTheme: panelTheme,
              component: component,
            ),
            const SizedBox(height: 8),
            Text(
              component.displayName ?? component.componentId,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: panelTheme.textPrimary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PreviewViewport extends StatelessWidget {
  const _PreviewViewport({
    required this.controller,
    required this.panelTheme,
    required this.component,
  });

  final AdvancedCustomizerController controller;
  final _PanelThemeData panelTheme;
  final AdvancedComponentDescriptor component;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double maxWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : 360;
        return Padding(
          padding: const EdgeInsets.all(2),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: maxWidth,
              maxWidth: maxWidth,
            ),
            child: IntrinsicHeight(
              child: AdvancedCustomizerPreviewBridge(
                controller: controller,
                child: component.previewBuilder != null
                    ? component.previewBuilder!(context, component)
                    : _PreviewMock(
                        component: component,
                        panelTheme: panelTheme,
                      ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _CompactSectionLabel extends StatelessWidget {
  const _CompactSectionLabel({
    required this.label,
    required this.panelTheme,
  });

  final String label;
  final _PanelThemeData panelTheme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        label,
        style: TextStyle(
          color: panelTheme.textPrimary,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _PreviewMock extends StatelessWidget {
  const _PreviewMock({
    required this.component,
    required this.panelTheme,
  });

  final AdvancedComponentDescriptor component;
  final _PanelThemeData panelTheme;

  @override
  Widget build(BuildContext context) {
    final String type = component.componentTypeId ?? component.componentId;
    if (type.contains('hero')) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 96,
            height: 10,
            decoration: BoxDecoration(
              color: panelTheme.textPrimary,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            height: 24,
            decoration: BoxDecoration(
              color: panelTheme.textPrimary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(height: 48),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: panelTheme.accent,
              borderRadius: BorderRadius.circular(999),
            ),
            child: const Text(
              'Play',
              style: TextStyle(
                color: Color(0xFF07111F),
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      );
    }

    if (type.contains('button')) {
      return Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: panelTheme.accent,
            borderRadius: BorderRadius.circular(999),
          ),
          child: const Text(
            'Action',
            style: TextStyle(
              color: Color(0xFF07111F),
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      );
    }

    if (type.contains('search')) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: panelTheme.surfaceRaised,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: panelTheme.outlineStrong),
        ),
        child: Text(
          'Search...',
          style: TextStyle(color: panelTheme.textMuted),
        ),
      );
    }

    if (type.contains('chip')) {
      return Align(
        alignment: Alignment.topLeft,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: panelTheme.textPrimary,
            borderRadius: BorderRadius.circular(999),
          ),
          child: const Text(
            'Genre',
            style: TextStyle(
              color: Color(0xFF07111F),
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      );
    }

    if (type.contains('progress')) {
      return Align(
        alignment: Alignment.centerLeft,
        child: Container(
          width: double.infinity,
          height: 10,
          decoration: BoxDecoration(
            color: panelTheme.textPrimary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(999),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: 0.56,
            child: Container(
              decoration: BoxDecoration(
                color: panelTheme.accent,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: double.infinity,
          height: 76,
          decoration: BoxDecoration(
            color: panelTheme.textPrimary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: 110,
          height: 10,
          decoration: BoxDecoration(
            color: panelTheme.textPrimary,
            borderRadius: BorderRadius.circular(999),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: 80,
          height: 10,
          decoration: BoxDecoration(
            color: panelTheme.textPrimary.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(999),
          ),
        ),
      ],
    );
  }
}

class _PanelActionBar extends StatelessWidget {
  const _PanelActionBar({
    required this.controller,
    required this.panelTheme,
  });

  final AdvancedCustomizerController controller;
  final _PanelThemeData panelTheme;

  @override
  Widget build(BuildContext context) {
    final AdvancedCustomizerPanelController panelController =
        AdvancedCustomizerPanelController(controller);

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool compact = constraints.maxWidth < 520;
        if (compact) {
          return Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.end,
            children: <Widget>[
              OutlinedButton(
                onPressed: panelController.onDiscardPressed,
                child: Text(controller.panelStrings.discardLabel),
              ),
              TextButton(
                onPressed: panelController.onUndoPressed,
                child: Text(controller.panelStrings.undoLabel),
              ),
              FilledButton(
                onPressed: panelController.onApplyPressed,
                child: Text(controller.panelStrings.applyLabel),
              ),
            ],
          );
        }

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
      },
    );
  }
}

class _UnifiedColorPicker extends StatelessWidget {
  const _UnifiedColorPicker({
    required this.color,
    required this.swatches,
    required this.panelTheme,
    required this.onChanged,
  });

  final Color color;
  final List<Color> swatches;
  final _PanelThemeData panelTheme;
  final ValueChanged<Color> onChanged;

  @override
  Widget build(BuildContext context) {
    final HSVColor hsvColor = HSVColor.fromColor(color);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: panelTheme.surfaceRaised,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: panelTheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: panelTheme.outlineStrong),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Color picker',
                      style: TextStyle(
                        color: panelTheme.textPrimary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '#${color.toARGB32().toRadixString(16).padLeft(8, '0').toUpperCase()}',
                      style: TextStyle(color: panelTheme.textMuted),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'H ${hsvColor.hue.round()}  S ${(hsvColor.saturation * 100).round()}  B ${(hsvColor.value * 100).round()}',
                      style: TextStyle(color: panelTheme.textMuted),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _ColorSlider(
            label: 'Hue',
            value: hsvColor.hue,
            max: 360,
            displayValue: hsvColor.hue.round().toString(),
            gradient: const <Color>[
              Color(0xFFFF004D),
              Color(0xFFFFA600),
              Color(0xFFFFFF00),
              Color(0xFF00D26A),
              Color(0xFF00C2FF),
              Color(0xFF3B5BFF),
              Color(0xFF9C27B0),
              Color(0xFFFF004D),
            ],
            panelTheme: panelTheme,
            onChanged: (double value) {
              onChanged(
                hsvColor.withHue(value.clamp(0, 360)).toColor(),
              );
            },
          ),
          _ColorSlider(
            label: 'Saturation',
            value: hsvColor.saturation * 100,
            max: 100,
            displayValue: '${(hsvColor.saturation * 100).round()}%',
            gradient: <Color>[
              hsvColor.withSaturation(0).toColor(),
              hsvColor.withSaturation(1).toColor(),
            ],
            panelTheme: panelTheme,
            onChanged: (double value) {
              onChanged(
                hsvColor.withSaturation((value / 100).clamp(0, 1)).toColor(),
              );
            },
          ),
          _ColorSlider(
            label: 'Brightness',
            value: hsvColor.value * 100,
            max: 100,
            displayValue: '${(hsvColor.value * 100).round()}%',
            gradient: <Color>[
              Colors.black,
              hsvColor.withValue(1).toColor(),
            ],
            panelTheme: panelTheme,
            onChanged: (double value) {
              onChanged(
                hsvColor.withValue((value / 100).clamp(0, 1)).toColor(),
              );
            },
          ),
          _ColorSlider(
            label: 'Opacity',
            value: color.a * 100,
            max: 100,
            displayValue: '${(color.a * 100).round()}%',
            gradient: <Color>[
              color.withValues(alpha: 0.12),
              color.withValues(alpha: 1),
            ],
            panelTheme: panelTheme,
            onChanged: (double value) {
              onChanged(
                color.withValues(alpha: (value / 100).clamp(0, 1)),
              );
            },
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: swatches.map((Color swatch) {
              return InkWell(
                onTap: () => onChanged(swatch),
                borderRadius: BorderRadius.circular(999),
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: swatch,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: panelTheme.outlineStrong),
                  ),
                ),
              );
            }).toList(growable: false),
          ),
        ],
      ),
    );
  }
}

class _ColorSlider extends StatelessWidget {
  const _ColorSlider({
    required this.label,
    required this.value,
    required this.max,
    required this.displayValue,
    required this.gradient,
    required this.panelTheme,
    required this.onChanged,
  });

  final String label;
  final double value;
  final double max;
  final String displayValue;
  final List<Color> gradient;
  final _PanelThemeData panelTheme;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(
              label,
              style: TextStyle(
                color: panelTheme.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Spacer(),
            Text(
              displayValue,
              style: TextStyle(
                color: panelTheme.textMuted,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          height: 28,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: gradient),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: panelTheme.outlineStrong),
          ),
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: Colors.transparent,
              inactiveTrackColor: Colors.transparent,
              thumbColor: panelTheme.textPrimary,
              overlayColor: panelTheme.textPrimary.withValues(alpha: 0.12),
              trackHeight: 28,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 9),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
            ),
            child: Slider(
              value: value.clamp(0, max),
              max: max,
              onChanged: onChanged,
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}

