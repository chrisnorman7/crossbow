/// A snippet of code.
class CodeSnippet {
  /// Create an instance.
  const CodeSnippet({
    required this.imports,
    required this.stringBuffer,
  });

  /// The imports to use.
  final Set<String> imports;

  /// The string buffer to write.
  final StringBuffer stringBuffer;

  /// Get the code for this instance.
  ///
  /// The code will need formatting.
  String get code {
    final importedPackages = List<String>.from(imports)..sort();
    return '${importedPackages.join("\n")}\n$stringBuffer';
  }
}
