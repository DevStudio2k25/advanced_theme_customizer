import '../../advanced_customizer_controller.dart';

class AdvancedCustomizerPanelController {
  AdvancedCustomizerPanelController(this.controller);

  final AdvancedCustomizerController controller;

  bool get hasUnsavedChanges => controller.hasDraftSession;

  void onApplyPressed() {
    controller.applyDraft();
  }

  void onDiscardPressed() {
    controller.discardDraft();
  }

  void onUndoPressed() {
    controller.undoLastApply();
  }
}
