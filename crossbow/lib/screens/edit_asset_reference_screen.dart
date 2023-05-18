import 'package:backstreets_widgets/screens.dart';
import 'package:backstreets_widgets/util.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../messages.dart';
import '../src/contexts/asset_context.dart';
import '../src/providers.dart';
import '../widgets/variable_name_list_tile.dart';
import 'select_asset_screen.dart';

/// A widget to edit an asset reference.
class EditAssetReferenceScreen extends ConsumerWidget {
  /// Create an instance.
  const EditAssetReferenceScreen({
    required this.assetReferenceId,
    super.key,
  });

  /// The ID of the asset reference to edit.
  final int assetReferenceId;

  /// Build the widget.
  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final value = ref.watch(assetReferenceProvider.call(assetReferenceId));
    return Cancel(
      child: SimpleScaffold(
        title: Intl.message('Edit Asset'),
        body: value.when(
          data: (final data) {
            final assetReference = data.value;
            final assetReferencesDao =
                data.projectContext.db.assetReferencesDao;
            return ListView(
              children: [
                ListTile(
                  autofocus: true,
                  title: Text(Intl.message('Asset Reference')),
                  subtitle: Text(
                    '${assetReference.folderName}/${assetReference.name}',
                  ),
                  onTap: () => pushWidget(
                    context: context,
                    builder: (final context) => SelectAssetScreen(
                      onChanged: (final value) async {
                        await assetReferencesDao.editAssetReference(
                          assetReference: assetReference,
                          folderName: value.folderName,
                          name: value.name,
                          comment: assetReference.comment,
                        );
                        invalidateAssetReferenceProvider(ref);
                      },
                      assetContext: AssetContext(
                        folderName: assetReference.folderName,
                        name: assetReference.name,
                      ),
                    ),
                  ),
                ),
                DoubleListTile(
                  value: assetReference.gain,
                  onChanged: (final value) async {
                    await assetReferencesDao.setGain(
                      assetReference: assetReference,
                      gain: value,
                    );
                    invalidateAssetReferenceProvider(ref);
                  },
                  title: 'Gain',
                  min: 0.01,
                  modifier: 0.1,
                ),
                TextListTile(
                  value: assetReference.comment ?? unsetMessage,
                  onChanged: (final value) async {
                    await assetReferencesDao.editAssetReference(
                      assetReference: assetReference,
                      folderName: assetReference.folderName,
                      name: assetReference.name,
                      comment: value.isEmpty ? null : value,
                    );
                    invalidateAssetReferenceProvider(ref);
                  },
                  header: 'Comment',
                ),
                VariableNameListTile(
                  variableName: assetReference.variableName,
                  getOtherVariableNames: () async {
                    final assets =
                        await assetReferencesDao.getAssetReferencesInFolder(
                      assetReference.folderName,
                    );
                    return assets
                        .map((final e) => e.variableName ?? unsetMessage)
                        .toList();
                  },
                  onChanged: (final value) async {
                    await assetReferencesDao.setVariableName(
                      assetReference: assetReference,
                      variableName: value,
                    );
                    invalidateAssetReferenceProvider(ref);
                  },
                )
              ],
            );
          },
          error: ErrorListView.withPositional,
          loading: LoadingWidget.new,
        ),
      ),
    );
  }

  /// Invalidate the [assetReferenceProvider].
  void invalidateAssetReferenceProvider(final WidgetRef ref) =>
      ref.invalidate(assetReferenceProvider.call(assetReferenceId));
}
