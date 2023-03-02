import 'package:backstreets_widgets/util.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:crossbow_backend/crossbow_backend.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;

import '../hotkeys.dart';
import '../messages.dart';
import '../screens/select_asset_screen.dart';
import '../src/contexts/asset_context.dart';
import '../src/contexts/value_context.dart';
import '../src/providers.dart';
import 'asset_reference_play_sound_semantics.dart';
import 'play_sound_semantics.dart';

/// A list tile to show the asset reference with the given [assetReferenceId].
class AssetReferenceListTile extends ConsumerWidget {
  /// Create an instance.
  const AssetReferenceListTile({
    required this.assetReferenceId,
    required this.onChanged,
    required this.nullable,
    required this.title,
    this.autofocus = false,
    this.looping = false,
    super.key,
  });

  /// The ID of the asset reference to show.
  final int? assetReferenceId;

  /// The function to call when the asset reference changes.
  final ValueChanged<int?> onChanged;

  /// Whether the asset reference can be `null`.
  final bool nullable;

  /// The title of the list tile.
  final String title;

  /// Whether this list tile should be auto focused.
  final bool autofocus;

  /// Whether the connected asset should loop.
  final bool looping;

  /// Build the widget.
  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final projectContext = ref.watch(projectContextNotifierProvider)!;
    final id = assetReferenceId;
    if (id == null) {
      return getBody(
        context: context,
        ref: ref,
        assetReferenceContext: ValueContext(
          projectContext: projectContext,
          value: null,
        ),
      );
    }
    final value = ref.watch(assetReferenceProvider.call(id));
    return value.when(
      data: (final data) => getBody(
        context: context,
        ref: ref,
        assetReferenceContext: data,
      ),
      error: ErrorListView.withPositional,
      loading: LoadingWidget.new,
    );
  }

  /// Get the body for this widget.
  Widget getBody({
    required final BuildContext context,
    required final WidgetRef ref,
    required final ValueContext<AssetReference?> assetReferenceContext,
  }) {
    final projectContext = assetReferenceContext.projectContext;
    final assetReference = assetReferenceContext.value;
    return AssetReferencePlaySoundSemantics(
      assetReferenceId: assetReferenceId,
      looping: looping,
      child: Builder(
        builder: (final context) {
          final assetReferencePath = assetReference == null
              ? null
              : path.join(assetReference.folderName, assetReference.name);
          final gain = assetReference?.gain;
          final assetReferenceGain = gain?.toStringAsFixed(2);
          return CallbackShortcuts(
            bindings: {
              deleteHotkey: () async {
                if (nullable && assetReference != null) {
                  await projectContext.db.utilsDao.deleteAssetReference(
                    assetReference,
                  );
                  onChanged(null);
                }
              }
            },
            child: ListTile(
              autofocus: autofocus,
              title: Text(title),
              subtitle: Text(
                assetReference == null
                    ? unsetMessage
                    : '$assetReferencePath ($assetReferenceGain)',
              ),
              onTap: () {
                PlaySoundSemantics.of(context)?.stop();
                pushWidget(
                  context: context,
                  builder: (final context) => SelectAssetScreen(
                    onChanged: (final value) async {
                      final assetReferencesDao =
                          projectContext.db.assetReferencesDao;
                      if (value == null) {
                        if (assetReference != null) {
                          await projectContext.db.utilsDao
                              .deleteAssetReference(assetReference);
                        }
                        onChanged(null);
                      } else {
                        final AssetReference newAssetReference;
                        if (assetReference == null) {
                          newAssetReference =
                              await assetReferencesDao.createAssetReference(
                            folderName: value.folderName,
                            name: value.name,
                          );
                        } else {
                          newAssetReference =
                              await assetReferencesDao.editAssetReference(
                            assetReferenceId: assetReference.id,
                            folderName: value.folderName,
                            name: value.name,
                          );
                        }
                        onChanged(
                          newAssetReference.id,
                        );
                        ref.invalidate(
                          assetReferenceProvider.call(newAssetReference.id),
                        );
                      }
                    },
                    assetContext: assetReference == null
                        ? null
                        : AssetContext(
                            folderName: assetReference.folderName,
                            name: assetReference.name,
                          ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
