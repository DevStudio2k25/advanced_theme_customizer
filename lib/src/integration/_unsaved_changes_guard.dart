import 'package:flutter/material.dart';

import '../advanced_customizer_controller.dart';

Future<bool> guardCustomizerExit(
  BuildContext context,
  AdvancedCustomizerController controller,
) async {
  if (!controller.hasDraftSession) {
    return true;
  }

  final _CustomizerExitDecision? decision =
      await showDialog<_CustomizerExitDecision>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Unsaved Changes'),
            content: const Text(
              'Apply your changes, discard them, or continue editing?',
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(_CustomizerExitDecision.cancel);
                },
                child: const Text('Keep Editing'),
              ),
              OutlinedButton(
                onPressed: () {
                  Navigator.of(context).pop(_CustomizerExitDecision.discard);
                },
                child: const Text('Discard'),
              ),
              FilledButton(
                onPressed: () {
                  Navigator.of(context).pop(_CustomizerExitDecision.apply);
                },
                child: const Text('Apply'),
              ),
            ],
          );
        },
      );

  switch (decision) {
    case _CustomizerExitDecision.apply:
      controller.applyDraft();
      return true;
    case _CustomizerExitDecision.discard:
      controller.discardDraft();
      return true;
    case _CustomizerExitDecision.cancel:
    case null:
      return false;
  }
}

enum _CustomizerExitDecision { apply, discard, cancel }
