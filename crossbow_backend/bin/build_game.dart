// ignore_for_file: avoid_print
import 'dart:io';

import 'package:crossbow_backend/crossbow_backend.dart';
import 'package:dart_style/dart_style.dart';
import 'package:encrypt/encrypt.dart';
import 'package:jinja/jinja.dart';
import 'package:path/path.dart' as path;
import 'package:recase/recase.dart';
import 'package:ziggurat/ziggurat.dart' as ziggurat;

const code = '''
/// Generated on {{ when }}.
import 'dart:io';
import 'package:crossbow_backend/crossbow_backend.dart';

Future<void> main() async {
  final projectContext = ProjectContext.fromFile(
    File('{{ filename}}'),
    encryptionKey: '{{encryptionKey }}',
    assetReferenceEncryptionKeys: {
      {% for id, key in assetReferenceEncryptionKeys %}
      {{ id }}: '{{ key }}',
      {% endfor %}
    },
  );
  await projectContext.run();
}
''';

Future<void> main(final List<String> args) async {
  if (args.length != 2) {
    return print(
      'You must specify a project file to load and an output directory.',
    );
  }
  final projectFilename = args.first;
  final outputDirectoryName = args.last;
  print('Importing project $projectFilename into $outputDirectoryName.');
  var projectContext = ProjectContext.fromFile(File(projectFilename));
  final outputDirectory = Directory(outputDirectoryName);
  if (outputDirectory.existsSync()) {
    return print(
      'The output directory ${outputDirectory.path} already exists.',
    );
  }
  outputDirectory.createSync(recursive: true);
  final assetsDirectory = Directory(
    path.join(outputDirectory.path, projectContext.project.assetsDirectory),
  )..createSync(recursive: true);
  print('Copying database...');
  final databaseFilename = projectContext.project.databaseFilename;
  final dbFile = File(
    path.join(
      projectContext.projectDirectory.path,
      databaseFilename,
    ),
  );
  File(path.join(outputDirectoryName, databaseFilename))
      .writeAsBytesSync(dbFile.readAsBytesSync());
  print('Importing project...');
  final encryptionKey = SecureRandom(32).base64;
  final key = Key.fromBase64(encryptionKey);
  final iv = IV.fromLength(16);
  final encrypter = Encrypter(AES(key));
  final data = encrypter
      .encryptBytes(projectContext.file.readAsBytesSync(), iv: iv)
      .bytes;
  final filename = path.join(outputDirectory.path, 'project.encrypted');
  final newProjectFile = File(filename)..writeAsBytesSync(data);
  print('Encryption key: $encryptionKey');
  print('Closing old database...');
  await projectContext.db.close();
  projectContext = ProjectContext.fromFile(
    newProjectFile,
    encryptionKey: encryptionKey,
  );
  final db = projectContext.db;
  final encryptionKeys = <int, String>{};
  final assetStores = <String, ziggurat.AssetStore>{};
  final query = db.select(db.assetReferences);
  final oldAssetsDirectory = path.join(
    path.dirname(projectFilename),
    projectContext.project.assetsDirectory,
  );
  for (final assetReference in await query.get()) {
    final folderName = assetReference.folderName;
    final assetStore = assetStores.putIfAbsent(
      folderName,
      () => ziggurat.AssetStore(
        filename: '$folderName.dart',
        destination: path.join(assetsDirectory.path, folderName),
        assets: [],
      ),
    );
    final comment = path.join(folderName, assetReference.name);
    final existing =
        assetStore.assets.where((final element) => element.comment == comment);
    if (existing.isEmpty) {
      print('Importing asset #${assetReference.id}.');
      final fullPath = path.join(
        oldAssetsDirectory,
        folderName,
        assetReference.name,
      );
      final ziggurat.AssetReferenceReference imported;
      final directory = Directory(fullPath);
      final file = File(fullPath);
      final variableName = 'assetReference${assetReference.id}';
      if (directory.existsSync()) {
        print('Importing directory $comment.');
        imported = assetStore.importDirectory(
          source: directory,
          variableName: variableName,
          comment: comment,
          relativeTo: Directory.current,
        );
      } else if (file.existsSync()) {
        print('Importing file $comment.');
        imported = assetStore.importFile(
          source: file,
          variableName: variableName,
          comment: comment,
          relativeTo: Directory.current,
        );
      } else {
        print('Cannot import $comment.');
        continue;
      }
      encryptionKeys[assetReference.id] = imported.reference.encryptionKey!;
      await db.assetReferencesDao.editAssetReference(
        assetReferenceId: assetReference.id,
        folderName: folderName,
        name: path.basename(imported.reference.name),
      );
    } else {
      final assetReferenceReference = existing.first;
      await db.assetReferencesDao.editAssetReference(
        assetReferenceId: assetReference.id,
        folderName: folderName,
        name: path.basename(assetReferenceReference.reference.name),
      );
    }
  }
  print('Closing database...');
  await db.close();
  final when = DateTime.now();
  final environment = Environment();
  final template = environment.fromString(code);
  final output = template.render({
    'when': when,
    'filename': path.basename(filename),
    'encryptionKey': encryptionKey,
    'assetReferenceEncryptionKeys': encryptionKeys,
  });
  final formatter = DartFormatter();
  final projectNameSnake = projectContext.project.projectName.snakeCase;
  final outputFilename = path.join(
    outputDirectoryName,
    '$projectNameSnake.dart',
  );
  File(outputFilename).writeAsStringSync(formatter.format(output));
  print('Code written to $outputFilename.');
}
