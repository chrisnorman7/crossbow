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
}
