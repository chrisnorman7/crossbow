import 'package:backstreets_widgets/shortcuts.dart';
import 'package:backstreets_widgets/util.dart';
import 'package:flutter/widgets.dart';

import '../hotkeys.dart';

/// A widget which maps the most common shortcuts.
class CommonShortcuts extends StatelessWidget {
  /// Create an instance.
  const CommonShortcuts({
    required this.child,
    this.newCallback,
    this.deleteCallback,
    this.moveUpCallback,
    this.moveDownCallback,
    this.copyText,
    super.key,
  });

  /// The widget below this one in the tree.
  final Widget child;

  /// The function to call with the [newProjectHotkey].
  final VoidCallback? newCallback;

  /// The function to call with the [deleteHotkey].
  final VoidCallback? deleteCallback;

  /// The function to call with the [moveUpShortcut].
  final VoidCallback? moveUpCallback;

  /// The function to call with the [moveDownShortcut].
  final VoidCallback? moveDownCallback;

  /// The text to copy with the [copyHotkey].
  final String? copyText;

  /// Build the widget.
  @override
  Widget build(final BuildContext context) {
    final newFunction = newCallback;
    final deleteFunction = deleteCallback;
    final moveUpFunction = moveUpCallback;
    final moveDownFunction = moveDownCallback;
    final text = copyText;
    return CallbackShortcuts(
      bindings: {
        if (newFunction != null) newShortcut: newFunction,
        if (deleteFunction != null) deleteShortcut: deleteFunction,
        if (moveUpFunction != null) moveUpShortcut: moveUpFunction,
        if (moveDownFunction != null) moveDownShortcut: moveDownFunction,
        copyHotkey: () {
          if (text != null) {
            setClipboardText(text);
          }
        }
      },
      child: child,
    );
  }
}
