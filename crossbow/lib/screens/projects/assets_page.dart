import 'dart:io';

import 'package:backstreets_widgets/widgets.dart';
import 'package:crossbow_backend/crossbow_backend.dart';
import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;

import '../../messages.dart';
import '../../src/providers.dart';
import '../../widgets/play_sound_semantics.dart';

/// A screen to show assets.
class AssetsPage extends ConsumerStatefulWidget {
  /// Create an instance.
  const AssetsPage({
    super.key,
  });

  /// Create state for this widget.
  @override
  AssetsPageState createState() => AssetsPageState();
}

/// State for [AssetsPage].
class AssetsPageState extends ConsumerState<AssetsPage> {
  String? _directoryName;

  /// Build a widget.
  @override
  Widget build(final BuildContext context) {
    final projectContext = ref.watch(projectContextNotifierProvider)!;
    final directoryName = _directoryName;
    if (directoryName == null) {
      final directories = projectContext.assetsDirectory
          .listSync()
          .whereType<Directory>()
          .toList();
      return BuiltSearchableListView(
        items: directories,
        builder: (final context, final index) {
          final directory = directories[index];
          final name = path.basename(directory.path);
          return SearchableListTile(
            searchString: name,
            child: ListTile(
              autofocus: index == 0,
              title: Text(name),
              onTap: () => setState(() => _directoryName = name),
            ),
          );
        },
      );
    }
    final entries = [
      null,
      ...Directory(
        path.join(projectContext.assetsDirectory.path, directoryName),
      ).listSync().toList()
    ];
    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.backspace): () =>
            setState(() => _directoryName = null)
      },
      child: BuiltSearchableListView(
        items: entries,
        builder: (final context, final index) {
          final entry = entries[index];
          if (entry == null) {
            return SearchableListTile(
              searchString: upMessage,
              child: ListTile(
                autofocus: true,
                title: Text(upMessage),
                onTap: () => setState(() => _directoryName = null),
              ),
            );
          }
          final name = path.basename(entry.path);
          final directory = Directory(entry.path);
          final file = File(entry.path);
          AssetReference? assetReference;
          final String size;
          if (file.existsSync()) {
            assetReference = AssetReference(
              id: -1,
              name: name,
              folderName: directoryName,
              gain: 0.7,
              detached: true,
            );
            size = filesize(file.statSync().size);
          } else if (directory.existsSync()) {
            assetReference = AssetReference(
              id: -1,
              name: name,
              folderName: directoryName,
              gain: 0.7,
              detached: true,
            );
            size = filesize(
              directory.listSync().whereType<File>().fold(
                    0,
                    (final previousValue, final element) =>
                        previousValue + element.statSync().size,
                  ),
            );
          } else {
            assetReference = null;
            size = unknownMessage;
          }
          final child = ListTile(
            title: Text(path.join(directoryName, name)),
            subtitle: Text(size),
            onTap: () {},
          );
          return SearchableListTile(
            searchString: name,
            child: assetReference == null
                ? child
                : PlaySoundSemantics(
                    assetReference: assetReference,
                    child: child,
                  ),
          );
        },
      ),
    );
  }
}
