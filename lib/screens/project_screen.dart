import 'package:backstreets_widgets/screens.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../src/contexts/project_context.dart';

/// The main project screen.
class ProjectScreen extends ConsumerStatefulWidget {
  /// Create an instance.
  const ProjectScreen({
    required this.projectContext,
    super.key,
  });

  /// The project context to use.
  final ProjectContext projectContext;

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
    return SimpleScaffold(
      title: project.projectName,
      body: const CenterText(text: 'Loaded.'),
    );
  }
}
