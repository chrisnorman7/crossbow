import 'dart:io';
import 'dart:math';

import 'package:crossbow_backend/crossbow_backend.dart';
import 'package:crossbow_backend/extensions.dart';
import 'package:dart_sdl/dart_sdl.dart';
import 'package:dart_synthizer/dart_synthizer.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';
import 'package:ziggurat/sound.dart' as ziggurat_sound;
import 'package:ziggurat/ziggurat.dart';
import 'package:ziggurat/ziggurat.dart' as ziggurat;

import 'custom_database.dart';

void main() async {
  final db = getDatabase();
  final assetReferencesDao = db.assetReferencesDao;
  final commandsDao = db.commandsDao;
  final callCommandsDao = db.callCommandsDao;
  final menusDao = db.menusDao;
  final menuItemsDao = db.menuItemsDao;
  final clink = await assetReferencesDao.createAssetReference(
    folderName: 'interface',
    name: 'clink.wav',
    gain: 1.0,
  );
  final boots = await assetReferencesDao.createAssetReference(
    folderName: 'footsteps',
    name: 'boots',
    gain: 0.5,
  );
  final command = await db.commandsDao.createCommand(messageSoundId: clink.id);
  final project = Project(
    projectName: 'Test Project',
    initialCommandId: command.id,
    assetsDirectory: 'test_assets',
  );
  final projectContext = ProjectContext(
    file: File('project.json'),
    project: project,
    db: db,
    assetReferenceEncryptionKeys: {
      boots.id: 'asdf123',
    },
  );

  group(
    'ProjectRunner',
    () {
      final synthizer = Synthizer()..initialize();
      final context = synthizer.createContext();
      final random = Random();
      final bufferCache = ziggurat_sound.BufferCache(
        maxSize: 1.gb,
        random: random,
        synthizer: synthizer,
      );
      final soundBackend = ziggurat_sound.SynthizerSoundBackend(
        context: context,
        bufferCache: bufferCache,
      );
      final sdl = Sdl();
      final projectRunner = ProjectRunner(
        projectContext: projectContext,
        sdl: sdl,
        synthizerContext: context,
        random: random,
        soundBackend: soundBackend,
      );

      setUpAll(projectRunner.setupGame);

      tearDownAll(() {
        bufferCache.destroy();
        context.destroy();
        synthizer.shutdown();
      });

      test(
        '.getTriggerMap',
        () async {
          final commandTriggersDao = db.commandTriggersDao;
          await db.delete(db.commandTriggers).go();
          final keyboardKeysDao = db.commandTriggerKeyboardKeysDao;
          final forwardsKey =
              await keyboardKeysDao.createCommandTriggerKeyboardKey(
            scanCode: ScanCode.w,
          );
          final forwardsTrigger = await commandTriggersDao.createCommandTrigger(
            description: 'Forward',
            gameControllerButton: GameControllerButton.dpadUp,
            keyboardKeyId: forwardsKey.id,
          );
          var triggerMap = await projectRunner.getTriggerMap();
          var triggers = triggerMap.triggers;
          expect(triggers.length, 1);
          var trigger = triggers.single;
          expect(trigger.button, GameControllerButton.dpadUp);
          expect(trigger.description, forwardsTrigger.description);
          expect(trigger.name, forwardsTrigger.name);
          var keyboardKey = trigger.keyboardKey!;
          expect(keyboardKey.altKey, false);
          expect(keyboardKey.controlKey, false);
          expect(keyboardKey.scanCode, ScanCode.w);
          expect(keyboardKey.shiftKey, false);
          final saveKeyboardKey =
              await keyboardKeysDao.createCommandTriggerKeyboardKey(
            scanCode: ScanCode.s,
            alt: true,
            control: true,
            shift: true,
          );
          final saveTrigger = await commandTriggersDao.createCommandTrigger(
            description: 'Save the game',
            gameControllerButton: GameControllerButton.leftshoulder,
            keyboardKeyId: saveKeyboardKey.id,
          );
          triggerMap = await projectRunner.getTriggerMap();
          triggers = triggerMap.triggers;
          expect(triggers.length, 2);
          trigger = triggers.first;
          expect(trigger.button, GameControllerButton.dpadUp);
          expect(trigger.description, forwardsTrigger.description);
          expect(trigger.name, forwardsTrigger.name);
          keyboardKey = trigger.keyboardKey!;
          expect(keyboardKey.altKey, false);
          expect(keyboardKey.controlKey, false);
          expect(keyboardKey.scanCode, ScanCode.w);
          expect(keyboardKey.shiftKey, false);
          trigger = triggers.last;
          expect(trigger.button, GameControllerButton.leftshoulder);
          expect(trigger.description, saveTrigger.description);
          expect(trigger.name, saveTrigger.name);
          keyboardKey = trigger.keyboardKey!;
          expect(keyboardKey.altKey, true);
          expect(keyboardKey.controlKey, true);
          expect(keyboardKey.scanCode, ScanCode.s);
          expect(keyboardKey.shiftKey, true);
        },
      );

      test(
        '.getAssetReference',
        () async {
          var assetReference = projectRunner.getAssetReference(clink);
          expect(assetReference.encryptionKey, null);
          expect(assetReference.gain, clink.gain);
          expect(
            assetReference.name,
            path.join(
              projectContext.assetsDirectory.path,
              clink.folderName,
              clink.name,
            ),
          );
          expect(assetReference.type, ziggurat.AssetType.file);
          expect(assetReference.getFile(random).existsSync(), true);
          assetReference = projectRunner.getAssetReference(boots);
          expect(
            assetReference.name,
            path.join(
              projectContext.assetsDirectory.path,
              boots.folderName,
              boots.name,
            ),
          );
          expect(assetReference.encryptionKey, 'asdf123');
          expect(assetReference.gain, boots.gain);
          expect(assetReference.type, ziggurat.AssetType.collection);
          expect(
            assetReference.getFile(random).path,
            path.join(
              projectContext.assetsDirectory.path,
              boots.folderName,
              boots.name,
              'readme.txt',
            ),
          );
        },
      );

      test(
        '.callCommandShouldRun',
        () async {
          final command = await commandsDao.createCommand();
          var callCommand = await callCommandsDao.createCallCommand(
            commandId: command.id,
            callingCommandId: command.id,
          );
          expect(await projectRunner.callCommandShouldRun(callCommand), true);
          callCommand = await callCommandsDao.setRandomNumberBase(
            callCommandId: callCommand.id,
            randomNumberBase: 1,
          );
          // Now the random number generator will always return `0`, so the
          // command should always run.
          expect(await projectRunner.callCommandShouldRun(callCommand), true);
        },
      );

      test(
        '.getMenuLevel',
        () async {
          // We need to use actual files and directories here, otherwise
          // `getAssetReference` kicks off.
          final music = await assetReferencesDao.createAssetReference(
            folderName: 'music',
            name: 'menu.mp3',
          );
          final selectItemSound = await assetReferencesDao.createAssetReference(
            folderName: 'menus',
            name: 'select.mp3',
            gain: 1.0,
          );
          final activateItemSound =
              await assetReferencesDao.createAssetReference(
            folderName: 'menus',
            name: 'activate.mp3',
            gain: 0.5,
          );
          final playMessage = await assetReferencesDao.createAssetReference(
            folderName: 'messages',
            name: 'play.mp3',
          );
          final quitMessage = await assetReferencesDao.createAssetReference(
            folderName: 'messages',
            name: 'quit.mp3',
          );
          final menu = await menusDao.createMenu(
            name: 'Test Menu',
            activateItemSoundId: activateItemSound.id,
            musicId: music.id,
            selectItemSoundId: selectItemSound.id,
          );
          final quitCommand = await commandsDao.createCommand();
          final playCommand = await commandsDao.createCommand();
          final quit = await menuItemsDao.createMenuItem(
            menuId: menu.id,
            name: 'Quit',
            position: 2,
            selectSoundId: quitMessage.id,
          );
          await callCommandsDao.createCallCommand(
            commandId: quitCommand.id,
            callingMenuItemId: quit.id,
          );
          final play = await menuItemsDao.createMenuItem(
            menuId: menu.id,
            name: 'Play',
            selectSoundId: playMessage.id,
          );
          await callCommandsDao.createCallCommand(
            commandId: playCommand.id,
            callingMenuItemId: play.id,
          );
          final label = await menuItemsDao.createMenuItem(
            menuId: menu.id,
            name: '...',
          );
          final menuLevel = await projectRunner.getMenuLevel(menu);
          final title = menuLevel.title;
          expect(title.gain, 0.7);
          expect(title.keepAlive, false);
          expect(title.sound, null);
          final menuItems = menuLevel.menuItems;
          expect(menuItems.length, 3);
          final playMenuItem = menuItems.first;
          final playLabel = playMenuItem.label;
          expect(playLabel.text, play.name);
          expect(playLabel.gain, playMessage.gain);
          expect(playLabel.keepAlive, true);
          final playSound = playLabel.sound!;
          expect(playSound.encryptionKey, null);
          expect(playSound.gain, playMessage.gain);
          expect(
            playSound.name,
            path.join(
              projectContext.assetsDirectory.path,
              playMessage.folderName,
              playMessage.name,
            ),
          );
          expect(playSound.type, AssetType.file);
          final labelMenuItem = menuItems[1];
          final labelLabel = labelMenuItem.label;
          expect(labelLabel.text, label.name);
          expect(labelLabel.gain, selectItemSound.gain);
          expect(labelLabel.keepAlive, true);
          final labelSound = labelLabel.sound!;
          expect(labelSound.encryptionKey, null);
          expect(labelSound.gain, selectItemSound.gain);
          expect(
            labelSound.name,
            path.join(
              projectContext.assetsDirectory.path,
              selectItemSound.folderName,
              selectItemSound.name,
            ),
          );
          final quitMenuItem = menuItems.last;
          final quitLabel = quitMenuItem.label;
          expect(quitLabel.text, quit.name);
          expect(quitLabel.gain, quitMessage.gain);
          expect(quitLabel.keepAlive, true);
          final quitSound = quitLabel.sound!;
          expect(quitSound.encryptionKey, null);
          expect(quitSound.gain, quitMessage.gain);
          expect(
            quitSound.name,
            path.join(
              projectContext.assetsDirectory.path,
              quitMessage.folderName,
              quitMessage.name,
            ),
          );
        },
      );
    },
  );
}
