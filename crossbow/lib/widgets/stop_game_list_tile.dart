import 'package:backstreets_widgets/shortcuts.dart';
import 'package:backstreets_widgets/util.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../messages.dart';
import '../screens/commands/edit_stop_game_screen.dart';
import '../src/providers.dart';

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
  final ValueChanged<int?> onChanged;

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
          widget.onChanged(stopGame.id);
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
        final projectContext = valueContext.projectContext;
        final stopGame = valueContext.value;
        return CallbackShortcuts(
          bindings: {
            deleteShortcut: () async {
              if (widget.nullable) {
                await projectContext.db.stopGamesDao
                    .deleteStopGame(stopGameId: stopGame.id);
                widget.onChanged(null);
              }
            }
          },
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
      error: ErrorListView.withPositional,
      loading: LoadingWidget.new,
    );
  }
}
