import 'package:crossbow_backend/crossbow_backend.dart';
import 'package:test/test.dart';

import '../../../custom_database.dart';

void main() {
  group(
    'StopGamesDao',
    () {
      final db = getDatabase();
      final stopGames = db.stopGamesDao;
      final commandsDao = db.commandsDao;

      test(
        '.createStopGame',
        () async {
          var stopGame = await stopGames.createStopGame();
          expect(stopGame.after, null);
          stopGame = await stopGames.createStopGame(after: 1234);
          expect(stopGame.after, 1234);
        },
      );

      test(
        '.getStopGame',
        () async {
          final stopGame = await stopGames.createStopGame();
          expect(
            await stopGames.getStopGame(id: stopGame.id),
            predicate<StopGame>((final value) => value.id == stopGame.id),
          );
        },
      );

      test(
        '.setAfter',
        () async {
          final stopGame = await stopGames.createStopGame(after: 1234);
          expect(stopGame.after, 1234);
          var updatedStopGame =
              await stopGames.setAfter(stopGameId: stopGame.id);
          expect(updatedStopGame.id, stopGame.id);
          expect(updatedStopGame.after, null);
          updatedStopGame =
              await stopGames.setAfter(stopGameId: stopGame.id, after: 4321);
          expect(updatedStopGame.id, stopGame.id);
          expect(updatedStopGame.after, 4321);
        },
      );

      test(
        '.deleteStopGame',
        () async {
          var stopGame = await stopGames.createStopGame();
          expect(await stopGames.deleteStopGame(stopGameId: stopGame.id), 1);
          stopGame = await stopGames.createStopGame();
          final command =
              await commandsDao.createCommand(stopGameId: stopGame.id);
          expect(command.stopGameId, stopGame.id);
          expect(await stopGames.deleteStopGame(stopGameId: stopGame.id), 1);
          expect(
            (await commandsDao.getCommand(id: command.id)).stopGameId,
            null,
          );
        },
      );
    },
  );
}
