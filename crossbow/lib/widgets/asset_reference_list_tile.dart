import 'package:backstreets_widgets/util.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:crossbow_backend/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;

import '../hotkeys.dart';
import '../messages.dart';
import '../screens/select_asset_screen.dart';
import '../src/contexts/asset_context.dart';
import '../src/contexts/value_context.dart';
import '../src/providers.dart';
import '../util.dart';

/// A list tile to show the asset reference with the given [assetReferenceId].
class AssetReferenceListTile extends ConsumerWidget {
  /// Create an instance.
  const AssetReferenceListTile({
    required this.assetReferenceId,
    required this.onChanged,
    required this.nullable,
    required this.title,
    this.autofocus = false,
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

  /// Build the widget.
  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final projectContext = ref.watch(projectContextNotifierProvider)!;
    final id = assetReferenceId;
    if (id == null) {
      return getBody(
        context: context,
        assetReferenceContext:
            ValueContext(projectContext: projectContext, value: null),
      );
    }
    final value = ref.watch(assetReferenceProvider.call(id));
    return value.when(
      data: (final data) => getBody(
        context: context,
        assetReferenceContext: data,
      ),
      error: ErrorListView.withPositional,
      loading: LoadingWidget.new,
    );
  }

  /// Get the body for this widget.
  Widget getBody({
    required final BuildContext context,
    required final ValueContext<AssetReference?> assetReferenceContext,
  }) {
    final projectContext = assetReferenceContext.projectContext;
    final assetReference = assetReferenceContext.value;
    return CallbackShortcuts(
      bindings: {
        deleteHotkey: () {
          if (nullable && assetReference != null) {
            intlConfirm(
              context: context,
              message: Intl.message(
                'Do you want to clear this asset reference?',
              ),
              title: confirmDeleteTitle,
              yesCallback: () async {
                Navigator.of(context).pop();
                await projectContext.db.assetReferencesDao
                    .deleteAssetReference(id: assetReference.id);
                onChanged(null);
              },
            );
          }
        }
      },
      child: ListTile(
        autofocus: autofocus,
        title: Text(title),
        subtitle: Text(
          assetReference == null
              ? unsetMessage
              : path.join(assetReference.folderName, assetReference.name),
        ),
        onTap: () {
          pushWidget(
            context: context,
            builder: (final context) => SelectAssetScreen(
              onChanged: (final value) async {
                final assetReferences = projectContext.db.assetReferencesDao;
                if (assetReference == null) {
                  onChanged(
                    (await assetReferences.createAssetReference(
                      folderName: value.folderName,
                      name: value.name,
                    ))
                        .id,
                  );
                } else {
                  await assetReferences.editAssetReference(
                    assetReferenceId: assetReference.id,
                    folderName: value.folderName,
                    name: value.name,
                  );
                  onChanged(assetReference.id);
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
  }
}
