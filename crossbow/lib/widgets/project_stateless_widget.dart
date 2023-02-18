import 'package:crossbow_backend/crossbow_backend.dart';
import 'package:flutter/material.dart';

/// The base class for a stateless widget with a [projectContext].
abstract class ProjectStatelessWidget extends StatelessWidget {
  /// Create an instance.
  const ProjectStatelessWidget({required this.projectContext, super.key});

  /// The project context to use.
  final ProjectContext projectContext;
}
