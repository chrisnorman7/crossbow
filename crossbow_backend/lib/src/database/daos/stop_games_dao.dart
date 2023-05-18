import 'package:drift/drift.dart';

import '../database.dart';
import '../tables/stop_games.dart';

part 'stop_games_dao.g.dart';

/// The stop games DAO.
@DriftAccessor(tables: [StopGames])
class StopGamesDao extends DatabaseAccessor<CrossbowBackendDatabase>
    with _$StopGamesDaoMixin {
  /// Create an instance.
  StopGamesDao(super.db);

  /// Create a stop game.
  Future<StopGame> createStopGame({final int? after}) =>
      into(stopGames).insertReturning(StopGamesCompanion(after: Value(after)));

  /// Get a stop game with the given [id].
  Future<StopGame> getStopGame({required final int id}) {
    final query = select(stopGames)
      ..where((final table) => table.id.equals(id));
    return query.getSingle();
  }

  /// Get an [update] query that matches [stopGame].
  UpdateStatement<$StopGamesTable, StopGame> getUpdateQuery(
    final StopGame stopGame,
  ) =>
      update(stopGames)..where((final table) => table.id.equals(stopGame.id));

  /// Set the [after] value for [stopGame].
  Future<StopGame> setAfter({
    required final StopGame stopGame,
    final int? after,
  }) async =>
      (await getUpdateQuery(stopGame)
              .writeReturning(StopGamesCompanion(after: Value(after))))
          .single;

  /// Delete [stopGame].
  Future<int> deleteStopGame({required final StopGame stopGame}) async {
    final query = delete(stopGames)
      ..where((final table) => table.id.equals(stopGame.id));
    return query.go();
  }

  /// Set the [variableName] for [stopGame].
  Future<StopGame> setVariableName({
    required final StopGame stopGame,
    final String? variableName,
  }) async =>
      (await getUpdateQuery(stopGame).writeReturning(
        StopGamesCompanion(variableName: Value(variableName)),
      ))
          .single;

  /// Set the [description] for [stopGame].
  Future<StopGame> setDescription({
    required final StopGame stopGame,
    required final String description,
  }) async =>
      (await getUpdateQuery(stopGame).writeReturning(
        StopGamesCompanion(description: Value(description)),
      ))
          .single;
}
