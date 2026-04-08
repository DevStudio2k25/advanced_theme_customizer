import 'package:flutter/material.dart';

import '../../advanced_customizer_controller.dart';
import '../_unsaved_changes_guard.dart';
import '../../panel/customizer_panel.dart';

Future<T?> openSettingsModeCustomizer<T>({
  required BuildContext context,
  required AdvancedCustomizerController controller,
  Widget? panelChild,
  bool useBottomSheet = true,
  bool protectUnsavedChanges = true,
}) async {
  controller.openGlobalCustomizer();

  if (useBottomSheet) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      isDismissible: !protectUnsavedChanges,
      enableDrag: !protectUnsavedChanges,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            if (!protectUnsavedChanges) {
              return true;
            }
            return guardCustomizerExit(context, controller);
          },
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: AdvancedCustomizerPanel(
                controller: controller,
                child: panelChild,
              ),
            ),
          ),
        );
      },
    );
  }

  return showDialog<T>(
    context: context,
    barrierDismissible: !protectUnsavedChanges,
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: () async {
          if (!protectUnsavedChanges) {
            return true;
          }
          return guardCustomizerExit(context, controller);
        },
        child: Dialog(
          child: AdvancedCustomizerPanel(
            controller: controller,
            child: panelChild,
          ),
        ),
      );
    },
  );
}
