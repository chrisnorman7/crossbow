import 'package:backstreets_widgets/util.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:crossbow_backend/crossbow_backend.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../messages.dart';
import '../screens/commands/edit_stop_game_screen.dart';
import '../src/providers.dart';
import 'common_shortcuts.dart';
import 'error_list_tile.dart';

/// A list tile that will show the stop game with the given [stopGameId].
class StopGameListTile extends ConsumerStatefulWidget {
  /// Create an instance.
  const StopGameListTile({
    required this.stopGameId,
    required this.onChanged,
    this.title,
    this.autofocus = false,
    this.nullable = true,
    super.key,
  });

  /// The ID of the current stop game.
  final int? stopGameId;

  /// The function to call when the stop game changes.
  final ValueChanged<StopGame?> onChanged;

  /// The title for the list tile.
  final String? title;

  /// Whether the list tile should be autofocused.
  final bool autofocus;

  /// Whether or not the stop game can be set to `null`.
  final bool nullable;

  /// Create state for this widget.
  @override
  StopGameListTileState createState() => StopGameListTileState();
}

/// State for [StopGameListTile].
class StopGameListTileState extends ConsumerState<StopGameListTile> {
  /// Build a widget.
  @override
  Widget build(final BuildContext context) {
    final id = widget.stopGameId;
    if (id == null) {
      return ListTile(
        autofocus: widget.autofocus,
        title: Text(widget.title ?? Intl.message('Stop Game')),
        subtitle: Text(unsetMessage),
        onTap: () async {
          final projectContext = ref.watch(projectContextNotifierProvider)!;
          final stopGame =
              await projectContext.db.stopGamesDao.createStopGame();
          widget.onChanged(stopGame);
          if (mounted) {
            await pushWidget(
              context: context,
              builder: (final context) =>
                  EditStopGameScreen(stopGameId: stopGame.id),
            );
          }
        },
      );
    }
    final value = ref.watch(stopGameProvider.call(id));
    return value.when(
      data: (final valueContext) {
        final stopGame = valueContext.value;
        return CommonShortcuts(
          deleteCallback: widget.nullable
              ? () async {
                  final projectContext =
                      ref.watch(projectContextNotifierProvider)!;
                  await projectContext.db.stopGamesDao
                      .deleteStopGame(stopGame: stopGame);
                  widget.onChanged(null);
                }
              : null,
          copyText: id.toString(),
          child: ListTile(
            autofocus: widget.autofocus,
            title: Text(widget.title ?? Intl.message('Stop Game')),
            subtitle: Text(setMessage),
            onTap: () async {
              await pushWidget(
                context: context,
                builder: (final context) =>
                    EditStopGameScreen(stopGameId: stopGame.id),
              );
            },
          ),
        );
      },
      error: ErrorListTile.withPositional,
      loading: LoadingWidget.new,
    );
  }
}
