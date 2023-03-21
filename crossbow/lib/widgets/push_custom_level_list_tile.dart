import 'package:backstreets_widgets/util.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../messages.dart';
import '../screens/commands/edit_push_custom_level_screen.dart';
import '../screens/select_custom_level_screen.dart';
import '../src/contexts/push_custom_level_context.dart';
import '../src/providers.dart';
import 'asset_reference_play_sound_semantics.dart';
import 'common_shortcuts.dart';
import 'error_list_tile.dart';
import 'play_sound_semantics.dart';

/// A list tile for configuring a push custom level.
class PushCustomLevelListTile extends ConsumerStatefulWidget {
  /// Create an instance.
  const PushCustomLevelListTile({
    required this.pushCustomLevelId,
    required this.onChanged,
    this.autofocus = false,
    super.key,
  });

  /// The ID of the current push custom level.
  final int? pushCustomLevelId;

  /// The function to call when the push custom level changes.
  final ValueChanged<int?> onChanged;

  /// Whether the list tile should be autofocused or not.
  final bool autofocus;

  /// Create state for this widget.
  @override
  PushCustomLevelListTileState createState() => PushCustomLevelListTileState();
}

/// State for [PushCustomLevelListTile].
class PushCustomLevelListTileState
    extends ConsumerState<PushCustomLevelListTile> {
  /// Build a widget.
  @override
  Widget build(final BuildContext context) {
    final id = widget.pushCustomLevelId;
    if (id == null) {
      return getBody(null);
    }
    final value = ref.watch(pushCustomLevelProvider.call(id));
    return value.when(
      data: getBody,
      error: ErrorListTile.withPositional,
      loading: LoadingWidget.new,
    );
  }

  /// Get the body for this widget.
  Widget getBody(final PushCustomLevelContext? pushCustomLevelContext) {
    final projectContext = ref.watch(projectContextNotifierProvider)!;
    final pushCustomLevelsDao = projectContext.db.pushCustomLevelsDao;
    final pushCustomLevel = pushCustomLevelContext?.value;
    final customLevel = pushCustomLevelContext?.customLevel;
    return AssetReferencePlaySoundSemantics(
      assetReferenceId: customLevel?.musicId,
      child: CommonShortcuts(
        deleteCallback: () async {
          if (pushCustomLevel != null) {
            await pushCustomLevelsDao.deletePushCustomLevel(
              id: pushCustomLevel.id,
            );
            widget.onChanged(null);
          }
        },
        child: Builder(
          builder: (final context) => ListTile(
            autofocus: widget.autofocus,
            title: Text(Intl.message('Push Custom Level')),
            subtitle: Text(customLevel?.name ?? unsetMessage),
            onTap: () {
              PlaySoundSemantics.of(context)?.stop();
              if (pushCustomLevel == null) {
                pushWidget(
                  context: context,
                  builder: (final context) => SelectCustomLevelScreen(
                    onChanged: (final value) async {
                      final newPushCustomLevel =
                          await pushCustomLevelsDao.createPushCustomLevel(
                        customLevelId: value,
                      );
                      widget.onChanged(newPushCustomLevel.id);
                      if (mounted) {
                        await pushWidget(
                          context: context,
                          builder: (final context) => EditPushCustomLevelScreen(
                            pushCustomLevelId: newPushCustomLevel.id,
                          ),
                        );
                      }
                    },
                  ),
                );
              } else {
                pushWidget(
                  context: context,
                  builder: (final context) => EditPushCustomLevelScreen(
                    pushCustomLevelId: pushCustomLevel.id,
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
