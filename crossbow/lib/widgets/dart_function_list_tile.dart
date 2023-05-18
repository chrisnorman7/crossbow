import 'package:backstreets_widgets/util.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:crossbow_backend/crossbow_backend.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../messages.dart';
import '../screens/commands/select_dart_function_screen.dart';
import '../src/providers.dart';
import 'common_shortcuts.dart';
import 'error_list_tile.dart';

/// A list tile to show a dart function.
class DartFunctionListTile extends ConsumerWidget {
  /// Create an instance.
  const DartFunctionListTile({
    required this.dartFunctionId,
    required this.onChanged,
    this.autofocus = false,
    super.key,
  });

  /// The ID of the dart function to show.
  final int? dartFunctionId;

  /// The function to call when the dart function changes.
  final ValueChanged<DartFunction?> onChanged;

  /// Whether to autofocus the list tile.
  final bool autofocus;

  /// Build the widget.
  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final id = dartFunctionId;
    if (id == null) {
      return ListTile(
        autofocus: autofocus,
        title: Text(dartFunctionMessage),
        subtitle: Text(unsetMessage),
        onTap: () => pushWidget(
          context: context,
          builder: (final context) => SelectDartFunctionScreen(
            onChanged: onChanged,
          ),
        ),
      );
    }
    final value = ref.watch(dartFunctionProvider.call(id));
    return CommonShortcuts(
      deleteCallback: () => onChanged(null),
      copyText: id.toString(),
      child: value.when(
        data: (final data) => ListTile(
          autofocus: autofocus,
          title: Text(dartFunctionMessage),
          subtitle: Text(data.value.description),
          onTap: () => pushWidget(
            context: context,
            builder: (final context) => SelectDartFunctionScreen(
              onChanged: onChanged,
              currentDartFunctionId: id,
            ),
          ),
        ),
        error: ErrorListTile.withPositional,
        loading: LoadingWidget.new,
      ),
    );
  }
}
