import 'dart:convert';

import '../migration/schema_migrator.dart';
import '../migration/schema_versions.dart';
import '../models/profile_models.dart';
import '../models/style_models.dart';
import '../validation/profile_validator.dart';

class AdvancedProfileParseResult {
  const AdvancedProfileParseResult({
    required this.success,
    this.profile,
    this.warnings = const <String>[],
    this.errorMessage,
  });

  final bool success;
  final AdvancedCustomizerProfile? profile;
  final List<String> warnings;
  final String? errorMessage;
}

class AdvancedProfileEncodeResult {
  const AdvancedProfileEncodeResult({
    required this.success,
    this.json,
    this.warnings = const <String>[],
    this.errorMessage,
  });

  final bool success;
  final String? json;
  final List<String> warnings;
  final String? errorMessage;
}

class AdvancedCustomizerProfileCodec {
  AdvancedCustomizerProfileCodec({
    AdvancedSchemaMigrator? migrator,
    AdvancedProfileValidator? validator,
  }) : _migrator = migrator ?? const AdvancedSchemaMigrator(),
       _validator = validator ?? const AdvancedProfileValidator();

  final AdvancedSchemaMigrator _migrator;
  final AdvancedProfileValidator _validator;

  AdvancedProfileParseResult parse(String rawJson) {
    try {
      final dynamic decoded = jsonDecode(rawJson);
      if (decoded is! Map<String, dynamic>) {
        return const AdvancedProfileParseResult(
          success: false,
          errorMessage: 'Profile JSON must be an object.',
        );
      }

      final AdvancedSchemaMigrationResult migration = _migrator
          .migrateToCurrent(decoded);
      final AdvancedCustomizerProfile profile = _fromJson(migration.payload);
      final AdvancedProfileValidationResult validation = _validator.validate(
        profile,
      );
      if (!validation.isValid) {
        return AdvancedProfileParseResult(
          success: false,
          warnings: <String>[...migration.warnings, ...validation.warnings],
          errorMessage: validation.errors.join(' | '),
        );
      }

      return AdvancedProfileParseResult(
        success: true,
        profile: profile,
        warnings: <String>[...migration.warnings, ...validation.warnings],
      );
    } on FormatException catch (error) {
      return AdvancedProfileParseResult(
        success: false,
        errorMessage: error.message,
      );
    } catch (error) {
      return AdvancedProfileParseResult(
        success: false,
        errorMessage: error.toString(),
      );
    }
  }

  AdvancedProfileEncodeResult encode(AdvancedCustomizerProfile profile) {
    final AdvancedProfileValidationResult validation = _validator.validate(
      profile,
    );
    if (!validation.isValid) {
      return AdvancedProfileEncodeResult(
        success: false,
        warnings: validation.warnings,
        errorMessage: validation.errors.join(' | '),
      );
    }

    final String json = jsonEncode(_toJson(profile));
    return AdvancedProfileEncodeResult(
      success: true,
      json: json,
      warnings: validation.warnings,
    );
  }

  AdvancedCustomizerProfile _fromJson(Map<String, dynamic> json) {
    final int schemaVersion =
        (json['schemaVersion'] as num?)?.toInt() ??
        kAdvancedCustomizerCurrentSchemaVersion;

    final Map<String, dynamic> profileJson =
        (json['profile'] as Map<String, dynamic>?) ?? <String, dynamic>{};
    final Map<String, dynamic> baseJson =
        (json['base'] as Map<String, dynamic>?) ?? <String, dynamic>{};

    final String id = (profileJson['id'] as String?) ?? 'default';
    final String name = (profileJson['name'] as String?) ?? 'Default Profile';
    final DateTime updatedAt =
        DateTime.tryParse(
          (profileJson['updatedAt'] as String?) ?? '',
        )?.toUtc() ??
        DateTime.now().toUtc();
    final String? basePresetId = baseJson['presetId'] as String?;

    final List<AdvancedScopedRule> rules = <AdvancedScopedRule>[];
    final dynamic rawRules = json['rules'];
    if (rawRules is List<dynamic>) {
      for (final dynamic entry in rawRules) {
        if (entry is! Map<String, dynamic>) {
          continue;
        }
        final AdvancedScopedRule? rule = AdvancedScopedRule.fromJson(entry);
        if (rule != null) {
          rules.add(rule);
        }
      }
    }

    return AdvancedCustomizerProfile(
      schemaVersion: schemaVersion,
      id: id,
      name: name,
      updatedAt: updatedAt,
      basePresetId: basePresetId,
      rules: rules,
    );
  }

  Map<String, dynamic> _toJson(AdvancedCustomizerProfile profile) {
    return <String, dynamic>{
      'schemaVersion': profile.schemaVersion,
      'profile': <String, dynamic>{
        'id': profile.id,
        'name': profile.name,
        'updatedAt': profile.updatedAt.toUtc().toIso8601String(),
      },
      'base': <String, dynamic>{
        if (profile.basePresetId != null) 'presetId': profile.basePresetId,
      },
      'rules': profile.rules
          .map((AdvancedScopedRule rule) => rule.toJson())
          .toList(growable: false),
    };
  }
}
