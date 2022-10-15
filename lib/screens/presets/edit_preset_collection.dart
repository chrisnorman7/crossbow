import 'dart:io';

import 'package:backstreets_widgets/icons.dart';
import 'package:backstreets_widgets/screens.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../messages.dart';
import '../../src/json/json_value_context.dart';
import '../../src/json/presets/preset_collection.dart';
import '../../src/providers/providers.dart';
import '../../util.dart';
import '../file_does_not_exist_screen.dart';
import 'edit_preset.dart';

/// A widget that can edit the [PresetCollection] stored in the given [file].
class EditPresetCollection extends ConsumerWidget {
  /// Create an instance.
  const EditPresetCollection({
    required this.file,
    super.key,
  });

  /// The file which contains the preset collection to edit.
  final File file;

  /// Build a widget.
  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    if (!file.existsSync()) {
      return FileDoesNotExistScreen(file: file);
    }
    final presetCollectionContext = ref.watch(
      presetCollectionProvider.call(file),
    );
    final presetCollection = presetCollectionContext.value;
    final presets = presetCollection.presets;
    return Cancel(
      child: TabbedScaffold(
        tabs: [
          TabbedScaffoldTab(
            title: settingsTitle,
            icon: settingsIcon,
            builder: (final context) => getSettingsPage(ref: ref),
          ),
          TabbedScaffoldTab(
            title: Intl.message('Presets'),
            icon: Text('${presets.length}'),
            builder: (final context) => getPresetsPage(ref: ref),
            floatingActionButton: FloatingActionButton(
              onPressed: () => createPreset(
                context: context,
                ref: ref,
                presetCollectionContext: presetCollectionContext,
              ),
              tooltip: Intl.message('Create Preset'),
              child: addIcon,
            ),
          )
        ],
      ),
    );
  }

  /// Get the settings page.
  Widget getSettingsPage({
    required final WidgetRef ref,
  }) {
    final presetCollectionContext = ref.watch(
      presetCollectionProvider.call(file),
    );
    final presetCollection = presetCollectionContext.value;
    return ListView(
      children: [
        TextListTile(
          value: presetCollection.name,
          onChanged: (final value) {
            presetCollection.name = value;
            save(ref: ref, presetCollection: presetCollectionContext);
          },
          header: nameMessage,
          autofocus: true,
        ),
        TextListTile(
          value: presetCollection.description,
          onChanged: (final value) {
            presetCollection.description = value;
            save(ref: ref, presetCollection: presetCollectionContext);
          },
          header: descriptionMessage,
        ),
        TextListTile(
          value: presetCollection.authors,
          onChanged: (final value) {
            presetCollection.authors = value;
            save(ref: ref, presetCollection: presetCollectionContext);
          },
          header: Intl.message('Authors'),
        )
      ],
    );
  }

  /// Get the page to show presets.
  Widget getPresetsPage({
    required final WidgetRef ref,
  }) {
    final presetCollection = ref.watch(presetCollectionProvider.call(file));
    final presets = presetCollection.value.presets;
    if (presets.isEmpty) {
      return CenterText(
        text: nothingToShowMessage('presets'),
        autofocus: true,
      );
    }
    return BuiltSearchableListView(
      items: presets,
      builder: (final context, final index) {
        final preset = presets[index];
        return SearchableListTile(
          searchString: preset.name,
          child: PushWidgetListTile(
            title: preset.name,
            builder: (final context) => EditPreset(
              file: presetCollection.file,
              id: preset.id,
            ),
            autofocus: index == 0,
            subtitle: preset.description,
          ),
        );
      },
    );
  }

  /// Save the preset collection.
  void save({
    required final WidgetRef ref,
    required final JsonValueContext<PresetCollection> presetCollection,
  }) {
    presetCollection.save();
    ref.refresh(presetCollectionProvider.call(presetCollection.file));
  }
}
