import 'package:flutter/material.dart';

class AdvancedCustomizerPanelSkin {
  const AdvancedCustomizerPanelSkin({
    this.backgroundColor,
    this.headerColor,
    this.headerTextStyle,
    this.cornerRadius = 20,
    this.elevation = 2,
  });

  final Color? backgroundColor;
  final Color? headerColor;
  final TextStyle? headerTextStyle;
  final double cornerRadius;
  final double elevation;
}

class AdvancedCustomizerPanelStrings {
  const AdvancedCustomizerPanelStrings({
    this.title = 'Customize Theme',
    this.unsavedChangesLabel = 'Unsaved changes',
    this.applyLabel = 'Apply',
    this.discardLabel = 'Discard',
    this.undoLabel = 'Undo',
    this.scopeLabel = 'Scope',
    this.pageLabel = 'Page',
    this.groupLabel = 'Group',
    this.componentTypeLabel = 'Component Type',
    this.allGroupsLabel = 'All groups',
    this.allComponentTypesLabel = 'All component types',
    this.componentsLabel = 'Components',
    this.statesLabel = 'States',
    this.fillLabel = 'Fill',
    this.borderLabel = 'Border',
    this.textLabel = 'Text',
    this.iconLabel = 'Icon',
    this.radiusLabel = 'Radius',
    this.borderWidthLabel = 'Border Width',
    this.copyLabel = 'Copy',
    this.pasteLabel = 'Paste',
    this.resetComponentLabel = 'Reset Component',
    this.resetGroupLabel = 'Reset Group',
    this.resetPageLabel = 'Reset Page',
    this.resetProfileLabel = 'Reset Profile',
  });

  final String title;
  final String unsavedChangesLabel;
  final String applyLabel;
  final String discardLabel;
  final String undoLabel;
  final String scopeLabel;
  final String pageLabel;
  final String groupLabel;
  final String componentTypeLabel;
  final String allGroupsLabel;
  final String allComponentTypesLabel;
  final String componentsLabel;
  final String statesLabel;
  final String fillLabel;
  final String borderLabel;
  final String textLabel;
  final String iconLabel;
  final String radiusLabel;
  final String borderWidthLabel;
  final String copyLabel;
  final String pasteLabel;
  final String resetComponentLabel;
  final String resetGroupLabel;
  final String resetPageLabel;
  final String resetProfileLabel;
}

class AdvancedCustomizerSectionVisibility {
  const AdvancedCustomizerSectionVisibility({
    this.showScopeSection = true,
    this.showComponentsSection = true,
    this.showPropertiesSection = true,
    this.showActionsSection = true,
  });

  final bool showScopeSection;
  final bool showComponentsSection;
  final bool showPropertiesSection;
  final bool showActionsSection;
}
