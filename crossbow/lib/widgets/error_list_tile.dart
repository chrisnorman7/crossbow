import 'package:backstreets_widgets/util.dart';
import 'package:flutter/material.dart';

import '../messages.dart';

/// A list tile with an [error], and a [stackTrace].
class ErrorListTile extends StatelessWidget {
  /// Create an instance.
  const ErrorListTile({
    required this.error,
    required this.stackTrace,
    super.key,
  });

  /// Return an instance with positional arguments.
  const ErrorListTile.withPositional(
    this.error,
    this.stackTrace, {
    super.key,
  });

  /// The error to show.
  final Object error;

  /// The stack trace to use.
  final StackTrace? stackTrace;

  /// Build the widget.
  @override
  Widget build(final BuildContext context) {
    final s = stackTrace;
    return ListTile(
      title: Text(errorTitle),
      subtitle: Text(error.toString()),
      isThreeLine: s != null,
      trailing: s == null ? null : Text(s.toString()),
      onTap: () => setClipboardText('$error\n$stackTrace'),
    );
  }
}
