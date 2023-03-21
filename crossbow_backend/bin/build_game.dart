// ignore_for_file: avoid_print
import 'dart:convert';
import 'dart:io';

import 'package:crossbow_backend/crossbow_backend.dart';
import 'package:dart_style/dart_style.dart';
import 'package:jinja/jinja.dart';
import 'package:path/path.dart' as path;
import 'package:plain_optional/plain_optional.dart';
import 'package:pubspec_yaml/pubspec_yaml.dart';
import 'package:recase/recase.dart';
import 'package:ziggurat/util.dart';
import 'package:ziggurat/ziggurat.dart' as ziggurat;

const code = '''
/// Generated on {{ when }}.
import 'dart:io';
import 'package:crossbow_backend/crossbow_backend.dart';

{% for dartFunction in dartFunctions %}
/// {{ dartFunction.description }}
Future<void> function{{ dartFunction.id }}(final ProjectRunner projectRunner) async {
  // TODO(Whoever): Code this function.
}
{% endfor %}

Future<void> main() async {
  final projectContext = ProjectContext.fromFile(
    File('{{ filename}}'),
    encryptionKey: '{{encryptionKey }}',
    assetReferenceEncryptionKeys: {
      {% for id, key in assetReferenceEncryptionKeys %}
      {{ id }}: '{{ key }}',
      {% endfor %}
    },
    dartFunctionsMap: {
      {% for dartFunction in dartFunctions %}
      {{ dartFunction.id }}: function{{ dartFunction.id }},
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
  final oldProjectFile = File(args.first);
  final oldProjectDirectory = oldProjectFile.parent;
  final newProjectDirectory = Directory(args.last);
  print(
    'Importing project ${oldProjectFile.path} into '
    '${newProjectDirectory.path}.',
  );
  if (newProjectDirectory.existsSync()) {
    return print(
      'The output directory ${newProjectDirectory.path} already exists.',
    );
  }
  newProjectDirectory.createSync(recursive: true);
  final project =
      Project.fromJson(jsonDecode(oldProjectFile.readAsStringSync()));
  final assetsDirectory = Directory(
    path.join(newProjectDirectory.path, project.assetsDirectory),
  )..createSync(recursive: true);
  print('Copying database...');
  final oldDatabaseFile = File(
    path.join(
      oldProjectFile.parent.path,
      project.databaseFilename,
    ),
  );
  final newDatabaseFile =
      File(path.join(newProjectDirectory.path, project.databaseFilename))
        ..writeAsBytesSync(oldDatabaseFile.readAsBytesSync());
  print('Importing project...');
  final filename = path.join(newProjectDirectory.path, 'project.encrypted');
  final newProjectFile = File(filename);
  final encryptionKey = encryptFile(
    inputFile: oldProjectFile,
    outputFile: newProjectFile,
  );
  print('Encryption key: $encryptionKey');
  print('Opening database...');
  final db = CrossbowBackendDatabase.fromFile(newDatabaseFile);
  final encryptionKeys = <int, String>{};
  final assetStores = <String, ziggurat.AssetStore>{};
  final query = db.select(db.assetReferences);
  final oldAssetsDirectory = path.join(
    oldProjectDirectory.path,
    project.assetsDirectory,
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
    final existing = assetStore.assets.where(
      (final element) => element.comment == comment,
    );
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
      encryptionKeys[assetReference.id] =
          assetReferenceReference.reference.encryptionKey!;
    }
  }
  final dartFunctions = await db.dartFunctionsDao.getDartFunctions();
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
    'dartFunctions': dartFunctions.map((final e) => e.toJson()),
  });
  final formatter = DartFormatter();
  final projectNameSnake = project.projectName.snakeCase;
  final binDirectory = Directory(path.join(newProjectDirectory.path, 'bin'))
    ..createSync();
  final outputFilename = path.join(
    binDirectory.path,
    '$projectNameSnake.dart',
  );
  File(outputFilename).writeAsStringSync(formatter.format(output));
  print('Code written to $outputFilename.');
  final pubspecFilename = path.join(newProjectDirectory.path, 'pubspec.yaml');
  final pubspecFile = File(pubspecFilename);
  final pubspec = PubspecYaml(
    name: projectNameSnake,
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
  print('Written $pubspecFilename.');
}
