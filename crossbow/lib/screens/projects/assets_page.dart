import 'dart:io';

import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;

import '../../messages.dart';
import '../../src/contexts/asset_context.dart';
import '../../src/providers.dart';
import '../../widgets/common_shortcuts.dart';
import '../../widgets/detached_asset_reference_list_tile.dart';

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
            child: CommonShortcuts(
              copyText: directory.path,
              child: ListTile(
                autofocus: index == 0,
                title: Text(name),
                onTap: () => setState(() => _directoryName = name),
              ),
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
                autofocus: entries.length == 1,
                title: Text(upMessage),
                onTap: () => setState(() => _directoryName = null),
              ),
            );
          }
          final name = path.basename(entry.path);
          return SearchableListTile(
            searchString: name,
            child: DetachedAssetReferenceListTile(
              assetContext: AssetContext(folderName: directoryName, name: name),
              autofocus: index == 1,
            ),
          );
        },
      ),
    );
  }
}
