import 'dart:async';
import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'advanced_customizer_config.dart';
import 'core/draft/draft_session_manager.dart';
import 'core/models/profile_models.dart';
import 'core/models/style_models.dart';
import 'core/persistence/profile_json_codec.dart';
import 'core/persistence/profile_store.dart';
import 'core/registry/component_registry.dart';
import 'core/resolver/style_resolver.dart';
import 'theme_hooks/panel_skin_hooks.dart';

class AdvancedCustomizerController extends ChangeNotifier {
  AdvancedCustomizerController({
    this.config = const AdvancedCustomizerConfig(),
    AdvancedCustomizerProfileCodec? codec,
    AdvancedStyleResolver? resolver,
    int maxUndoEntries = 20,
  }) : _codec = codec ?? AdvancedCustomizerProfileCodec(),
       _resolver = resolver ?? const AdvancedStyleResolver(),
       _activeScope = config.defaultScope,
       _panelSkin = config.panelSkin,
       _panelStrings = config.panelStrings,
       _sectionVisibility = config.sectionVisibility,
       _lockedTargets = <String>{...config.lockedTargetIds} {
    _storeAdapter = config.profileStore == null
        ? null
        : AdvancedCustomizerProfileStoreAdapter(
            store: config.profileStore!,
            codec: _codec,
          );

    AdvancedCustomizerProfile committed = AdvancedCustomizerProfile.empty();

    final String? seedJson = config.defaultProfileJson;
    if (seedJson != null && seedJson.trim().isNotEmpty) {
      final AdvancedProfileParseResult parsed = _codec.parse(seedJson);
      _addWarnings(parsed.warnings);
      if (parsed.success && parsed.profile != null) {
        committed = parsed.profile!.copy();
        _defaultProfile = parsed.profile!.copy();
      } else {
        _recordDiagnostic(
          AdvancedCustomizerDiagnosticCode.invalidDefaultProfile,
          'Default profile JSON could not be loaded safely.',
          severity: AdvancedCustomizerDiagnosticSeverity.error,
        );
      }
    }

    _draftManager = AdvancedDraftSessionManager(
      committed: committed,
      maxUndoEntries: maxUndoEntries,
    );

    if (_storeAdapter != null) {
      unawaited(hydrateFromStore());
    }
  }

  final AdvancedCustomizerConfig config;
  final AdvancedCustomizerProfileCodec _codec;
  final AdvancedStyleResolver _resolver;
  late final AdvancedCustomizerProfileStoreAdapter? _storeAdapter;

  late final AdvancedDraftSessionManager _draftManager;

  AdvancedCustomizerProfile? _defaultProfile;
  String? _activePageId;
  String? _activeGroupId;
  String? _activeComponentTypeId;
  bool _inPagePreviewEnabled = false;
  String? _inPagePreviewPageId;
  AdvancedCustomizerScope _activeScope;
  AdvancedStyleEntry? _clipboardStyle;

  final List<String> _runtimeWarnings = <String>[];
  final Set<String> _runtimeWarningSet = <String>{};
  final List<AdvancedCustomizerDiagnostic> _runtimeDiagnostics =
      <AdvancedCustomizerDiagnostic>[];
  final Set<String> _runtimeDiagnosticKeys = <String>{};

  AdvancedCustomizerPanelSkin _panelSkin;
  AdvancedCustomizerPanelStrings _panelStrings;
  AdvancedCustomizerSectionVisibility _sectionVisibility;

  final Set<String> _lockedTargets;
  Set<String> _selectedComponents = <String>{};
  Set<AdvancedCustomizerState> _selectedStates = <AdvancedCustomizerState>{
    AdvancedCustomizerState.defaultState,
  };
  Set<AdvancedCustomizerProperty> _selectedProperties =
      <AdvancedCustomizerProperty>{};

  AdvancedCustomizerProfile get committedProfile =>
      _draftManager.committedProfile;
  AdvancedCustomizerProfile? get draftProfile => _draftManager.draftProfile;
  AdvancedCustomizerProfile get activeProfile =>
      draftProfile ?? committedProfile;

  bool get hasDraftSession => _draftManager.hasDraft;

  String? get activePageId => _activePageId;
  String? get activeGroupId => _activeGroupId;
  String? get activeComponentTypeId => _activeComponentTypeId;
  bool get inPagePreviewEnabled => _inPagePreviewEnabled;
  String? get inPagePreviewPageId => _inPagePreviewPageId;

  String? get effectivePageId {
    if (_activePageId != null) {
      return _activePageId;
    }
    final List<String> pages = availablePageIds;
    if (pages.isEmpty) {
      return null;
    }
    return pages.first;
  }

  AdvancedCustomizerScope get activeScope => _activeScope;
  AdvancedCustomizerProfile? get defaultProfile => _defaultProfile?.copy();

  List<String> get runtimeWarnings =>
      List<String>.unmodifiable(_runtimeWarnings);

  List<AdvancedCustomizerDiagnostic> get runtimeDiagnostics =>
      List<AdvancedCustomizerDiagnostic>.unmodifiable(_runtimeDiagnostics);

  List<String> get availablePageIds {
    final Set<String> ids = config.exposedPageIds.isNotEmpty
        ? <String>{...config.exposedPageIds}
        : <String>{...config.registry.pageIds};

    if (_activePageId != null) {
      ids.add(_activePageId!);
    }

    final List<String> output = ids.toList(growable: false);
    output.sort();
    return output;
  }

  List<AdvancedComponentGroupDescriptor> get availableGroupsForActivePage {
    final String? pageId = effectivePageId;
    if (pageId == null) {
      return const <AdvancedComponentGroupDescriptor>[];
    }
    return config.registry.groupsForPage(pageId);
  }

  List<AdvancedComponentDescriptor> get visibleComponents {
    final String? pageId = effectivePageId;
    if (pageId == null) {
      return const <AdvancedComponentDescriptor>[];
    }
    return config.registry.forPage(pageId, groupId: _activeGroupId);
  }

  UnmodifiableSetView<String> get lockedTargets =>
      UnmodifiableSetView<String>(_lockedTargets);
  UnmodifiableSetView<String> get selectedComponents =>
      UnmodifiableSetView<String>(_selectedComponents);
  UnmodifiableSetView<AdvancedCustomizerState> get selectedStates =>
      UnmodifiableSetView<AdvancedCustomizerState>(_selectedStates);
  UnmodifiableSetView<AdvancedCustomizerProperty> get selectedProperties =>
      UnmodifiableSetView<AdvancedCustomizerProperty>(_selectedProperties);

  AdvancedCustomizerPanelSkin get panelSkin => _panelSkin;
  AdvancedCustomizerPanelStrings get panelStrings => _panelStrings;
  AdvancedCustomizerSectionVisibility get sectionVisibility =>
      _sectionVisibility;

  List<String> consumeRuntimeWarnings() {
    final List<String> output = List<String>.from(_runtimeWarnings);
    _runtimeWarnings.clear();
    _runtimeWarningSet.clear();
    return output;
  }

  List<AdvancedCustomizerDiagnostic> consumeRuntimeDiagnostics() {
    final List<AdvancedCustomizerDiagnostic> output =
        List<AdvancedCustomizerDiagnostic>.from(_runtimeDiagnostics);
    _runtimeDiagnostics.clear();
    _runtimeDiagnosticKeys.clear();
    return output;
  }

  void clearRuntimeWarnings() {
    _runtimeWarnings.clear();
    _runtimeWarningSet.clear();
    _runtimeDiagnostics.clear();
    _runtimeDiagnosticKeys.clear();
    notifyListeners();
  }

  void clearRuntimeDiagnostics() {
    _runtimeDiagnostics.clear();
    _runtimeDiagnosticKeys.clear();
    notifyListeners();
  }

  void openCustomizerGlobal() => openGlobalCustomizer();

  void openGlobalCustomizer() {
    _activePageId = null;
    _activeGroupId = null;
    _activeComponentTypeId = null;
    _activeScope = AdvancedCustomizerScope.global;
    notifyListeners();
  }

  void openCustomizerForPage(String pageId) {
    _activePageId = pageId;
    _activeGroupId = null;
    _activeComponentTypeId = null;
    _activeScope = AdvancedCustomizerScope.page;
    notifyListeners();
  }

  void setActiveScope(AdvancedCustomizerScope scope) {
    _activeScope = scope;
    notifyListeners();
  }

  void setActiveGroup(String? groupId) {
    _activeGroupId = groupId;
    if (_activeScope == AdvancedCustomizerScope.group && groupId == null) {
      _recordDiagnostic(
        AdvancedCustomizerDiagnosticCode.invalidScopeContext,
        'Group scope selected without a group id.',
      );
    }
    notifyListeners();
  }

  void setActiveComponentType(String? componentTypeId) {
    _activeComponentTypeId = componentTypeId;
    if (_activeScope == AdvancedCustomizerScope.componentType &&
        componentTypeId == null) {
      _recordDiagnostic(
        AdvancedCustomizerDiagnosticCode.invalidScopeContext,
        'Component-type scope selected without a component type id.',
      );
    }
    notifyListeners();
  }

  void enableInPagePreview({String? pageId}) {
    _inPagePreviewEnabled = true;
    _inPagePreviewPageId = pageId;
    notifyListeners();
  }

  void disableInPagePreview() {
    _inPagePreviewEnabled = false;
    _inPagePreviewPageId = null;
    notifyListeners();
  }

  void setInPagePreviewEnabled(bool enabled, {String? pageId}) {
    if (enabled) {
      enableInPagePreview(pageId: pageId);
      return;
    }
    disableInPagePreview();
  }

  bool isInPagePreviewActiveFor(String pageId) {
    if (!_inPagePreviewEnabled) {
      return false;
    }
    return _inPagePreviewPageId == null || _inPagePreviewPageId == pageId;
  }

  void startDraftSession([AdvancedCustomizerScope? scope]) {
    if (scope != null) {
      _activeScope = scope;
    }
    _draftManager.startDraft();
    notifyListeners();
  }

  bool applyDraft() {
    final bool applied = _draftManager.applyDraft();
    if (applied) {
      _persistCommittedProfileIfConfigured();
      notifyListeners();
    }
    return applied;
  }

  bool discardDraft() {
    final bool discarded = _draftManager.discardDraft();
    if (discarded) {
      notifyListeners();
    }
    return discarded;
  }

  bool undoLastApply() {
    final bool undone = _draftManager.undoLastApply();
    if (undone) {
      _persistCommittedProfileIfConfigured();
      notifyListeners();
    }
    return undone;
  }

  Future<void> hydrateFromStore() async {
    final AdvancedCustomizerProfileStoreAdapter? adapter = _storeAdapter;
    if (adapter == null) {
      return;
    }

    final AdvancedProfileParseResult? loaded = await adapter.loadProfile();
    if (loaded == null) {
      return;
    }

    _addWarnings(loaded.warnings);

    if (!loaded.success || loaded.profile == null) {
      _recordDiagnostic(
        AdvancedCustomizerDiagnosticCode.persistenceLoadFailed,
        'Persisted profile could not be loaded safely.',
        severity: AdvancedCustomizerDiagnosticSeverity.error,
      );
      notifyListeners();
      return;
    }

    _draftManager.setCommittedProfile(loaded.profile!.copy());
    notifyListeners();
  }

  Future<void> persistCommittedProfile() async {
    final AdvancedCustomizerProfileStoreAdapter? adapter = _storeAdapter;
    if (adapter == null) {
      return;
    }

    final AdvancedProfileEncodeResult saved = await adapter.saveProfile(
      committedProfile,
    );
    _addWarnings(saved.warnings);
    if (!saved.success) {
      _recordDiagnostic(
        AdvancedCustomizerDiagnosticCode.persistenceSaveFailed,
        'Persisting profile failed and committed memory state was kept intact.',
        severity: AdvancedCustomizerDiagnosticSeverity.error,
      );
    }
  }

  AdvancedCustomizerExportResult exportProfileJson() {
    final AdvancedProfileEncodeResult encoded = _codec.encode(
      committedProfile.copyWith(updatedAt: DateTime.now().toUtc()),
    );

    return AdvancedCustomizerExportResult(
      success: encoded.success,
      json: encoded.json,
      warnings: encoded.warnings,
      diagnostics: _toDiagnostics(
        encoded.warnings,
        code: AdvancedCustomizerDiagnosticCode.unknown,
      ),
      errorMessage: encoded.errorMessage,
    );
  }

  AdvancedCustomizerImportResult importProfileJson(
    String json,
    AdvancedCustomizerImportMode mode,
  ) {
    final AdvancedProfileParseResult parsed = _codec.parse(json);
    _addWarnings(parsed.warnings);
    if (!parsed.success || parsed.profile == null) {
      final List<AdvancedCustomizerDiagnostic> diagnostics =
          <AdvancedCustomizerDiagnostic>[
            ..._toDiagnostics(
              parsed.warnings,
              code: AdvancedCustomizerDiagnosticCode.unknown,
            ),
            if (parsed.errorMessage != null)
              AdvancedCustomizerDiagnostic(
                code: AdvancedCustomizerDiagnosticCode.invalidImportPayload,
                message: parsed.errorMessage!,
                severity: AdvancedCustomizerDiagnosticSeverity.error,
              ),
          ];

      return AdvancedCustomizerImportResult(
        success: false,
        warnings: parsed.warnings,
        diagnostics: diagnostics,
        errorCode: 'invalid_import',
        errorMessage: parsed.errorMessage,
      );
    }

    final AdvancedCustomizerProfile incoming = parsed.profile!;

    if (mode == AdvancedCustomizerImportMode.replace) {
      _draftManager.setCommittedProfile(incoming.copy());
      _persistCommittedProfileIfConfigured();
    } else if (mode == AdvancedCustomizerImportMode.merge) {
      _draftManager.setCommittedProfile(
        _mergeProfiles(committedProfile, incoming),
      );
      _persistCommittedProfileIfConfigured();
    } else {
      _defaultProfile = incoming.copy();
    }

    notifyListeners();

    return AdvancedCustomizerImportResult(
      success: true,
      profile: committedProfile.copy(),
      warnings: parsed.warnings,
      diagnostics: _toDiagnostics(
        parsed.warnings,
        code: AdvancedCustomizerDiagnosticCode.unknown,
      ),
    );
  }

  bool importDefaultProfile(String json) => setDefaultProfileJson(json);

  bool setDefaultProfileJson(String json) {
    final AdvancedProfileParseResult parsed = _codec.parse(json);
    if (!parsed.success || parsed.profile == null) {
      _recordDiagnostic(
        AdvancedCustomizerDiagnosticCode.invalidDefaultProfile,
        parsed.errorMessage ?? 'Default profile JSON could not be parsed.',
        severity: AdvancedCustomizerDiagnosticSeverity.error,
      );
      return false;
    }

    _defaultProfile = parsed.profile!.copy();
    notifyListeners();
    return true;
  }

  void lockTargets(Iterable<String> targetIds) {
    _lockedTargets.addAll(targetIds);
    _selectedComponents.removeWhere(_lockedTargets.contains);
    notifyListeners();
  }

  void unlockTargets(Iterable<String> targetIds) {
    _lockedTargets.removeAll(targetIds.toSet());
    notifyListeners();
  }

  void setActivePage(String pageId) {
    _activePageId = pageId;
    _activeGroupId = null;
    _activeComponentTypeId = null;
    notifyListeners();
  }

  void setSelectedComponents(Iterable<String> componentIds) {
    final bool hasRegistry = config.registry.components.isNotEmpty;
    final Set<String> next = <String>{};

    for (final String id in componentIds) {
      if (_lockedTargets.contains(id)) {
        _recordDiagnostic(
          AdvancedCustomizerDiagnosticCode.lockedTargetSkipped,
          'Component $id is locked and was skipped.',
          targetId: id,
        );
        continue;
      }

      if (hasRegistry && config.registry.byId(id) == null) {
        _recordDiagnostic(
          AdvancedCustomizerDiagnosticCode.unknownComponentId,
          'Unknown component id was ignored safely: $id.',
          targetId: id,
        );
        continue;
      }

      next.add(id);
    }

    _selectedComponents = next;
    notifyListeners();
  }

  void setSelectedStates(Iterable<AdvancedCustomizerState> states) {
    final Set<AdvancedCustomizerState> next = states.toSet();
    _selectedStates = next.isEmpty
        ? <AdvancedCustomizerState>{AdvancedCustomizerState.defaultState}
        : next;
    notifyListeners();
  }

  void setSelectedProperties(Iterable<AdvancedCustomizerProperty> properties) {
    _selectedProperties = properties.toSet();
    notifyListeners();
  }

  void setFill(Color color) =>
      _setStyleProperty(AdvancedCustomizerProperty.fill, color);
  void setBorder(Color color) =>
      _setStyleProperty(AdvancedCustomizerProperty.border, color);
  void setText(Color color) =>
      _setStyleProperty(AdvancedCustomizerProperty.text, color);
  void setIcon(Color color) =>
      _setStyleProperty(AdvancedCustomizerProperty.icon, color);

  void setRadius(double value) {
    if (value < 0) {
      return;
    }
    _setStyleProperty(AdvancedCustomizerProperty.radius, value);
  }

  void setBorderWidth(double value) {
    if (value < 0) {
      _recordDiagnostic(
        AdvancedCustomizerDiagnosticCode.invalidNumericValue,
        'Negative border width was ignored safely.',
      );
      return;
    }
    _setStyleProperty(AdvancedCustomizerProperty.borderWidth, value);
  }

  void applyStylePack(AdvancedStyleValue value) {
    if (value.fill != null) {
      setFill(value.fill!);
    }
    if (value.border != null) {
      setBorder(value.border!);
    }
    if (value.text != null) {
      setText(value.text!);
    }
    if (value.icon != null) {
      setIcon(value.icon!);
    }
    if (value.radius != null) {
      setRadius(value.radius!);
    }
    if (value.borderWidth != null) {
      setBorderWidth(value.borderWidth!);
    }
  }

  bool copyStyleFrom(String componentId) {
    final AdvancedStyleEntry? found = _findStyleEntry(componentId);
    if (found == null) {
      return false;
    }
    _clipboardStyle = found.copy();
    return true;
  }

  bool pasteStyleTo(Iterable<String> componentIds) {
    final AdvancedStyleEntry? clipboard = _clipboardStyle;
    if (clipboard == null) {
      return false;
    }

    final List<String> editableTargets = componentIds
        .where((String id) => !_lockedTargets.contains(id))
        .toList(growable: false);
    if (editableTargets.isEmpty) {
      return false;
    }

    _ensureDraft();
    final AdvancedScopedRule rule = _ruleForCurrentScope();
    final Map<String, AdvancedStyleEntry> styles = <String, AdvancedStyleEntry>{
      ...rule.styles,
    };

    for (final String target in editableTargets) {
      styles[target] = clipboard.copy();
    }

    _replaceRuleInDraft(rule.copyWith(styles: styles));
    notifyListeners();
    return true;
  }

  void resetComponent(String componentId) {
    _mutateDraftRules((List<AdvancedScopedRule> rules) {
      for (int i = 0; i < rules.length; i++) {
        final AdvancedScopedRule rule = rules[i];
        if (!rule.styles.containsKey(componentId)) {
          continue;
        }

        final Map<String, AdvancedStyleEntry> styles =
            <String, AdvancedStyleEntry>{...rule.styles};
        styles.remove(componentId);
        rules[i] = rule.copyWith(styles: styles);
      }
    });
    notifyListeners();
  }

  void resetGroup(String groupId, {String? pageId}) {
    final String? effectivePage = pageId ?? effectivePageId;
    if (effectivePage == null) {
      _recordDiagnostic(
        AdvancedCustomizerDiagnosticCode.groupResetSkipped,
        'Group reset skipped because page context was not available.',
      );
      notifyListeners();
      return;
    }

    final Set<String> ids = config.registry
        .componentIdsForGroup(effectivePage, groupId)
        .toSet();
    if (ids.isEmpty) {
      _recordDiagnostic(
        AdvancedCustomizerDiagnosticCode.groupResetSkipped,
        'Group reset skipped because no components matched the group.',
        targetId: groupId,
      );
      notifyListeners();
      return;
    }

    _resetComponents(ids);
    notifyListeners();
  }

  void resetPage(String pageId) {
    final Set<String> ids = config.registry.componentIdsForPage(pageId).toSet();
    _mutateDraftRules((List<AdvancedScopedRule> rules) {
      for (int i = 0; i < rules.length; i++) {
        final AdvancedScopedRule rule = rules[i];

        if (rule.scope == AdvancedCustomizerScope.page &&
            rule.target == pageId) {
          rules[i] = rule.copyWith(
            styles: const <String, AdvancedStyleEntry>{},
          );
          continue;
        }

        final Map<String, AdvancedStyleEntry> styles =
            <String, AdvancedStyleEntry>{...rule.styles};
        styles.removeWhere(
          (String componentId, AdvancedStyleEntry _) =>
              ids.contains(componentId) || componentId.startsWith('$pageId.'),
        );
        rules[i] = rule.copyWith(styles: styles);
      }
    });
    notifyListeners();
  }

  void resetProfile() {
    _ensureDraft();

    final AdvancedCustomizerProfile baseline =
        _defaultProfile?.copy() ??
        committedProfile.copyWith(rules: const <AdvancedScopedRule>[]);

    _draftManager.replaceDraft(
      baseline.copyWith(updatedAt: DateTime.now().toUtc()),
    );
    notifyListeners();
  }

  void setPanelSkin(AdvancedCustomizerPanelSkin skinConfig) {
    _panelSkin = skinConfig;
    notifyListeners();
  }

  void setPanelStrings(AdvancedCustomizerPanelStrings localizedStrings) {
    _panelStrings = localizedStrings;
    notifyListeners();
  }

  void setPanelSectionVisibility(
    AdvancedCustomizerSectionVisibility visibilityConfig,
  ) {
    _sectionVisibility = visibilityConfig;
    notifyListeners();
  }

  dynamic resolveProperty(
    String componentKey,
    AdvancedCustomizerProperty property,
    AdvancedCustomizerState state, {
    String? groupId,
    String? componentTypeId,
  }) {
    return traceResolvedProperty(
      componentKey,
      property,
      state,
      groupId: groupId,
      componentTypeId: componentTypeId,
    ).value;
  }

  AdvancedStyleResolveTrace traceResolvedProperty(
    String componentKey,
    AdvancedCustomizerProperty property,
    AdvancedCustomizerState state, {
    String? groupId,
    String? componentTypeId,
  }) {
    final AdvancedStyleResolveContext context = AdvancedStyleResolveContext(
      pageId: _activePageId,
      groupId: groupId,
      componentTypeId: componentTypeId,
    );

    final AdvancedStyleResolveTrace activeTrace = _resolver
        .resolvePropertyWithTrace(
          profile: activeProfile,
          componentKey: componentKey,
          property: property,
          state: state,
          context: context,
          sourceLabel: 'active',
        );

    if (activeTrace.resolved) {
      return activeTrace;
    }

    final AdvancedCustomizerProfile? defaults = _defaultProfile;
    if (defaults == null) {
      return activeTrace;
    }

    final AdvancedStyleResolveTrace defaultTrace = _resolver
        .resolvePropertyWithTrace(
          profile: defaults,
          componentKey: componentKey,
          property: property,
          state: state,
          context: context,
          sourceLabel: 'default',
        );

    return activeTrace.mergeWith(defaultTrace);
  }

  void _setStyleProperty(AdvancedCustomizerProperty property, dynamic value) {
    final List<String> editableTargets = _selectedComponents
        .where((String id) => !_lockedTargets.contains(id))
        .toList(growable: false);

    if (editableTargets.isEmpty) {
      return;
    }

    _ensureDraft();
    final AdvancedScopedRule rule = _ruleForCurrentScope();
    final Map<String, AdvancedStyleEntry> styles = <String, AdvancedStyleEntry>{
      ...rule.styles,
    };

    for (final String targetId in editableTargets) {
      final AdvancedComponentDescriptor? descriptor = config.registry.byId(
        targetId,
      );
      if (descriptor != null) {
        if (!descriptor.isEditable) {
          _recordDiagnostic(
            AdvancedCustomizerDiagnosticCode.readOnlyTargetSkipped,
            'Component $targetId is read-only and was skipped.',
            targetId: targetId,
          );
          continue;
        }
        if (!descriptor.editableProperties.contains(property)) {
          _recordDiagnostic(
            AdvancedCustomizerDiagnosticCode.lockedPropertySkipped,
            'Property ${property.value} is locked for component $targetId.',
            targetId: targetId,
            scope: _activeScope,
          );
          continue;
        }
      }

      AdvancedStyleEntry entry =
          (styles[targetId] ?? const AdvancedStyleEntry()).copy();
      for (final AdvancedCustomizerState state in _selectedStates) {
        if (descriptor != null && !descriptor.editableStates.contains(state)) {
          _recordDiagnostic(
            AdvancedCustomizerDiagnosticCode.lockedStateSkipped,
            'State ${state.value} is locked for component $targetId.',
            targetId: targetId,
            scope: _activeScope,
          );
          continue;
        }

        final AdvancedStyleValue currentValue =
            entry.valueFor(state) ?? const AdvancedStyleValue();
        final AdvancedStyleValue nextValue = currentValue.writeProperty(
          property,
          value,
        );
        entry = entry.upsertState(state, nextValue);
        _warnIfLowContrast(targetId, state, nextValue);
      }
      styles[targetId] = entry;
    }

    _replaceRuleInDraft(rule.copyWith(styles: styles));
    notifyListeners();
  }

  void _warnIfLowContrast(
    String componentId,
    AdvancedCustomizerState state,
    AdvancedStyleValue value,
  ) {
    if (value.fill == null || value.text == null) {
      return;
    }

    final double ratio = _contrastRatio(value.fill!, value.text!);
    if (ratio < 4.5) {
      _recordDiagnostic(
        AdvancedCustomizerDiagnosticCode.lowContrastRisk,
        'Low contrast warning for $componentId:${state.value} '
        '(${ratio.toStringAsFixed(2)}:1).',
        targetId: componentId,
        scope: _activeScope,
      );
    }
  }

  double _contrastRatio(Color a, Color b) {
    final double l1 = a.computeLuminance();
    final double l2 = b.computeLuminance();
    final double lighter = l1 > l2 ? l1 : l2;
    final double darker = l1 > l2 ? l2 : l1;
    return (lighter + 0.05) / (darker + 0.05);
  }

  void _ensureDraft() {
    if (!_draftManager.hasDraft) {
      _draftManager.startDraft();
    }
  }

  AdvancedScopedRule _ruleForCurrentScope() {
    final AdvancedCustomizerProfile draft = draftProfile ?? committedProfile;
    final AdvancedCustomizerScope scope = _activeScope;
    final String target = _targetForScope(scope);

    for (final AdvancedScopedRule rule in draft.rules) {
      if (rule.scope == scope && rule.target == target) {
        return rule.copy();
      }
    }

    return AdvancedScopedRule(
      scope: scope,
      target: target,
      priority: _priorityForScope(scope),
      styles: const <String, AdvancedStyleEntry>{},
    );
  }

  String _targetForScope(AdvancedCustomizerScope scope) {
    switch (scope) {
      case AdvancedCustomizerScope.global:
        return 'global';
      case AdvancedCustomizerScope.page:
        return _activePageId ?? 'page.unknown';
      case AdvancedCustomizerScope.group:
        if (_activeGroupId != null) {
          return _activeGroupId!;
        }
        return (_activePageId == null)
            ? 'group.unknown'
            : '${_activePageId!}.group';
      case AdvancedCustomizerScope.componentType:
        if (_activeComponentTypeId != null) {
          return _activeComponentTypeId!;
        }
        return (_activePageId == null)
            ? 'componentType.unknown'
            : '${_activePageId!}.componentType';
    }
  }

  int _priorityForScope(AdvancedCustomizerScope scope) {
    switch (scope) {
      case AdvancedCustomizerScope.global:
        return 100;
      case AdvancedCustomizerScope.page:
        return 200;
      case AdvancedCustomizerScope.group:
        return 300;
      case AdvancedCustomizerScope.componentType:
        return 400;
    }
  }

  void _replaceRuleInDraft(AdvancedScopedRule nextRule) {
    final AdvancedCustomizerProfile draft = (draftProfile ?? committedProfile)
        .copy();
    final List<AdvancedScopedRule> rules = draft.rules
        .map((AdvancedScopedRule rule) => rule.copy())
        .toList();

    final int index = rules.indexWhere(
      (AdvancedScopedRule rule) =>
          rule.scope == nextRule.scope && rule.target == nextRule.target,
    );

    if (index >= 0) {
      rules[index] = nextRule;
    } else {
      rules.add(nextRule);
    }

    _draftManager.replaceDraft(
      draft.copyWith(rules: rules, updatedAt: DateTime.now().toUtc()),
    );
  }

  void _mutateDraftRules(void Function(List<AdvancedScopedRule> rules) mutate) {
    _ensureDraft();
    final AdvancedCustomizerProfile draft = (draftProfile ?? committedProfile)
        .copy();
    final List<AdvancedScopedRule> rules = draft.rules
        .map((AdvancedScopedRule rule) => rule.copy())
        .toList();

    mutate(rules);

    final List<AdvancedScopedRule> compacted = rules
        .where((AdvancedScopedRule rule) => rule.styles.isNotEmpty)
        .toList(growable: false);

    _draftManager.replaceDraft(
      draft.copyWith(rules: compacted, updatedAt: DateTime.now().toUtc()),
    );
  }

  void _resetComponents(Set<String> componentIds) {
    _mutateDraftRules((List<AdvancedScopedRule> rules) {
      for (int i = 0; i < rules.length; i++) {
        final AdvancedScopedRule rule = rules[i];
        final Map<String, AdvancedStyleEntry> styles =
            <String, AdvancedStyleEntry>{...rule.styles};
        for (final String componentId in componentIds) {
          styles.remove(componentId);
        }
        rules[i] = rule.copyWith(styles: styles);
      }
    });
  }

  void _addWarning(String warning) {
    if (_runtimeWarningSet.add(warning)) {
      _runtimeWarnings.add(warning);
    }

    _addDiagnostic(
      AdvancedCustomizerDiagnostic(
        code: AdvancedCustomizerDiagnosticCode.unknown,
        message: warning,
      ),
    );
  }

  void _addWarnings(Iterable<String> warnings) {
    for (final String warning in warnings) {
      _addWarning(warning);
    }
  }

  void _recordDiagnostic(
    AdvancedCustomizerDiagnosticCode code,
    String message, {
    AdvancedCustomizerDiagnosticSeverity severity =
        AdvancedCustomizerDiagnosticSeverity.warning,
    String? targetId,
    AdvancedCustomizerScope? scope,
  }) {
    _addWarning(message);
    _addDiagnostic(
      AdvancedCustomizerDiagnostic(
        code: code,
        message: message,
        severity: severity,
        targetId: targetId,
        scope: scope,
      ),
    );
  }

  void _addDiagnostic(AdvancedCustomizerDiagnostic diagnostic) {
    if (_runtimeDiagnosticKeys.add(diagnostic.stableKey)) {
      _runtimeDiagnostics.add(diagnostic);
    }
  }

  List<AdvancedCustomizerDiagnostic> _toDiagnostics(
    Iterable<String> warnings, {
    required AdvancedCustomizerDiagnosticCode code,
  }) {
    return warnings
        .map(
          (String warning) => AdvancedCustomizerDiagnostic(
            code: code,
            message: warning,
            severity: AdvancedCustomizerDiagnosticSeverity.warning,
          ),
        )
        .toList(growable: false);
  }

  void _persistCommittedProfileIfConfigured() {
    if (_storeAdapter != null) {
      unawaited(persistCommittedProfile());
    }
  }

  AdvancedStyleEntry? _findStyleEntry(String componentId) {
    final List<AdvancedScopedRule> rules = activeProfile.rules
        .map((AdvancedScopedRule rule) => rule.copy())
        .toList();

    rules.sort((AdvancedScopedRule left, AdvancedScopedRule right) {
      final int rankDiff = _priorityForScope(
        right.scope,
      ).compareTo(_priorityForScope(left.scope));
      if (rankDiff != 0) {
        return rankDiff;
      }
      return right.priority.compareTo(left.priority);
    });

    for (final AdvancedScopedRule rule in rules) {
      final AdvancedStyleEntry? entry = rule.styles[componentId];
      if (entry != null) {
        return entry;
      }
    }

    return null;
  }

  AdvancedCustomizerProfile _mergeProfiles(
    AdvancedCustomizerProfile base,
    AdvancedCustomizerProfile incoming,
  ) {
    final List<AdvancedScopedRule> merged = base.rules
        .map((AdvancedScopedRule rule) => rule.copy())
        .toList();

    for (final AdvancedScopedRule incomingRule in incoming.rules) {
      final int index = merged.indexWhere(
        (AdvancedScopedRule rule) =>
            rule.scope == incomingRule.scope &&
            rule.target == incomingRule.target,
      );

      if (index < 0) {
        merged.add(incomingRule.copy());
        continue;
      }

      final AdvancedScopedRule current = merged[index];
      final Map<String, AdvancedStyleEntry> styles =
          <String, AdvancedStyleEntry>{...current.styles};
      for (final MapEntry<String, AdvancedStyleEntry> entry
          in incomingRule.styles.entries) {
        final AdvancedStyleEntry? existingEntry = styles[entry.key];
        if (existingEntry == null) {
          styles[entry.key] = entry.value.copy();
          continue;
        }

        styles[entry.key] = _mergeStyleEntries(existingEntry, entry.value);
      }

      merged[index] = current.copyWith(
        priority: incomingRule.priority,
        styles: styles,
      );
    }

    return base.copyWith(updatedAt: DateTime.now().toUtc(), rules: merged);
  }

  AdvancedStyleEntry _mergeStyleEntries(
    AdvancedStyleEntry base,
    AdvancedStyleEntry incoming,
  ) {
    final Map<AdvancedCustomizerState, AdvancedStyleValue> states =
        <AdvancedCustomizerState, AdvancedStyleValue>{...base.states};

    for (final MapEntry<AdvancedCustomizerState, AdvancedStyleValue> entry
        in incoming.states.entries) {
      final AdvancedStyleValue? existing = states[entry.key];
      if (existing == null) {
        states[entry.key] = entry.value;
        continue;
      }

      states[entry.key] = _mergeStyleValues(existing, entry.value);
    }

    return AdvancedStyleEntry(states: states);
  }

  AdvancedStyleValue _mergeStyleValues(
    AdvancedStyleValue base,
    AdvancedStyleValue incoming,
  ) {
    return AdvancedStyleValue(
      fill: incoming.fill ?? base.fill,
      border: incoming.border ?? base.border,
      text: incoming.text ?? base.text,
      icon: incoming.icon ?? base.icon,
      radius: incoming.radius ?? base.radius,
      borderWidth: incoming.borderWidth ?? base.borderWidth,
    );
  }
}
