import 'package:flutter/material.dart';

enum AdvancedCustomizerScope { global, page, group, componentType }

enum AdvancedCustomizerState {
  defaultState,
  hover,
  focused,
  active,
  disabled,
  selected,
  error,
}

enum AdvancedCustomizerProperty {
  fill,
  border,
  text,
  icon,
  radius,
  borderWidth,
}

enum AdvancedCustomizerImportMode { replace, merge, defaults }

const List<AdvancedCustomizerState> kAdvancedCustomizerAllStates =
    <AdvancedCustomizerState>[
      AdvancedCustomizerState.defaultState,
      AdvancedCustomizerState.hover,
      AdvancedCustomizerState.focused,
      AdvancedCustomizerState.active,
      AdvancedCustomizerState.disabled,
      AdvancedCustomizerState.selected,
      AdvancedCustomizerState.error,
    ];

extension AdvancedCustomizerScopeX on AdvancedCustomizerScope {
  String get value {
    switch (this) {
      case AdvancedCustomizerScope.global:
        return 'global';
      case AdvancedCustomizerScope.page:
        return 'page';
      case AdvancedCustomizerScope.group:
        return 'group';
      case AdvancedCustomizerScope.componentType:
        return 'componentType';
    }
  }

  static AdvancedCustomizerScope? fromString(String? value) {
    switch (value) {
      case 'global':
        return AdvancedCustomizerScope.global;
      case 'page':
        return AdvancedCustomizerScope.page;
      case 'group':
        return AdvancedCustomizerScope.group;
      case 'componentType':
        return AdvancedCustomizerScope.componentType;
      default:
        return null;
    }
  }
}

extension AdvancedCustomizerStateX on AdvancedCustomizerState {
  String get value {
    switch (this) {
      case AdvancedCustomizerState.defaultState:
        return 'default';
      case AdvancedCustomizerState.hover:
        return 'hover';
      case AdvancedCustomizerState.focused:
        return 'focused';
      case AdvancedCustomizerState.active:
        return 'active';
      case AdvancedCustomizerState.disabled:
        return 'disabled';
      case AdvancedCustomizerState.selected:
        return 'selected';
      case AdvancedCustomizerState.error:
        return 'error';
    }
  }

  static AdvancedCustomizerState? fromString(String? value) {
    switch (value) {
      case 'default':
        return AdvancedCustomizerState.defaultState;
      case 'hover':
        return AdvancedCustomizerState.hover;
      case 'focused':
        return AdvancedCustomizerState.focused;
      case 'active':
        return AdvancedCustomizerState.active;
      case 'disabled':
        return AdvancedCustomizerState.disabled;
      case 'selected':
        return AdvancedCustomizerState.selected;
      case 'error':
        return AdvancedCustomizerState.error;
      default:
        return null;
    }
  }
}

extension AdvancedCustomizerPropertyX on AdvancedCustomizerProperty {
  String get value {
    switch (this) {
      case AdvancedCustomizerProperty.fill:
        return 'fill';
      case AdvancedCustomizerProperty.border:
        return 'border';
      case AdvancedCustomizerProperty.text:
        return 'text';
      case AdvancedCustomizerProperty.icon:
        return 'icon';
      case AdvancedCustomizerProperty.radius:
        return 'radius';
      case AdvancedCustomizerProperty.borderWidth:
        return 'borderWidth';
    }
  }

  static AdvancedCustomizerProperty? fromString(String? value) {
    switch (value) {
      case 'fill':
        return AdvancedCustomizerProperty.fill;
      case 'border':
        return AdvancedCustomizerProperty.border;
      case 'text':
        return AdvancedCustomizerProperty.text;
      case 'icon':
        return AdvancedCustomizerProperty.icon;
      case 'radius':
        return AdvancedCustomizerProperty.radius;
      case 'borderWidth':
        return AdvancedCustomizerProperty.borderWidth;
      default:
        return null;
    }
  }
}

extension AdvancedCustomizerImportModeX on AdvancedCustomizerImportMode {
  String get value {
    switch (this) {
      case AdvancedCustomizerImportMode.replace:
        return 'replace';
      case AdvancedCustomizerImportMode.merge:
        return 'merge';
      case AdvancedCustomizerImportMode.defaults:
        return 'defaults';
    }
  }
}

String colorToHex(Color color) {
  final String hex = color.value
      .toRadixString(16)
      .padLeft(8, '0')
      .toUpperCase();
  return '#$hex';
}

Color? colorFromDynamic(dynamic raw) {
  if (raw == null) {
    return null;
  }
  if (raw is int) {
    return Color(raw);
  }
  if (raw is! String) {
    return null;
  }

  final String text = raw.trim();
  if (!text.startsWith('#')) {
    return null;
  }
  final String payload = text.substring(1);

  if (payload.length == 8) {
    final int? value = int.tryParse(payload, radix: 16);
    return value == null ? null : Color(value);
  }

  if (payload.length == 6) {
    final int? rgb = int.tryParse(payload, radix: 16);
    return rgb == null ? null : Color(0xFF000000 | rgb);
  }

  return null;
}

@immutable
class AdvancedStyleValue {
  const AdvancedStyleValue({
    this.fill,
    this.border,
    this.text,
    this.icon,
    this.radius,
    this.borderWidth,
  });

  final Color? fill;
  final Color? border;
  final Color? text;
  final Color? icon;
  final double? radius;
  final double? borderWidth;

  bool get isEmpty =>
      fill == null &&
      border == null &&
      text == null &&
      icon == null &&
      radius == null &&
      borderWidth == null;

  AdvancedStyleValue copyWith({
    Color? fill,
    Color? border,
    Color? text,
    Color? icon,
    double? radius,
    double? borderWidth,
    bool clearFill = false,
    bool clearBorder = false,
    bool clearText = false,
    bool clearIcon = false,
    bool clearRadius = false,
    bool clearBorderWidth = false,
  }) {
    return AdvancedStyleValue(
      fill: clearFill ? null : (fill ?? this.fill),
      border: clearBorder ? null : (border ?? this.border),
      text: clearText ? null : (text ?? this.text),
      icon: clearIcon ? null : (icon ?? this.icon),
      radius: clearRadius ? null : (radius ?? this.radius),
      borderWidth: clearBorderWidth ? null : (borderWidth ?? this.borderWidth),
    );
  }

  dynamic readProperty(AdvancedCustomizerProperty property) {
    switch (property) {
      case AdvancedCustomizerProperty.fill:
        return fill;
      case AdvancedCustomizerProperty.border:
        return border;
      case AdvancedCustomizerProperty.text:
        return text;
      case AdvancedCustomizerProperty.icon:
        return icon;
      case AdvancedCustomizerProperty.radius:
        return radius;
      case AdvancedCustomizerProperty.borderWidth:
        return borderWidth;
    }
  }

  AdvancedStyleValue writeProperty(
    AdvancedCustomizerProperty property,
    dynamic value,
  ) {
    switch (property) {
      case AdvancedCustomizerProperty.fill:
        return copyWith(fill: value as Color?);
      case AdvancedCustomizerProperty.border:
        return copyWith(border: value as Color?);
      case AdvancedCustomizerProperty.text:
        return copyWith(text: value as Color?);
      case AdvancedCustomizerProperty.icon:
        return copyWith(icon: value as Color?);
      case AdvancedCustomizerProperty.radius:
        return copyWith(radius: value as double?);
      case AdvancedCustomizerProperty.borderWidth:
        return copyWith(borderWidth: value as double?);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> output = <String, dynamic>{};

    if (fill != null) {
      output['fill'] = colorToHex(fill!);
    }
    if (border != null) {
      output['border'] = colorToHex(border!);
    }
    if (text != null) {
      output['text'] = colorToHex(text!);
    }
    if (icon != null) {
      output['icon'] = colorToHex(icon!);
    }
    if (radius != null) {
      output['radius'] = radius;
    }
    if (borderWidth != null) {
      output['borderWidth'] = borderWidth;
    }

    return output;
  }

  static AdvancedStyleValue fromJson(Map<String, dynamic> json) {
    return AdvancedStyleValue(
      fill: colorFromDynamic(json['fill']),
      border: colorFromDynamic(json['border']),
      text: colorFromDynamic(json['text']),
      icon: colorFromDynamic(json['icon']),
      radius: (json['radius'] as num?)?.toDouble(),
      borderWidth: (json['borderWidth'] as num?)?.toDouble(),
    );
  }
}

@immutable
class AdvancedStyleEntry {
  const AdvancedStyleEntry({
    this.states = const <AdvancedCustomizerState, AdvancedStyleValue>{},
  });

  final Map<AdvancedCustomizerState, AdvancedStyleValue> states;

  AdvancedStyleValue? valueFor(AdvancedCustomizerState state) => states[state];

  AdvancedStyleEntry upsertState(
    AdvancedCustomizerState state,
    AdvancedStyleValue value,
  ) {
    final Map<AdvancedCustomizerState, AdvancedStyleValue> next =
        <AdvancedCustomizerState, AdvancedStyleValue>{...states};

    if (value.isEmpty) {
      next.remove(state);
    } else {
      next[state] = value;
    }

    return AdvancedStyleEntry(states: next);
  }

  AdvancedStyleEntry copy() {
    return AdvancedStyleEntry(
      states: <AdvancedCustomizerState, AdvancedStyleValue>{...states},
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> output = <String, dynamic>{};

    for (final MapEntry<AdvancedCustomizerState, AdvancedStyleValue> entry
        in states.entries) {
      output[entry.key.value] = entry.value.toJson();
    }

    return output;
  }

  static AdvancedStyleEntry fromJson(Map<String, dynamic> json) {
    final Map<AdvancedCustomizerState, AdvancedStyleValue> states =
        <AdvancedCustomizerState, AdvancedStyleValue>{};

    for (final MapEntry<String, dynamic> entry in json.entries) {
      final AdvancedCustomizerState? state =
          AdvancedCustomizerStateX.fromString(entry.key);
      if (state == null || entry.value is! Map<String, dynamic>) {
        continue;
      }
      states[state] = AdvancedStyleValue.fromJson(
        entry.value as Map<String, dynamic>,
      );
    }

    return AdvancedStyleEntry(states: states);
  }
}

@immutable
class AdvancedScopedRule {
  const AdvancedScopedRule({
    required this.scope,
    required this.target,
    required this.priority,
    this.styles = const <String, AdvancedStyleEntry>{},
  });

  final AdvancedCustomizerScope scope;
  final String target;
  final int priority;
  final Map<String, AdvancedStyleEntry> styles;

  AdvancedScopedRule copyWith({
    AdvancedCustomizerScope? scope,
    String? target,
    int? priority,
    Map<String, AdvancedStyleEntry>? styles,
  }) {
    return AdvancedScopedRule(
      scope: scope ?? this.scope,
      target: target ?? this.target,
      priority: priority ?? this.priority,
      styles: styles ?? this.styles,
    );
  }

  AdvancedScopedRule copy() {
    final Map<String, AdvancedStyleEntry> copiedStyles =
        <String, AdvancedStyleEntry>{};
    for (final MapEntry<String, AdvancedStyleEntry> entry in styles.entries) {
      copiedStyles[entry.key] = entry.value.copy();
    }

    return AdvancedScopedRule(
      scope: scope,
      target: target,
      priority: priority,
      styles: copiedStyles,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> styleMap = <String, dynamic>{};
    for (final MapEntry<String, AdvancedStyleEntry> entry in styles.entries) {
      styleMap[entry.key] = entry.value.toJson();
    }

    return <String, dynamic>{
      'scope': scope.value,
      'target': target,
      'priority': priority,
      'styles': styleMap,
    };
  }

  static AdvancedScopedRule? fromJson(Map<String, dynamic> json) {
    final AdvancedCustomizerScope? scope = AdvancedCustomizerScopeX.fromString(
      json['scope'] as String?,
    );
    final String? target = json['target'] as String?;
    if (scope == null || target == null || target.isEmpty) {
      return null;
    }

    final int priority = (json['priority'] as num?)?.toInt() ?? 0;

    final Map<String, AdvancedStyleEntry> styles =
        <String, AdvancedStyleEntry>{};
    final dynamic rawStyles = json['styles'];
    if (rawStyles is Map<String, dynamic>) {
      for (final MapEntry<String, dynamic> entry in rawStyles.entries) {
        if (entry.value is! Map<String, dynamic>) {
          continue;
        }
        styles[entry.key] = AdvancedStyleEntry.fromJson(
          entry.value as Map<String, dynamic>,
        );
      }
    }

    return AdvancedScopedRule(
      scope: scope,
      target: target,
      priority: priority,
      styles: styles,
    );
  }
}
