import 'package:backstreets_widgets/util.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../hotkeys.dart';
import '../messages.dart';
import '../screens/commands/edit_push_menu_screen.dart';
import '../screens/select_menu_screen.dart';
import '../src/contexts/push_menu_context.dart';
import '../src/providers.dart';
import 'asset_reference_play_sound_semantics.dart';
import 'play_sound_semantics.dart';

/// A list tile for configuring a push menu.
class PushMenuListTile extends ConsumerStatefulWidget {
  /// Create an instance.
  const PushMenuListTile({
    required this.pushMenuId,
    required this.onChanged,
    this.autofocus = false,
    super.key,
  });

  /// The ID of the current push menu.
  final int? pushMenuId;

  /// The function to call when the push menu changes.
  final ValueChanged<int?> onChanged;

  /// Whether the list tile should be autofocused or not.
  final bool autofocus;

  /// Create state for this widget.
  @override
  PushMenuListTileState createState() => PushMenuListTileState();
}

/// State for [PushMenuListTile].
class PushMenuListTileState extends ConsumerState<PushMenuListTile> {
  /// Build a widget.
  @override
  Widget build(final BuildContext context) {
    final id = widget.pushMenuId;
    if (id == null) {
      return getBody(null);
    }
    final value = ref.watch(pushMenuProvider.call(id));
    return value.when(
      data: getBody,
      error: ErrorListView.withPositional,
      loading: LoadingWidget.new,
    );
  }

  /// Get the body for this widget.
  Widget getBody(final PushMenuContext? pushMenuContext) {
    final projectContext = ref.watch(projectContextNotifierProvider)!;
    final pushMenusDao = projectContext.db.pushMenusDao;
    final pushMenu = pushMenuContext?.value;
    final menu = pushMenuContext?.menu;
    return AssetReferencePlaySoundSemantics(
      assetReferenceId: menu?.musicId,
      child: CallbackShortcuts(
        bindings: {
          deleteHotkey: () async {
            if (pushMenu != null) {
              await pushMenusDao.deletePushMenu(id: pushMenu.id);
              widget.onChanged(null);
            }
          }
        },
        child: Builder(
          builder: (final context) => ListTile(
            autofocus: widget.autofocus,
            title: Text(Intl.message('Push Menu')),
            subtitle: Text(menu?.name ?? unsetMessage),
            onTap: () {
              PlaySoundSemantics.of(context)?.stop();
              if (pushMenu == null) {
                pushWidget(
                  context: context,
                  builder: (final context) => SelectMenuScreen(
                    onChanged: (final value) async {
                      final newPushMenu = await pushMenusDao.createPushMenu(
                        menuId: value,
                      );
                      widget.onChanged(newPushMenu.id);
                      if (mounted) {
                        await pushWidget(
                          context: context,
                          builder: (final context) =>
                              EditPushMenuScreen(pushMenuId: newPushMenu.id),
                        );
                      }
                    },
                  ),
                );
              } else {
                pushWidget(
                  context: context,
                  builder: (final context) => EditPushMenuScreen(
                    pushMenuId: pushMenu.id,
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
