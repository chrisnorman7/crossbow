import 'dart:io';

import 'package:backstreets_widgets/screens.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../messages.dart';
import '../../src/json/presets/preset.dart';
import '../../src/json/presets/preset_collection.dart';
import '../../src/providers/preset_argument.dart';
import '../../src/providers/preset_context.dart';
import '../../src/providers/providers.dart';
import '../file_does_not_exist_screen.dart';

/// A widget to edit a [Preset].
class EditPreset extends ConsumerWidget {
  /// Create an instance.
  const EditPreset({
    required this.file,
    required this.id,
    super.key,
  });

  /// The file where the [PresetCollection] is stored.
  final File file;

  /// The ID of the [Preset] to edit.
  final String id;

  ///
  /// Build the widget.
  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    if (!file.existsSync()) {
      return FileDoesNotExistScreen(file: file);
    }
    final presetContext = ref.watch(
      presetProvider.call(PresetArgument(file: file, id: id)),
    );
    final preset = presetContext.preset;
    return Cancel(
      child: SimpleScaffold(
        title: Intl.message('Edit Preset'),
        body: ListView(
          children: [
            TextListTile(
              value: preset.name,
              onChanged: (final value) {
                preset.name = value;
                save(ref: ref, presetContext: presetContext);
              },
              header: nameMessage,
              autofocus: true,
            ),
            TextListTile(
              value: preset.description,
              onChanged: (final value) {
                preset.description = value;
                save(ref: ref, presetContext: presetContext);
              },
              header: descriptionMessage,
            ),
            TextListTile(
              value: preset.code,
              onChanged: (final value) {
                preset.code = value;
                save(ref: ref, presetContext: presetContext);
              },
              header: Intl.message('Code'),
            )
          ],
        ),
      ),
    );
  }

  /// Save the given [presetContext].
  void save({
    required final WidgetRef ref,
    required final PresetContext presetContext,
  }) {
    presetContext.presetCollectionContext.save();
    ref.refresh(
      presetProvider.call(PresetArgument(file: file, id: id)),
    );
  }
}
