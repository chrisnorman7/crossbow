import 'dart:io';

import 'package:backstreets_widgets/screens.dart';
import 'package:crossbow_backend/crossbow_backend.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;

import '../messages.dart';
import '../src/contexts/asset_context.dart';
import '../src/providers.dart';
import '../widgets/play_sound_semantics.dart';

/// A screen for selecting an asset, and creating an asset reference.
class SelectAssetScreen extends ConsumerStatefulWidget {
  /// Create an instance.
  const SelectAssetScreen({
    required this.onChanged,
    this.assetContext,
    this.nullable = true,
    super.key,
  });

  /// The current asset.
  final AssetContext? assetContext;

  /// Whether or not the [assetContext] can be set to `null`.
  final bool nullable;

  /// The function to call when the [assetContext] has changed.
  final ValueChanged<AssetContext?> onChanged;

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
      return SelectItem<String?>(
        values: [null, ...directories],
        onDone: (final value) {
          if (value == null) {
            Navigator.of(context).pop();
            widget.onChanged(null);
          } else {
            setState(
              () {
                _folderName = value;
              },
            );
          }
        },
        getWidget: (final value) {
          if (value == null) {
            return Text(clearMessage);
          }
          return Text(value);
        },
        shouldPop: false,
        title: Intl.message('Select Folder'),
        value: widget.assetContext?.folderName,
      );
    }
    final directory = Directory(
      path.join(projectContext.assetsDirectory.path, folderName),
    );
    final items =
        directory.listSync().map<String>((final e) => path.basename(e.path));
    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.backspace): () => setState(() {
              _folderName = null;
            })
      },
      child: SelectItem<String?>(
        values: [null, ...items],
        getWidget: (final value) {
          if (value == null) {
            return Text(upMessage);
          }
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
            ),
            child: Text('$value ($type)'),
          );
        },
        onDone: (final value) {
          if (value == null) {
            setState(() {
              _folderName = null;
            });
          } else {
            Navigator.of(context).pop();
            widget.onChanged(
              AssetContext(folderName: folderName, name: value),
            );
          }
        },
        shouldPop: false,
        title: Intl.message('Select Asset'),
        value: folderName == widget.assetContext?.folderName
            ? widget.assetContext?.name
            : null,
      ),
    );
  }
}
