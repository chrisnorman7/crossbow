import 'package:backstreets_widgets/screens.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:crossbow_backend/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../messages.dart';
import '../../../src/contexts/value_context.dart';
import '../../../src/providers.dart';
import '../../../widgets/asset_reference_list_tile.dart';
import '../../../widgets/call_command_list_tile.dart';

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
    required final ValueContext<MenuItem> menuItemContext,
    required final WidgetRef ref,
  }) {
    final menuItemsDao = menuItemContext.projectContext.db.menuItemsDao;
    final menuItem = menuItemContext.value;
    return SimpleScaffold(
      title: Intl.message('Edit Menu Item'),
      body: ListView(
        children: [
          TextListTile(
            value: menuItem.name,
            onChanged: (final value) async {
              await menuItemsDao.setName(menuItemId: menuId, name: value);
              invalidateMenuProvider(ref);
            },
            header: Intl.message('Menu Item Name'),
            autofocus: true,
          ),
          AssetReferenceListTile(
            assetReferenceId: menuItem.selectSoundId,
            onChanged: (final value) async {
              invalidateMenuProvider(ref);
            },
            nullable: true,
            title: callCommandMessage,
          ),
          CallCommandListTile(
            callCommandId: menuItem.callCommandId,
            onChanged: (final value) async {
              await menuItemsDao.setCallCommand(
                menuItemId: menuItem.id,
                callCommandId: value,
              );
              invalidateMenuProvider(ref);
            },
            title: callCommandMessage,
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
