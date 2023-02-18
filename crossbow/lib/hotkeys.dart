import 'package:backstreets_widgets/shortcuts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// The hotkey for creating a new project.
final newProjectHotkey = SingleActivator(
  LogicalKeyboardKey.keyN,
  control: useControlKey,
  meta: useMetaKey,
);

/// The hotkey for opening an existing project.
final openProjectHotkey = SingleActivator(
  LogicalKeyboardKey.keyO,
  control: useControlKey,
  meta: useMetaKey,
);

/// The hotkey for copying things.
final copyHotkey = SingleActivator(
  LogicalKeyboardKey.keyC,
  control: useControlKey,
  meta: useMetaKey,
);

/// The hotkey for closing something.
final closeHotkey = SingleActivator(
  LogicalKeyboardKey.keyW,
  control: useControlKey,
  meta: useMetaKey,
);
