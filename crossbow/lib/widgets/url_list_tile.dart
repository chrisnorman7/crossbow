import 'package:backstreets_widgets/util.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../messages.dart';

/// A list tile for editing the given [url].
class UrlListTile extends StatelessWidget {
  /// Create an instance.
  const UrlListTile({
    required this.url,
    required this.onChanged,
    this.title,
    this.autofocus = false,
    super.key,
  });

  /// The URL to edit.
  final String? url;

  /// The function to call when [url] changes.
  final ValueChanged<String?> onChanged;

  /// The title for the list tile.
  final String? title;

  /// Whether the list tile should be autofocused.
  final bool autofocus;

  /// Build the widget.
  @override
  Widget build(final BuildContext context) {
    final value = url;
    return ListTile(
      autofocus: autofocus,
      title: Text(title ?? urlMessage),
      subtitle: Text(value ?? unsetMessage),
      onTap: () => pushWidget(
        context: context,
        builder: (final context) => GetText(
          onDone: (final value) {
            Navigator.pop(context);
            onChanged(value.isEmpty ? null : value);
          },
          labelText: urlMessage,
          text: value ?? '',
          title: Intl.message('Edit URL'),
          tooltip: doneMessage,
          validator: (final value) {
            final uri = Uri.tryParse(value ?? '');
            if (uri == null || uri.isAbsolute == false) {
              return invalidInputMessage;
            }
            return null;
          },
        ),
      ),
      isThreeLine: true,
      trailing: value == null
          ? null
          : IconButton(
              icon: Icon(
                Icons.open_in_browser,
                semanticLabel: Intl.message('Test URL'),
              ),
              onPressed: () => launchUrl(Uri.parse(value)),
            ),
    );
  }
}
