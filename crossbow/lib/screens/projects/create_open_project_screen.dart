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
                        await loadProjectContext(projectContext);
                      } else {
                        data.appPreferences.recentProjectPath = null;
                        await data.save();
                        ref.invalidate(appPreferencesProvider);
                      }
                    },
                  ),
                ListTile(
                  autofocus: recentProjectFile == null ||
                      recentProjectFile.existsSync() == false,
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
      type: FileType.custom,
    );
    if (path == null) {
      return;
    }
    final file = File(path);
    final projectContext = await ProjectContext.blank(projectFile: file);
    if (mounted) {
      await loadProjectContext(projectContext);
    }
  }

  /// Open an existing project.
  Future<void> openProject() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final result = await FilePicker.platform.pickFiles(
      allowedExtensions: ['json'],
      dialogTitle: openProjectDialogTitle,
      initialDirectory: documentsDirectory.path,
      type: FileType.custom,
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
      await loadProjectContext(projectContext);
      // ignore: avoid_catches_without_on_clauses
    } catch (e, s) {
      if (mounted) {
        await pushWidget(
          context: context,
          builder: (final context) => Cancel(
            child: ErrorScreen(error: e, stackTrace: s),
          ),
        );
      }
      return;
    }
  }

  /// Clear the project context.
  Future<void> clearProjectContext() async {
    final notifier = ref.watch(projectContextNotifierProvider.notifier);
    await notifier.clearProjectContext();
  }

  /// Load the given [projectContext].
  Future<void> loadProjectContext(final ProjectContext projectContext) async {
    final preferences = await ref.watch(appPreferencesProvider.future);
    preferences.appPreferences.recentProjectPath = projectContext.file.path;
    await preferences.save();
    if (mounted) {
      ref
          .watch(projectContextNotifierProvider.notifier)
          .setProjectContext(projectContext);
      await pushWidget(
        context: context,
        builder: (final context) => const ProjectContextScreen(),
      );
      await clearProjectContext();
    } else {
      await projectContext.db.close();
    }
  }

  /// Dispose of the widget.
  @override
  void dispose() {
    super.dispose();
    ref.watch(bufferCacheProvider).destroy();
    ref.watch(synthizerContextProvider).destroy();
    ref.watch(synthizerProvider).shutdown();
  }
}
