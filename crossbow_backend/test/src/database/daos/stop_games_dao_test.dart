import 'package:crossbow_backend/crossbow_backend.dart';
import 'package:test/test.dart';

import '../../../custom_database.dart';

void main() {
  group(
    'StopGamesDao',
    () {
      final db = getDatabase();
      final stopGamesDao = db.stopGamesDao;
      final commandsDao = db.commandsDao;

      test(
        '.createStopGame',
        () async {
          var stopGame = await stopGamesDao.createStopGame();
          expect(stopGame.after, null);
          stopGame = await stopGamesDao.createStopGame(after: 1234);
          expect(stopGame.after, 1234);
        },
      );

      test(
        '.getStopGame',
        () async {
          final stopGame = await stopGamesDao.createStopGame();
          expect(
            await stopGamesDao.getStopGame(id: stopGame.id),
            predicate<StopGame>((final value) => value.id == stopGame.id),
          );
        },
      );

      test(
        '.setAfter',
        () async {
          final stopGame = await stopGamesDao.createStopGame(after: 1234);
          expect(stopGame.after, 1234);
          var updatedStopGame = await stopGamesDao.setAfter(stopGame: stopGame);
          expect(updatedStopGame.id, stopGame.id);
          expect(updatedStopGame.after, null);
          updatedStopGame =
              await stopGamesDao.setAfter(stopGame: stopGame, after: 4321);
          expect(updatedStopGame.id, stopGame.id);
          expect(updatedStopGame.after, 4321);
        },
      );

      test(
        '.deleteStopGame',
        () async {
          var stopGame = await stopGamesDao.createStopGame();
          expect(await stopGamesDao.deleteStopGame(stopGame: stopGame), 1);
          stopGame = await stopGamesDao.createStopGame();
          final command = await commandsDao.createCommand(stopGame: stopGame);
          expect(command.stopGameId, stopGame.id);
          expect(await stopGamesDao.deleteStopGame(stopGame: stopGame), 1);
          expect(
            (await commandsDao.getCommand(id: command.id)).stopGameId,
            null,
          );
        },
      );

      test(
        '.setVariableName',
        () async {
          final stopGame = await stopGamesDao.createStopGame();
          expect(stopGame.variableName, null);
          final updatedStopGame = await stopGamesDao.setVariableName(
            stopGame: stopGame,
            variableName: 'stopGame',
          );
          expect(updatedStopGame.id, stopGame.id);
          expect(updatedStopGame.variableName, 'stopGame');
        },
      );

      test(
        '.setDescription',
        () async {
          final stopGame = await stopGamesDao.createStopGame();
          expect(stopGame.description, 'Stop the game.');
          final updatedStopGame = await stopGamesDao.setDescription(
            stopGame: stopGame,
            description: 'Stop.',
          );
          expect(updatedStopGame.id, stopGame.id);
          expect(updatedStopGame.description, 'Stop.');
        },
      );
    },
  );
}
