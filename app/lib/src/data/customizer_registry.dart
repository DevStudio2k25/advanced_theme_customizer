import 'package:advanced_theme_customizer/advanced_theme_customizer.dart';
import 'package:flutter/material.dart';

import '../data/anime_data.dart';
import '../widgets/anime_card.dart';
import '../widgets/feature_widgets.dart';
import '../widgets/resolved_button.dart';
import '../widgets/search_box.dart';

final AdvancedComponentRegistry animeCustomizerRegistry =
    AdvancedComponentRegistry(
      pages: <AdvancedPageDescriptor>[
        AdvancedPageDescriptor(pageId: 'home', displayName: 'Home'),
        AdvancedPageDescriptor(pageId: 'discover', displayName: 'Discover'),
        AdvancedPageDescriptor(pageId: 'watchlist', displayName: 'Watchlist'),
      ],
      groups: <AdvancedComponentGroupDescriptor>[
        AdvancedComponentGroupDescriptor(
          groupId: 'shell',
          pageId: 'home',
          displayName: 'Shell',
        ),
        AdvancedComponentGroupDescriptor(
          groupId: 'hero',
          pageId: 'home',
          displayName: 'Hero',
        ),
        AdvancedComponentGroupDescriptor(
          groupId: 'cards',
          pageId: 'home',
          displayName: 'Cards',
        ),
        AdvancedComponentGroupDescriptor(
          groupId: 'search',
          pageId: 'discover',
          displayName: 'Search',
        ),
        AdvancedComponentGroupDescriptor(
          groupId: 'results',
          pageId: 'discover',
          displayName: 'Results',
        ),
        AdvancedComponentGroupDescriptor(
          groupId: 'watchlist',
          pageId: 'watchlist',
          displayName: 'Watchlist',
        ),
      ],
      components: <AdvancedComponentDescriptor>[
        AdvancedComponentDescriptor(
          componentId: 'app.shell.navbar',
          pageId: 'home',
          groupId: 'shell',
          componentTypeId: 'shell.navbar',
          displayName: 'Bottom Navigation',
        ),
        AdvancedComponentDescriptor(
          componentId: 'home.hero.banner',
          pageId: 'home',
          groupId: 'hero',
          componentTypeId: 'hero.banner',
          displayName: 'Hero Banner',
          previewBuilder: _buildHeroPreview,
        ),
        AdvancedComponentDescriptor(
          componentId: 'home.hero.play',
          pageId: 'home',
          groupId: 'hero',
          componentTypeId: 'hero.button',
          displayName: 'Hero Play Button',
          previewBuilder: _buildHeroPlayPreview,
        ),
        AdvancedComponentDescriptor(
          componentId: 'home.card.item',
          pageId: 'home',
          groupId: 'cards',
          componentTypeId: 'card.item',
          displayName: 'Anime Card',
          previewBuilder: _buildHomeCardPreview,
        ),
        AdvancedComponentDescriptor(
          componentId: 'discover.search.input',
          pageId: 'discover',
          groupId: 'search',
          componentTypeId: 'search.input',
          displayName: 'Search Input',
          previewBuilder: _buildSearchPreview,
        ),
        AdvancedComponentDescriptor(
          componentId: 'discover.genre.chip',
          pageId: 'discover',
          groupId: 'search',
          componentTypeId: 'genre.chip',
          displayName: 'Genre Chip',
          previewBuilder: _buildGenrePreview,
        ),
        AdvancedComponentDescriptor(
          componentId: 'discover.result.card',
          pageId: 'discover',
          groupId: 'results',
          componentTypeId: 'result.card',
          displayName: 'Result Card',
          previewBuilder: _buildDiscoverCardPreview,
        ),
        AdvancedComponentDescriptor(
          componentId: 'watchlist.item.card',
          pageId: 'watchlist',
          groupId: 'watchlist',
          componentTypeId: 'watchlist.card',
          displayName: 'Watchlist Card',
          previewBuilder: _buildWatchlistPreview,
        ),
        AdvancedComponentDescriptor(
          componentId: 'watchlist.progress.bar',
          pageId: 'watchlist',
          groupId: 'watchlist',
          componentTypeId: 'watchlist.progress',
          displayName: 'Progress Bar',
          previewBuilder: _buildProgressPreview,
        ),
      ],
    );

Widget _buildHeroPreview(
  BuildContext context,
  AdvancedComponentDescriptor component,
) {
  return const HeroPromoCard(compact: true);
}

Widget _buildHeroPlayPreview(
  BuildContext context,
  AdvancedComponentDescriptor component,
) {
  return const Center(
    child: ResolvedButton(
      componentKey: 'home.hero.play',
      label: 'Play Now',
      icon: Icons.play_arrow_rounded,
      fallbackFill: Color(0xFF00B5D8),
      fallbackText: Color(0xFF001826),
    ),
  );
}

Widget _buildHomeCardPreview(
  BuildContext context,
  AdvancedComponentDescriptor component,
) {
  return Align(
    alignment: Alignment.topLeft,
    child: HorizontalAnimeCard(
      item: trendingAnime.first,
      componentKey: component.componentId,
    ),
  );
}

Widget _buildSearchPreview(
  BuildContext context,
  AdvancedComponentDescriptor component,
) {
  return const IgnorePointer(
    child: SearchBox(value: '', onChanged: _noopSearchChange),
  );
}

Widget _buildGenrePreview(
  BuildContext context,
  AdvancedComponentDescriptor component,
) {
  return const Align(
    alignment: Alignment.topLeft,
    child: GenrePreviewChip(selected: true, label: 'Action'),
  );
}

Widget _buildDiscoverCardPreview(
  BuildContext context,
  AdvancedComponentDescriptor component,
) {
  return Align(
    alignment: Alignment.topLeft,
    child: DiscoverAnimeCard(item: discoverAnime.first),
  );
}

Widget _buildWatchlistPreview(
  BuildContext context,
  AdvancedComponentDescriptor component,
) {
  return Align(
    alignment: Alignment.topLeft,
    child: WatchlistTile(item: watchlistAnime.first),
  );
}

Widget _buildProgressPreview(
  BuildContext context,
  AdvancedComponentDescriptor component,
) {
  return const Align(
    alignment: Alignment.centerLeft,
    child: WatchlistProgressBar(progress: 0.56),
  );
}

void _noopSearchChange(String value) {}
