import 'package:backstreets_widgets/util.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:crossbow_backend/crossbow_backend.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../messages.dart';
import '../screens/select_custom_level_screen.dart';
import '../src/contexts/value_context.dart';
import '../src/providers.dart';
import 'asset_reference_play_sound_semantics.dart';
import 'common_shortcuts.dart';
import 'error_list_tile.dart';
import 'play_sound_semantics.dart';

/// A list tile that allows selecting a new custom level.
class CustomLevelListTile extends ConsumerWidget {
  /// Create an instance.
  const CustomLevelListTile({
    required this.customLevelId,
    required this.onChanged,
    this.title,
    this.autofocus = false,
    this.nullable = false,
    super.key,
  });

  /// The ID of the current custom level.
  final int? customLevelId;

  /// The function to call when the custom level changes.
  final ValueChanged<CustomLevel?> onChanged;

  /// The title for this list tile.
  final String? title;

  /// Whether the list tile should be autofocused.
  final bool autofocus;

  /// Whether the new menu ID can be `null`.
  final bool nullable;

  /// Build the widget.
  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final id = customLevelId;
    if (id == null) {
      return getBody(context: context);
    }
    final value = ref.watch(customLevelProvider.call(id));
    return value.when(
      data: (final data) => getBody(context: context, customLevelContext: data),
      error: ErrorListTile.withPositional,
      loading: LoadingWidget.new,
    );
  }

  /// Get the body for this widget.
  Widget getBody({
    required final BuildContext context,
    final ValueContext<CustomLevel>? customLevelContext,
  }) {
    final level = customLevelContext?.value;
    return CommonShortcuts(
      deleteCallback: () {
        if (nullable) {
          onChanged(null);
        }
      },
      child: AssetReferencePlaySoundSemantics(
        assetReferenceId: level?.musicId,
        looping: true,
        child: Builder(
          builder: (final context) => ListTile(
            autofocus: autofocus,
            title: Text(title ?? Intl.message('Custom Level')),
            subtitle: Text(level?.name ?? unsetMessage),
            onTap: () {
              PlaySoundSemantics.of(context)?.stop();
              pushWidget(
                context: context,
                builder: (final context) => SelectCustomLevelScreen(
                  onChanged: onChanged,
                  currentCustomLevelId: level?.id,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
