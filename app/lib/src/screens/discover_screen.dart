import 'package:advanced_theme_customizer/advanced_theme_customizer.dart';
import 'package:flutter/material.dart';

import '../data/anime_data.dart';
import '../models/anime_item.dart';
import '../widgets/anime_card.dart';
import '../widgets/feature_widgets.dart';
import '../widgets/search_box.dart';
import '../widgets/section_title.dart';

class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({
    super.key,
    required this.query,
    required this.activeGenre,
    required this.onQueryChanged,
    required this.onGenreChanged,
  });

  final String query;
  final String activeGenre;
  final ValueChanged<String> onQueryChanged;
  final ValueChanged<String> onGenreChanged;

  @override
  Widget build(BuildContext context) {
    final String normalized = query.trim().toLowerCase();
    final List<AnimeItem> filtered = discoverAnime
        .where((AnimeItem item) {
          final bool genrePass =
              activeGenre == 'All' || item.genre == activeGenre;
          if (!genrePass) {
            return false;
          }
          if (normalized.isEmpty) {
            return true;
          }
          return item.title.toLowerCase().contains(normalized) ||
              item.genre.toLowerCase().contains(normalized) ||
              item.tagline.toLowerCase().contains(normalized);
        })
        .toList(growable: false);

    return AdvancedCustomizerInPagePreviewContainer(
      pageId: 'discover',
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final int columns = constraints.maxWidth >= 1100
              ? 3
              : constraints.maxWidth >= 700
              ? 2
              : 1;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SectionTitle(
                  title: 'Discover Anime',
                  subtitle: 'Search, filter and pick your next binge',
                ),
                const SizedBox(height: 14),
                SearchBox(value: query, onChanged: onQueryChanged),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: animeGenres
                      .map((String genre) {
                        final bool selected = genre == activeGenre;
                        return GenrePreviewChip(
                          selected: selected,
                          label: genre,
                          onTap: () => onGenreChanged(genre),
                        );
                      })
                      .toList(growable: false),
                ),
                const SizedBox(height: 18),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filtered.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: columns == 1 ? 2.6 : 1.55,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return DiscoverAnimeCard(item: filtered[index]);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
