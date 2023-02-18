import 'dart:io';

import 'package:backstreets_widgets/util.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../hotkeys.dart';

/// A list tile to show the given [directory].
class DirectoryListTile extends StatelessWidget {
  /// Create an instance.
  const DirectoryListTile({
    required this.directory,
    required this.title,
    this.autofocus = false,
    super.key,
  });

  /// The directory to use.
  final Directory directory;

  /// The title of this list tile.
  final String title;

  /// Whether or not this list tile should be autofocused.
  final bool autofocus;

  /// Build the widget.
  @override
  Widget build(final BuildContext context) => CallbackShortcuts(
        bindings: {copyHotkey: () => setClipboardText(directory.path)},
        child: ListTile(
          autofocus: autofocus,
          title: Text(title),
          subtitle: Text(directory.path),
          onTap: () {
            final uri = Uri.directory(directory.path);
            launchUrl(uri);
          },
        ),
      );
}
