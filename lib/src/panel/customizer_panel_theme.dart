part of 'customizer_panel.dart';

class _PanelThemeData {
  const _PanelThemeData({
    required this.background,
    required this.surface,
    required this.surfaceRaised,
    required this.previewSurface,
    required this.headerStart,
    required this.headerEnd,
    required this.accent,
    required this.accentSoft,
    required this.textPrimary,
    required this.textMuted,
    required this.outline,
    required this.outlineStrong,
    required this.danger
  });

  factory _PanelThemeData.fromController(
    AdvancedCustomizerController controller,
  ) {
    final Color accent =
        controller.panelSkin.headerColor ?? const Color(0xFF5EE6FF);
    final Color background =
        controller.panelSkin.backgroundColor ?? const Color(0xFF07111F);
    return _PanelThemeData(
      background: background,
      surface: const Color(0xFF0E1728),
      surfaceRaised: const Color(0xFF121E33),
      previewSurface: const Color(0xFF0C1630),
      headerStart: const Color(0xFF0B1527),
      headerEnd: Color.lerp(accent, const Color(0xFF0B1527), 0.72)!,
      accent: accent,
      accentSoft: accent.withValues(alpha: 0.18),
      textPrimary: const Color(0xFFF4F7FB),
      textMuted: const Color(0xFF8DA0C0),
      outline: const Color(0xFF20304D),
      outlineStrong: const Color(0xFF334B73),
      danger: const Color(0xFFFF6B6B)
    );
  }

  final Color background;
  final Color surface;
  final Color surfaceRaised;
  final Color previewSurface;
  final Color headerStart;
  final Color headerEnd;
  final Color accent;
  final Color accentSoft;
  final Color textPrimary;
  final Color textMuted;
  final Color outline;
  final Color outlineStrong;
  final Color danger;

  ThemeData buildTheme(ThemeData base) {
    final ColorScheme scheme = ColorScheme.dark(
      primary: accent,
      secondary: accent,
      surface: surface,
      onSurface: textPrimary,
      error: danger,
    );

    return base.copyWith(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      colorScheme: scheme,
      textTheme: base.textTheme.apply(
        bodyColor: textPrimary,
        displayColor: textPrimary,
      ),
      dividerColor: outline,
      cardColor: surface,
      iconTheme: IconThemeData(color: textMuted),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceRaised,
        hintStyle: TextStyle(color: textMuted),
        prefixIconColor: textMuted,
        suffixIconColor: textMuted,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: accent, width: 1.4),
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: surfaceRaised,
        disabledColor: surfaceRaised,
        selectedColor: accentSoft,
        secondarySelectedColor: accentSoft,
        side: BorderSide(color: outline),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
        labelStyle: TextStyle(
          color: textMuted,
          fontWeight: FontWeight.w600,
        ),
        secondaryLabelStyle: TextStyle(
          color: textPrimary,
          fontWeight: FontWeight.w700,
        ),
      ),
      sliderTheme: base.sliderTheme.copyWith(
        activeTrackColor: accent,
        thumbColor: accent,
        overlayColor: accent.withValues(alpha: 0.16),
        inactiveTrackColor: outlineStrong,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: accent,
          foregroundColor: const Color(0xFF07111F),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: textPrimary,
          side: BorderSide(color: outlineStrong),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: accent,
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

