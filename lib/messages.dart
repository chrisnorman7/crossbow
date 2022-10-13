/// Provides common translation messages.
library messages;

import 'package:intl/intl.dart';

/// The message to be shown when no value is provided.
final emptyValueMessage = Intl.message('You must provide a value');

/// The message which is shown when deleting a file.
final confirmDeleteFileMessage =
    Intl.message('Are you sure you want to delete this file?');

/// The title of confirm delete message boxes.
final confirmDeleteTitle = Intl.message('Confirm Delete');

/// The message shown when there is nothing to show.
String nothingToShowMessage(final String what) => Intl.message(
      'There are no $what to show.',
      args: [what],
      desc: 'The message to show when there is nothing to see',
      examples: {
        'what': ['classes', 'presets', 'files']
      },
      name: 'nothingToShowMessage',
    );
