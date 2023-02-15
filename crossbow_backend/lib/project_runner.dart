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
          await runCommand(command: command);
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
  Future<void> runCommand({required final Command command}) async {
    final messageText = command.messageText;
    if (messageText != null) {
      game.outputText(messageText);
    }
    final pushMenuId = command.pushMenuId;
    if (pushMenuId != null) {
      final pushMenuRow = await db.pushMenusDao.getPushMenu(id: pushMenuId);
      await pushMenu(pushMenu: pushMenuRow);
    }
  }

  /// Push the given [pushMenu].
  Future<void> pushMenu({required final PushMenu pushMenu}) async {
    final menu = await db.menusDao.getMenu(id: pushMenu.menuId);
    final menuItems = await db.menusDao.getMenuItems(menuId: menu.id);
    final menuLevel = ziggurat_menus.Menu(
      game: game,
      title: ziggurat.Message(text: menu.name),
      items: menuItems
          .map<ziggurat_menus.MenuItem>(
            (final e) => ziggurat_menus.MenuItem(
              ziggurat.Message(text: e.name),
              ziggurat_menus.menuItemLabel,
            ),
          )
          .toList(),
    );
    game.pushLevel(
      menuLevel,
      after: pushMenu.after,
      fadeLength: pushMenu.fadeLength,
    );
  }
}
