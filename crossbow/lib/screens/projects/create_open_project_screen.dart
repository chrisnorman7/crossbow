import 'dart:io';

import 'package:backstreets_widgets/screens.dart';
import 'package:backstreets_widgets/util.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:crossbow_backend/crossbow_backend.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import '../../hotkeys.dart';
import '../../messages.dart';
import '../../src/providers.dart';
import '../../util.dart';
import 'project_context_screen.dart';

/// A widget for opening and creating projects.
class CreateOpenProjectScreen extends ConsumerStatefulWidget {
  /// Create an instance.
  const CreateOpenProjectScreen({
    super.key,
  });

  /// Create state for this widget.
  @override
  CreateOpenProjectState createState() => CreateOpenProjectState();
}

/// State for [CreateOpenProjectScreen].
class CreateOpenProjectState extends ConsumerState<CreateOpenProjectScreen> {
  /// Build a widget.
  @override
  Widget build(final BuildContext context) {
    final result = ref.watch(appPreferencesProvider);
    return result.when(
      data: (final data) {
        final recentProjectPath = data.appPreferences.recentProjectPath;
        final recentProjectFile =
            recentProjectPath == null ? null : File(recentProjectPath);
        return CallbackShortcuts(
          bindings: {
            newProjectHotkey: newProject,
            openProjectHotkey: openProject
          },
          child: SimpleScaffold(
            title: Intl.message('Load Project'),
            body: ListView(
              children: [
                if (recentProjectFile != null && recentProjectFile.existsSync())
                  ListTile(
                    autofocus: true,
                    title: Text(openProjectDialogTitle),
                    subtitle: Text(recentProjectFile.path),
                    onTap: () async {
                      final file = recentProjectFile;
                      if (file.existsSync()) {
                        final projectContext = ProjectContext.fromFile(file);
                        ref
                            .watch(projectContextNotifierProvider.notifier)
                            .setProjectContext(projectContext);
                        await pushWidget(
                          context: context,
                          builder: (final context) =>
                              const ProjectContextScreen(),
                        );
                      } else {
                        data.appPreferences.recentProjectPath = null;
                        ref.invalidate(appPreferencesProvider);
                      }
                    },
                  ),
                ListTile(
                  autofocus: recentProjectPath == null,
                  title: Text(Intl.message('Create New Project')),
                  subtitle: Text(
                    singleActivatorToString(
                      singleActivator: newProjectHotkey,
                    ),
                  ),
                  onTap: newProject,
                ),
                ListTile(
                  title: Text(Intl.message('Open Existing Project')),
                  subtitle: Text(
                    singleActivatorToString(
                      singleActivator: openProjectHotkey,
                    ),
                  ),
                  onTap: openProject,
                )
              ],
            ),
          ),
        );
      },
      error: ErrorScreen.withPositional,
      loading: LoadingScreen.new,
    );
  }

  /// Create a new project.
  Future<void> newProject() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = await FilePicker.platform.saveFile(
      allowedExtensions: ['json'],
      dialogTitle: newProjectDialogTitle,
      fileName: 'project.json',
      initialDirectory: documentsDirectory.path,
    );
    if (path == null) {
      return;
    }
    final file = File(path);
    final projectContext = await ProjectContext.blank(projectFile: file);
    final preferences = await ref.watch(appPreferencesProvider.future);
    preferences.appPreferences.recentProjectPath = path;
    await preferences.save();
    ref
        .watch(projectContextNotifierProvider.notifier)
        .setProjectContext(projectContext);
    if (mounted) {
      await pushWidget(
        context: context,
        builder: (final context) => const ProjectContextScreen(),
      );
    }
  }

  /// Open an existing project.
  Future<void> openProject() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final result = await FilePicker.platform.pickFiles(
      allowedExtensions: ['.json'],
      dialogTitle: openProjectDialogTitle,
      initialDirectory: documentsDirectory.path,
    );
    if (result == null) {
      return;
    }
    final path = result.files.single.path;
    if (path == null) {
      if (mounted) {
        return showMessage(context: context, message: emptyPathMessage);
      } else {
        return;
      }
    }
    final file = File(path);
    final ProjectContext projectContext;
    try {
      projectContext = ProjectContext.fromFile(file);
      // ignore: avoid_catches_without_on_clauses
    } catch (e, s) {
      if (mounted) {
        await pushWidget(
          context: context,
          builder: (final context) =>
              Cancel(child: ErrorScreen(error: e, stackTrace: s)),
        );
      }
      return;
    }
    final preferences = await ref.watch(appPreferencesProvider.future);
    preferences.appPreferences.recentProjectPath = path;
    await preferences.save();
    if (mounted) {
      await pushWidget(
        context: context,
        builder: (final context) => const ProjectContextScreen(),
      );
    } else {
      await projectContext.db.close();
    }
  }
}
