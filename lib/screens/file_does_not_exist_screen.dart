import 'dart:io';

import 'package:backstreets_widgets/screens.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';

import '../messages.dart';

/// A widget to advise that the given [file] does not exist.
class FileDoesNotExistScreen extends StatelessWidget {
  /// Create an instance.
  const FileDoesNotExistScreen({
    required this.file,
    super.key,
  });

  /// The file to complain about.
  final File file;

  /// Build the widget.
  @override
  Widget build(final BuildContext context) => Cancel(
        child: SimpleScaffold(
          title: errorTitleMessage,
          body: CenterText(
            text: fileDoesNotExistMessage(file.path),
            autofocus: true,
          ),
        ),
      );
}
