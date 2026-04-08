import '../models/profile_models.dart';

class AdvancedDraftSessionManager {
  AdvancedDraftSessionManager({
    required AdvancedCustomizerProfile committed,
    this.maxUndoEntries = 20,
  }) : _committed = committed;

  final int maxUndoEntries;

  AdvancedCustomizerProfile _committed;
  AdvancedCustomizerProfile? _draft;
  final List<AdvancedCustomizerProfile> _undoStack =
      <AdvancedCustomizerProfile>[];

  AdvancedCustomizerProfile get committedProfile => _committed;
  AdvancedCustomizerProfile? get draftProfile => _draft;
  bool get hasDraft => _draft != null;

  void setCommittedProfile(AdvancedCustomizerProfile profile) {
    _committed = profile.copy();
    _draft = null;
  }

  AdvancedCustomizerProfile startDraft() {
    _draft = _committed.copy();
    return _draft!;
  }

  void replaceDraft(AdvancedCustomizerProfile profile) {
    _draft = profile.copy();
  }

  bool applyDraft() {
    if (_draft == null) {
      return false;
    }

    _undoStack.add(_committed.copy());
    if (_undoStack.length > maxUndoEntries) {
      _undoStack.removeAt(0);
    }

    _committed = _draft!.copyWith(updatedAt: DateTime.now().toUtc());
    _draft = null;
    return true;
  }

  bool discardDraft() {
    if (_draft == null) {
      return false;
    }
    _draft = null;
    return true;
  }

  bool undoLastApply() {
    if (_undoStack.isEmpty) {
      return false;
    }

    _committed = _undoStack.removeLast();
    _draft = null;
    return true;
  }
}
