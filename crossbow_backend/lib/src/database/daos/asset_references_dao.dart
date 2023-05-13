import 'package:drift/drift.dart';

import '../database.dart';
import '../tables/asset_references.dart';

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
    final double gain = 0.7,
    final bool detached = false,
  }) async =>
      into(assetReferences).insertReturning(
        AssetReferencesCompanion(
          folderName: Value(folderName),
          name: Value(name),
          gain: Value(gain),
          detached: Value(detached),
        ),
      );

  /// Get the asset reference with the given [id].
  Future<AssetReference> getAssetReference({required final int id}) async {
    final query = select(assetReferences)
      ..where((final table) => table.id.equals(id));
    return query.getSingle();
  }

  /// Get the detached asset reference with the given [folderName], and [name].
  Future<AssetReference?> getDetachedAssetReference({
    required final String folderName,
    required final String name,
  }) =>
      (select(assetReferences)
            ..where(
              (final table) =>
                  table.folderName.equals(folderName) &
                  table.name.equals(name) &
                  table.detached.equals(true),
            ))
          .getSingleOrNull();

  /// Edit the asset reference with the given [assetReferenceId].
  Future<AssetReference> editAssetReference({
    required final int assetReferenceId,
    required final String folderName,
    required final String name,
    final String? comment,
  }) async {
    final query = update(assetReferences)
      ..where((final table) => table.id.equals(assetReferenceId));
    return (await query.writeReturning(
      AssetReferencesCompanion(
        folderName: Value(folderName),
        name: Value(name),
        comment: Value(comment),
      ),
    ))
        .single;
  }

  /// Get an [update] query that matches [id].
  UpdateStatement<$AssetReferencesTable, AssetReference> getUpdateQuery(
    final int id,
  ) =>
      update(assetReferences)..where((final table) => table.id.equals(id));

  /// Set the gain for the asset reference with the given [assetReferenceId].
  Future<AssetReference> setGain({
    required final int assetReferenceId,
    required final double gain,
  }) async =>
      (await getUpdateQuery(assetReferenceId)
              .writeReturning(AssetReferencesCompanion(gain: Value(gain))))
          .single;

  /// Delete the asset reference with the given [id].
  Future<int> deleteAssetReference({required final int id}) async {
    final query = delete(assetReferences)
      ..where((final table) => table.id.equals(id));
    return query.go();
  }

  /// Get all the assets in [folderName].
  Future<List<AssetReference>> getAssetReferencesInFolder(
    final String folderName,
  ) {
    final query = select(assetReferences)
      ..where((final table) => table.folderName.equals(folderName));
    return query.get();
  }

  /// Set the [variableName] for the asset reference with the given
  /// [assetReferenceId].
  Future<AssetReference> setVariableName({
    required final int assetReferenceId,
    final String? variableName,
  }) async =>
      (await getUpdateQuery(assetReferenceId).writeReturning(
        AssetReferencesCompanion(variableName: Value(variableName)),
      ))
          .single;
}
