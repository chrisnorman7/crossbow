import 'dart:convert';

import 'package:dart_synthizer/dart_synthizer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import 'contexts/app_preferences_context.dart';
import 'json/app_preferences.dart';

/// Provide shared preferences.
final sharedPreferencesProvider = FutureProvider<SharedPreferences>(
  (final ref) => SharedPreferences.getInstance(),
);

/// Provide the app preferences.
final appPreferencesProvider = FutureProvider<AppPreferencesContext>(
  (final ref) async {
    final prefs = await ref.watch(sharedPreferencesProvider.future);
    final data = prefs.getString(appPreferencesKey);
    final AppPreferences preferences;
    if (data == null) {
      preferences = AppPreferences();
    } else {
      final json = jsonDecode(data);
      preferences = AppPreferences.fromJson(json);
    }
    return AppPreferencesContext(appPreferences: preferences);
  },
);

/// Provide a synthizer instance.
final synthizerProvider = Provider((final ref) => Synthizer()..initialize());

/// Provide a synthizer context.
final synthizerContextProvider = Provider((final ref) {
  final synthizer = ref.watch(synthizerProvider);
  return synthizer.createContext();
});
