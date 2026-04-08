import 'package:flutter/material.dart';

import '../models/anime_item.dart';
import 'resolved_surface.dart';

class HorizontalAnimeCard extends StatelessWidget {
  const HorizontalAnimeCard({
    super.key,
    required this.item,
    required this.componentKey,
  });

  final AnimeItem item;
  final String componentKey;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      child: ResolvedSurface(
        componentKey: componentKey,
        padding: const EdgeInsets.all(12),
        fallbackFill: const Color(0xFF11192C),
        fallbackBorder: const Color(0xFF2E4466),
        fallbackRadius: 18,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: <Color>[item.accent, Colors.black87],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: const Center(
                    child: Icon(Icons.movie_creation_outlined, size: 32),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(item.title, maxLines: 1, overflow: TextOverflow.ellipsis),
            Text(
              '${item.genre} • ${item.rating}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class DiscoverAnimeCard extends StatelessWidget {
  const DiscoverAnimeCard({super.key, required this.item});

  final AnimeItem item;

  @override
  Widget build(BuildContext context) {
    return ResolvedSurface(
      componentKey: 'discover.result.card',
      padding: const EdgeInsets.all(14),
      fallbackFill: const Color(0xFF11182A),
      fallbackBorder: const Color(0xFF32486A),
      fallbackRadius: 18,
      child: Row(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 0.75,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: <Color>[item.accent, Colors.black87],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Icon(Icons.movie_filter, color: Colors.white70),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(item.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Text(
                  item.tagline,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const Spacer(),
                Text('${item.genre} • ${item.episodes} ep • ${item.rating}'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class WatchlistAnimeCard extends StatelessWidget {
  const WatchlistAnimeCard({
    super.key,
    required this.item,
    required this.child,
  });

  final AnimeItem item;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ResolvedSurface(
      componentKey: 'watchlist.item.card',
      padding: const EdgeInsets.all(14),
      fallbackFill: const Color(0xFF101629),
      fallbackBorder: const Color(0xFF2A3E5E),
      fallbackRadius: 18,
      child: child,
    );
  }
}
