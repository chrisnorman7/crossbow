import 'package:backstreets_widgets/icons.dart';
import 'package:backstreets_widgets/screens.dart';
import 'package:backstreets_widgets/util.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:crossbow_backend/crossbow_backend.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../constants.dart';
import '../../../messages.dart';
import '../../../src/contexts/call_commands_context.dart';
import '../../../src/contexts/call_commands_target.dart';
import '../../../src/contexts/menu_context.dart';
import '../../../src/providers.dart';
import '../../../util.dart';
import '../../../widgets/asset_reference_list_tile.dart';
import '../../../widgets/asset_reference_play_sound_semantics.dart';
import '../../../widgets/call_commands_list_tile.dart';
import '../../../widgets/common_shortcuts.dart';
import '../../../widgets/variable_name_list_tile.dart';
import 'edit_menu_item_screen.dart';
import 'preview_menu_screen.dart';

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
    final menu = menuContext.value;
    return TabbedScaffold(
      tabs: [
        TabbedScaffoldTab(
          title: Intl.message('Menu Settings'),
          icon: settingsIcon,
          actions: [
            TextButton(
              onPressed: () => pushWidget(
                context: context,
                builder: (final context) => PreviewMenuScreen(menuId: menu.id),
              ),
              child: Text(Intl.message('Test Menu')),
            )
          ],
          builder: (final context) => CommonShortcuts(
            testCallback: () => pushWidget(
              context: context,
              builder: (final context) => PreviewMenuScreen(menuId: menu.id),
            ),
            child: getSettingsPage(
              context: context,
              menu: menu,
            ),
          ),
        ),
        TabbedScaffoldTab(
          title: Intl.message('Menu Items'),
          icon: Text(menuContext.menuItems.length.toString()),
          builder: (final context) => getMenuItemsPage(
            context: context,
            menuContext: menuContext,
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: newMenuItem,
            tooltip: Intl.message('New Menu Item'),
            child: intlNewIcon,
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
    final menusDao = projectContext.db.menusDao;
    return ListView(
      children: [
        TextListTile(
          value: menu.name,
          onChanged: (final value) async {
            await menusDao.setName(menu: menu, name: value);
            invalidateMenuProvider();
          },
          header: menuNameLabel,
          autofocus: true,
          labelText: menuNameLabel,
        ),
        AssetReferenceListTile(
          assetReferenceId: menu.musicId,
          onChanged: (final value) async {
            await menusDao.setMusicId(
              menu: menu,
              music: value,
            );
            invalidateMenuProvider();
          },
          nullable: true,
          title: Intl.message('Menu Music'),
          looping: true,
        ),
        AssetReferenceListTile(
          assetReferenceId: menu.activateItemSoundId,
          onChanged: (final value) async {
            await menusDao.setActivateItemSoundId(
              menu: menu,
              activateItemSound: value,
            );
            invalidateMenuProvider();
          },
          nullable: true,
          title: Intl.message('Default Activate Item Sound'),
        ),
        AssetReferenceListTile(
          assetReferenceId: menu.selectItemSoundId,
          onChanged: (final value) async {
            await menusDao.setSelectItemSoundId(
              menu: menu,
              selectItemSound: value,
            );
            invalidateMenuProvider();
          },
          nullable: true,
          title: Intl.message('Default Select Item Sound'),
        ),
        CallCommandsListTile(
          callCommandsContext: CallCommandsContext(
            target: CallCommandsTarget.menuOnCancel,
            id: menu.id,
          ),
          title: Intl.message('Cancel Commands'),
        ),
        VariableNameListTile(
          variableName: menu.variableName,
          getOtherVariableNames: () async {
            final menus = await menusDao.getMenus();
            return menus
                .map((final e) => e.variableName ?? unsetMessage)
                .toList();
          },
          onChanged: (final value) async {
            await menusDao.setVariableName(
              menu: menu,
              variableName: value,
            );
            invalidateMenuProvider();
          },
        ),
      ],
    );
  }

  /// Get the list view of menu items.
  Widget getMenuItemsPage({
    required final BuildContext context,
    required final MenuContext menuContext,
  }) {
    final db = menuContext.projectContext.db;
    final menuItemsDao = db.menuItemsDao;
    final menusDao = db.menusDao;
    final menu = menuContext.value;
    final menuItems = menuContext.menuItems;
    final Widget child;
    if (menuItems.isEmpty) {
      child = CenterText(
        text: nothingToShowMessage,
        autofocus: true,
      );
    } else {
      child = ReorderableList(
        itemBuilder: (final context, final index) {
          final menuItem = menuItems[index];
          return CommonShortcuts(
            moveDownCallback: () => reorderMenuItems(
              oldIndex: index,
              newIndex: index + 1,
            ),
            moveUpCallback: () =>
                reorderMenuItems(oldIndex: index, newIndex: index - 1),
            deleteCallback: () async {
              final callCommands = await menuItemsDao.getCallCommands(
                menuItem: menuItem,
              );
              final onCancelCallCommands =
                  await menusDao.getOnCancelCallCommands(menu: menu);
              if (!mounted) {
                return;
              }
              if (callCommands.isNotEmpty) {
                await showMessage(
                  context: context,
                  message: Intl.message(
                    'You cannot delete menu items that have commands.',
                  ),
                );
              } else if (onCancelCallCommands.isNotEmpty) {
                await showMessage(
                  context: context,
                  message: Intl.message(
                    'You cannot delete a menu with cancel commands.',
                  ),
                );
              } else {
                await intlConfirm(
                  context: context,
                  message: 'Are you sure you want to delete this menu item?',
                  title: confirmDeleteTitle,
                  yesCallback: () async {
                    Navigator.of(context).pop();
                    await db.utilsDao.deleteMenuItem(menuItem);
                    invalidateMenuProvider();
                  },
                );
              }
            },
            copyText: menuItem.id.toString(),
            key: ValueKey(menuItem.id),
            child: AssetReferencePlaySoundSemantics(
              assetReferenceId:
                  menuItem.selectSoundId ?? menu.selectItemSoundId,
              child: ListTile(
                autofocus: index == 0,
                title: Text(menuItem.name),
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
        itemCount: menuItems.length,
        onReorder: (final oldIndex, final newIndex) => reorderMenuItems(
          oldIndex: oldIndex,
          newIndex: newIndex,
        ),
      );
    }
    return CommonShortcuts(
      newCallback: newMenuItem,
      child: child,
    );
  }

  /// Invalidate the [menuProvider].
  void invalidateMenuProvider() =>
      ref.invalidate(menuProvider.call(widget.menuId));

  /// Create a new menu item.
  Future<void> newMenuItem() async {
    final projectContext = ref.watch(projectContextNotifierProvider)!;
    final menuId = widget.menuId;
    final db = projectContext.db;
    final menuItemsDao = db.menuItemsDao;
    final menusDao = db.menusDao;
    final menu = await menusDao.getMenu(id: menuId);
    final menuItems = await menuItemsDao.getMenuItems(menu: menu);
    final menuItem = await menuItemsDao.createMenuItem(
      menu: menu,
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

  /// Reorder menu items.
  Future<void> reorderMenuItems({
    required final int newIndex,
    required final int oldIndex,
  }) async {
    if (newIndex < 0) {
      return;
    }
    final projectContext = ref.watch(projectContextNotifierProvider)!;
    final db = projectContext.db;
    final menuItemsDao = db.menuItemsDao;
    final menusDao = db.menusDao;
    final menu = await menusDao.getMenu(id: widget.menuId);
    final menuItems = await menuItemsDao.getMenuItems(menu: menu);
    final oldMenuItem = menuItems[oldIndex];
    final newMenuItem =
        newIndex >= menuItems.length ? null : menuItems[newIndex];
    await menuItemsDao.moveMenuItem(
      menuItem: oldMenuItem,
      position: newIndex,
    );
    if (newMenuItem != null) {
      await menuItemsDao.moveMenuItem(
        menuItem: newMenuItem,
        position: oldIndex,
      );
    }
    if (mounted) {
      invalidateMenuProvider();
    }
  }
}
