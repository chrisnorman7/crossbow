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

  /// Delete [dartFunction].
  Future<int> deleteDartFunction({required final DartFunction dartFunction}) =>
      (delete(dartFunctions)
            ..where((final table) => table.id.equals(dartFunction.id)))
          .go();

  /// Get the function with the given [id].
  Future<DartFunction> getDartFunction({required final int id}) =>
      (select(dartFunctions)..where((final table) => table.id.equals(id)))
          .getSingle();

  /// Get an [update] query that matches [dartFunction].
  UpdateStatement<$DartFunctionsTable, DartFunction> getUpdateQuery(
    final DartFunction dartFunction,
  ) =>
      update(dartFunctions)
        ..where((final table) => table.id.equals(dartFunction.id));

  /// Set the [description] for [dartFunction].
  Future<DartFunction> setDescription({
    required final DartFunction dartFunction,
    required final String description,
  }) async =>
      (await getUpdateQuery(dartFunction).writeReturning(
        DartFunctionsCompanion(description: Value(description)),
      ))
          .single;

  /// Get all dart functions, sorted by description.
  Future<List<DartFunction>> getDartFunctions() async {
    final query = select(dartFunctions)
      ..orderBy([(final table) => OrderingTerm.asc(table.description)]);
    return query.get();
  }

  /// Set the [name] for [dartFunction].
  Future<DartFunction> setName({
    required final DartFunction dartFunction,
    final String? name,
  }) async =>
      (await getUpdateQuery(dartFunction).writeReturning(
        DartFunctionsCompanion(functionName: Value(name)),
      ))
          .single;
}
