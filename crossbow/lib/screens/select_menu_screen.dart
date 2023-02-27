import 'package:backstreets_widgets/screens.dart';
import 'package:crossbow_backend/crossbow_backend.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../src/contexts/value_context.dart';
import '../src/providers.dart';
import '../widgets/asset_reference_play_sound_semantics.dart';

/// A screen for selecting a menu.
class SelectMenuScreen extends ConsumerWidget {
  /// Create an instance.
  const SelectMenuScreen({
    required this.onChanged,
    this.currentMenuId,
    super.key,
  });

  /// The function to call when a new menu is selected.
  final ValueChanged<int> onChanged;

  /// The ID of the current menu.
  final int? currentMenuId;

  /// Build the widget.
  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final value = ref.watch(menusProvider);
    return value.when(
      data: getBody,
      error: ErrorScreen.withPositional,
      loading: LoadingScreen.new,
    );
  }

  /// Get the body for this widget.
  Widget getBody(final ValueContext<List<Menu>> valueContext) {
    final menus = valueContext.value;
    final menuId = currentMenuId;
    return SelectItem(
      values: menus,
      onDone: (final value) => onChanged(value.id),
      getSearchString: (final value) => value.name,
      getWidget: (final value) => AssetReferencePlaySoundSemantics(
        assetReferenceId: value.musicId,
        child: Text(value.name),
      ),
      title: Intl.message('Select Menu'),
      value: menuId == null
          ? null
          : menus.firstWhere((final element) => element.id == menuId),
    );
  }
}
