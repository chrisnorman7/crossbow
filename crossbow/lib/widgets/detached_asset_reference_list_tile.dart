import 'dart:io';

import 'package:backstreets_widgets/widgets.dart';
import 'package:crossbow_backend/crossbow_backend.dart';
import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;
import 'package:ziggurat/ziggurat.dart' as ziggurat;

import '../messages.dart';
import '../src/contexts/asset_context.dart';
import '../src/providers.dart';
import 'common_shortcuts.dart';
import 'error_list_tile.dart';
import 'play_sound_semantics.dart';

/// A list tile which shows a detached asset reference.
class DetachedAssetReferenceListTile extends ConsumerWidget {
  /// Create an instance.
  const DetachedAssetReferenceListTile({
    required this.assetContext,
    this.autofocus = false,
    super.key,
  });

  /// The asset context to use.
  final AssetContext assetContext;

  /// Whether the list tile should be autofocused or not.
  final bool autofocus;

  /// Build the widget.
  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final folderName = assetContext.folderName;
    final name = assetContext.name;
    final value = ref.watch(detachedAssetReferenceProvider.call(assetContext));
    return value.when(
      data: (final data) {
        final projectContext = data.projectContext;
        final assetReferencesDao = projectContext.db.assetReferencesDao;
        final detachedAssetReference = data.value;
        final fullPath = path.join(
          projectContext.assetsDirectory.path,
          assetContext.folderName,
          name,
        );
        final directory = Directory(fullPath);
        final file = File(fullPath);
        AssetReference? assetReference;
        final String size;
        if (file.existsSync()) {
          assetReference = AssetReference(
            id: -1,
            name: name,
            folderName: folderName,
            gain: 0.7,
            detached: true,
          );
          size = filesize(file.statSync().size);
        } else if (directory.existsSync()) {
          assetReference = AssetReference(
            id: -1,
            name: name,
            folderName: folderName,
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
        // We can't use `PlaySoundSemantics` here, because of a bug in
        // `CheckboxListTile`.
        final title = Text(path.join(folderName, name));
        return CommonShortcuts(
          copyText: detachedAssetReference?.id.toString() ?? getAssetCode(ref),
          deleteCallback: detachedAssetReference == null
              ? null
              : () async {
                  await assetReferencesDao.deleteAssetReference(
                    id: detachedAssetReference.id,
                  );
                  ref.invalidate(
                    detachedAssetReferenceProvider.call(assetContext),
                  );
                },
          child: CheckboxListTile(
            autofocus: autofocus,
            value: detachedAssetReference != null,
            onChanged: (final value) async {
              if (detachedAssetReference == null) {
                await assetReferencesDao.createAssetReference(
                  folderName: folderName,
                  name: name,
                  detached: true,
                );
              } else {
                await assetReferencesDao.deleteAssetReference(
                  id: detachedAssetReference.id,
                );
              }
              ref.invalidate(
                detachedAssetReferenceProvider.call(assetContext),
              );
            },
            key: ValueKey(fullPath),
            title: assetReference == null
                ? title
                : PlaySoundSemantics(
                    assetReference: assetReference,
                    child: title,
                  ),
            subtitle: Text(size),
          ),
        );
      },
      error: ErrorListTile.withPositional,
      loading: LoadingWidget.new,
    );
  }

  /// Get valid code for the [assetContext].
  String getAssetCode(final WidgetRef ref) {
    final projectContext = ref.watch(projectContextNotifierProvider);
    if (projectContext == null) {
      return 'Broke.';
    }
    final folderName = assetContext.folderName;
    final name = assetContext.name;
    final fullPath = path
        .join(projectContext.project.assetsDirectory, folderName, name)
        .replaceAll(path.separator, '/');
    final ziggurat.AssetType assetType;
    if (Directory(
      path.join(projectContext.assetsDirectory.path, folderName, name),
    ).existsSync()) {
      assetType = ziggurat.AssetType.collection;
    } else {
      assetType = ziggurat.AssetType.file;
    }
    return "AssetReference('$fullPath', $assetType,)";
  }
}
