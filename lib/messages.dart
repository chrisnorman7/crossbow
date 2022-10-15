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

/// An error message.
final errorTitleMessage = Intl.message('Error');

/// The message to show when [path] does not exist.
String fileDoesNotExistMessage(final String path) => Intl.message(
      'The file $path does not exist.',
      args: [path],
      desc: 'The message to show when a file does not exist',
      examples: {
        'path': [
          r'c:\users\Someone\Documents\file.json',
          '/home/someone/Documents/document.json',
          '/Users/Someone/Documents/file.json'
        ]
      },
      name: 'fileDoesNotExistMessage',
    );

/// The title of a name field.
final nameMessage = Intl.message('Name');

/// The title of a description field.
final descriptionMessage = Intl.message('Description');

/// The title of a settings page.
final settingsTitle = Intl.message('Settings');
