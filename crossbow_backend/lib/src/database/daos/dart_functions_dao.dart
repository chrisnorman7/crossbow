import 'package:drift/drift.dart';

import '../database.dart';
import '../tables/dart_functions.dart';

part 'dart_functions_dao.g.dart';

/// The dart functions DAO.
@DriftAccessor(tables: [DartFunctions])
class DartFunctionsDao extends DatabaseAccessor<CrossbowBackendDatabase>
    with _$DartFunctionsDaoMixin {
  /// Create an instance.
  DartFunctionsDao(super.db);

  /// Create a new function.
  Future<DartFunction> createDartFunction({
    required final String description,
  }) =>
      into(dartFunctions).insertReturning(
        DartFunctionsCompanion(
          description: Value(description),
        ),
      );

  /// Delete the function with the given [id].
  Future<int> deleteDartFunction({required final int id}) =>
      (delete(dartFunctions)..where((final table) => table.id.equals(id))).go();

  /// Get the function with the given [id].
  Future<DartFunction> getDartFunction({required final int id}) =>
      (select(dartFunctions)..where((final table) => table.id.equals(id)))
          .getSingle();

  /// Get an [update] query that matches on [id].
  UpdateStatement<$DartFunctionsTable, DartFunction> getUpdateQuery(
    final int id,
  ) =>
      update(dartFunctions)..where((final table) => table.id.equals(id));

  /// Set the [description] value for the dart function with the given
  /// [dartFunctionId].
  Future<DartFunction> setDescription({
    required final int dartFunctionId,
    required final String description,
  }) async =>
      (await getUpdateQuery(dartFunctionId).writeReturning(
        DartFunctionsCompanion(description: Value(description)),
      ))
          .single;
}
