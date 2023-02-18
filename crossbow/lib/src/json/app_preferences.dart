import 'package:json_annotation/json_annotation.dart';

part 'app_preferences.g.dart';

/// The application preferences.
@JsonSerializable()
class AppPreferences {
  /// Create an instance.
  AppPreferences({
    this.recentProjectPath,
  });

  /// Create an instance from a JSON object.
  factory AppPreferences.fromJson(final Map<String, dynamic> json) =>
      _$AppPreferencesFromJson(json);

  /// The path of the most recent project (if any).
  String? recentProjectPath;

  /// Convert an instance to JSON.
  Map<String, dynamic> toJson() => _$AppPreferencesToJson(this);
}
