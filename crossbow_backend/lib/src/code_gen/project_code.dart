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
import 'main_dart_code.dart';

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
      Directory(path.join(libDirectory.path, 'assets_stores'));

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
  String writeProjectFile({
    required final File oldProjectFile,
    required final File newProjectFile,
  }) =>
      encryptFile(
        inputFile: oldProjectFile,
        outputFile: newProjectFile,
      );

  /// Write everything.
  Future<void> save() async {
    final project = oldProject;
    if (encryptedAssetsDirectory.existsSync()) {
      for (final entity in encryptedAssetsDirectory.listSync()) {
        entity.deleteSync(recursive: true);
      }
    } else {
      encryptedAssetsDirectory.createSync(recursive: true);
    }
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
      await db.assetReferencesDao.setVariableName(
        assetReferenceId: assetReference.id,
        variableName: variableName,
      );
    }
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
    final encryptionKey = writeProjectFile(
      oldProjectFile: oldProjectFile,
      newProjectFile: encryptedProjectFile,
    );
    await writeMainFile(
      db: db,
      encryptionKey: encryptionKey,
      encryptionKeys: encryptionKeys,
    );
    await writeAssetReferences(db: db, encryptionKeys: encryptionKeys);
    await db.close();
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
    final query = db.select(db.assetReferences)
      ..where((final table) => table.variableName.isNotNull());
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
      final stringBuffer = assetReferenceStringBuffers.putIfAbsent(
        folderName,
        () => StringBuffer()
          ..writeln('/// Assets for ${assetReference.folderName}.')
          ..writeln("import 'package:ziggurat/ziggurat.dart';"),
      )
        ..writeln('/// ${assetReference.comment}.')
        ..writeln('const ${assetReference.variableName} = AssetReference(')
        ..writeln("'${assetReference.name}',")
        ..writeln('$assetType,')
        ..writeln("encryptionKey: '$encryptionKey',");
      final gain = assetReference.gain;
      if (gain != 0.7) {
        stringBuffer.writeln('gain: ${assetReference.gain},');
      }
      stringBuffer.writeln(');');
    }
    if (!assetSourcesDirectory.existsSync()) {
      assetSourcesDirectory.createSync(recursive: true);
    }
    for (final entry in assetReferenceStringBuffers.entries) {
      final folderName = entry.key;
      final file =
          File(path.join(assetSourcesDirectory.path, '$folderName.dart'));
      final buffer = entry.value;
      final code = formatter.format(buffer.toString());
      file.writeAsStringSync(code);
    }
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
}
