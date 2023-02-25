import 'dart:convert';
import 'dart:io';

import 'package:crossbow_backend/crossbow_backend.dart';
import 'package:crossbow_backend/database.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';

import '../../custom_database.dart';

/// The file where the test database is stored.
final databaseFile = File('test_db.sqlite3');

/// The file where the test project is stored.
final projectFile = File('test_project.json');
void main() {
  group(
    'ProjectContext',
    () {
      tearDown(() {
        if (databaseFile.existsSync()) {
          databaseFile.deleteSync(recursive: true);
        }
        if (projectFile.existsSync()) {
          projectFile.deleteSync(recursive: true);
        }
      });
      final project = Project(
        projectName: 'Test Project',
        initialCommandId: 1,
        databaseFilename: databaseFile.path,
        assetsDirectory: 'test_assets',
      );

      test(
        'Initialise',
        () async {
          final pretendDirectory = Directory('projects');
          const pretendProjectFilename = 'test-project.json';
          final projectContext = ProjectContext(
            file: File(
              path.join(
                pretendDirectory.path,
                pretendProjectFilename,
              ),
            ),
            project: project,
            db: getDatabase(),
          );
          expect(
            projectContext.assetsDirectory.path,
            path.join(pretendDirectory.path, project.assetsDirectory),
          );
          expect(
            projectContext.file.path,
            path.join(pretendDirectory.path, pretendProjectFilename),
          );
          expect(projectContext.project, project);
          await projectContext.db.close();
        },
      );

      test(
        '.fromFile',
        () async {
          expect(projectFile.existsSync(), false);
          final project = Project(
            projectName: 'My Test Project',
            initialCommandId: 1,
            appName: 'test_game',
            orgName: 'site.backstreets',
            assetsDirectory: 'test_assets',
            databaseFilename: databaseFile.path,
          );
          projectFile.writeAsStringSync(jsonEncode(project));
          expect(projectFile.existsSync(), true);
          final projectContext = ProjectContext.fromFile(projectFile);
          expect(
            projectContext.project,
            predicate<Project>(
              (final value) =>
                  value.appName == project.appName &&
                  value.assetsDirectory == project.assetsDirectory &&
                  value.databaseFilename == project.databaseFilename &&
                  value.orgName == project.orgName &&
                  value.projectName == project.projectName,
            ),
          );
          await projectContext.db.close();
        },
      );

      test(
        '.initialCommand',
        () async {
          final db = getDatabase();
          final command = await db.commandsDao.createCommand();
          final project = Project(
            projectName: 'Test Project',
            initialCommandId: command.id,
          );
          final projectContext =
              ProjectContext(file: databaseFile, project: project, db: db);
          expect(
            await projectContext.initialCommand,
            predicate<Command>((final value) => value.id == command.id),
          );
          await db.close();
        },
      );

      test(
        '.blank',
        () async {
          final file = File('db.sqlite3');
          if (file.existsSync()) {
            file.deleteSync();
          }
          final projectContext = await ProjectContext.blank(
            projectFile: projectFile,
          );
          expect(projectContext.project.projectName, 'Untitled Project');
          expect(
            await projectContext.initialCommand,
            predicate<Command>(
              (final value) =>
                  value.id == projectContext.project.initialCommandId &&
                  value.messageText == 'This command has not been programmed.',
            ),
          );
          expect(projectContext.file.existsSync(), true);
          projectContext.file.deleteSync();
          expect(projectContext.assetsDirectory.existsSync(), true);
          projectContext.assetsDirectory.deleteSync();
          await projectContext.db.close();
        },
      );

      test(
        '.dbFile',
        () async {
          final projectContext = ProjectContext(
            file: projectFile,
            project: project,
            db: getDatabase(),
          );

          expect(
            projectContext.dbFile.path,
            path.join(projectFile.parent.path, project.databaseFilename),
          );
          await projectContext.db.close();
        },
      );
    },
  );
}
