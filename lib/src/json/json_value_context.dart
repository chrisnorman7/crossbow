import 'dart:io';

import '../../constants.dart';

/// A class which holds a [value] which can be saved to [file].
class JsonValueContext<T> {
  /// Create an instance.
  const JsonValueContext({
    required this.file,
    required this.value,
  });

  /// The file where [value] will be [save]d.
  final File file;

  /// The value which will be stored.
  final T value;

  /// The function to call to save [value] to [file].
  void save() {
    final data = indentedJsonEncoder.convert(value);
    file.writeAsStringSync(data);
  }
}
