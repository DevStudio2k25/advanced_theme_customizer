part of 'customizer_panel.dart';

class _WidgetCanvasTab extends StatelessWidget {
  const _WidgetCanvasTab({
    required this.controller,
    required this.panelTheme,
    required this.searchController,
    required this.searchQuery,
    required this.components,
    required this.selectedComponentId,
    required this.onPageSelected,
    required this.onComponentSelected,
  });

  final AdvancedCustomizerController controller;
  final _PanelThemeData panelTheme;
  final TextEditingController searchController;
  final String searchQuery;
  final List<AdvancedComponentDescriptor> components;
  final String? selectedComponentId;
  final ValueChanged<String> onPageSelected;
  final ValueChanged<AdvancedComponentDescriptor> onComponentSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (controller.sectionVisibility.showScopeSection)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _CompactSectionLabel(label: 'Page', panelTheme: panelTheme),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: controller.availablePageIds.map((String pageId) {
                  final bool selected = controller.effectivePageId == pageId;
                  return _PageChip(
                    label: pageId,
                    selected: selected,
                    panelTheme: panelTheme,
                    onTap: () => onPageSelected(pageId),
                  );
                }).toList(growable: false),
              ),
            ],
          ),
        if (controller.sectionVisibility.showScopeSection &&
            controller.sectionVisibility.showComponentsSection)
          const SizedBox(height: 12),
        if (controller.sectionVisibility.showComponentsSection)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _PanelSectionTitle(
                title: 'Widgets',
                panelTheme: panelTheme,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: controller.panelStrings.componentSearchHint,
                  prefixIcon: const Icon(Icons.search_rounded),
                  suffixIcon: searchQuery.isEmpty
                      ? null
                      : IconButton(
                          onPressed: searchController.clear,
                          icon: const Icon(Icons.close_rounded),
                        ),
                ),
              ),
              const SizedBox(height: 10),
              if (components.isEmpty)
                Text(
                  'Is page scope me abhi koi component match nahi hua.',
                  style: TextStyle(color: panelTheme.textMuted),
                )
              else
                LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    final double maxWidth = constraints.maxWidth;
                    final int columns = maxWidth >= 1080
                        ? 3
                        : maxWidth >= 700
                        ? 2
                        : 1;
                    final double spacing = 10;
                    final double cardWidth =
                        (maxWidth - ((columns - 1) * spacing)) / columns;

                    return Wrap(
                      spacing: spacing,
                      runSpacing: spacing,
                      children: components
                          .map((AdvancedComponentDescriptor component) {
                            return SizedBox(
                              width: cardWidth,
                              child: _ComponentPreviewCard(
                                controller: controller,
                                panelTheme: panelTheme,
                                component: component,
                                selected: component.componentId ==
                                    selectedComponentId,
                                onTap: () => onComponentSelected(component),
                              ),
                            );
                          })
                          .toList(growable: false),
                    );
                  },
                ),
            ],
          ),
      ],
    );
  }

}
