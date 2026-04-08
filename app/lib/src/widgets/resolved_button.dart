import 'package:advanced_theme_customizer/advanced_theme_customizer.dart';
import 'package:flutter/material.dart';

class ResolvedButton extends StatelessWidget {
  const ResolvedButton({
    super.key,
    required this.componentKey,
    required this.label,
    required this.icon,
    required this.fallbackFill,
    required this.fallbackText,
    this.compact = false,
  });

  final String componentKey;
  final String label;
  final IconData icon;
  final Color fallbackFill;
  final Color fallbackText;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return AdvancedCustomizerResolvedColor(
      componentKey: componentKey,
      property: AdvancedCustomizerProperty.fill,
      fallbackColor: fallbackFill,
      builder: (BuildContext context, Color? fill) {
        return AdvancedCustomizerResolvedColor(
          componentKey: componentKey,
          property: AdvancedCustomizerProperty.text,
          fallbackColor: fallbackText,
          builder: (BuildContext context, Color? text) {
            return AdvancedCustomizerResolvedColor(
              componentKey: componentKey,
              property: AdvancedCustomizerProperty.border,
              fallbackColor: fill,
              builder: (BuildContext context, Color? border) {
                return AdvancedCustomizerResolvedDouble(
                  componentKey: componentKey,
                  property: AdvancedCustomizerProperty.radius,
                  fallbackValue: compact ? 12 : 16,
                  builder: (BuildContext context, double? radius) {
                    return AdvancedCustomizerResolvedDouble(
                      componentKey: componentKey,
                      property: AdvancedCustomizerProperty.borderWidth,
                      fallbackValue: 1,
                      builder: (BuildContext context, double? borderWidth) {
                        return ElevatedButton.icon(
                          onPressed: () {},
                          icon: Icon(icon, size: compact ? 16 : 20),
                          label: Text(label),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: fill,
                            foregroundColor: text,
                            side: BorderSide(
                              color: border ?? Colors.transparent,
                              width: borderWidth ?? 1,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(radius ?? 14),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: compact ? 12 : 18,
                              vertical: compact ? 8 : 12,
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
