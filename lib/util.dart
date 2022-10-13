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
import 'screens/presets/edit_preset.dart';
import 'src/json/json_value_context.dart';
import 'src/json/presets/preset.dart';
import 'src/json/presets/preset_collection.dart';
import 'src/providers/providers.dart';

/// Create a new ID.
String newId() => uuid.v4();

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
        if (!appContext.presetsDirectory.existsSync()) {
          appContext.presetsDirectory.createSync(recursive: true);
        }
        final file = File(
          path.join(
            appContext.presetsDirectory.path,
            value.endsWith(presetCollectionFileExtension)
                ? value
                : '$value$presetCollectionFileExtension',
          ),
        );
        final data = indentedJsonEncoder.convert(collection.toJson());
        file.writeAsStringSync(data);
        Navigator.pop(context);
        ref.refresh(presetCollectionsProvider);
      },
      labelText: Intl.message('Filename'),
      title: Intl.message('Preset Collection Filename'),
      tooltip: Intl.message('Save'),
      validator: (final value) {
        if (!appContext.presetsDirectory.existsSync()) {
          return null;
        }
        if (value == null || value.isEmpty) {
          return emptyValueMessage;
        }
        for (final file
            in appContext.presetsDirectory.listSync().whereType<File>()) {
          final filenameLowerCase = path.basename(file.path).toLowerCase();
          if (filenameLowerCase == value.toLowerCase() ||
              filenameLowerCase ==
                  '${value.toLowerCase()}$presetCollectionFileExtension') {
            return Intl.message('There is already a file with that name');
          }
        }
        return null;
      },
    ),
  );
}

/// Create a new preset inside of a [presetCollectionContext].
Future<void> createPreset({
  required final BuildContext context,
  required final WidgetRef ref,
  required final JsonValueContext<PresetCollection> presetCollectionContext,
}) {
  final preset = Preset();
  presetCollectionContext.value.presets.add(preset);
  ref.refresh(presetCollectionsProvider);
  return pushWidget(
    context: context,
    builder: (final context) =>
        EditPreset(file: presetCollectionContext.file, id: preset.id),
  );
}

/// Confirm before deleting a given [file].
Future<void> confirmDeleteFile({
  required final BuildContext context,
  required final File file,
  final VoidCallback? onDone,
}) =>
    confirm(
      context: context,
      message: confirmDeleteFileMessage,
      title: confirmDeleteTitle,
      yesCallback: () {
        file.deleteSync(recursive: true);
        Navigator.pop(context);
        onDone?.call();
      },
    );
