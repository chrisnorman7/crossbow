import 'package:backstreets_widgets/util.dart';
import 'package:flutter/material.dart';

import 'screens/presets/presets_list.dart';

/// The type of JSON.
typedef JsonType = Map<String, dynamic>;

/// The intent to show presets.
class PresetsIntent extends Intent {
  /// Allow this class to be constant.
  const PresetsIntent();
}

/// Show the edit presets window.
class PresetsAction extends ContextAction<PresetsIntent> {
  /// Create an instance.
  PresetsAction();

  /// Push the widget.
  @override
  void invoke(final PresetsIntent intent, [final BuildContext? context]) {
    if (context != null) {
      pushWidget(
        context: context,
        builder: (final context) => const PresetsList(),
      );
    }
  }
}
