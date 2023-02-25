import '../../database.dart';

/// A context which holds the [text] and [assetReference] of a [command].
class MessageContext {
  /// Create an instance.
  const MessageContext({
    required this.command,
    required this.text,
    required this.assetReference,
  });

  /// The command which has issued this message.
  final Command command;

  /// The text of the message.
  final String? text;

  /// The asset reference of the message.
  final AssetReference? assetReference;
}
