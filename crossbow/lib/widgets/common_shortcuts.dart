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
    this.copyText,
    super.key,
  });

  /// The widget below this one in the tree.
  final Widget child;

  /// The function to call with the [newProjectHotkey].
  final VoidCallback? newCallback;

  /// The function to call with the [deleteHotkey].
  final VoidCallback? deleteCallback;

  /// The text to copy with the [copyHotkey].
  final String? copyText;

  /// Build the widget.
  @override
  Widget build(final BuildContext context) {
    final text = copyText;
    return CallbackShortcuts(
      bindings: {
        newShortcut: () => newCallback?.call(),
        deleteShortcut: () => deleteCallback?.call(),
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
