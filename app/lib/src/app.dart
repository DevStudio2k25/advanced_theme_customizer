import 'package:advanced_theme_customizer/advanced_theme_customizer.dart';
import 'package:flutter/material.dart';

import 'data/customizer_registry.dart';
import 'screens/discover_screen.dart';
import 'screens/home_screen.dart';
import 'screens/watchlist_screen.dart';
import 'theme/app_theme.dart';
import 'widgets/resolved_surface.dart';

void runAnimeApp() {
  runApp(const RealCustomizerApp());
}

class RealCustomizerApp extends StatefulWidget {
  const RealCustomizerApp({super.key});

  @override
  State<RealCustomizerApp> createState() => _RealCustomizerAppState();
}

class _RealCustomizerAppState extends State<RealCustomizerApp> {
  late final AdvancedCustomizerController _controller;
  int _currentIndex = 0;
  String _searchQuery = '';
  String _activeGenre = 'All';

  static const List<String> _pageIds = <String>[
    'home',
    'discover',
    'watchlist',
  ];

  String get _activePageId => _pageIds[_currentIndex];

  @override
  void initState() {
    super.initState();
    _controller = AdvancedCustomizerController(
      config: AdvancedCustomizerConfig(
        registry: animeCustomizerRegistry,
        panelStrings: const AdvancedCustomizerPanelStrings(
          title: 'Theme Studio',
          componentSearchHint: 'Find UI block...',
        ),
      ),
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
      theme: buildAnimeTheme(),
      home: AdvancedCustomizerPreviewBridge(
        controller: _controller,
        child: Builder(
          builder: (BuildContext appContext) {
            return Stack(
              children: <Widget>[
                const _BackgroundDecor(),
                Scaffold(
                  backgroundColor: Colors.transparent,
                  appBar: AppBar(
                    title: const Text('Astra Anime'),
                    actions: <Widget>[
                      IconButton(
                        tooltip: 'Page Theme Studio',
                        onPressed: () {
                          openPageModeCustomizer<void>(
                            context: appContext,
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
                      children: <Widget>[
                        const HomeScreen(),
                        DiscoverScreen(
                          query: _searchQuery,
                          activeGenre: _activeGenre,
                          onQueryChanged: (String value) {
                            setState(() {
                              _searchQuery = value;
                            });
                          },
                          onGenreChanged: (String value) {
                            setState(() {
                              _activeGenre = value;
                            });
                          },
                        ),
                        const WatchlistScreen(),
                      ],
                    ),
                  ),
                  bottomNavigationBar: ResolvedSurface(
                    componentKey: 'app.shell.navbar',
                    padding: const EdgeInsets.only(top: 4),
                    fallbackFill: const Color(0xFF101729),
                    fallbackBorder: const Color(0xFF26344F),
                    fallbackRadius: 0,
                    child: NavigationBar(
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
                          icon: Icon(Icons.search),
                          label: 'Discover',
                        ),
                        NavigationDestination(
                          icon: Icon(Icons.bookmark_border),
                          label: 'Watchlist',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _BackgroundDecor extends StatelessWidget {
  const _BackgroundDecor();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[
            Color(0xFF090D18),
            Color(0xFF111A31),
            Color(0xFF090D18),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            top: -80,
            right: -40,
            child: _GlowOrb(
              size: 220,
              color: const Color(0xFF00B5D8).withValues(alpha: 0.18),
            ),
          ),
          Positioned(
            left: -90,
            bottom: 120,
            child: _GlowOrb(
              size: 260,
              color: const Color(0xFFFF5B9A).withValues(alpha: 0.12),
            ),
          ),
        ],
      ),
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(colors: <Color>[color, Colors.transparent]),
        ),
      ),
    );
  }
}
