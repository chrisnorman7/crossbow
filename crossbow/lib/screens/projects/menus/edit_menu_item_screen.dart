import 'package:backstreets_widgets/screens.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:crossbow_backend/crossbow_backend.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../messages.dart';
import '../../../src/contexts/menu_item_context.dart';
import '../../../src/providers.dart';
import '../../../widgets/asset_reference_list_tile.dart';
import '../../../widgets/call_commands_list_tile.dart';

/// A screen to edit the [MenuItem] with the given [menuItemId].
class EditMenuItemScreen extends ConsumerWidget {
  /// Create an instance.
  const EditMenuItemScreen({
    required this.menuId,
    required this.menuItemId,
    super.key,
  });

  /// The menu that the menu item belongs to.
  final int menuId;

  /// The ID of the menu item to edit.
  final int menuItemId;

  /// Build the widget.
  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final value = ref.watch(menuItemProvider.call(menuItemId));
    return Cancel(
      child: value.when(
        data: (final data) => getBody(
          context: context,
          ref: ref,
          menuItemContext: data,
        ),
        error: ErrorScreen.withPositional,
        loading: LoadingScreen.new,
      ),
    );
  }

  /// Get the body of the widget.
  Widget getBody({
    required final BuildContext context,
    required final MenuItemContext menuItemContext,
    required final WidgetRef ref,
  }) {
    final menuItemsDao = menuItemContext.projectContext.db.menuItemsDao;
    final menuItem = menuItemContext.menuItem;
    final menu = menuItemContext.menu;
    return SimpleScaffold(
      title: Intl.message('Edit Menu Item'),
      body: ListView(
        children: [
          TextListTile(
            value: menuItem.name,
            onChanged: (final value) async {
              await menuItemsDao.setName(menuItemId: menuItemId, name: value);
              invalidateMenuProvider(ref);
            },
            header: Intl.message('Menu Item Name'),
            autofocus: true,
          ),
          AssetReferenceListTile(
            assetReferenceId: menuItem.selectSoundId ?? menu.selectItemSoundId,
            onChanged: (final value) async {
              await menuItemsDao.setSelectSoundId(
                menuItemId: menuItemId,
                selectSoundId: value,
              );
              invalidateMenuProvider(ref);
            },
            nullable: true,
            title: Intl.message('Select Sound'),
          ),
          CallCommandsListTile(
            target: CallCommandsTarget.menuItem,
            id: menuItem.id,
            title: callCommandsMessage,
          ),
          AssetReferenceListTile(
            assetReferenceId:
                menuItem.activateSoundId ?? menu.activateItemSoundId,
            onChanged: (final value) async {
              await menuItemsDao.setActivateSoundId(
                menuItemId: menuItemId,
                activateSoundId: value,
              );
              invalidateMenuProvider(ref);
            },
            nullable: true,
            title: Intl.message('Activate Sound'),
          )
        ],
      ),
    );
  }

  /// Invalidate the menu item provider.
  void invalidateMenuProvider(final WidgetRef ref) => ref
    ..invalidate(menuItemProvider.call(menuItemId))
    ..invalidate(menuProvider.call(menuId));
}
