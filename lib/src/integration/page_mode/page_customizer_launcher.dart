import 'package:flutter/material.dart';

import '../../advanced_customizer_controller.dart';
import '../../panel/customizer_panel.dart';
import '../_unsaved_changes_guard.dart';

Future<T?> openPageModeCustomizer<T>({
  required BuildContext context,
  required AdvancedCustomizerController controller,
  required String pageId,
  Widget? panelChild,
  bool protectUnsavedChanges = true,
}) async {
  controller.openCustomizerForPage(pageId);
  controller.enableInPagePreview(pageId: pageId);

  try {
    return await Navigator.of(context).push<T>(
      MaterialPageRoute<T>(
        builder: (BuildContext context) {
          Future<void> requestClose(BuildContext routeContext) async {
            if (protectUnsavedChanges) {
              final bool canClose = await guardCustomizerExit(
                routeContext,
                controller,
              );
              if (!canClose || !routeContext.mounted) {
                return;
              }
            }
            if (routeContext.mounted) {
              Navigator.of(routeContext).pop();
            }
          }

          return PopScope(
            canPop: !protectUnsavedChanges,
            onPopInvokedWithResult: (bool didPop, Object? result) async {
              if (didPop || !protectUnsavedChanges) {
                return;
              }
              final bool canClose = await guardCustomizerExit(
                context,
                controller,
              );
              if (canClose && context.mounted) {
                Navigator.of(context).pop();
              }
            },
            child: Scaffold(
              body: SafeArea(
                child: AdvancedCustomizerPage(
                  controller: controller,
                  child: panelChild,
                  onCloseRequested: () => requestClose(context),
                ),
              ),
            ),
          );
        },
        fullscreenDialog: true,
      ),
    );
  } finally {
    controller.disableInPagePreview();
  }
}
