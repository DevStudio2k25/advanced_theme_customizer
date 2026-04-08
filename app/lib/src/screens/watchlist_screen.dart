import 'package:advanced_theme_customizer/advanced_theme_customizer.dart';
import 'package:flutter/material.dart';

import '../data/anime_data.dart';
import '../models/anime_item.dart';
import '../widgets/feature_widgets.dart';
import '../widgets/section_title.dart';

class WatchlistScreen extends StatelessWidget {
  const WatchlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AdvancedCustomizerInPagePreviewContainer(
      pageId: 'watchlist',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SectionTitle(
              title: 'Your Watchlist',
              subtitle: 'Resume episodes from where you stopped',
            ),
            const SizedBox(height: 14),
            ...watchlistAnime.map(
              (AnimeItem item) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: WatchlistTile(item: item),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
