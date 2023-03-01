import 'dart:convert';
import 'dart:io';

import 'package:crossbow_backend/crossbow_backend.dart';
import 'package:test/test.dart';

void main() {
  group(
    'Project',
    () {
      test(
        '.fromFile',
        () {
          const initialProject = Project(
            projectName: 'Test Project',
            initialCommandId: 1,
            appName: 'test_project',
            assetsDirectory: 'sound_files',
            databaseFilename: 'database.sqlite3',
            framesPerSecond: 120,
            orgName: 'com.test',
          );
          final file = File('test_project.json');
          final json = initialProject.toJson();
          file.writeAsStringSync(jsonEncode(json));
          final project = Project.fromFile(file);
          expect(project.appName, initialProject.appName);
          expect(project.assetsDirectory, initialProject.assetsDirectory);
          expect(project.databaseFilename, initialProject.databaseFilename);
          expect(project.framesPerSecond, initialProject.framesPerSecond);
          expect(project.initialCommandId, initialProject.initialCommandId);
          expect(project.orgName, initialProject.orgName);
          expect(project.projectName, initialProject.projectName);
          file.deleteSync();
        },
      );
    },
  );
}
