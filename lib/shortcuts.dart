/// The shortcuts to be used by the program.
library shortcuts;

import 'package:backstreets_widgets/shortcuts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// The shortcut for viewing and editing presets.
final presetsShortcut = SingleActivator(
  LogicalKeyboardKey.keyP,
  control: useControlKey,
  meta: useMetaKey,
  shift: true,
);
