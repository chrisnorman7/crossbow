import 'package:backstreets_widgets/util.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../hotkeys.dart';
import '../messages.dart';
import '../screens/select_menu_screen.dart';
import '../src/contexts/menu_context.dart';
import '../src/providers.dart';
import 'asset_reference_play_sound_semantics.dart';
import 'play_sound_semantics.dart';

/// A list tile that allows selecting a new menu.
class MenuListTile extends ConsumerWidget {
  /// Create an instance.
  const MenuListTile({
    required this.menuId,
    required this.onChanged,
    this.title,
    this.autofocus = false,
    this.nullable = false,
    super.key,
  });

  /// The ID of the current menu.
  final int? menuId;

  /// The function to call when the menu changes.
  final ValueChanged<int?> onChanged;

  /// The title for this list tile.
  final String? title;

  /// Whether the list tile should be autofocused.
  final bool autofocus;

  /// Whether the new menu ID can be `null`.
  final bool nullable;

  /// Build the widget.
  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final id = menuId;
    if (id == null) {
      return getBody(context: context);
    }
    final value = ref.watch(menuProvider.call(id));
    return value.when(
      data: (final data) => getBody(context: context, menuContext: data),
      error: ErrorListView.withPositional,
      loading: LoadingWidget.new,
    );
  }

  /// Get the body for this widget.
  Widget getBody({
    required final BuildContext context,
    final MenuContext? menuContext,
  }) {
    final menu = menuContext?.menu;
    return CallbackShortcuts(
      bindings: {
        deleteHotkey: () {
          if (nullable) {
            onChanged(null);
          }
        }
      },
      child: AssetReferencePlaySoundSemantics(
        assetReferenceId: menu?.musicId,
        looping: true,
        child: Builder(
          builder: (final context) => ListTile(
            autofocus: autofocus,
            title: Text(title ?? Intl.message('Menu')),
            subtitle: Text(menu?.name ?? unsetMessage),
            onTap: () {
              PlaySoundSemantics.of(context)?.stop();
              pushWidget(
                context: context,
                builder: (final context) => SelectMenuScreen(
                  onChanged: onChanged,
                  currentMenuId: menu?.id,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
