import 'core/models/style_models.dart';
import 'core/persistence/profile_store.dart';
import 'core/registry/component_registry.dart';
import 'theme_hooks/panel_skin_hooks.dart';

class AdvancedCustomizerConfig {
  const AdvancedCustomizerConfig({
    this.registry = const AdvancedComponentRegistry(),
    this.defaultProfileJson,
    this.profileStore,
    this.exposedPageIds = const <String>{},
    this.lockedTargetIds = const <String>{},
    this.panelSkin = const AdvancedCustomizerPanelSkin(),
    this.panelStrings = const AdvancedCustomizerPanelStrings(),
    this.sectionVisibility = const AdvancedCustomizerSectionVisibility(),
    this.defaultScope = AdvancedCustomizerScope.global,
  });

  final AdvancedComponentRegistry registry;
  final String? defaultProfileJson;
  final AdvancedCustomizerProfileStore? profileStore;
  final Set<String> exposedPageIds;
  final Set<String> lockedTargetIds;
  final AdvancedCustomizerPanelSkin panelSkin;
  final AdvancedCustomizerPanelStrings panelStrings;
  final AdvancedCustomizerSectionVisibility sectionVisibility;
  final AdvancedCustomizerScope defaultScope;
}
