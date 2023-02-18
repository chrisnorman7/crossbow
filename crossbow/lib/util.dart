import 'dart:io';

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
