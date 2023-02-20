import 'package:drift/drift.dart';

import '../../database.dart';

part 'asset_references_dao.g.dart';

/// The asset references DAO.
@DriftAccessor(tables: [AssetReferences])
class AssetReferencesDao extends DatabaseAccessor<CrossbowBackendDatabase>
    with _$AssetReferencesDaoMixin {
  /// Create an instance.
  AssetReferencesDao(super.db);

  /// Create an asset reference.
  Future<AssetReference> createAssetReference({
    required final String folderName,
    required final String name,
  }) async =>
      into(assetReferences).insertReturning(
        AssetReferencesCompanion(
          folderName: Value(folderName),
          name: Value(name),
        ),
      );

  /// Edit the asset reference with the given [assetReferenceId].
  Future<AssetReference> editAssetReference({
    required final int assetReferenceId,
    required final String folderName,
    required final String name,
  }) async {
    final query = update(assetReferences)
      ..where((final table) => table.id.equals(assetReferenceId));
    return (await query.writeReturning(
      AssetReferencesCompanion(
        folderName: Value(folderName),
        name: Value(name),
      ),
    ))
        .single;
  }
}
