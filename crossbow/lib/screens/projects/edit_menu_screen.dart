import 'package:backstreets_widgets/icons.dart';
import 'package:backstreets_widgets/screens.dart';
import 'package:backstreets_widgets/util.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:crossbow_backend/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../constants.dart';
import '../../messages.dart';
import '../../src/contexts/menu_context.dart';
import '../../src/providers.dart';
import '../../widgets/asset_reference_list_tile.dart';
import '../../widgets/asset_reference_play_sound_semantics.dart';
import '../../widgets/call_command_list_tile.dart';
import 'menus/edit_menu_item_screen.dart';

/// A screen for editing the menu with the given [menuId].
class EditMenuScreen extends ConsumerStatefulWidget {
  /// Create an instance.
  const EditMenuScreen({
    required this.menuId,
    super.key,
  });

  /// The ID of the menu to edit.
  final int menuId;

  /// Create state for this widget.
  @override
  EditMenuScreenState createState() => EditMenuScreenState();
}

/// State for [EditMenuScreen].
class EditMenuScreenState extends ConsumerState<EditMenuScreen> {
  /// Build a widget.
  @override
  Widget build(final BuildContext context) {
    final value = ref.watch(menuProvider.call(widget.menuId));
    return Cancel(
      child: value.when(
        data: getBody,
        error: ErrorScreen.withPositional,
        loading: LoadingScreen.new,
      ),
    );
  }

  /// Get the body for this widget.
  Widget getBody(final MenuContext menuContext) {
    final menu = menuContext.menu;
    final menuItems = menuContext.menuItems;
    return TabbedScaffold(
      tabs: [
        TabbedScaffoldTab(
          title: Intl.message('Menu Settings'),
          icon: settingsIcon,
          builder: (final context) => getSettingsPage(
            context: context,
            menu: menu,
          ),
        ),
        TabbedScaffoldTab(
          title: Intl.message('Menu Items'),
          icon: Text(menuContext.menuItems.length.toString()),
          builder: (final context) => getMenuItemsPage(
            context: context,
            menuItems: menuItems,
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: newMenuItem,
            tooltip: Intl.message('New Menu Item'),
            child: newIcon,
          ),
        )
      ],
    );
  }

  /// Get the settings page.
  Widget getSettingsPage({
    required final BuildContext context,
    required final Menu menu,
  }) {
    final projectContext = ref.watch(projectContextNotifierProvider)!;
    final menus = projectContext.db.menusDao;
    return ListView(
      children: [
        TextListTile(
          value: menu.name,
          onChanged: (final value) async {
            await menus.setName(menuId: menu.id, name: value);
            invalidateMenuProvider();
          },
          header: menuNameLabel,
          autofocus: true,
          labelText: menuNameLabel,
        ),
        AssetReferenceListTile(
          assetReferenceId: menu.musicId,
          onChanged: (final value) async {
            await menus.setMusicId(menuId: menu.id, musicId: value);
            invalidateMenuProvider();
          },
          nullable: true,
          title: Intl.message('Menu Music'),
          looping: true,
        ),
        AssetReferenceListTile(
          assetReferenceId: menu.activateItemSoundId,
          onChanged: (final value) async {
            await menus.setActivateItemSoundId(
              menuId: menu.id,
              activateItemSoundId: value,
            );
            invalidateMenuProvider();
          },
          nullable: true,
          title: Intl.message('Activate Item Sound'),
        ),
        AssetReferenceListTile(
          assetReferenceId: menu.selectItemSoundId,
          onChanged: (final value) async {
            await menus.setSelectItemSoundId(
              menuId: menu.id,
              selectItemSoundId: value,
            );
            invalidateMenuProvider();
          },
          nullable: true,
          title: Intl.message('Select Item Sound'),
        ),
        CallCommandListTile(
          callCommandId: menu.onCancelCallCommandId,
          onChanged: (final value) async {
            await menus.setOnCancelCallCommandId(
              menuId: menu.id,
              callCommandId: value,
            );
            invalidateMenuProvider();
          },
          title: Intl.message('Cancel Command'),
        )
      ],
    );
  }

  /// Get the list view of menu items.
  Widget getMenuItemsPage({
    required final BuildContext context,
    required final List<MenuItem> menuItems,
  }) =>
      BuiltSearchableListView(
        items: menuItems,
        builder: (final context, final index) {
          final menuItem = menuItems[index];
          return SearchableListTile(
            searchString: menuItem.name,
            child: AssetReferencePlaySoundSemantics(
              assetReferenceId: menuItem.selectSoundId,
              child: ListTile(
                autofocus: index == 0,
                title: Text(menuItem.name),
                subtitle: Text(
                  menuItem.callCommandId == null
                      ? Intl.message('Label')
                      : Intl.message('Button'),
                ),
                onTap: () async {
                  await pushWidget(
                    context: context,
                    builder: (final context) => EditMenuItemScreen(
                      menuId: menuItem.menuId,
                      menuItemId: menuItem.id,
                    ),
                  );
                },
              ),
            ),
          );
        },
      );

  /// Invalidate the [menuProvider].
  void invalidateMenuProvider() =>
      ref.invalidate(menuProvider.call(widget.menuId));

  /// Create a new menu item.
  Future<void> newMenuItem() async {
    final projectContext = ref.watch(projectContextNotifierProvider)!;
    final menuId = widget.menuId;
    final menuItemsDao = projectContext.db.menuItemsDao;
    final menuItems = await menuItemsDao.getMenuItems(menuId: menuId);
    final menuItem = await menuItemsDao.createMenuItem(
      menuId: menuId,
      name: 'Untitled Menu Item',
      position: menuItems.length,
    );
    invalidateMenuProvider();
    if (mounted) {
      await pushWidget(
        context: context,
        builder: (final context) => EditMenuItemScreen(
          menuId: menuId,
          menuItemId: menuItem.id,
        ),
      );
    }
  }
}