import 'package:flutter/material.dart';

import '../models/anime_item.dart';

const List<AnimeItem> trendingAnime = <AnimeItem>[
  AnimeItem(
    title: 'Blade of Dawn',
    tagline: 'Chosen warrior awakens an ancient edge.',
    genre: 'Action',
    episodes: 24,
    rating: 8.9,
    accent: Color(0xFFB22222),
  ),
  AnimeItem(
    title: 'Skyline Rebirth',
    tagline: 'One last pilot keeps a floating city alive.',
    genre: 'Sci-Fi',
    episodes: 12,
    rating: 8.4,
    accent: Color(0xFF4169E1),
  ),
  AnimeItem(
    title: 'Echoes of Kyoto',
    tagline: 'Old spirits return through forbidden music.',
    genre: 'Mystery',
    episodes: 16,
    rating: 8.5,
    accent: Color(0xFF8B5A2B),
  ),
];

const List<AnimeItem> discoverAnime = <AnimeItem>[
  AnimeItem(
    title: 'Prism Circuit',
    tagline: 'Arena pilots fight through neon storms.',
    genre: 'Sci-Fi',
    episodes: 13,
    rating: 8.1,
    accent: Color(0xFF7B68EE),
  ),
  AnimeItem(
    title: 'Silent Shrine',
    tagline: 'A village hides an immortal curse.',
    genre: 'Horror',
    episodes: 10,
    rating: 7.8,
    accent: Color(0xFF2F4F4F),
  ),
  AnimeItem(
    title: 'Summer Court',
    tagline: 'Romance blooms during tournament season.',
    genre: 'Romance',
    episodes: 22,
    rating: 7.9,
    accent: Color(0xFFFF6F61),
  ),
  AnimeItem(
    title: 'Iron Atlas',
    tagline: 'A mechanic maps worlds by rail.',
    genre: 'Adventure',
    episodes: 26,
    rating: 8.2,
    accent: Color(0xFF556B2F),
  ),
  AnimeItem(
    title: 'Moonline Academy',
    tagline: 'Students unlock power by stargazing.',
    genre: 'Fantasy',
    episodes: 14,
    rating: 8.0,
    accent: Color(0xFF483D8B),
  ),
  AnimeItem(
    title: 'Ghostwire Unit',
    tagline: 'Agents hunt signals from another layer.',
    genre: 'Thriller',
    episodes: 18,
    rating: 8.3,
    accent: Color(0xFF4682B4),
  ),
];

const List<AnimeItem> watchlistAnime = <AnimeItem>[
  AnimeItem(
    title: 'Blade of Dawn',
    tagline: 'Episode 15: Crimson Duel',
    genre: 'Action',
    episodes: 24,
    rating: 8.9,
    accent: Color(0xFFB22222),
    progress: 0.64,
  ),
  AnimeItem(
    title: 'Moonline Academy',
    tagline: 'Episode 08: Lunar Trial',
    genre: 'Fantasy',
    episodes: 14,
    rating: 8.0,
    accent: Color(0xFF483D8B),
    progress: 0.35,
  ),
  AnimeItem(
    title: 'Iron Atlas',
    tagline: 'Episode 03: Cold Junction',
    genre: 'Adventure',
    episodes: 26,
    rating: 8.2,
    accent: Color(0xFF556B2F),
    progress: 0.12,
  ),
];

const List<String> animeGenres = <String>[
  'All',
  'Action',
  'Sci-Fi',
  'Fantasy',
  'Adventure',
  'Romance',
  'Thriller',
  'Horror',
  'Mystery',
];
