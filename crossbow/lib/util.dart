import 'dart:io';

import 'package:backstreets_widgets/util.dart';
import 'package:flutter/material.dart';

import 'messages.dart';

/// Return a string representation of the given [singleActivator].
String singleActivatorToString({
  required final SingleActivator singleActivator,
  final String join = '+',
}) {
  final metaKey = Platform.isMacOS ? optionKey : altKey;
  final keys = <String>[];
  if (singleActivator.control) {
    keys.add(controlKey);
  }
  if (singleActivator.alt) {
    keys.add(metaKey);
  }
  if (singleActivator.shift) {
    keys.add(shiftKey);
  }
  keys.add(singleActivator.trigger.keyLabel);
  return keys.join(join);
}

/// Confirm something.
Future<void> intlConfirm({
  required final BuildContext context,
  required final String message,
  required final String title,
  final VoidCallback? yesCallback,
  final VoidCallback? noCallback,
}) =>
    confirm(
      context: context,
      message: message,
      noCallback: noCallback,
      noLabel: no,
      title: title,
      yesCallback: yesCallback,
      yesLabel: yes,
    );

/// Show a message.
Future<void> intlShowMessage({
  required final BuildContext context,
  required final String message,
  required final String title,
}) =>
    showMessage(context: context, message: message, title: title);
