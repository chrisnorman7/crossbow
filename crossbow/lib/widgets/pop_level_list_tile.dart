import 'package:backstreets_widgets/util.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../hotkeys.dart';
import '../messages.dart';
import '../screens/commands/edit_pop_level_screen.dart';
import '../src/providers.dart';

/// A list tile to show a pop level with the given [popLevelId].
class PopLevelListTile extends ConsumerStatefulWidget {
  /// Create an instance.
  const PopLevelListTile({
    required this.popLevelId,
    required this.onChanged,
    required this.title,
    this.autofocus = false,
    this.nullable = true,
    super.key,
  });

  /// The ID of the pop level to show.
  final int? popLevelId;

  /// The function to call when the pop level changes.
  final ValueChanged<int?> onChanged;

  /// The title of the list tile.
  final String title;

  /// Whether the list tile should be autofocused.
  final bool autofocus;

  /// Whether the pop level can be set to `null`.
  final bool nullable;

  /// Create state for this widget.
  @override
  PopLevelListTileState createState() => PopLevelListTileState();
}

/// State for [PopLevelListTile].
class PopLevelListTileState extends ConsumerState<PopLevelListTile> {
  /// Build a widget.
  @override
  Widget build(final BuildContext context) {
    final popLevelId = widget.popLevelId;
    if (popLevelId == null) {
      return ListTile(
        autofocus: widget.autofocus,
        title: Text(widget.title),
        subtitle: Text(unsetMessage),
        onTap: () async {
          final projectContext = ref.watch(projectContextNotifierProvider)!;
          final popLevel =
              await projectContext.db.popLevelsDao.createPopLevel();
          widget.onChanged(popLevel.id);
          if (mounted) {
            await pushWidget(
              context: context,
              builder: (final context) => EditPopLevelScreen(
                popLevelId: popLevel.id,
                onChanged: widget.onChanged,
              ),
            );
          }
        },
      );
    }
    final value = ref.watch(popLevelProvider.call(popLevelId));
    return value.when(
      data: (final valueContext) {
        final projectContext = valueContext.projectContext;
        final popLevel = valueContext.value;
        return CallbackShortcuts(
          bindings: {
            deleteHotkey: () async {
              if (widget.nullable) {
                await projectContext.db.popLevelsDao
                    .deletePopLevel(id: popLevel.id);
                widget.onChanged(null);
              }
            }
          },
          child: ListTile(
            autofocus: widget.autofocus,
            title: Text(widget.title),
            subtitle: Text(setMessage),
            onTap: () => pushWidget(
              context: context,
              builder: (final context) => EditPopLevelScreen(
                popLevelId: popLevel.id,
                onChanged: widget.onChanged,
              ),
            ),
          ),
        );
      },
      error: ErrorListView.withPositional,
      loading: LoadingWidget.new,
    );
  }
}
