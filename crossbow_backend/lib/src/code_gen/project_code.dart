import 'dart:io';

import 'package:dart_style/dart_style.dart';
import 'package:path/path.dart' as path;
import 'package:plain_optional/plain_optional.dart';
import 'package:pubspec_yaml/pubspec_yaml.dart';
import 'package:recase/recase.dart';
import 'package:ziggurat/util.dart';
import 'package:ziggurat/ziggurat.dart' as ziggurat;

import '../../crossbow_backend.dart';
import '../../extensions.dart';
import 'flutter_git_ignore.dart';

/// The ziggurat import to use.
const zigguratImport = "import 'package:ziggurat/ziggurat.dart';";

/// The import for ziggurat sounds.
String get zigguratSoundsImport => "import 'package:ziggurat/sound.dart';";

/// The import for `crossbow_backend`.
const crossbowBackendImport =
    "import 'package:crossbow_backend/crossbow_backend.dart';";

/// The type of the encryption keys map.
typedef EncryptionKeys = Map<int, String>;

/// A class for generating code for a project.
class ProjectCode {
  /// Create an instance.
  const ProjectCode({
    required this.formatter,
    required this.oldProjectFile,
    required this.outputDirectory,
  });

  /// The formatter to format code with.
  final DartFormatter formatter;

  /// The project file to read from.
  final File oldProjectFile;

  /// The directory where [oldProject] resides.
  Directory get oldProjectDirectory => oldProjectFile.parent;

  /// The directory where code should be stored.
  ///
  /// Unless you have a very good reason for doing different, [outputDirectory]
  /// should be the root of your project, where the `pubspec.yaml` file is
  /// stored.
  final String outputDirectory;

  /// The old project to read from.
  Project get oldProject => Project.fromFile(oldProjectFile);

  /// The `lib` directory for the project.
  Directory get libDirectory => Directory(path.join(outputDirectory, 'lib'));

  /// The `src` directory for the project.
  Directory get srcDirectory => Directory(path.join(libDirectory.path, 'src'));

  /// The name of the [gameFunctionsBaseFile].
  String get gameFunctionsBaseFilename => 'game_functions_base.dart';

  /// The file where the game functions abstract class will be written.
  File get gameFunctionsBaseFile =>
      File(path.join(srcDirectory.path, gameFunctionsBaseFilename));

  /// The file where the initial game functions class will be written.
  File get gameFunctionsFile =>
      File(path.join(libDirectory.path, 'game_functions.dart'));

  /// The `bin` directory for the project.
  Directory get binDirectory => Directory(path.join(outputDirectory, 'bin'));

  /// The directory where encrypted assets will be stored.
  Directory get encryptedAssetsDirectory => Directory(
        path.join(outputDirectory, oldProject.assetsDirectory),
      );

  /// The directory where asset source code files will be written.
  Directory get assetSourcesDirectory =>
      Directory(path.join(srcDirectory.path, 'assets_stores'));

  /// The file where command trigger source code will be written.
  File get commandTriggersFile =>
      File(path.join(libDirectory.path, 'command_triggers.dart'));

  /// The directory where menu-related source code will be written.
  Directory get menusDirectory =>
      Directory(path.join(srcDirectory.path, 'menus'));

  /// The directory where the source code for menu items will be stored.
  Directory get menuItemsDirectory =>
      Directory(path.join(menusDirectory.path, 'menu_items'));

  /// The file where menus source code will be stored.
  File get menusFile => File(path.join(menusDirectory.path, 'menus.dart'));

  /// The file where the source code for push menus will be stored.
  File get pushMenusFile =>
      File(path.join(menusDirectory.path, 'push_menus.dart'));

  /// The file where source code for commands will be stored.
  File get commandsFile => File(path.join(libDirectory.path, 'commands.dart'));

  /// The file where source code for custom levels will be stored.
  File get customLevelsFile =>
      File(path.join(libDirectory.path, 'custom_levels.dart'));

  /// The file where source code for pop levels will be stored
  File get popLevelsFile =>
      File(path.join(libDirectory.path, 'pop_levels.dart'));

  /// The file where source code for push custom levels will be stored.
  File get pushCustomLevelsFile =>
      File(path.join(libDirectory.path, 'push_custom_levels.dart'));

  /// The file where source code for stop games will be stored.
  File get stopGamesFile =>
      File(path.join(libDirectory.path, 'stop_games.dart'));

  /// The `.gitignore` file to use.
  File get gitignoreFile => File(path.join(outputDirectory, '.gitignore'));

  /// The file where the build script will be written.
  File get buildScriptFileDefault =>
      File(path.join(outputDirectory, 'build-project'));

  /// The file where the windows build script will be written.
  File get buildScriptFileWindows => File('${buildScriptFileDefault.path}.bat');

  /// The file where reverbs will be written.
  File get reverbsFile => File(path.join(libDirectory.path, 'reverbs.dart'));

  /// The package name to be used by this project.
  String get packageName => oldProject.projectName.snakeCase;

  /// The runner filename.
  String get projectContextFilename => 'project_context.dart';

  /// The file where code for the runner class will be written.
  File get projectContextFile =>
      File(path.join(libDirectory.path, projectContextFilename));

  /// The filename for the main entry point.
  File get mainFile => File(path.join(binDirectory.path, '$packageName.dart'));

  /// The path where the pubspec will reside.
  File get pubspecFile => File(path.join(outputDirectory, 'pubspec.yaml'));

  /// The file where the encrypted project will be written.
  File get encryptedProjectFile =>
      File(path.join(outputDirectory, 'project.encrypted'));

  /// The file where the project database will be written.
  File get databaseFile =>
      File(path.join(outputDirectory, oldProject.databaseFilename));

  /// Write the project file.
  String writeProjectFile() => encryptFile(
        inputFile: oldProjectFile,
        outputFile: encryptedProjectFile,
      );

  /// Clear a [directory] of its contents.
  void clearDirectory(final Directory directory) {
    for (final entity in directory.listSync()) {
      entity.deleteSync(recursive: true);
    }
  }

  /// Ensure a [directory] is created and empty.
  ///
  /// This function uses [clearDirectory] if `directory.existsSync()` is `true`.
  void ensureClearDirectory(final Directory directory) {
    if (directory.existsSync()) {
      clearDirectory(directory);
    } else {
      directory.createSync(recursive: true);
    }
  }

  /// Ensure the given [entity] is deleted.
  void ensureDelete(final FileSystemEntity entity) {
    if (entity.existsSync()) {
      entity.deleteSync(recursive: true);
    }
  }

  /// Encrypt and import all assets.
  Future<EncryptionKeys> writeEncryptedAssetReferences({
    required final CrossbowBackendDatabase db,
  }) async {
    ensureClearDirectory(encryptedAssetsDirectory);
    final encryptionKeys = <int, String>{};
    final importedAssets = <String, ziggurat.AssetReferenceReference>{};
    final assetStores = <String, ziggurat.AssetStore>{};
    final assetReferencesDao = db.assetReferencesDao;
    final query = db.select(db.assetReferences);
    final oldAssetsDirectory = path.join(
      oldProjectDirectory.path,
      oldProject.assetsDirectory,
    );
    for (final assetReference in await query.get()) {
      final folderName = assetReference.folderName;
      final assetStore = assetStores.putIfAbsent(
        folderName,
        () => ziggurat.AssetStore(
          filename: '$folderName.dart',
          destination: path.join(encryptedAssetsDirectory.path, folderName),
          assets: [],
        ),
      );
      final assetReferenceComment = assetReference.comment;
      final assetReferenceKey = path.join(folderName, assetReference.name);
      final assetReferenceReference = importedAssets[assetReferenceKey];
      final comment =
          (assetReferenceComment == null || assetReferenceComment.isEmpty)
              ? assetReferenceKey
              : assetReferenceComment;
      final variableName =
          assetReference.variableName ?? 'assetReference${assetReference.id}';
      if (assetReferenceReference == null) {
        final fullPath = path.join(
          oldAssetsDirectory,
          folderName,
          assetReference.name,
        );
        final ziggurat.AssetReferenceReference imported;
        final directory = Directory(fullPath);
        final file = File(fullPath);
        if (directory.existsSync()) {
          imported = assetStore.importDirectory(
            source: directory,
            variableName: variableName,
            comment: comment,
            relativeTo: Directory.current,
          );
        } else if (file.existsSync()) {
          imported = assetStore.importFile(
            source: file,
            variableName: variableName,
            comment: comment,
            relativeTo: Directory.current,
          );
        } else {
          await assetReferencesDao.deleteAssetReference(
            assetReference: assetReference,
          );
          continue;
        }
        encryptionKeys[assetReference.id] = imported.reference.encryptionKey!;
        importedAssets[assetReferenceKey] = imported;
        await assetReferencesDao.editAssetReference(
          assetReference: assetReference,
          folderName: folderName,
          name: path.basename(imported.reference.name),
          comment: comment,
        );
      } else {
        await assetReferencesDao.editAssetReference(
          assetReference: assetReference,
          folderName: folderName,
          name: path.basename(assetReferenceReference.reference.name),
          comment: comment,
        );
        encryptionKeys[assetReference.id] =
            assetReferenceReference.reference.encryptionKey!;
      }
      await assetReferencesDao.setVariableName(
        assetReference: assetReference,
        variableName: variableName,
      );
    }
    return encryptionKeys;
  }

  /// Write the game functions base file.
  Future<void> writeGameFunctionsBase({
    required final CrossbowBackendDatabase db,
  }) async {
    final dartFunctions = await db.dartFunctionsDao.getDartFunctions();
    final stringBuffer = StringBuffer()
      ..writeln(crossbowBackendImport)
      ..writeln('/// Custom game functions.\n')
      ..writeln('abstract class GameFunctionsBase {')
      ..writeln('/// Allow subclasses to be constant.')
      ..writeln('const GameFunctionsBase();');
    for (final f in dartFunctions) {
      stringBuffer
        ..writeln('/// ${f.description}')
        ..writeln(
          'Future<void> ${f.name}(final ProjectRunner runner);',
        );
    }
    stringBuffer.writeln('}');
    final gameFunctionsBaseCode = formatter.format(stringBuffer.toString());
    gameFunctionsBaseFile.writeAsStringSync(gameFunctionsBaseCode);
  }

  /// Write the game functions class.
  void writeGameFunctionsClass() {
    final stringBuffer = StringBuffer()
      ..writeln("import 'src/$gameFunctionsBaseFilename';")
      ..writeln('/// Provide all the game functions.')
      ..writeln('class GameFunctions extends GameFunctionsBase {')
      ..writeln('/// Make this class constant.')
      ..writeln('const GameFunctions();')
      ..writeln('}');
    final gameFunctionsCode = formatter.format(stringBuffer.toString());
    gameFunctionsFile.writeAsStringSync(gameFunctionsCode);
  }

  /// Write pubspec.yaml.
  void writePubspec() {
    final pubspec = PubspecYaml(
      name: packageName,
      description: const Optional(
        'A game created with the Crossbow game engine.',
      ),
      dependencies: const [
        PackageDependencySpec.git(
          GitPackageDependencySpec(
            package: 'crossbow_backend',
            url: 'https://github.com/chrisnorman7/crossbow',
            path: Optional('crossbow_backend'),
          ),
        )
      ],
      environment: const {'sdk': '>=2.19.0 <4.0.0'},
    );
    pubspecFile.writeAsStringSync(pubspec.toYamlString());
  }

  /// Write all assets to disk.
  Future<void> writeAssetReferences({
    required final CrossbowBackendDatabase db,
    required final Map<int, String> encryptionKeys,
  }) async {
    final query = db.select(db.assetReferences);
    final assetReferences = await query.get();
    if (assetReferences.isEmpty) {
      ensureDelete(assetSourcesDirectory);
      return;
    }
    final assetReferenceStringBuffers = <String, StringBuffer>{};
    for (final assetReference in assetReferences) {
      final folderName = assetReference.folderName.snakeCase;
      final encryptionKey = encryptionKeys[assetReference.id]!;
      final fullPath = path.join(
        encryptedAssetsDirectory.path,
        assetReference.folderName,
        assetReference.name,
      );
      final ziggurat.AssetType assetType;
      if (Directory(fullPath).existsSync()) {
        assetType = ziggurat.AssetType.collection;
      } else if (File(fullPath).existsSync()) {
        assetType = ziggurat.AssetType.file;
      } else {
        throw StateError(
          'Asset reference not imported properly: $assetReference.',
        );
      }
      final variableName =
          assetReference.variableName ?? 'assetReference${assetReference.id}';
      final stringBuffer = assetReferenceStringBuffers.putIfAbsent(
        folderName,
        () => StringBuffer()
          ..writeln('/// Assets for ${assetReference.folderName}.')
          ..writeln(zigguratImport),
      )
        ..writeln('/// ${assetReference.comment}')
        ..writeln('const $variableName = AssetReference(')
        ..writeln(
          "'${oldProject.assetsDirectory}/${assetReference.folderName}/${assetReference.name}',",
        )
        ..writeln('$assetType,')
        ..writeln("encryptionKey: '$encryptionKey',");
      final gain = assetReference.gain;
      if (gain != 0.7) {
        stringBuffer.writeln('gain: ${assetReference.gain},');
      }
      stringBuffer.writeln(');');
    }
    ensureClearDirectory(assetSourcesDirectory);
    for (final entry in assetReferenceStringBuffers.entries) {
      final folderName = entry.key;
      final file = File(
        path.join(assetSourcesDirectory.path, '$folderName.dart'),
      );
      final buffer = entry.value;
      final code = formatter.format(buffer.toString());
      file.writeAsStringSync(code);
    }
  }

  /// Write command triggers to [commandTriggersFile].
  Future<void> writeCommandTriggers(final CrossbowBackendDatabase db) async {
    final query = db.select(db.commandTriggers);
    final commandTriggers = await query.get();
    if (commandTriggers.isEmpty) {
      ensureDelete(commandTriggersFile);
      return;
    }
    final imports = {zigguratImport};
    final stringBuffer = StringBuffer();
    for (final commandTrigger in commandTriggers) {
      final variableName =
          commandTrigger.variableName ?? 'commandTrigger${commandTrigger.id}';
      stringBuffer
        ..writeln('/// ${commandTrigger.description}')
        ..writeln('const $variableName = CommandTrigger(')
        ..writeln("name: '${commandTrigger.name}',")
        ..writeln("description: '${commandTrigger.description}',");
      final button = commandTrigger.gameControllerButton;
      if (button != null) {
        stringBuffer.writeln('button: $button,');
      }
      final keyboardKeyId = commandTrigger.keyboardKeyId;
      if (keyboardKeyId != null) {
        imports.add("import 'package:dart_sdl/dart_sdl.dart';");
        final keyboardKey = await db.commandTriggerKeyboardKeysDao
            .getCommandTriggerKeyboardKey(id: keyboardKeyId);
        stringBuffer
          ..writeln('keyboardKey: CommandKeyboardKey(')
          ..writeln('${keyboardKey.scanCode},');
        if (keyboardKey.alt) {
          stringBuffer.writeln('altKey: true,');
        }
        if (keyboardKey.control) {
          stringBuffer.writeln('controlKey: true');
        }
        if (keyboardKey.shift) {
          stringBuffer.writeln('shiftKey: true,');
        }
        stringBuffer.writeln('),');
      }
      stringBuffer.writeln(');');
    }
    final snippet = CodeSnippet(imports: imports, stringBuffer: stringBuffer);
    final code = formatter.format(snippet.code);
    commandTriggersFile.writeAsStringSync(code);
  }

  /// Write all commands.
  Future<void> writeCommands(final CrossbowBackendDatabase db) async {
    final query = db.select(db.commands);
    final commands = await query.get();
    final stringBuffer = StringBuffer()..writeln(crossbowBackendImport);
    for (final command in commands) {
      final variableName = command.variableName ?? 'getCommand${command.id}';
      stringBuffer
        ..writeln('/// ${command.description}')
        ..writeln(
          'Future<Command> $variableName(final ProjectRunner runner) =>',
        )
        ..writeln('runner.db.commandsDao.getCommand(id: ${command.id});');
    }
    final code = formatter.format(stringBuffer.toString());
    commandsFile.writeAsStringSync(code);
  }

  /// Write all custom levels.
  Future<void> writeCustomLevels(final CrossbowBackendDatabase db) async {
    final customLevels = await db.customLevelsDao.getCustomLevels();
    if (customLevels.isEmpty) {
      ensureDelete(customLevelsFile);
      return;
    }
    final stringBuffer = StringBuffer()..writeln(crossbowBackendImport);
    for (final customLevel in customLevels) {
      final variableName =
          customLevel.variableName ?? 'getCustomLevel${customLevel.id}';
      stringBuffer
        ..writeln('/// ${customLevel.name}.')
        ..writeln(
          'Future<CustomLevel> $variableName(final ProjectRunner runner) =>',
        )
        ..writeln(
          'runner.db.customLevelsDao.getCustomLevel(id: ${customLevel.id});',
        );
    }
    final code = formatter.format(stringBuffer.toString());
    customLevelsFile.writeAsStringSync(code);
  }

  /// Write pop levels.
  Future<void> writePopLevels(final CrossbowBackendDatabase db) async {
    final query = db.select(db.popLevels);
    final popLevels = await query.get();
    if (popLevels.isEmpty) {
      ensureDelete(popLevelsFile);
      return;
    }
    final stringBuffer = StringBuffer()..writeln(crossbowBackendImport);
    for (final popLevel in popLevels) {
      final variableName = popLevel.variableName ?? 'getPopLevel${popLevel.id}';
      stringBuffer
        ..writeln('/// ${popLevel.description}')
        ..writeln(
          'Future<PopLevel> $variableName(final ProjectRunner runner) =>',
        )
        ..writeln('runner.db.popLevelsDao.getPopLevel(id: ${popLevel.id});');
    }
    final code = formatter.format(stringBuffer.toString());
    popLevelsFile.writeAsStringSync(code);
  }

  /// Write all push custom levels.
  Future<void> writePushCustomLevels(final CrossbowBackendDatabase db) async {
    final pushCustomLevels = await db.pushCustomLevelsDao.getPushCustomLevels();
    if (pushCustomLevels.isEmpty) {
      ensureDelete(pushCustomLevelsFile);
      return;
    }
    final stringBuffer = StringBuffer()..writeln(crossbowBackendImport);
    for (final pushCustomLevel in pushCustomLevels) {
      final variableName = pushCustomLevel.variableName ??
          'getPushCustomLevel${pushCustomLevel.id}';
      final customLevel = await db.customLevelsDao.getCustomLevel(
        id: pushCustomLevel.customLevelId,
      );
      stringBuffer
        ..writeln('/// Push ${customLevel.name}.')
        ..writeln('Future<PushCustomLevel> $variableName')
        ..writeln('(final ProjectRunner runner) =>')
        ..writeln('runner.db.pushCustomLevelsDao.getPushCustomLevel(')
        ..writeln('id: ${pushCustomLevel.id});');
    }
    final code = formatter.format(stringBuffer.toString());
    pushCustomLevelsFile.writeAsStringSync(code);
  }

  /// Write stop games.
  Future<void> writeStopGames(final CrossbowBackendDatabase db) async {
    final query = db.select(db.stopGames);
    final stopGames = await query.get();
    if (stopGames.isEmpty) {
      ensureDelete(stopGamesFile);
      return;
    }
    final stringBuffer = StringBuffer()..writeln(crossbowBackendImport);
    for (final stopGame in stopGames) {
      final variableName = stopGame.variableName ?? 'getStopGame${stopGame.id}';
      stringBuffer
        ..writeln('/// ${stopGame.description}')
        ..writeln(
          'Future<StopGame> $variableName(final ProjectRunner runner) =>',
        )
        ..writeln('runner.db.stopGamesDao.getStopGame(id: ${stopGame.id});');
    }
    final code = formatter.format(stringBuffer.toString());
    stopGamesFile.writeAsStringSync(code);
  }

  /// Write all menus.
  Future<void> writeMenus(final CrossbowBackendDatabase db) async {
    final query = db.select(db.menus);
    final menus = await query.get();
    if (menus.isEmpty) {
      ensureDelete(menusFile);
      return;
    }
    final stringBuffer = StringBuffer()..writeln(crossbowBackendImport);
    for (final menu in menus) {
      final variableName = menu.variableName ?? 'getMenu${menu.id}';
      stringBuffer
        ..writeln('/// ${menu.name}.')
        ..writeln('Future<Menu> $variableName(final ProjectRunner runner) =>')
        ..writeln('runner.db.menusDao.getMenu(id: ${menu.id});');
    }
    final code = formatter.format(stringBuffer.toString());
    menusFile.writeAsStringSync(code);
  }

  /// Write code for menu items.
  Future<void> writeMenuItems(final CrossbowBackendDatabase db) async {
    final query = db.select(db.menuItems);
    final menuItems = await query.get();
    if (menuItems.isEmpty) {
      return;
    }
    final menuItemsBuffers = <int, StringBuffer>{};
    for (final menuItem in menuItems) {
      final variableName = menuItem.variableName ?? 'getMenuItem${menuItem.id}';
      menuItemsBuffers.putIfAbsent(
        menuItem.menuId,
        () => StringBuffer()
          ..writeln(
            "import 'package:crossbow_backend/crossbow_backend.dart';",
          ),
      )
        ..writeln('/// ${menuItem.name}.')
        ..writeln(
          'Future<MenuItem> $variableName(final ProjectRunner runner) =>',
        )
        ..writeln('runner.db.menuItemsDao.getMenuItem(id: ${menuItem.id});');
    }
    for (final entry in menuItemsBuffers.entries) {
      final menuId = entry.key;
      final stringBuffer = entry.value;
      final menu = await db.menusDao.getMenu(id: menuId);
      final source = '/// Menu items for ${menu.name}.\n$stringBuffer';
      final code = formatter.format(source);
      File(path.join(menuItemsDirectory.path, 'menu_$menuId.dart'))
          .writeAsStringSync(code);
    }
  }

  /// Write source code for all push menus.
  Future<void> writePushMenus(final CrossbowBackendDatabase db) async {
    final query = db.select(db.pushMenus);
    final pushMenus = await query.get();
    if (pushMenus.isEmpty) {
      ensureDelete(pushMenusFile);
      return;
    }
    final stringBuffer = StringBuffer()
      ..writeln("import 'package:crossbow_backend/crossbow_backend.dart';");
    for (final pushMenu in pushMenus) {
      final variableName = pushMenu.variableName ?? 'getPushMenu${pushMenu.id}';
      final menu = await db.menusDao.getMenu(id: pushMenu.menuId);
      stringBuffer
        ..writeln('/// Push ${menu.name}.')
        ..writeln(
          'Future<PushMenu> $variableName(final ProjectRunner runner) =>',
        )
        ..writeln('runner.db.pushMenusDao.getPushMenu(id: ${pushMenu.id});');
    }
    final code = formatter.format(stringBuffer.toString());
    pushMenusFile.writeAsStringSync(code);
  }

  /// Write the runner file.
  /// Write the project context file.
  Future<void> writeProjectContextFile({
    required final CrossbowBackendDatabase db,
    required final String encryptionKey,
    required final EncryptionKeys encryptionKeys,
  }) async {
    final filename = path.basename(encryptedProjectFile.path);
    final stringBuffer = StringBuffer()
      ..writeln("import 'dart:io';")
      ..writeln("import 'package:crossbow_backend/crossbow_backend.dart';")
      ..writeln("import 'game_functions.dart';")
      ..writeln('/// Return a project runner for this game.')
      ..writeln('ProjectContext getProjectContext() {')
      ..writeln('  const gameFunctions = GameFunctions();')
      ..writeln('  return ProjectContext.fromFile(')
      ..writeln("    File('$filename'),")
      ..writeln("    encryptionKey: '$encryptionKey',")
      ..writeln('    assetReferenceEncryptionKeys: {');
    for (final entry in encryptionKeys.entries) {
      final id = entry.key;
      final key = entry.value;
      stringBuffer.writeln("$id: '$key',");
    }
    stringBuffer
      ..writeln('},')
      ..writeln('dartFunctionsMap: {');
    for (final function in await db.dartFunctionsDao.getDartFunctions()) {
      final name = function.name;
      stringBuffer.writeln("'$name': gameFunctions.$name,");
    }
    stringBuffer.writeln('},);}');
    final code = formatter.format(stringBuffer.toString());
    projectContextFile.writeAsStringSync(code);
  }

  /// Write the main file.
  Future<void> writeMainFile() async {
    final stringBuffer = StringBuffer()
      ..writeln('/// $packageName.')
      ..writeln("import 'package:$packageName/$projectContextFilename';")
      ..writeln('/// Run the game.')
      ..writeln('Future<void> main() async {')
      ..writeln('// Create the project context.')
      ..writeln('final projectContext = getProjectContext();')
      ..writeln('// Now run the project.')
      ..writeln('return projectContext.run();')
      ..writeln('}');
    final code = formatter.format(stringBuffer.toString());
    mainFile.writeAsStringSync(code);
  }

  /// Write a `.gitignore` file.
  Future<void> writeGitIgnore(final CrossbowBackendDatabase db) async {
    final stringBuffer = StringBuffer()
      ..writeln(flutterGitIgnore)
      ..writeln('# Engine related');
    for (final entity in [
      assetSourcesDirectory,
      encryptedAssetsDirectory,
      encryptedProjectFile,
      commandTriggersFile,
      commandsFile,
      customLevelsFile,
      pushCustomLevelsFile,
      pushMenusFile,
      popLevelsFile,
      gameFunctionsBaseFile,
      databaseFile,
      menusFile,
      stopGamesFile,
      ...[
        for (final menu in await db.menusDao.getMenus())
          File(path.join(menusDirectory.path, 'menu_${menu.id}.dart'))
      ],
      ...[
        for (final menu in await db.menusDao.getMenus())
          File(path.join(menuItemsDirectory.path, 'menu_${menu.id}.dart'))
      ],
      buildScriptFileDefault,
      buildScriptFileWindows,
      Directory(path.join(outputDirectory, packageName)),
      reverbsFile,
      projectContextFile,
    ]) {
      stringBuffer.writeln(
        entity.path.substring(outputDirectory.length + 1).replaceAll(r'\', '/'),
      );
    }
    gitignoreFile.writeAsStringSync(stringBuffer.toString());
  }

  /// Write build scripts.
  void writeBuildScripts() {
    final directory = packageName;
    final sourceAssetsDirectory = path.basename(encryptedAssetsDirectory.path);
    final destinationAssetsDirectory = path.join(
      directory,
      sourceAssetsDirectory,
    );
    final defaultScriptBuffer = StringBuffer()
      ..writeln('#!/bin/sh')
      ..writeln('rm -rf $directory')
      ..writeln('mkdir $directory')
      ..writeln('cp -R $sourceAssetsDirectory $directory');
    final windowsStringBuffer = StringBuffer()
      ..writeln('@echo off')
      ..writeln('rd /S /Q $directory')
      ..writeln('md $directory')
      ..writeln('xcopy *.dll $directory')
      ..writeln(
        'xcopy /E /Y /I $sourceAssetsDirectory $destinationAssetsDirectory',
      );
    for (final file in [databaseFile, encryptedProjectFile]) {
      final filename = path.basename(file.path);
      defaultScriptBuffer.writeln('cp $filename $directory');
      windowsStringBuffer.writeln('xcopy $filename $directory');
    }
    final bin = path.basename(binDirectory.path);
    final mainFilename = path.basename(mainFile.path);
    defaultScriptBuffer.writeln(
      'dart compile exe $bin/$mainFilename -o $directory/$directory',
    );
    windowsStringBuffer.writeln(
      'dart compile exe $bin\\$mainFilename -o $directory\\$directory.exe',
    );
    buildScriptFileDefault.writeAsStringSync(defaultScriptBuffer.toString());
    buildScriptFileWindows.writeAsStringSync(windowsStringBuffer.toString());
  }

  /// Write all reverbs.
  Future<void> writeReverbs(final CrossbowBackendDatabase db) async {
    final reverbs = await db.reverbsDao.getReverbs();
    if (reverbs.isEmpty) {
      ensureDelete(reverbsFile);
      return;
    }
    final stringBuffer = StringBuffer()
      ..writeln('// ignore_for_file: avoid_redundant_argument_values')
      ..writeln(zigguratSoundsImport);
    for (final reverb in reverbs) {
      final variableName = reverb.variableName ?? 'reverbPreset${reverb.id}';
      final name = reverb.name;
      stringBuffer
        ..writeln('/// ${reverb.name}.')
        ..writeln('const $variableName = ReverbPreset(')
        ..write('name: ');
      if (name.contains("'")) {
        stringBuffer.write('"$name"');
      } else {
        stringBuffer.write("'$name'");
      }
      stringBuffer
        ..writeln(',')
        ..writeln('gain: ${reverb.gain},')
        ..writeln('lateReflectionsDelay: ${reverb.lateReflectionsDelay},')
        ..writeln(
          'lateReflectionsDiffusion: ${reverb.lateReflectionsDiffusion},',
        )
        ..writeln(
          'lateReflectionsHfReference: ${reverb.lateReflectionsHfReference},',
        )
        ..writeln(
          'lateReflectionsHfRolloff: ${reverb.lateReflectionsHfRolloff},',
        )
        ..writeln(
          'lateReflectionsLfReference: ${reverb.lateReflectionsLfReference},',
        )
        ..writeln(
          'lateReflectionsLfRolloff: ${reverb.lateReflectionsLfRolloff},',
        )
        ..writeln('lateReflectionsModulationDepth: ')
        ..writeln('${reverb.lateReflectionsModulationDepth},')
        ..writeln('lateReflectionsModulationFrequency: ')
        ..writeln('${reverb.lateReflectionsModulationFrequency},')
        ..writeln('meanFreePath: ${reverb.meanFreePath},')
        ..writeln('t60: ${reverb.t60},')
        ..writeln(');');
    }
    final code = formatter.format(stringBuffer.toString());
    reverbsFile.writeAsStringSync(code);
  }

  /// Write everything.
  Future<void> save() async {
    final project = oldProject;
    final oldDatabaseFile = File(
      path.join(
        oldProjectDirectory.path,
        project.databaseFilename,
      ),
    );
    databaseFile.writeAsBytesSync(oldDatabaseFile.readAsBytesSync());
    final db = CrossbowBackendDatabase.fromFile(databaseFile);
    if (!pubspecFile.existsSync()) {
      writePubspec();
    }
    if (!libDirectory.existsSync()) {
      libDirectory.createSync();
    }
    if (!srcDirectory.existsSync()) {
      srcDirectory.createSync();
    }
    if (!binDirectory.existsSync()) {
      binDirectory.createSync(recursive: true);
    }
    final encryptionKey = writeProjectFile();
    await writeGameFunctionsBase(db: db);
    if (!gameFunctionsFile.existsSync()) {
      writeGameFunctionsClass();
    }
    await writeCommandTriggers(db);
    await writeCommands(db);
    await writeCustomLevels(db);
    await writePopLevels(db);
    await writePushCustomLevels(db);
    await writeStopGames(db);
    ensureClearDirectory(menusDirectory);
    await writeMenus(db);
    ensureClearDirectory(menuItemsDirectory);
    await writeMenuItems(db);
    await writePushMenus(db);
    final encryptionKeys = await writeEncryptedAssetReferences(db: db);
    await writeProjectContextFile(
      db: db,
      encryptionKey: encryptionKey,
      encryptionKeys: encryptionKeys,
    );
    if (!mainFile.existsSync()) {
      await writeMainFile();
    }
    await writeAssetReferences(db: db, encryptionKeys: encryptionKeys);
    await writeGitIgnore(db);
    writeBuildScripts();
    await writeReverbs(db);
    await db.close();
  }
}
