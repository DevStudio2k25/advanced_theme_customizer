import 'package:advanced_theme_customizer/advanced_theme_customizer.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const DemoCustomizerApp());
}

const AdvancedComponentRegistry kRegistry = AdvancedComponentRegistry(
  pages: <AdvancedPageDescriptor>[
    AdvancedPageDescriptor(pageId: 'home', displayName: 'Home'),
    AdvancedPageDescriptor(pageId: 'profile', displayName: 'Profile'),
  ],
  groups: <AdvancedComponentGroupDescriptor>[
    AdvancedComponentGroupDescriptor(
      groupId: 'home.cards',
      pageId: 'home',
      displayName: 'Home Cards',
    ),
    AdvancedComponentGroupDescriptor(
      groupId: 'home.actions',
      pageId: 'home',
      displayName: 'Home Actions',
    ),
    AdvancedComponentGroupDescriptor(
      groupId: 'profile.cards',
      pageId: 'profile',
      displayName: 'Profile Cards',
    ),
    AdvancedComponentGroupDescriptor(
      groupId: 'profile.actions',
      pageId: 'profile',
      displayName: 'Profile Actions',
    ),
  ],
  components: <AdvancedComponentDescriptor>[
    AdvancedComponentDescriptor(
      componentId: 'home.card.hero',
      pageId: 'home',
      groupId: 'home.cards',
      componentTypeId: 'card.hero',
      displayName: 'Home Hero Card',
    ),
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
      componentId: 'profile.card.summary',
      pageId: 'profile',
      groupId: 'profile.cards',
      componentTypeId: 'card.summary',
      displayName: 'Profile Summary Card',
    ),
    AdvancedComponentDescriptor(
      componentId: 'profile.button.primary',
      pageId: 'profile',
      groupId: 'profile.actions',
      componentTypeId: 'button.primary',
      displayName: 'Profile Primary Button',
    ),
  ],
);

class DemoCustomizerApp extends StatefulWidget {
  const DemoCustomizerApp({super.key});

  @override
  State<DemoCustomizerApp> createState() => _DemoCustomizerAppState();
}

class _DemoCustomizerAppState extends State<DemoCustomizerApp> {
  late final AdvancedCustomizerController _controller;
  int _currentIndex = 0;

  String get _activePageId => _currentIndex == 0 ? 'home' : 'profile';

  @override
  void initState() {
    super.initState();
    _controller = AdvancedCustomizerController(
      config: const AdvancedCustomizerConfig(registry: kRegistry),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF006A6A)),
        useMaterial3: true,
      ),
      home: AdvancedCustomizerPreviewBridge(
        controller: _controller,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Advanced Theme Customizer Demo'),
            actions: <Widget>[
              IconButton(
                tooltip: 'Page Customizer',
                onPressed: () {
                  openPageModeCustomizer<void>(
                    context: context,
                    controller: _controller,
                    pageId: _activePageId,
                  );
                },
                icon: const Icon(Icons.tune),
              ),
            ],
          ),
          body: SafeArea(
            child: IndexedStack(
              index: _currentIndex,
              children: const <Widget>[_HomePage(), _ProfilePage()],
            ),
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: _currentIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _currentIndex = index;
              });
            },
            destinations: const <NavigationDestination>[
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outline),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomePage extends StatelessWidget {
  const _HomePage();

  @override
  Widget build(BuildContext context) {
    return AdvancedCustomizerInPagePreviewContainer(
      pageId: 'home',
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final bool wide = constraints.maxWidth >= 820;
          final Widget card = _ResolvedCard(
            componentKey: 'home.card.hero',
            title: 'Weekly Revenue',
            subtitle: '?1,24,500 (+12.4%)',
          );

          final Widget actions = Wrap(
            spacing: 12,
            runSpacing: 12,
            children: const <Widget>[
              _ResolvedButton(
                componentKey: 'home.button.primary',
                label: 'Approve',
              ),
              _ResolvedButton(
                componentKey: 'home.button.secondary',
                label: 'Review',
              ),
            ],
          );

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: wide
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(child: card),
                      const SizedBox(width: 20),
                      Expanded(child: actions),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      card,
                      const SizedBox(height: 20),
                      actions,
                    ],
                  ),
          );
        },
      ),
    );
  }
}

class _ProfilePage extends StatelessWidget {
  const _ProfilePage();

  @override
  Widget build(BuildContext context) {
    return AdvancedCustomizerInPagePreviewContainer(
      pageId: 'profile',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const <Widget>[
            _ResolvedCard(
              componentKey: 'profile.card.summary',
              title: 'Account Health',
              subtitle: 'All checks passed',
            ),
            SizedBox(height: 16),
            _ResolvedButton(
              componentKey: 'profile.button.primary',
              label: 'Save Profile',
            ),
          ],
        ),
      ),
    );
  }
}

class _ResolvedCard extends StatelessWidget {
  const _ResolvedCard({
    required this.componentKey,
    required this.title,
    required this.subtitle,
  });

  final String componentKey;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return AdvancedCustomizerResolvedColor(
      componentKey: componentKey,
      property: AdvancedCustomizerProperty.fill,
      fallbackColor: scheme.surface,
      builder: (BuildContext context, Color? fill) {
        return AdvancedCustomizerResolvedColor(
          componentKey: componentKey,
          property: AdvancedCustomizerProperty.border,
          fallbackColor: scheme.outlineVariant,
          builder: (BuildContext context, Color? border) {
            return AdvancedCustomizerResolvedColor(
              componentKey: componentKey,
              property: AdvancedCustomizerProperty.text,
              fallbackColor: scheme.onSurface,
              builder: (BuildContext context, Color? textColor) {
                return AdvancedCustomizerResolvedDouble(
                  componentKey: componentKey,
                  property: AdvancedCustomizerProperty.radius,
                  fallbackValue: 16,
                  builder: (BuildContext context, double? radius) {
                    return Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: fill,
                        borderRadius: BorderRadius.circular(radius ?? 16),
                        border: Border.all(
                          color: border ?? scheme.outlineVariant,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            title,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: textColor,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            subtitle,
                            style: Theme.of(
                              context,
                            ).textTheme.bodyLarge?.copyWith(color: textColor),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}

class _ResolvedButton extends StatelessWidget {
  const _ResolvedButton({required this.componentKey, required this.label});

  final String componentKey;
  final String label;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return AdvancedCustomizerResolvedColor(
      componentKey: componentKey,
      property: AdvancedCustomizerProperty.fill,
      fallbackColor: scheme.primary,
      builder: (BuildContext context, Color? fill) {
        return AdvancedCustomizerResolvedColor(
          componentKey: componentKey,
          property: AdvancedCustomizerProperty.text,
          fallbackColor: scheme.onPrimary,
          builder: (BuildContext context, Color? text) {
            return AdvancedCustomizerResolvedColor(
              componentKey: componentKey,
              property: AdvancedCustomizerProperty.border,
              fallbackColor: fill,
              builder: (BuildContext context, Color? border) {
                return AdvancedCustomizerResolvedDouble(
                  componentKey: componentKey,
                  property: AdvancedCustomizerProperty.radius,
                  fallbackValue: 12,
                  builder: (BuildContext context, double? radius) {
                    return AdvancedCustomizerResolvedDouble(
                      componentKey: componentKey,
                      property: AdvancedCustomizerProperty.borderWidth,
                      fallbackValue: 1,
                      builder: (BuildContext context, double? borderWidth) {
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: fill,
                            foregroundColor: text,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(radius ?? 12),
                              side: BorderSide(
                                color: border ?? Colors.transparent,
                                width: borderWidth ?? 1,
                              ),
                            ),
                          ),
                          onPressed: () {},
                          child: Text(label),
                        );
                      },
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
