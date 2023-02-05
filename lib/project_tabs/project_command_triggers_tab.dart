import 'package:flutter/material.dart';

import '../src/contexts/project_context.dart';

/// The tab for showing project command triggers.
class ProjectCommandTriggersTab extends StatefulWidget {
  /// Create an instance.
  const ProjectCommandTriggersTab({
    required this.projectContext,
    super.key,
  });

  /// The project context to use.
  final ProjectContext projectContext;

  /// Create state for this widget.
  @override
  ProjectCommandTriggersTabState createState() =>
      ProjectCommandTriggersTabState();
}

/// State for [ProjectCommandTriggersTab].
class ProjectCommandTriggersTabState extends State<ProjectCommandTriggersTab> {
  /// Build a widget.
  @override
  Widget build(final BuildContext context) {
    final project = widget.projectContext.project;
    return ListView.builder(
      itemBuilder: (final context, final index) {
        final commandTrigger = project.commandTriggers[index];
        return ListTile(
          autofocus: index == 0,
          title: Text(commandTrigger.description),
        );
      },
      itemCount: project.commandTriggers.length,
    );
  }
}
