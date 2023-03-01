import 'dart:io';
import 'dart:math';

import 'package:dart_sdl/dart_sdl.dart';
import 'package:dart_synthizer/dart_synthizer.dart';
import 'package:open_url/open_url.dart';
import 'package:path/path.dart' as path;
import 'package:ziggurat/menus.dart' as ziggurat_menus;
import 'package:ziggurat/sound.dart';
import 'package:ziggurat/ziggurat.dart' as ziggurat;

import 'src/contexts/message_context.dart';
import 'src/contexts/project_context.dart';
import 'src/database/database.dart';
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
          await handleCommand(command);
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

  /// Get an asset from the given [assetReference].
  ziggurat.AssetReference getAssetReference(
    final AssetReference assetReference,
  ) {
    final name = path.join(
      projectContext.assetsDirectory.path,
      assetReference.folderName,
      assetReference.name,
    );
    final encryptionKey =
        projectContext.assetReferenceEncryptionKeys[assetReference.id];
    final directory = Directory(name);
    if (directory.existsSync()) {
      return ziggurat.AssetReference.collection(
        name,
        encryptionKey: encryptionKey,
        gain: assetReference.gain,
      );
    }
    final file = File(name);
    if (file.existsSync()) {
      return ziggurat.AssetReference.file(
        name,
        encryptionKey: encryptionKey,
        gain: assetReference.gain,
      );
    }
    throw FileSystemException('Cannot find the given path.', name);
  }

  /// Run the given [command].
  Future<void> handleCommand(final Command command) async {
    final messageText = command.messageText;
    final assetReferenceId = command.messageSoundId;
    final assetReference = assetReferenceId == null
        ? null
        : await db.assetReferencesDao.getAssetReference(id: assetReferenceId);
    final messageContext = MessageContext(
      command: command,
      text: messageText,
      assetReference: assetReference,
    );
    await handleMessageContext(messageContext);
    final pushMenuId = command.pushMenuId;
    if (pushMenuId != null) {
      final pushMenuRow = await db.pushMenusDao.getPushMenu(id: pushMenuId);
      await handlePushMenu(pushMenuRow);
    }
    final callCommands = await db.commandsDao.getCallCommands(
      commandId: command.id,
    );
    await handleCallCommands(callCommands);
    final stopGameId = command.stopGameId;
    if (stopGameId != null) {
      final stopGame = await db.stopGamesDao.getStopGame(id: stopGameId);
      await handleStopGame(stopGame);
    }
    final popLevelId = command.popLevelId;
    if (popLevelId != null) {
      final popLevel = await db.popLevelsDao.getPopLevel(id: popLevelId);
      await handlePopLevel(popLevel);
    }
    final url = command.url;
    if (url != null) {
      await openUrl(url);
    }
  }

  /// Handle the given [messageContext].
  Future<void> handleMessageContext(final MessageContext messageContext) async {
    final text = messageContext.text;
    final assetReference = messageContext.assetReference;
    if (text != null || assetReference != null) {
      game.outputMessage(
        ziggurat.Message(
          gain: assetReference?.gain ?? 0.7,
          sound:
              assetReference == null ? null : getAssetReference(assetReference),
          text: text,
        ),
      );
    }
  }

  /// Return `true` if the given [callCommand] should run.
  Future<bool> callCommandShouldRun(final CallCommand callCommand) async {
    final randomNumberBase = callCommand.randomNumberBase;
    if (randomNumberBase == null || random.nextInt(randomNumberBase) == 0) {
      return true;
    }
    return false;
  }

  /// Handle the given [callCommand].
  ///
  /// The [handleCallCommands] method should already have established whether or
  /// not [callCommand] should run by way of the [callCommandShouldRun] method.
  Future<void> handleCallCommand(final CallCommand callCommand) async {
    final command = await db.commandsDao.getCommand(id: callCommand.commandId);
    final after = callCommand.after;
    if (after == null) {
      await handleCommand(command);
    } else {
      game.callAfter(
        func: () => handleCommand(command),
        runAfter: after,
      );
    }
  }

  /// Handle the given [callCommands].
  Future<void> handleCallCommands(final List<CallCommand> callCommands) async {
    for (final callCommand in callCommands) {
      if (await callCommandShouldRun(callCommand)) {
        await handleCallCommand(callCommand);
      }
    }
  }

  /// Get a menu level from the given [menu].
  Future<ziggurat_menus.Menu> getMenuLevel(final Menu menu) async {
    final menuItems = await db.menuItemsDao.getMenuItems(menuId: menu.id);
    final assetReferences = db.assetReferencesDao;
    final selectItemSoundId = menu.selectItemSoundId;
    final activateItemSoundId = menu.activateItemSoundId;
    final selectItemSound = selectItemSoundId == null
        ? null
        : getAssetReference(
            await assetReferences.getAssetReference(id: selectItemSoundId),
          );
    final activateItemSound = activateItemSoundId == null
        ? null
        : getAssetReference(
            await assetReferences.getAssetReference(id: activateItemSoundId),
          );
    final selectItemSounds = <int, ziggurat.AssetReference>{};
    final activateItemSounds = <int, ziggurat.AssetReference>{};
    for (final item in menuItems) {
      final selectSoundId = item.selectSoundId;
      if (selectSoundId != null) {
        selectItemSounds[item.id] = getAssetReference(
          await assetReferences.getAssetReference(id: selectSoundId),
        );
      }
      final activateSoundId = item.activateSoundId;
      if (activateSoundId != null) {
        activateItemSounds[item.id] = getAssetReference(
          await assetReferences.getAssetReference(id: activateSoundId),
        );
      }
    }
    final musicId = menu.musicId;
    final music = musicId == null
        ? null
        : await assetReferences.getAssetReference(id: musicId);
    return ziggurat_menus.Menu(
      game: game,
      title: ziggurat.Message(text: menu.name),
      items: menuItems.map<ziggurat_menus.MenuItem>(
        (final e) {
          final selectSound = selectItemSounds[e.id] ?? selectItemSound;
          final activateSound = activateItemSounds[e.id] ?? activateItemSound;
          return ziggurat_menus.MenuItem(
            ziggurat.Message(
              text: e.name,
              sound: selectSound,
              gain: selectSound?.gain ?? 0.7,
              keepAlive: true,
            ),
            ziggurat_menus.Button(
              () async {
                final callCommands = await db.menuItemsDao.getCallCommands(
                  menuItemId: e.id,
                );
                await handleCallCommands(callCommands);
              },
              activateSound: activateSound,
            ),
          );
        },
      ).toList(),
      music: music == null
          ? null
          : Music(
              sound: getAssetReference(music),
              gain: music.gain,
            ),
      onCancel: () async {
        final callCommands = await db.menusDao.getOnCancelCallCommands(
          menuId: menu.id,
        );
        await handleCallCommands(callCommands);
      },
    );
  }

  /// Push the given [pushMenu].
  Future<void> handlePushMenu(final PushMenu pushMenu) async {
    final menu = await db.menusDao.getMenu(id: pushMenu.menuId);
    final menuLevel = await getMenuLevel(menu);
    game.pushLevel(
      menuLevel,
      after: pushMenu.after,
      fadeLength: pushMenu.fadeLength,
    );
  }

  /// Handle the given [stopGame].
  Future<void> handleStopGame(final StopGame stopGame) async {
    final after = stopGame.after;
    if (after == null) {
      game.stop();
    } else {
      game.callAfter(func: game.stop, runAfter: after);
    }
  }

  /// Handle the given [popLevel].
  Future<void> handlePopLevel(final PopLevel popLevel) async {
    game.popLevel(ambianceFadeTime: popLevel.fadeLength);
  }
}
