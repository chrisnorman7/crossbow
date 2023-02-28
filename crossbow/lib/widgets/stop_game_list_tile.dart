import 'package:backstreets_widgets/shortcuts.dart';
import 'package:backstreets_widgets/util.dart';
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

  /// Create state for this widget.
  @override
  StopGameListTileState createState() => StopGameListTileState();
}

/// State for [StopGameListTile].
class StopGameListTileState extends ConsumerState<StopGameListTile> {
  /// Build a widget.
  @override
  Widget build(final BuildContext context) {
    final projectContext = ref.watch(projectContextNotifierProvider)!;
    final stopGamesDao = projectContext.db.stopGamesDao;
    final value = widget.stopGameId;
    return CallbackShortcuts(
      bindings: {
        deleteShortcut: () async {
          if (value != null) {
            await stopGamesDao.deleteStopGame(stopGameId: value);
            widget.onChanged(null);
          }
        }
      },
      child: ListTile(
        autofocus: widget.autofocus,
        title: Text(widget.title ?? Intl.message('Stop Game')),
        subtitle: Text(value == null ? unsetMessage : setMessage),
        onTap: () async {
          if (value == null) {
            final stopGame =
                await projectContext.db.stopGamesDao.createStopGame();
            if (mounted) {
              await pushWidget(
                context: context,
                builder: (final context) =>
                    EditStopGameScreen(stopGameId: stopGame.id),
              );
            }
            widget.onChanged(stopGame.id);
          } else {
            await pushWidget(
              context: context,
              builder: (final context) => EditStopGameScreen(stopGameId: value),
            );
          }
        },
      ),
    );
  }
}
