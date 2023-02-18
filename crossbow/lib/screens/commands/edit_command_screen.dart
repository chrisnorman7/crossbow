import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A screen to edit the command with the given [commandId].
class EditCommandScreen extends ConsumerWidget {
  /// Create an instance.
  const EditCommandScreen({
    required this.commandId,
    super.key,
  });

  /// The ID of the command to edit.
  final int commandId;

  /// Build the widget.
  @override
  Widget build(final BuildContext context, final WidgetRef ref) =>
      const Placeholder();
}
