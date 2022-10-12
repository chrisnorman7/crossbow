import 'package:backstreets_widgets/icons.dart';
import 'package:backstreets_widgets/screens.dart';
import 'package:backstreets_widgets/util.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../src/json/json_value_context.dart';
import '../../src/json/presets/preset_collection.dart';
import '../../src/providers/providers.dart';
import '../../util.dart';

/// A widget for viewing preset collections.
class PresetCollectionsList extends ConsumerWidget {
  /// Create an instance.
  const PresetCollectionsList({
    super.key,
  });

  /// Build the widget.
  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final provider = ref.watch(presetCollectionsProvider);
    return provider.when(
      data: (final data) => Cancel(
        child: SimpleScaffold(
          title: 'Presets',
          body: getBody(ref: ref, presets: data.toList()),
          floatingActionButton: FloatingActionButton(
            onPressed: () => createPresetCollection(context: context, ref: ref),
            tooltip: Intl.message('New Preset Collection'),
            child: addIcon,
          ),
        ),
      ),
      error: ErrorScreen.withPositional,
      loading: LoadingScreen.new,
    );
  }

  /// Get the main widget.
  Widget getBody({
    required final WidgetRef ref,
    required final List<JsonValueContext<PresetCollection>> presets,
  }) {
    if (presets.isEmpty) {
      return CenterText(
        text: Intl.message(
          'There are no presets to show.',
          desc: 'The message to show when there are no presets to show.',
        ),
        autofocus: true,
      );
    }
    return BuiltSearchableListView(
      items: presets,
      builder: (final context, final index) {
        final value = presets[index];
        final preset = value.value;
        return SearchableListTile(
          searchString: preset.name,
          child: ListTile(
            autofocus: index == 0,
            title: Text(preset.name),
            subtitle: Text(preset.description),
            onTap: () => setClipboardText(preset.description),
          ),
        );
      },
    );
  }
}
