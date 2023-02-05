import 'package:backstreets_widgets/screens.dart';
import 'package:backstreets_widgets/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../hotkeys.dart';
import '../project_tabs/project_command_triggers_tab.dart';
import '../project_tabs/project_settings_tab.dart';
import '../src/contexts/project_context.dart';
import 'create_open_project_screen.dart';

/// The main project screen.
class ProjectScreen extends ConsumerStatefulWidget {
  /// Create an instance.
  const ProjectScreen({
    required this.projectContext,
    required this.isTopLevel,
    super.key,
  });

  /// The project context to use.
  final ProjectContext projectContext;

  /// Whether or not this window is on top of the stack.
  ///
  /// If this value is `false`, then you can safely assume that a
  /// [CreateOpenProjectScreen] instance is above it in the navigator stack.
  final bool isTopLevel;

  /// Create state for this widget.
  @override
  ProjectScreenState createState() => ProjectScreenState();
}

/// State for [ProjectScreen].
class ProjectScreenState extends ConsumerState<ProjectScreen> {
  /// Build a widget.
  @override
  Widget build(final BuildContext context) {
    final project = widget.projectContext.project;
    return WillPopScope(
      onWillPop: () async {
        if (project.lastModified != null) {
          await confirm(
            context: context,
            message: Intl.message(
              'Do you want to save the project before closing it?',
            ),
            title: Intl.message('Save Project'),
            yesCallback: () {
              Navigator.of(context).pop();
              widget.projectContext.save();
            },
          );
        }
        return true;
      },
      child: CallbackShortcuts(
        bindings: {
          saveProjectHotkey: saveProject,
          closeProjectHotkey: closeProject
        },
        child: TabbedScaffold(
          tabs: [
            TabbedScaffoldTab(
              title: Intl.message('Project Settings'),
              icon: const Icon(Icons.settings),
              builder: (final context) => ProjectSettingsTab(
                projectContext: widget.projectContext,
                closeProjectFunction: closeProject,
              ),
            ),
            TabbedScaffoldTab(
              title: Intl.message('Command Triggers'),
              icon: Text(
                '${project.commandTriggers.length}',
              ),
              builder: (final context) => ProjectCommandTriggersTab(
                projectContext: widget.projectContext,
              ),
            )
          ],
        ),
      ),
    );
  }

  /// Save the project.
  void saveProject() {
    widget.projectContext.save();
    setState(() {});
  }

  /// Close this project.
  void closeProject() {
    Navigator.of(context).maybePop();
    if (widget.isTopLevel) {
      pushWidget(
        context: context,
        builder: (final context) => const CreateOpenProjectScreen(),
      );
    }
  }
}
