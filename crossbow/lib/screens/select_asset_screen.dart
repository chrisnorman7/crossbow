import 'dart:io';

import 'package:backstreets_widgets/screens.dart';
import 'package:crossbow_backend/crossbow_backend.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;

import '../messages.dart';
import '../src/contexts/asset_context.dart';
import '../src/providers.dart';
import '../widgets/common_shortcuts.dart';
import '../widgets/play_sound_semantics.dart';

/// A screen for selecting an asset, and creating an asset reference.
class SelectAssetScreen extends ConsumerStatefulWidget {
  /// Create an instance.
  const SelectAssetScreen({
    required this.onChanged,
    this.assetContext,
    super.key,
  });

  /// The current asset.
  final AssetContext? assetContext;

  /// The function to call when the [assetContext] has changed.
  final ValueChanged<AssetContext> onChanged;

  /// Create state for this widget.
  @override
  SelectAssetScreenState createState() => SelectAssetScreenState();
}

/// State for [SelectAssetScreen].
class SelectAssetScreenState extends ConsumerState<SelectAssetScreen> {
  String? _folderName;

  /// Initialise state.
  @override
  void initState() {
    super.initState();
    _folderName = widget.assetContext?.folderName;
  }

  /// Build a widget.
  @override
  Widget build(final BuildContext context) {
    final projectContext = ref.watch(projectContextNotifierProvider)!;
    final folderName = _folderName;
    if (folderName == null) {
      final directories = projectContext.assetsDirectory
          .listSync()
          .whereType<Directory>()
          .map<String>(
            (final e) => path.basename(e.path),
          );
      return SelectItem(
        values: directories.toList(),
        onDone: (final value) {
          setState(
            () {
              _folderName = value;
            },
          );
        },
        getWidget: Text.new,
        shouldPop: false,
        title: Intl.message('Select Folder'),
      );
    }
    final directory = Directory(
      path.join(projectContext.assetsDirectory.path, folderName),
    );
    final items =
        directory.listSync().map<String>((final e) => path.basename(e.path));
    return CommonShortcuts(
      backspaceCallback: () => setState(() {
        _folderName = null;
      }),
      child: SelectItem(
        values: items.toList(),
        getWidget: (final value) {
          final fullPath = path.join(
            projectContext.assetsDirectory.path,
            folderName,
            value,
          );
          final String type;
          final directory = Directory(fullPath);
          final file = File(fullPath);
          if (directory.existsSync()) {
            type = directoryMessage;
          } else if (file.existsSync()) {
            type = fileMessage;
          } else {
            type = unknownMessage;
          }
          return PlaySoundSemantics(
            assetReference: AssetReference(
              id: -1,
              name: value,
              folderName: folderName,
              gain: 0.7,
              detached: true,
            ),
            child: Text('$value ($type)'),
          );
        },
        onDone: (final value) => widget.onChanged(
          AssetContext(
            folderName: folderName,
            name: value,
          ),
        ),
        title: Intl.message('Select Asset'),
        value: folderName == widget.assetContext?.folderName
            ? widget.assetContext?.name
            : null,
      ),
    );
  }
}
