import 'package:flutter/material.dart';

import '../models/anime_item.dart';
import 'resolved_button.dart';
import 'resolved_surface.dart';

class HeroPromoCard extends StatelessWidget {
  const HeroPromoCard({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final Widget copyBlock = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Skyline Rebirth',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'A ruined floating city gets one last chance through a rogue pilot and a forgotten core.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Colors.white.withValues(alpha: 0.9),
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: const <Widget>[
            _MetaChip(text: 'Sci-Fi'),
            _MetaChip(text: '13 Episodes'),
            _MetaChip(text: '8.4 Rating'),
          ],
        ),
        const SizedBox(height: 18),
        const ResolvedButton(
          componentKey: 'home.hero.play',
          label: 'Play Now',
          icon: Icons.play_arrow_rounded,
          fallbackFill: Color(0xFF00B5D8),
          fallbackText: Color(0xFF001826),
        ),
      ],
    );
    final Widget previewBlock = AspectRatio(
      aspectRatio: 16 / 9,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: <Color>[Color(0xFF0F172A), Color(0xFF3B2A61)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: const Center(
            child: Icon(
              Icons.play_circle_fill_rounded,
              size: 72,
              color: Colors.white70,
            ),
          ),
        ),
      ),
    );

    return ResolvedSurface(
      componentKey: 'home.hero.banner',
      padding: const EdgeInsets.all(20),
      fallbackFill: const Color(0xFF172542),
      fallbackBorder: const Color(0xFF27406B),
      fallbackRadius: 24,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: <Color>[Color(0xFF1A2555), Color(0xFF541D5C)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: compact
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    copyBlock,
                    const SizedBox(height: 18),
                    previewBlock,
                  ],
                )
              : LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    final bool wide = constraints.maxWidth >= 900;
                    return wide
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(flex: 5, child: copyBlock),
                              const SizedBox(width: 18),
                              Expanded(flex: 4, child: previewBlock),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              copyBlock,
                              const SizedBox(height: 18),
                              previewBlock,
                            ],
                          );
                  },
                ),
        ),
      ),
    );
  }
}

class GenrePreviewChip extends StatelessWidget {
  const GenrePreviewChip({
    super.key,
    required this.selected,
    required this.label,
    this.onTap,
  });

  final bool selected;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ResolvedSurface(
      componentKey: 'discover.genre.chip',
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      fallbackFill: selected
          ? const Color(0xFF00B5D8)
          : const Color(0xFF121A2C),
      fallbackBorder: const Color(0xFF395680),
      fallbackRadius: 999,
      fallbackText: selected ? const Color(0xFF001828) : Colors.white,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Text(label),
      ),
    );
  }
}

class WatchlistProgressBar extends StatelessWidget {
  const WatchlistProgressBar({super.key, required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    return ResolvedSurface(
      componentKey: 'watchlist.progress.bar',
      padding: EdgeInsets.zero,
      fallbackFill: const Color(0xFF1A2740),
      fallbackBorder: const Color(0xFF334D73),
      fallbackRadius: 999,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(999),
        child: SizedBox(
          height: 10,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Container(color: Colors.white.withValues(alpha: 0.12)),
              FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: progress.clamp(0, 1),
                child: Container(color: const Color(0xFF00B5D8)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WatchlistTile extends StatelessWidget {
  const WatchlistTile({super.key, required this.item});

  final AnimeItem item;

  @override
  Widget build(BuildContext context) {
    return ResolvedSurface(
      componentKey: 'watchlist.item.card',
      padding: const EdgeInsets.all(14),
      fallbackFill: const Color(0xFF101629),
      fallbackBorder: const Color(0xFF2A3E5E),
      fallbackRadius: 18,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              CircleAvatar(
                backgroundColor: item.accent,
                child: const Icon(Icons.tv, color: Colors.white),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      item.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      item.tagline,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const ResolvedButton(
                componentKey: 'home.hero.play',
                label: 'Resume',
                icon: Icons.play_arrow,
                compact: true,
                fallbackFill: Color(0xFF00B5D8),
                fallbackText: Color(0xFF001826),
              ),
            ],
          ),
          const SizedBox(height: 12),
          WatchlistProgressBar(progress: item.progress),
          const SizedBox(height: 6),
          Text(
            'Progress ${(item.progress * 100).round()}% • ${item.episodes} episodes',
          ),
        ],
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.22)),
      ),
      child: Text(text, style: const TextStyle(color: Colors.white)),
    );
  }
}
