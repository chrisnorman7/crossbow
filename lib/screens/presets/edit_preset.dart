import 'dart:io';

import 'package:backstreets_widgets/icons.dart';
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
import '../../util.dart';
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
      child: TabbedScaffold(
        tabs: [
          TabbedScaffoldTab(
            title: settingsTitle,
            icon: settingsIcon,
            builder: (final context) => getSettingsPage(
              ref: ref,
              presetContext: presetContext,
            ),
          ),
          TabbedScaffoldTab(
            title: Intl.message('Fields'),
            icon: Text('${preset.fields.length}'),
            builder: (final context) => getFieldsPage(ref: ref, preset: preset),
            floatingActionButton: FloatingActionButton(
              onPressed: () => createPresetField(
                context: context,
                ref: ref,
                presetContext: presetContext,
              ),
              tooltip: Intl.message('Create Field'),
              child: addIcon,
            ),
          )
        ],
      ),
    );
  }

  /// Save the given [presetContext].
  void save({
    required final WidgetRef ref,
    required final PresetContext presetContext,
  }) {
    presetContext.presetCollectionContext.save();
    ref
      ..refresh(
        presetProvider.call(PresetArgument(file: file, id: id)),
      )
      ..refresh(
        presetCollectionProvider.call(file),
      );
  }

  /// Get the settings page.
  Widget getSettingsPage({
    required final WidgetRef ref,
    required final PresetContext presetContext,
  }) {
    final preset = presetContext.preset;
    return ListView(
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
    );
  }

  /// Get the fields page.
  Widget getFieldsPage({
    required final WidgetRef ref,
    required final Preset preset,
  }) {
    final fields = preset.fields;
    if (fields.isEmpty) {
      return CenterText(
        text: nothingToShowMessage('fields'),
        autofocus: true,
      );
    }
    return BuiltSearchableListView(
      items: fields,
      builder: (final context, final index) {
        final field = fields[index];
        return SearchableListTile(
          searchString: field.name,
          child: PushWidgetListTile(
            title: field.name,
            builder: (final context) => const Placeholder(),
            autofocus: index == 0,
            subtitle: '${field.type.name} ( ${field.defaultValue}',
          ),
        );
      },
    );
  }
}
