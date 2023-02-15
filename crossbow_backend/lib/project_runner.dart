import 'dart:math';

import 'package:dart_sdl/dart_sdl.dart';
import 'package:dart_synthizer/dart_synthizer.dart';
import 'package:ziggurat/menus.dart' as ziggurat_menus;
import 'package:ziggurat/sound.dart';
import 'package:ziggurat/ziggurat.dart' as ziggurat;

import 'database.dart';
import 'src/contexts/project_context.dart';
import 'src/json/project.dart';

/// A class for running a [projectContext].
///
/// To modify how rows in the database are handled, subclass [ProjectRunner],
/// and override the `handle*` methods.
class ProjectRunner {
  /// Create an instance.
  ProjectRunner({
    required this.projectContext,
    required this.sdl,
    required this.synthizerContext,
    required this.random,
    required this.soundBackend,
  }) : game = ziggurat.Game(
          title: projectContext.project.projectName,
          sdl: sdl,
          soundBackend: soundBackend,
          appName: projectContext.project.appName,
          orgName: projectContext.project.orgName,
          random: random,
        );

  /// The project context to use.
  final ProjectContext projectContext;

  /// The project that the [projectContext] represents.
  Project get project => projectContext.project;

  /// The database to use.
  CrossbowBackendDatabase get db => projectContext.db;

  /// The sdl instance to use.
  final Sdl sdl;

  /// The synthizer context to use.
  final Context synthizerContext;

  /// The synthizer instance to use.
  Synthizer get synthizer => synthizerContext.synthizer;

  /// The random number generator to use.
  final Random random;

  /// The sound backend to use.
  final SynthizerSoundBackend soundBackend;

  /// The buffer cache to use.
  BufferCache get bufferCache => soundBackend.bufferCache;

  /// The game to use.
  final ziggurat.Game game;

  /// Run this game.
  Future<void> run() async {
    try {
      await game.run(
        framesPerSecond: project.framesPerSecond,
        onStart: () async {
          final command = await projectContext.initialCommand;
          await handleCommand(command: command);
        },
      );
    } finally {
      await destroy();
    }
  }

  /// Destroy this project runner.
  Future<void> destroy() async {
    sdl.quit();
    bufferCache.destroy();
    synthizerContext.destroy();
    synthizer.shutdown();
    await db.close();
  }

  /// Run the given [command].
  Future<void> handleCommand({required final Command command}) async {
    final messageText = command.messageText;
    if (messageText != null) {
      game.outputText(messageText);
    }
    final pushMenuId = command.pushMenuId;
    if (pushMenuId != null) {
      final pushMenuRow = await db.pushMenusDao.getPushMenu(id: pushMenuId);
      await handlePushMenu(pushMenu: pushMenuRow);
    }
    final callCommandId = command.callCommandId;
    if (callCommandId != null) {
      final callCommand =
          await db.callCommandsDao.getCallCommand(id: callCommandId);
      await handleCallCommand(callCommand: callCommand);
    }
    final stopGameId = command.stopGameId;
    if (stopGameId != null) {
      final stopGame = await db.stopGamesDao.getStopGame(id: stopGameId);
      await handleStopGame(stopGame: stopGame);
    }
  }

  /// Handle the given [callCommand].
  Future<void> handleCallCommand({
    required final CallCommand callCommand,
  }) async {
    final command = await db.commandsDao.getCommand(id: callCommand.commandId);
    final after = callCommand.after;
    if (after == null) {
      await handleCommand(command: command);
    } else {
      game.callAfter(
        func: () => handleCommand(command: command),
        runAfter: after,
      );
    }
  }

  /// Push the given [pushMenu].
  Future<void> handlePushMenu({required final PushMenu pushMenu}) async {
    final menu = await db.menusDao.getMenu(id: pushMenu.menuId);
    final menuItems = await db.menusDao.getMenuItems(menuId: menu.id);
    final menuLevel = ziggurat_menus.Menu(
      game: game,
      title: ziggurat.Message(text: menu.name),
      items: menuItems.map<ziggurat_menus.MenuItem>(
        (final e) {
          final callCommandId = e.callCommandId;
          return ziggurat_menus.MenuItem(
            ziggurat.Message(text: e.name),
            callCommandId == null
                ? ziggurat_menus.menuItemLabel
                : ziggurat_menus.Button(() async {
                    final callCommand = await db.callCommandsDao.getCallCommand(
                      id: callCommandId,
                    );
                    await handleCallCommand(callCommand: callCommand);
                  }),
          );
        },
      ).toList(),
    );
    game.pushLevel(
      menuLevel,
      after: pushMenu.after,
      fadeLength: pushMenu.fadeLength,
    );
  }

  /// Handle the given [stopGame].
  Future<void> handleStopGame({required final StopGame stopGame}) async {
    final after = stopGame.after;
    if (after == null) {
      game.stop();
    } else {
      game.callAfter(func: game.stop, runAfter: after);
    }
  }
}
