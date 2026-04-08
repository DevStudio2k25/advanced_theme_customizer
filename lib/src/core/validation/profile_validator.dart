import '../models/profile_models.dart';
import '../models/style_models.dart';

class AdvancedProfileValidationResult {
  const AdvancedProfileValidationResult({
    this.errors = const <String>[],
    this.warnings = const <String>[],
  });

  final List<String> errors;
  final List<String> warnings;

  bool get isValid => errors.isEmpty;
}

class AdvancedProfileValidator {
  const AdvancedProfileValidator();

  AdvancedProfileValidationResult validate(AdvancedCustomizerProfile profile) {
    final List<String> errors = <String>[];
    final List<String> warnings = <String>[];

    if (profile.id.trim().isEmpty) {
      errors.add('Profile id cannot be empty.');
    }

    if (profile.name.trim().isEmpty) {
      errors.add('Profile name cannot be empty.');
    }

    for (final AdvancedScopedRule rule in profile.rules) {
      if (rule.target.trim().isEmpty) {
        errors.add('Rule target cannot be empty.');
      }
      for (final MapEntry<String, AdvancedStyleEntry> styleEntry
          in rule.styles.entries) {
        if (styleEntry.key.trim().isEmpty) {
          errors.add('Component key cannot be empty.');
        }
        for (final MapEntry<AdvancedCustomizerState, AdvancedStyleValue>
            stateEntry
            in styleEntry.value.states.entries) {
          final double? radius = stateEntry.value.radius;
          final double? borderWidth = stateEntry.value.borderWidth;
          if (radius != null && radius < 0) {
            errors.add(
              'Radius cannot be negative for ${styleEntry.key}:${stateEntry.key.value}.',
            );
          }
          if (borderWidth != null && borderWidth < 0) {
            errors.add(
              'Border width cannot be negative for ${styleEntry.key}:${stateEntry.key.value}.',
            );
          }
          if (stateEntry.value.isEmpty) {
            warnings.add(
              'Empty style state found for ${styleEntry.key}:${stateEntry.key.value}.',
            );
          }
        }
      }
    }

    return AdvancedProfileValidationResult(errors: errors, warnings: warnings);
  }
}
