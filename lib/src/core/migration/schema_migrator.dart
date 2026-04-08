import 'schema_versions.dart';

class AdvancedSchemaMigrationResult {
  const AdvancedSchemaMigrationResult({
    required this.payload,
    required this.schemaVersion,
    this.warnings = const <String>[],
  });

  final Map<String, dynamic> payload;
  final int schemaVersion;
  final List<String> warnings;
}

class AdvancedSchemaMigrator {
  const AdvancedSchemaMigrator();

  AdvancedSchemaMigrationResult migrateToCurrent(Map<String, dynamic> source) {
    final List<String> warnings = <String>[];

    final int sourceVersion =
        (source['schemaVersion'] as num?)?.toInt() ??
        kAdvancedCustomizerCurrentSchemaVersion;

    if (sourceVersion < kAdvancedCustomizerMinimumSupportedSchemaVersion) {
      throw const FormatException('Unsupported schema version.');
    }

    if (sourceVersion == kAdvancedCustomizerCurrentSchemaVersion) {
      return AdvancedSchemaMigrationResult(
        payload: source,
        schemaVersion: sourceVersion,
        warnings: warnings,
      );
    }

    if (sourceVersion == 1) {
      warnings.add('Migrated schema v1 profile to schema v2.');
      return _migrateV1ToV2(source, warnings);
    }

    throw const FormatException('Schema migration path not implemented.');
  }

  AdvancedSchemaMigrationResult _migrateV1ToV2(
    Map<String, dynamic> source,
    List<String> warnings,
  ) {
    final DateTime now = DateTime.now().toUtc();
    final Map<String, dynamic> profile = <String, dynamic>{
      'id': (source['profileId'] as String?) ?? 'migrated_profile',
      'name': (source['profileName'] as String?) ?? 'Migrated Profile',
      'updatedAt': now.toIso8601String(),
    };

    final Map<String, dynamic> base = <String, dynamic>{
      'presetId': (source['presetId'] as String?) ?? 'classic',
    };

    final List<Map<String, dynamic>> rules = <Map<String, dynamic>>[];
    final dynamic rawTokens = source['tokens'];

    if (rawTokens is Map<String, dynamic> && rawTokens.isNotEmpty) {
      final Map<String, dynamic> styles = <String, dynamic>{};
      for (final MapEntry<String, dynamic> entry in rawTokens.entries) {
        if (entry.value is! Map<String, dynamic>) {
          warnings.add('Dropped unsupported v1 token entry: ${entry.key}.');
          continue;
        }
        styles[entry.key] = <String, dynamic>{'default': entry.value};
      }

      if (styles.isNotEmpty) {
        rules.add(<String, dynamic>{
          'scope': 'global',
          'target': 'global',
          'priority': 100,
          'styles': styles,
        });
      }
    }

    return AdvancedSchemaMigrationResult(
      payload: <String, dynamic>{
        'schemaVersion': kAdvancedCustomizerCurrentSchemaVersion,
        'profile': profile,
        'base': base,
        'rules': rules,
      },
      schemaVersion: kAdvancedCustomizerCurrentSchemaVersion,
      warnings: warnings,
    );
  }
}
