import 'package:flutter/material.dart';

import '../hotkeys.dart';

/// A [CallbackShortcuts] which allows [newProjectHotkey] to trigger
/// [newCallback].
class NewCallbackShortcuts extends StatelessWidget {
  /// Create an instance.
  const NewCallbackShortcuts({
    required this.newCallback,
    required this.child,
    super.key,
  });

  /// The function to call when [newProjectHotkey] is pressed.
  final VoidCallback newCallback;

  /// The widget below this one in the tree.
  final Widget child;

  /// Build the widget.
  @override
  Widget build(final BuildContext context) => CallbackShortcuts(
        bindings: {newProjectHotkey: newCallback},
        child: child,
      );
}
