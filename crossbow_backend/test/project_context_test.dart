import 'dart:convert';
import 'dart:io';

import 'package:crossbow_backend/crossbow_backend.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';

import 'custom_database.dart';

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
    },
  );
}
