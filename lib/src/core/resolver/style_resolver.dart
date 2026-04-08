import '../models/profile_models.dart';
import '../models/style_models.dart';

class AdvancedStyleResolveContext {
  const AdvancedStyleResolveContext({
    this.pageId,
    this.groupId,
    this.componentTypeId,
  });

  final String? pageId;
  final String? groupId;
  final String? componentTypeId;
}

class AdvancedStyleResolveStep {
  const AdvancedStyleResolveStep({
    required this.source,
    required this.scope,
    required this.target,
    required this.priority,
    required this.requestedState,
    required this.property,
    required this.matched,
    required this.reason,
    this.matchedState,
    this.value,
  });

  final String source;
  final AdvancedCustomizerScope scope;
  final String target;
  final int priority;
  final AdvancedCustomizerState requestedState;
  final AdvancedCustomizerProperty property;
  final bool matched;
  final String reason;
  final AdvancedCustomizerState? matchedState;
  final dynamic value;
}

class AdvancedStyleResolveTrace {
  const AdvancedStyleResolveTrace({
    required this.source,
    required this.componentKey,
    required this.property,
    required this.requestedState,
    required this.steps,
    this.value,
  });

  final String source;
  final String componentKey;
  final AdvancedCustomizerProperty property;
  final AdvancedCustomizerState requestedState;
  final List<AdvancedStyleResolveStep> steps;
  final dynamic value;

  bool get resolved => value != null;

  AdvancedStyleResolveTrace mergeWith(AdvancedStyleResolveTrace other) {
    return AdvancedStyleResolveTrace(
      source: '$source+${other.source}',
      componentKey: componentKey,
      property: property,
      requestedState: requestedState,
      steps: <AdvancedStyleResolveStep>[...steps, ...other.steps],
      value: resolved ? value : other.value,
    );
  }
}

class _PropertyResolution {
  const _PropertyResolution({
    this.value,
    this.matchedState,
    required this.reason,
  });

  final dynamic value;
  final AdvancedCustomizerState? matchedState;
  final String reason;

  bool get matched => value != null;
}

class AdvancedStyleResolver {
  const AdvancedStyleResolver();

  dynamic resolveProperty({
    required AdvancedCustomizerProfile profile,
    required String componentKey,
    required AdvancedCustomizerProperty property,
    required AdvancedCustomizerState state,
    AdvancedStyleResolveContext context = const AdvancedStyleResolveContext(),
  }) {
    return resolvePropertyWithTrace(
      profile: profile,
      componentKey: componentKey,
      property: property,
      state: state,
      context: context,
    ).value;
  }

  AdvancedStyleResolveTrace resolvePropertyWithTrace({
    required AdvancedCustomizerProfile profile,
    required String componentKey,
    required AdvancedCustomizerProperty property,
    required AdvancedCustomizerState state,
    AdvancedStyleResolveContext context = const AdvancedStyleResolveContext(),
    String sourceLabel = 'profile',
  }) {
    final List<AdvancedScopedRule> sorted = _prioritizeRules(
      profile.rules,
      context,
    );
    final List<AdvancedStyleResolveStep> steps = <AdvancedStyleResolveStep>[];

    for (final AdvancedScopedRule rule in sorted) {
      final AdvancedStyleEntry? entry = rule.styles[componentKey];
      if (entry == null) {
        steps.add(
          AdvancedStyleResolveStep(
            source: sourceLabel,
            scope: rule.scope,
            target: rule.target,
            priority: rule.priority,
            requestedState: state,
            property: property,
            matched: false,
            reason: 'component_not_in_rule',
          ),
        );
        continue;
      }

      final _PropertyResolution resolution = _readPropertyWithStateFallback(
        entry,
        state,
        property,
      );
      steps.add(
        AdvancedStyleResolveStep(
          source: sourceLabel,
          scope: rule.scope,
          target: rule.target,
          priority: rule.priority,
          requestedState: state,
          property: property,
          matched: resolution.matched,
          matchedState: resolution.matchedState,
          value: resolution.value,
          reason: resolution.reason,
        ),
      );

      if (resolution.matched) {
        return AdvancedStyleResolveTrace(
          source: sourceLabel,
          componentKey: componentKey,
          property: property,
          requestedState: state,
          steps: steps,
          value: resolution.value,
        );
      }
    }

    return AdvancedStyleResolveTrace(
      source: sourceLabel,
      componentKey: componentKey,
      property: property,
      requestedState: state,
      steps: steps,
      value: null,
    );
  }

  _PropertyResolution _readPropertyWithStateFallback(
    AdvancedStyleEntry entry,
    AdvancedCustomizerState state,
    AdvancedCustomizerProperty property,
  ) {
    final AdvancedStyleValue? requestedStateValue = entry.valueFor(state);
    final dynamic requestedStateProperty = requestedStateValue?.readProperty(
      property,
    );
    if (requestedStateProperty != null) {
      return _PropertyResolution(
        value: requestedStateProperty,
        matchedState: state,
        reason: 'resolved_requested_state',
      );
    }

    if (state != AdvancedCustomizerState.defaultState) {
      final AdvancedStyleValue? defaultStateValue = entry.valueFor(
        AdvancedCustomizerState.defaultState,
      );
      final dynamic defaultStateProperty = defaultStateValue?.readProperty(
        property,
      );
      if (defaultStateProperty != null) {
        return _PropertyResolution(
          value: defaultStateProperty,
          matchedState: AdvancedCustomizerState.defaultState,
          reason: 'resolved_default_state_fallback',
        );
      }
    }

    return const _PropertyResolution(
      value: null,
      matchedState: null,
      reason: 'property_missing_for_requested_and_default_state',
    );
  }

  List<AdvancedScopedRule> _prioritizeRules(
    List<AdvancedScopedRule> rules,
    AdvancedStyleResolveContext context,
  ) {
    final List<AdvancedScopedRule> filtered = <AdvancedScopedRule>[];

    for (final AdvancedScopedRule rule in rules) {
      if (_matchesScope(rule, context)) {
        filtered.add(rule);
      }
    }

    filtered.sort((AdvancedScopedRule left, AdvancedScopedRule right) {
      final int scopeOrderCompare = _scopeRank(
        right.scope,
      ).compareTo(_scopeRank(left.scope));
      if (scopeOrderCompare != 0) {
        return scopeOrderCompare;
      }
      return right.priority.compareTo(left.priority);
    });

    return filtered;
  }

  bool _matchesScope(
    AdvancedScopedRule rule,
    AdvancedStyleResolveContext context,
  ) {
    switch (rule.scope) {
      case AdvancedCustomizerScope.global:
        return true;
      case AdvancedCustomizerScope.page:
        return context.pageId != null && context.pageId == rule.target;
      case AdvancedCustomizerScope.group:
        return context.groupId != null && context.groupId == rule.target;
      case AdvancedCustomizerScope.componentType:
        return context.componentTypeId != null &&
            context.componentTypeId == rule.target;
    }
  }

  int _scopeRank(AdvancedCustomizerScope scope) {
    switch (scope) {
      case AdvancedCustomizerScope.global:
        return 1;
      case AdvancedCustomizerScope.page:
        return 2;
      case AdvancedCustomizerScope.group:
        return 3;
      case AdvancedCustomizerScope.componentType:
        return 4;
    }
  }
}
