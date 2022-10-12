/// Provides various utility functions.
library util;

import 'dart:io';

import 'package:backstreets_widgets/util.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;

import 'constants.dart';
import 'messages.dart';
import 'src/json/presets/preset_collection.dart';
import 'src/providers/providers.dart';

/// Create a new preset.
Future<void> createPresetCollection({
  required final BuildContext context,
  required final WidgetRef ref,
}) async {
  final collection = PresetCollection();
  final appContext = await ref.watch(appContextProvider.future);
  await pushWidget(
    context: context,
    builder: (final context) => GetText(
      onDone: (final value) {
        final file = File(path.join(appContext.presetsDirectory.path, value));
        final data = indentedJsonEncoder.convert(collection.toJson());
        file.writeAsStringSync(data);
        Navigator.pop(context);
        ref.refresh(presetCollectionsProvider);
      },
      labelText: Intl.message('Filename'),
      title: Intl.message('Preset Collection Filename'),
      tooltip: Intl.message('Save'),
      validator: (final value) {
        if (value == null || value.isEmpty) {
          return emptyValueMessage;
        }
        for (final file
            in appContext.presetsDirectory.listSync().whereType<File>()) {
          if (path.basename(file.path).toLowerCase() == value.toLowerCase()) {
            return Intl.message('There is already a file with that name');
          }
        }
        return null;
      },
    ),
  );
}
