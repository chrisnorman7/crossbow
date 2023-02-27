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
class PushMenuListTile extends ConsumerWidget {
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

  /// Build the widget.
  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final id = pushMenuId;
    if (id == null) {
      return getBody(
        context: context,
        ref: ref,
      );
    }
    final value = ref.watch(pushMenuProvider.call(id));
    return value.when(
      data: (final data) =>
          getBody(context: context, ref: ref, pushMenuContext: data),
      error: ErrorListView.withPositional,
      loading: LoadingWidget.new,
    );
  }

  /// Get the body for this widget.
  Widget getBody({
    required final BuildContext context,
    required final WidgetRef ref,
    final PushMenuContext? pushMenuContext,
  }) {
    final projectContext = ref.watch(projectContextNotifierProvider)!;
    final pushMenusDao = projectContext.db.pushMenusDao;
    final pushMenu = pushMenuContext?.pushMenu;
    final menu = pushMenuContext?.menu;
    return AssetReferencePlaySoundSemantics(
      assetReferenceId: menu?.musicId,
      child: CallbackShortcuts(
        bindings: {
          deleteHotkey: () async {
            if (pushMenu != null) {
              await pushMenusDao.deletePushMenu(
                id: pushMenu.id,
              );
              onChanged(null);
            }
          }
        },
        child: Builder(
          builder: (final context) => ListTile(
            autofocus: autofocus,
            title: Text(Intl.message('Push Menu')),
            subtitle: Text(menu == null ? unsetMessage : menu.name),
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
                      onChanged(newPushMenu.id);
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
