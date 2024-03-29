import 'dart:io';
import 'dart:math';

import 'package:dart_sdl/dart_sdl.dart';
import 'package:dart_synthizer/dart_synthizer.dart';
import 'package:open_url/open_url.dart';
import 'package:path/path.dart' as path;
import 'package:ziggurat/levels.dart';
import 'package:ziggurat/menus.dart' as ziggurat_menus;
import 'package:ziggurat/sound.dart';
import 'package:ziggurat/ziggurat.dart' as ziggurat;

import 'extensions.dart';
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
  });

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
  late final ziggurat.Game game;

  /// Get a suitable trigger map.
  Future<ziggurat.TriggerMap> getTriggerMap() async {
    final triggers = (await db.commandTriggersDao.getCommandTriggers())
        .map<Future<ziggurat.CommandTrigger>>((final commandTrigger) async {
      final keyboardKeyId = commandTrigger.keyboardKeyId;
      final keyboardKey = keyboardKeyId == null
          ? null
          : await db.commandTriggerKeyboardKeysDao
              .getCommandTriggerKeyboardKey(id: keyboardKeyId);
      return ziggurat.CommandTrigger(
        description: commandTrigger.description,
        name: commandTrigger.name,
        button: commandTrigger.gameControllerButton,
        keyboardKey: keyboardKey == null
            ? null
            : ziggurat.CommandKeyboardKey(
                keyboardKey.scanCode,
                altKey: keyboardKey.alt,
                controlKey: keyboardKey.control,
                shiftKey: keyboardKey.shift,
              ),
      );
    });
    return ziggurat.TriggerMap(await Future.wait(triggers));
  }

  /// Setup the [game].
  ///
  /// This method is used by the [run] method to prepare the [game] getter for
  /// use.
  Future<void> setupGame() async {
    final triggerMap = await getTriggerMap();
    game = ziggurat.Game(
      title: projectContext.project.projectName,
      sdl: sdl,
      soundBackend: soundBackend,
      appName: projectContext.project.appName,
      orgName: projectContext.project.orgName,
      random: random,
      triggerMap: triggerMap,
    );
  }

  /// Play a sound from the given [id].
  Future<Sound> playSound(final int id) async {
    final assetReference = await getAssetReferenceFromId(id);
    return game.playSimpleSound(sound: assetReference);
  }

  /// Run this game.
  Future<void> run() async {
    await setupGame();
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

  /// Get an asset reference from the given [id].
  Future<ziggurat.AssetReference> getAssetReferenceFromId(final int id) async {
    final assetReference = await db.assetReferencesDao.getAssetReference(
      id: id,
    );
    return getAssetReference(assetReference);
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
      command: command,
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
    final pushCustomLevelId = command.pushCustomLevelId;
    if (pushCustomLevelId != null) {
      final pushCustomLevel = await db.pushCustomLevelsDao
          .getPushCustomLevel(id: pushCustomLevelId);
      await handlePushCustomLevel(pushCustomLevel);
    }
    final dartFunctionId = command.dartFunctionId;
    if (dartFunctionId != null) {
      final dartFunction =
          await db.dartFunctionsDao.getDartFunction(id: dartFunctionId);
      await handleDartFunction(dartFunction);
    }
  }

  /// Handle the given [messageContext].
  Future<void> handleMessageContext(final MessageContext messageContext) async {
    final text = messageContext.text;
    final assetReference = messageContext.assetReference;
    if (text != null || assetReference != null) {
      game.outputMessage(
        ziggurat.Message(
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
    final menuItems = await db.menuItemsDao.getMenuItems(menu: menu);
    final assetReferences = db.assetReferencesDao;
    final selectItemSoundId = menu.selectItemSoundId;
    final activateItemSoundId = menu.activateItemSoundId;
    final selectItemSound = selectItemSoundId == null
        ? null
        : await getAssetReferenceFromId(selectItemSoundId);
    final activateItemSound = activateItemSoundId == null
        ? null
        : await getAssetReferenceFromId(activateItemSoundId);
    final selectItemSounds = <int, ziggurat.AssetReference>{};
    final activateItemSounds = <int, ziggurat.AssetReference>{};
    for (final item in menuItems) {
      final selectSoundId = item.selectSoundId;
      if (selectSoundId != null) {
        selectItemSounds[item.id] = await getAssetReferenceFromId(
          selectSoundId,
        );
      }
      final activateSoundId = item.activateSoundId;
      if (activateSoundId != null) {
        activateItemSounds[item.id] = await getAssetReferenceFromId(
          activateSoundId,
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
              keepAlive: true,
            ),
            activator: ziggurat_menus.MenuItemActivator(
              onActivate: () async {
                final callCommands = await db.menuItemsDao.getCallCommands(
                  menuItem: e,
                );
                await handleCallCommands(callCommands);
              },
              sound: activateSound,
            ),
          );
        },
      ).toList(),
      music: music == null ? null : getAssetReference(music),
      onCancel: () async {
        final callCommands = await db.menusDao.getOnCancelCallCommands(
          menu: menu,
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

  /// Get a level from the provided [customLevel].
  Future<Level> getCustomLevel(final CustomLevel customLevel) async {
    final musicId = customLevel.musicId;
    final level = Level(
      game: game,
      music: musicId == null
          ? null
          : await getAssetReferenceFromId(
              musicId,
            ),
    );
    final customLevelCommandsDao = db.customLevelCommandsDao;
    for (final customLevelCommand in await db.customLevelsDao
        .getCustomLevelCommands(customLevel: customLevel)) {
      final trigger = await db.commandTriggersDao.getCommandTrigger(
        id: customLevelCommand.commandTriggerId,
      );
      final callCommands = await customLevelCommandsDao.getCallCommands(
        customLevelCommand: customLevelCommand,
      );
      final releaseCommands = await customLevelCommandsDao.getReleaseCommands(
        customLevelCommand: customLevelCommand,
      );
      if (callCommands.isNotEmpty || releaseCommands.isNotEmpty) {
        level.registerCommand(
          trigger.name,
          ziggurat.Command(
            interval: customLevelCommand.interval,
            onStart: callCommands.isEmpty
                ? null
                : () => handleCallCommands(callCommands),
            onStop: releaseCommands.isEmpty
                ? null
                : () => handleCallCommands(releaseCommands),
          ),
        );
      }
    }
    return level;
  }

  /// Handle the given [pushCustomLevel].
  Future<void> handlePushCustomLevel(
    final PushCustomLevel pushCustomLevel,
  ) async {
    final customLevelsDao = db.customLevelsDao;
    final customLevel = await customLevelsDao.getCustomLevel(
      id: pushCustomLevel.customLevelId,
    );
    final level = await getCustomLevel(customLevel);
    game.pushLevel(
      level,
      after: pushCustomLevel.after,
      fadeLength: pushCustomLevel.fadeLength,
    );
  }

  /// Handle the given [dartFunction].
  Future<void> handleDartFunction(final DartFunction dartFunction) async {
    final f = projectContext.dartFunctionsMap[dartFunction.name];
    if (f == null) {
      throw StateError('There is no dart code for $dartFunction.');
    }
    await f(this);
  }
}
