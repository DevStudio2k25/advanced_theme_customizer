import 'package:advanced_theme_customizer/advanced_theme_customizer.dart';
import 'package:flutter/material.dart';

import '../data/anime_data.dart';
import '../widgets/anime_card.dart';
import '../widgets/feature_widgets.dart';
import '../widgets/section_title.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AdvancedCustomizerInPagePreviewContainer(
      pageId: 'home',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const HeroPromoCard(),
            const SizedBox(height: 24),
            const SectionTitle(
              title: 'Trending Right Now',
              subtitle: 'Popular picks from this week',
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 205,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: trendingAnime.length,
                separatorBuilder: (BuildContext context, int index) =>
                    const SizedBox(width: 12),
                itemBuilder: (BuildContext context, int index) {
                  return HorizontalAnimeCard(
                    item: trendingAnime[index],
                    componentKey: 'home.card.item',
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            const SectionTitle(
              title: 'Continue Watching',
              subtitle: 'Resume from where you stopped',
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 205,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: watchlistAnime.length,
                separatorBuilder: (BuildContext context, int index) =>
                    const SizedBox(width: 12),
                itemBuilder: (BuildContext context, int index) {
                  return HorizontalAnimeCard(
                    item: watchlistAnime[index],
                    componentKey: 'home.card.item',
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
