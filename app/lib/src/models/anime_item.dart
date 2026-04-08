import 'package:flutter/material.dart';

class AnimeItem {
  const AnimeItem({
    required this.title,
    required this.tagline,
    required this.genre,
    required this.episodes,
    required this.rating,
    required this.accent,
    this.progress = 0,
  });

  final String title;
  final String tagline;
  final String genre;
  final int episodes;
  final double rating;
  final Color accent;
  final double progress;
}
