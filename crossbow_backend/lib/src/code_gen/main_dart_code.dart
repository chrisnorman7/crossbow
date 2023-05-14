/// The code for a project's main entry point.
const mainDartCode = '''
library {{ packageName }};
import 'dart:io';
import 'package:crossbow_backend/crossbow_backend.dart';
import 'package:{{ packageName }}/game_functions.dart';

Future<void> main() async {
  const gameFunctions = GameFunctions();
  final projectContext = ProjectContext.fromFile(
    File('{{ filename }}'),
    encryptionKey: '{{encryptionKey }}',
    assetReferenceEncryptionKeys: {
      {% for id, key in assetReferenceEncryptionKeys %}
      {{ id }}: '{{ key }}',
      {% endfor %}
    },
    dartFunctionsMap: {
      {% for dartFunction in dartFunctions %}
      '{{ dartFunction.name }}': gameFunctions.{{ dartFunction.name }},
      {% endfor %}
    },
  );
  await projectContext.run();
}
''';
