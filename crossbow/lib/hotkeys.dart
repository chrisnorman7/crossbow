import 'package:backstreets_widgets/shortcuts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// The hotkey for copying things.
final copyHotkey = SingleActivator(
  LogicalKeyboardKey.keyC,
  control: useControlKey,
  meta: useMetaKey,
);

/// The hotkey for testing things.
final testHotkey = SingleActivator(
  LogicalKeyboardKey.keyT,
  control: useControlKey,
  meta: useMetaKey,
  shift: true,
);

/// The page up hotkey.
const pageUpHotkey = SingleActivator(LogicalKeyboardKey.pageUp);

/// The page down hotkey.
const pageDownHotkey = SingleActivator(LogicalKeyboardKey.pageDown);

/// The backspace hotkey.
const backspaceHotkey = SingleActivator(LogicalKeyboardKey.backspace);

/// Build something.
final buildHotkey = SingleActivator(
  LogicalKeyboardKey.keyB,
  control: useControlKey,
  meta: useMetaKey,
  shift: true,
);
