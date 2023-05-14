import 'dart:io';

import 'package:dart_style/dart_style.dart';
import 'package:jinja/jinja.dart';
import 'package:path/path.dart' as path;
import 'package:plain_optional/plain_optional.dart';
import 'package:pubspec_yaml/pubspec_yaml.dart';
import 'package:recase/recase.dart';
import 'package:ziggurat/util.dart';
import 'package:ziggurat/ziggurat.dart' as ziggurat;

import '../../crossbow_backend.dart';
import '../../extensions.dart';
import 'code_snippet.dart';
import 'main_dart_code.dart';

/// The ziggurat import to use.
const zigguratImport = "import 'package:ziggurat/ziggurat.dart';";

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

  /// The file where the game functions abstract class will be written.
  File get gameFunctionsBaseFile =>
      File(path.join(srcDirectory.path, 'game_functions_base.dart'));

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
  File get commandTriggerFile =>
      File(path.join(libDirectory.path, 'command_triggers.dart'));

  /// The directory where menu-related source code will be written.
  Directory get menusDirectory =>
      Directory(path.join(srcDirectory.path, 'menus'));

  /// The file where menus source code will be stored.
  File get menusFile => File(path.join(menusDirectory.path, 'menus.dart'));

  /// The file where the source code for push menus will be stored.
  File get pushMenusFile =>
      File(path.join(menusDirectory.path, 'push_menus.dart'));

  /// The package name to be used by this project.
  String get packageName => oldProject.projectName.snakeCase;

  /// The filename for the main entry point.
  File get mainFile => File(path.join(binDirectory.path, '$packageName.dart'));

  /// The path where the pubspec will reside.
  File get pubspecFile => File(path.join(outputDirectory, 'pubspec.yaml'));

  /// The file where the encrypted project will be written.
  File get encryptedProjectFile =>
      File(path.join(outputDirectory, 'project.encrypted'));

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

  /// Encrypt and import all assets.
  Future<EncryptionKeys> writeEncryptedAssetReferences({
    required final CrossbowBackendDatabase db,
  }) async {
    ensureClearDirectory(encryptedAssetsDirectory);
    final encryptionKeys = <int, String>{};
    final assetStores = <String, ziggurat.AssetStore>{};
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
      final comment = path.join(folderName, assetReference.name);
      final existing = assetStore.assets.where(
        (final element) => element.comment == comment,
      );
      final variableName =
          assetReference.variableName ?? 'assetReference${assetReference.id}';
      if (existing.isEmpty) {
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
          throw StateError('Invalid asset reference: $assetReference');
        }
        encryptionKeys[assetReference.id] = imported.reference.encryptionKey!;
        await db.assetReferencesDao.editAssetReference(
          assetReferenceId: assetReference.id,
          folderName: folderName,
          name: path.basename(imported.reference.name),
          comment: fullPath,
        );
      } else {
        final assetReferenceReference = existing.first;
        await db.assetReferencesDao.editAssetReference(
          assetReferenceId: assetReference.id,
          folderName: folderName,
          name: path.basename(assetReferenceReference.reference.name),
        );
        encryptionKeys[assetReference.id] =
            assetReferenceReference.reference.encryptionKey!;
      }
    }
    return encryptionKeys;
  }

  /// Write the game functions base file.
  Future<void> writeGameFunctionsBase({
    required final CrossbowBackendDatabase db,
  }) async {
    final stringBuffer = StringBuffer()
      ..writeln("import 'package:crossbow_backend/crossbow_backend.dart';")
      ..writeln('/// Custom game functions.\n')
      ..writeln('abstract class GameFunctionsBase {')
      ..writeln('/// Allow subclasses to be constant.')
      ..writeln('const GameFunctionsBase();');
    for (final f in await db.dartFunctionsDao.getDartFunctions()) {
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
      ..writeln("import 'src/$gameFunctionsBaseFile';")
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
    final assetReferenceStringBuffers = <String, StringBuffer>{};
    final query = db.select(db.assetReferences);
    for (final assetReference in await query.get()) {
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
        ..writeln('/// ${assetReference.comment}.')
        ..writeln('const $variableName = AssetReference(')
        ..writeln("'${assetReference.name}',")
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

  /// Write command triggers to [commandTriggerFile].
  Future<void> writeCommandTriggers(final CrossbowBackendDatabase db) async {
    final query = db.select(db.commandTriggers);
    final commandTriggers = await query.get();
    if (commandTriggers.isEmpty) {
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
    commandTriggerFile.writeAsStringSync(code);
  }

  /// Write all menus.
  Future<void> writeMenus(final CrossbowBackendDatabase db) async {
    final query = db.select(db.menus);
    final menus = await query.get();
    if (menus.isEmpty) {
      return;
    }
    final stringBuffer = StringBuffer()
      ..writeln("import 'package:crossbow_backend/crossbow_backend.dart';");
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

  /// Write source code for all push menus.
  Future<void> writePushMenus(final CrossbowBackendDatabase db) async {
    final query = db.select(db.pushMenus);
    final pushMenus = await query.get();
    if (pushMenus.isEmpty) {
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

  /// Write the main file.
  Future<void> writeMainFile({
    required final CrossbowBackendDatabase db,
    required final String encryptionKey,
    required final Map<int, String> encryptionKeys,
  }) async {
    final environment = Environment();
    final template = environment.fromString(mainDartCode);
    final dartFunctions = await db.dartFunctionsDao.getDartFunctions();
    final output = template.render({
      'packageName': packageName,
      'filename': path.basename(encryptedProjectFile.path),
      'encryptionKey': encryptionKey,
      'assetReferenceEncryptionKeys': encryptionKeys,
      'dartFunctions': dartFunctions.map<Map<String, dynamic>>((final e) {
        final data = e.toJson();
        data['name'] = e.name;
        return data;
      }),
    });
    mainFile.writeAsStringSync(formatter.format(output));
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
    final newDatabaseFile =
        File(path.join(outputDirectory, project.databaseFilename))
          ..writeAsBytesSync(oldDatabaseFile.readAsBytesSync());
    final db = CrossbowBackendDatabase.fromFile(newDatabaseFile);
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
    await writeCommandTriggers(db);
    ensureClearDirectory(menusDirectory);
    await writeMenus(db);
    await writePushMenus(db);
    final encryptionKeys = await writeEncryptedAssetReferences(db: db);
    await writeMainFile(
      db: db,
      encryptionKey: encryptionKey,
      encryptionKeys: encryptionKeys,
    );
    await writeAssetReferences(db: db, encryptionKeys: encryptionKeys);
    await db.close();
  }
}
