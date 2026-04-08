import 'package:advanced_theme_customizer/advanced_theme_customizer.dart';
import 'package:flutter/material.dart';

class ResolvedSurface extends StatelessWidget {
  const ResolvedSurface({
    super.key,
    required this.componentKey,
    required this.child,
    required this.padding,
    required this.fallbackFill,
    required this.fallbackBorder,
    required this.fallbackRadius,
    this.fallbackText,
  });

  final String componentKey;
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color fallbackFill;
  final Color fallbackBorder;
  final double fallbackRadius;
  final Color? fallbackText;

  @override
  Widget build(BuildContext context) {
    return AdvancedCustomizerResolvedColor(
      componentKey: componentKey,
      property: AdvancedCustomizerProperty.fill,
      fallbackColor: fallbackFill,
      builder: (BuildContext context, Color? fill) {
        return AdvancedCustomizerResolvedColor(
          componentKey: componentKey,
          property: AdvancedCustomizerProperty.border,
          fallbackColor: fallbackBorder,
          builder: (BuildContext context, Color? border) {
            return AdvancedCustomizerResolvedColor(
              componentKey: componentKey,
              property: AdvancedCustomizerProperty.text,
              fallbackColor: fallbackText,
              builder: (BuildContext context, Color? textColor) {
                return AdvancedCustomizerResolvedDouble(
                  componentKey: componentKey,
                  property: AdvancedCustomizerProperty.radius,
                  fallbackValue: fallbackRadius,
                  builder: (BuildContext context, double? radius) {
                    return AdvancedCustomizerResolvedDouble(
                      componentKey: componentKey,
                      property: AdvancedCustomizerProperty.borderWidth,
                      fallbackValue: 1,
                      builder: (BuildContext context, double? borderWidth) {
                        return DefaultTextStyle.merge(
                          style: TextStyle(color: textColor),
                          child: Container(
                            padding: padding,
                            decoration: BoxDecoration(
                              color: fill,
                              borderRadius: BorderRadius.circular(
                                radius ?? fallbackRadius,
                              ),
                              border: Border.all(
                                color: border ?? fallbackBorder,
                                width: borderWidth ?? 1,
                              ),
                            ),
                            child: child,
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
