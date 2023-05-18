import 'dart:math';

/// Random number generator.
final random = Random();

/// Generate a random string.
String newId() => [
      for (var i = 0; i < 12; i++) String.fromCharCode(random.nextInt(256))
    ].join();
