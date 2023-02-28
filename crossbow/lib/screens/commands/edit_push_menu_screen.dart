import 'package:backstreets_widgets/screens.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../src/contexts/push_menu_context.dart';
import '../../src/providers.dart';
import '../../widgets/after_list_tile.dart';
import '../../widgets/fade_length_list_tile.dart';
import '../../widgets/menu_list_tile.dart';

/// A screen for editing a push menu with the given [pushMenuId].
class EditPushMenuScreen extends ConsumerWidget {
  /// Create an instance.
  const EditPushMenuScreen({
    required this.pushMenuId,
    super.key,
  });

  /// The ID of the push menu to edit.
  final int pushMenuId;

  /// Build the widget.
  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final value = ref.watch(pushMenuProvider.call(pushMenuId));
    return Cancel(
      child: value.when(
        data: (final data) => getBody(
          context: context,
          ref: ref,
          pushMenuContext: data,
        ),
        error: ErrorScreen.withPositional,
        loading: LoadingScreen.new,
      ),
    );
  }

  /// Get the body for this widget.
  Widget getBody({
    required final BuildContext context,
    required final WidgetRef ref,
    required final PushMenuContext pushMenuContext,
  }) {
    final projectContext = ref.watch(projectContextNotifierProvider)!;
    final pushMenusDao = projectContext.db.pushMenusDao;
    final pushMenu = pushMenuContext.pushMenu;
    final menu = pushMenuContext.menu;
    return SimpleScaffold(
      title: Intl.message('Edit Push Menu'),
      body: ListView(
        children: [
          MenuListTile(
            menuId: menu.id,
            onChanged: (final value) async {
              await pushMenusDao.setMenuId(
                pushMenuId: pushMenuId,
                menuId: value!,
              );
            },
            autofocus: true,
          ),
          AfterListTile(
            after: pushMenu.after,
            onChanged: (final value) async {
              await pushMenusDao.setAfter(
                pushMenuId: pushMenuId,
                after: value == 0 ? null : value,
              );
              invalidatePushMenuProvider(ref);
            },
            title: Intl.message('Push Delay'),
          ),
          FadeLengthListTile(
            fadeLength: pushMenu.fadeLength,
            onChanged: (final value) async {
              await pushMenusDao.setFadeLength(
                pushMenuId: pushMenuId,
                fadeLength: value,
              );
              invalidatePushMenuProvider(ref);
            },
          )
        ],
      ),
    );
  }

  /// Invalidate the push menu provider.
  void invalidatePushMenuProvider(final WidgetRef ref) =>
      ref.invalidate(pushMenuProvider.call(pushMenuId));
}
