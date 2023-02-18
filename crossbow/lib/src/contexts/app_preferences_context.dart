import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';
import '../json/app_preferences.dart';

/// A class to hold [appPreferences], and the ability to [save].
class AppPreferencesContext {
  /// Create an instance.
  const AppPreferencesContext({
    required this.appPreferences,
  });

  /// The application preferences.
  final AppPreferences appPreferences;

  /// Save the [appPreferences].
  Future<void> save() async {
    final json = appPreferences.toJson();
    final data = jsonEncode(json);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(appPreferencesKey, data);
  }
}
