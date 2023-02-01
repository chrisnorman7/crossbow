import 'package:flutter/material.dart';

import 'constants.dart';

/// Get a new ID.
String newId() => uuid.v4();

/// Return a pretty-printed version of [singleActivator].
String singleActivatorToString(final SingleActivator singleActivator) {
  final keys = <String>[];
  if (singleActivator.control) {
    keys.add('CTRL');
  }
  if (singleActivator.alt) {
    keys.add('ALT');
  }
  if (singleActivator.meta) {
    keys.add('META');
  }
  if (singleActivator.shift) {
    keys.add('SHIFT');
  }
  keys.add(singleActivator.trigger.keyLabel);
  return keys.join('+');
}
