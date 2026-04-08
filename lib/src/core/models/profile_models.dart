import 'style_models.dart';

enum AdvancedCustomizerDiagnosticSeverity { info, warning, error }

enum AdvancedCustomizerDiagnosticCode {
  unknown,
  invalidImportPayload,
  invalidDefaultProfile,
  unknownComponentId,
  lockedTargetSkipped,
  readOnlyTargetSkipped,
  lockedPropertySkipped,
  lockedStateSkipped,
  invalidNumericValue,
  lowContrastRisk,
  persistenceLoadFailed,
  persistenceSaveFailed,
  groupResetSkipped,
  invalidScopeContext,
}

class AdvancedCustomizerDiagnostic {
  const AdvancedCustomizerDiagnostic({
    required this.code,
    required this.message,
    this.severity = AdvancedCustomizerDiagnosticSeverity.warning,
    this.targetId,
    this.scope,
  });

  final AdvancedCustomizerDiagnosticCode code;
  final String message;
  final AdvancedCustomizerDiagnosticSeverity severity;
  final String? targetId;
  final AdvancedCustomizerScope? scope;

  String get stableKey =>
      '${code.name}|${severity.name}|${scope?.name ?? ''}|${targetId ?? ''}|$message';
}

class AdvancedCustomizerProfile {
  const AdvancedCustomizerProfile({
    required this.schemaVersion,
    required this.id,
    required this.name,
    required this.updatedAt,
    this.basePresetId,
    this.rules = const <AdvancedScopedRule>[],
  });

  final int schemaVersion;
  final String id;
  final String name;
  final DateTime updatedAt;
  final String? basePresetId;
  final List<AdvancedScopedRule> rules;

  AdvancedCustomizerProfile copyWith({
    int? schemaVersion,
    String? id,
    String? name,
    DateTime? updatedAt,
    String? basePresetId,
    List<AdvancedScopedRule>? rules,
  }) {
    return AdvancedCustomizerProfile(
      schemaVersion: schemaVersion ?? this.schemaVersion,
      id: id ?? this.id,
      name: name ?? this.name,
      updatedAt: updatedAt ?? this.updatedAt,
      basePresetId: basePresetId ?? this.basePresetId,
      rules: rules ?? this.rules,
    );
  }

  AdvancedCustomizerProfile copy() {
    return AdvancedCustomizerProfile(
      schemaVersion: schemaVersion,
      id: id,
      name: name,
      updatedAt: updatedAt,
      basePresetId: basePresetId,
      rules: rules.map((AdvancedScopedRule rule) => rule.copy()).toList(),
    );
  }

  static AdvancedCustomizerProfile empty({
    String id = 'default',
    String name = 'Default Profile',
    int schemaVersion = 2,
  }) {
    return AdvancedCustomizerProfile(
      schemaVersion: schemaVersion,
      id: id,
      name: name,
      updatedAt: DateTime.now().toUtc(),
      rules: const <AdvancedScopedRule>[],
    );
  }
}

class AdvancedCustomizerImportResult {
  const AdvancedCustomizerImportResult({
    required this.success,
    this.profile,
    this.warnings = const <String>[],
    this.diagnostics = const <AdvancedCustomizerDiagnostic>[],
    this.errorCode,
    this.errorMessage,
  });

  final bool success;
  final AdvancedCustomizerProfile? profile;
  final List<String> warnings;
  final List<AdvancedCustomizerDiagnostic> diagnostics;
  final String? errorCode;
  final String? errorMessage;
}

class AdvancedCustomizerExportResult {
  const AdvancedCustomizerExportResult({
    required this.success,
    this.json,
    this.warnings = const <String>[],
    this.diagnostics = const <AdvancedCustomizerDiagnostic>[],
    this.errorMessage,
  });

  final bool success;
  final String? json;
  final List<String> warnings;
  final List<AdvancedCustomizerDiagnostic> diagnostics;
  final String? errorMessage;
}
