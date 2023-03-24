import 'package:backstreets_widgets/screens.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:crossbow_backend/crossbow_backend.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../src/contexts/menu_context.dart';
import '../../../src/providers.dart';
import '../../../widgets/asset_reference_play_sound_semantics.dart';
import '../../../widgets/music_widget.dart';

/// A screen for previewing the menu with the given [menuId].
class PreviewMenuScreen extends ConsumerWidget {
  /// Create an instance.
  const PreviewMenuScreen({
    required this.menuId,
    super.key,
  });

  /// The ID of the menu to preview.
  final int menuId;

  /// Build the widget.
  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final value = ref.watch(menuProvider.call(menuId));
    return Cancel(
      child: SimpleScaffold(
        title: Intl.message('Preview Menu'),
        body: value.when(
          data: (final menuContext) => getBody(
            ref: ref,
            menuContext: menuContext,
          ),
          error: ErrorListView.withPositional,
          loading: LoadingWidget.new,
        ),
      ),
    );
  }

  /// Get the body for this widget.
  Widget getBody({
    required final WidgetRef ref,
    required final MenuContext menuContext,
  }) {
    final menu = menuContext.value;
    final menuItems = menuContext.menuItems;
    return MusicWidget(
      musicId: menu.musicId,
      child: ListView.builder(
        itemBuilder: (final context, final index) {
          if (index == 0) {
            return ListTile(
              autofocus: true,
              title: Text(menu.name),
              onTap: () {},
            );
          }
          final menuItem = menuItems[index - 1];
          return getMenuItemWidget(
            ref: ref,
            projectContext: menuContext.projectContext,
            menu: menu,
            menuItem: menuItem,
          );
        },
        itemCount: menuItems.length + 1,
      ),
    );
  }

  /// Get a list tile for the given [menuItem].
  Widget getMenuItemWidget({
    required final WidgetRef ref,
    required final ProjectContext projectContext,
    required final Menu menu,
    required final MenuItem menuItem,
  }) {
    final selectSoundId = menuItem.selectSoundId ?? menu.selectItemSoundId;
    final activateSoundId =
        menuItem.activateSoundId ?? menu.activateItemSoundId;
    return AssetReferencePlaySoundSemantics(
      assetReferenceId: selectSoundId,
      child: ListTile(
        title: Text(menuItem.name),
        onTap: () async {
          if (activateSoundId != null) {
            final projectRunner = await ref.watch(projectRunnerProvider.future);
            final game = projectRunner!.game;
            final assetReference = await projectContext.db.assetReferencesDao
                .getAssetReference(id: activateSoundId);
            final sound = projectRunner.getAssetReference(assetReference);
            game.playSimpleSound(sound: sound);
          }
        },
      ),
    );
  }
}
