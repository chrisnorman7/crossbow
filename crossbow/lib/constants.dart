import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// The key that will hold the app preferences.
const appPreferencesKey = 'crossbow_preferences';

/// The icon shown when creating something.
final intlNewIcon = Icon(
  Icons.new_label,
  semanticLabel: Intl.message('New'),
);
