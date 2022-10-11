import 'package:backstreets_widgets/screens.dart';
import 'package:backstreets_widgets/util.dart';
import 'package:backstreets_widgets/widgets/searchable_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../src/json/presets/preset.dart';
import '../../src/providers/providers.dart';

/// A widget for viewing presets.
class PresetsList extends ConsumerWidget {
  /// Create an instance.
  const PresetsList({
    super.key,
  });

  /// Build the widget.
  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final provider = ref.watch(presetsProvider);
    return provider.when(
      data: (final data) => SimpleScaffold(
        title: 'Presets',
        body: getBody(ref: ref, presets: data.toList()),
      ),
      error: ErrorScreen.withPositional,
      loading: LoadingScreen.new,
    );
  }

  /// Get the main widget.
  Widget getBody({
    required final WidgetRef ref,
    required final List<Preset> presets,
  }) =>
      BuiltSearchableListView(
        items: presets,
        builder: (final context, final index) {
          final preset = presets[index];
          return SearchableListTile(
            searchString: preset.name,
            child: ListTile(
              autofocus: index == 0,
              title: Text(preset.name),
              subtitle: Text(preset.description),
              onTap: () => setClipboardText(preset.code),
            ),
          );
        },
      );
}
