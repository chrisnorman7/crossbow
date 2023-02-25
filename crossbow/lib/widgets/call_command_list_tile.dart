import 'package:crossbow_backend/crossbow_backend.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../messages.dart';

/// A list tile to show the [CallCommand] instance with the given
/// [callCommandId].
class CallCommandListTile extends ConsumerWidget {
  /// Create an instance.
  const CallCommandListTile({
    required this.callCommandId,
    required this.onChanged,
    required this.title,
    this.autofocus = false,
    this.nullable = true,
    super.key,
  });

  /// The ID of the call command to show.
  final int? callCommandId;

  /// The function to call when the call command changes.
  final ValueChanged<int?> onChanged;

  /// The title of this widget.
  final String title;

  /// Whether the list tile should be autofocused.
  final bool autofocus;

  /// Whether the call command can be set to `null`.
  final bool nullable;

  /// Build the widget.
  @override
  Widget build(final BuildContext context, final WidgetRef ref) => ListTile(
        autofocus: autofocus,
        title: Text(title),
        subtitle: Text(callCommandId == null ? unsetMessage : setMessage),
        onTap: () async {},
      );
}
