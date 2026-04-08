import '../models/style_models.dart';

class AdvancedPageDescriptor {
  const AdvancedPageDescriptor({
    required this.pageId,
    this.displayName,
    this.exposed = true,
  });

  final String pageId;
  final String? displayName;
  final bool exposed;
}

class AdvancedComponentGroupDescriptor {
  const AdvancedComponentGroupDescriptor({
    required this.groupId,
    required this.pageId,
    this.displayName,
  });

  final String groupId;
  final String pageId;
  final String? displayName;
}

class AdvancedComponentDescriptor {
  const AdvancedComponentDescriptor({
    required this.componentId,
    required this.pageId,
    this.componentTypeId,
    this.groupId,
    this.instanceId,
    this.displayName,
    this.isEditable = true,
    this.editableStates = kAdvancedCustomizerAllStates,
    this.editableProperties = const <AdvancedCustomizerProperty>{
      AdvancedCustomizerProperty.fill,
      AdvancedCustomizerProperty.border,
      AdvancedCustomizerProperty.text,
      AdvancedCustomizerProperty.icon,
      AdvancedCustomizerProperty.radius,
      AdvancedCustomizerProperty.borderWidth,
    },
  });

  final String componentId;
  final String pageId;
  final String? componentTypeId;
  final String? groupId;
  final String? instanceId;
  final String? displayName;
  final bool isEditable;
  final List<AdvancedCustomizerState> editableStates;
  final Set<AdvancedCustomizerProperty> editableProperties;
}

class AdvancedComponentRegistry {
  const AdvancedComponentRegistry({
    this.pages = const <AdvancedPageDescriptor>[],
    this.groups = const <AdvancedComponentGroupDescriptor>[],
    this.components = const <AdvancedComponentDescriptor>[],
  });

  final List<AdvancedPageDescriptor> pages;
  final List<AdvancedComponentGroupDescriptor> groups;
  final List<AdvancedComponentDescriptor> components;

  List<String> get pageIds {
    final Set<String> output = <String>{};
    for (final AdvancedPageDescriptor page in pages) {
      if (page.exposed) {
        output.add(page.pageId);
      }
    }
    for (final AdvancedComponentDescriptor component in components) {
      output.add(component.pageId);
    }
    return output.toList(growable: false)..sort();
  }

  List<AdvancedPageDescriptor> get exposedPages {
    if (pages.isNotEmpty) {
      return pages
          .where((AdvancedPageDescriptor page) => page.exposed)
          .toList(growable: false);
    }
    return pageIds
        .map((String pageId) => AdvancedPageDescriptor(pageId: pageId))
        .toList(growable: false);
  }

  List<AdvancedComponentDescriptor> forPage(String pageId, {String? groupId}) {
    return components
        .where(
          (AdvancedComponentDescriptor descriptor) =>
              descriptor.pageId == pageId &&
              (groupId == null || descriptor.groupId == groupId),
        )
        .toList(growable: false);
  }

  List<AdvancedComponentGroupDescriptor> groupsForPage(String pageId) {
    if (groups.isNotEmpty) {
      return groups
          .where(
            (AdvancedComponentGroupDescriptor group) => group.pageId == pageId,
          )
          .toList(growable: false);
    }

    final Set<String> derived = components
        .where(
          (AdvancedComponentDescriptor component) => component.pageId == pageId,
        )
        .map((AdvancedComponentDescriptor component) => component.groupId)
        .whereType<String>()
        .toSet();

    final List<AdvancedComponentGroupDescriptor> output =
        <AdvancedComponentGroupDescriptor>[];
    for (final String groupId in derived) {
      output.add(
        AdvancedComponentGroupDescriptor(groupId: groupId, pageId: pageId),
      );
    }
    output.sort(
      (
        AdvancedComponentGroupDescriptor left,
        AdvancedComponentGroupDescriptor right,
      ) => left.groupId.compareTo(right.groupId),
    );
    return output;
  }

  List<String> componentIdsForPage(String pageId) {
    return forPage(pageId)
        .map((AdvancedComponentDescriptor descriptor) => descriptor.componentId)
        .toList(growable: false);
  }

  List<String> componentIdsForGroup(String pageId, String groupId) {
    return forPage(pageId, groupId: groupId)
        .map((AdvancedComponentDescriptor descriptor) => descriptor.componentId)
        .toList(growable: false);
  }

  AdvancedComponentDescriptor? byId(String componentId) {
    for (final AdvancedComponentDescriptor descriptor in components) {
      if (descriptor.componentId == componentId) {
        return descriptor;
      }
    }
    return null;
  }
}
