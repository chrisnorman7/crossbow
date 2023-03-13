import 'package:intl/intl.dart';

/// The name of the control key.
final controlKey = Intl.message('CTRL', desc: 'The name of the control key');

/// The name of the alt key.
final altKey = Intl.message('ALT', desc: 'The name of the alt key');

/// The name of the option key.
final optionKey = Intl.message('OPTION', desc: 'The name  of the option key');

/// The name of the shift key.
final shiftKey = Intl.message('SHIFT', desc: 'The name of the shift key');

/// The title of the new project dialog.
final newProjectDialogTitle = Intl.message(
  'New Project',
  desc: 'The title for the new project dialog box',
);

/// The title of the open project dialog.
final openProjectDialogTitle = Intl.message(
  'Open Project',
  desc: 'The title of the open project dialog box',
);

/// The message to show that an empty path was given.
final emptyPathMessage = Intl.message('No path was given.');

/// The message for project name.
final projectNameMessage = Intl.message('Project Name');

/// The message for app name.
final appNameMessage = Intl.message('App Name');

/// The message for org name.
final orgNameMessage = Intl.message('Org Name');

/// The message for frames per second.
final framesPerSecondMessage = Intl.message('Frames Per Second');

/// The unset message.
final unsetMessage = Intl.message('Unset');

/// The set message.
final setMessage = Intl.message('Set');

/// The confirm delete title.
final confirmDeleteTitle = Intl.message('Confirm Delete');

/// Yes.
final yes = Intl.message('Yes');

/// No.
final no = Intl.message('No');

/// The title of the edit command screen.
final editCommandTitle = Intl.message('Edit Command');

/// Output text.
final outputText = Intl.message('Output Text');

/// Output sound.
final outputSound = Intl.message('Output Sound');

/// The up message.
final upMessage = Intl.message('Up');

/// File message.
final fileMessage = Intl.message('File');

/// Directory message.
final directoryMessage = Intl.message('Directory');

/// Unknown message.
const unknownMessage = 'Unknown';

/// Clear.
final clearMessage = Intl.message('Clear');

/// Seconds.
final secondsMessage = Intl.message('Seconds');

/// Menu name.
final menuNameLabel = Intl.message('Menu Name');

/// Call commands.
final callCommandsMessage = Intl.message('Call Commands');

/// Error title.
final errorTitle = Intl.message('Error');

/// In.
final inMessage = Intl.message('in');

/// The delete message.
final deleteMessage = Intl.message('Delete');

/// The fade length title.
final fadeLengthTitle = Intl.message('Fade Length');

/// Random chance message.
String randomChanceMessage(final int i) => Intl.message(
      '1 in $i chance',
      args: [i],
      desc: 'The message to show for random chances',
      examples: {
        'i': [1, 4, 5]
      },
    );

/// The every time message.
final everyTimeMessage = Intl.message('Every time');

/// Done.
final doneMessage = Intl.message('Done');

/// Invalid input.
final invalidInputMessage = Intl.message('Invalid input');

/// Delete the given [row].
String deleteRowMessage(final int row) => Intl.message(
      'Delete row $row',
      args: [row],
      desc: 'The message for delete row buttons',
      examples: {
        'row': [1, 2, 3]
      },
    );

/// Edit the command for the given [row].
String editRowCommandMessage(final int row) => Intl.message(
      'Edit row $row command',
      args: [row],
      desc: 'The message for edit command buttons in the call commands screen',
      examples: {
        'row': [1, 2, 3]
      },
    );

/// URL.
final urlMessage = Intl.message('URL');

/// There is nothing to show.
final nothingToShowMessage = Intl.message('There is nothing to show.');

/// Pin.
final pinMessage = Intl.message('Pin');

/// Unpin message.
final unpinMessage = Intl.message('Unpin');

/// Create Command.
final createCommandMessage = Intl.message('Create Command');

/// Can't unpin a called command.
final cantDeleteCalledCommand =
    Intl.message('You cannot unpin this command because it is being used.');
