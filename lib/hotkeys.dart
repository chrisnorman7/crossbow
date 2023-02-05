import 'package:backstreets_widgets/shortcuts.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

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

/// The hotkey for saving the project.
final saveProjectHotkey = SingleActivator(
  LogicalKeyboardKey.keyS,
  control: useControlKey,
  meta: useMetaKey,
);

/// The hotkey for closing the current project.
final closeProjectHotkey = SingleActivator(
  LogicalKeyboardKey.keyW,
  control: useControlKey,
  meta: useMetaKey,
);
