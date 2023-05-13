import 'package:backstreets_widgets/util.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../constants.dart';
import 'common_shortcuts.dart';

/// A widget which allows editing a [variableName].
class VariableNameListTile extends StatelessWidget {
  /// Create an instance.
  const VariableNameListTile({
    required this.variableName,
    required this.getOtherVariableNames,
    required this.onChanged,
    this.title = 'Variable Name',
    this.autofocus = false,
    this.nullable = true,
    super.key,
  });

  /// The current variable name.
  final String? variableName;

  /// The other variable names in this scope.
  final Future<List<String>> Function() getOtherVariableNames;

  /// The function to call when [variableName] changes.
  final ValueChanged<String?> onChanged;

  /// The title of this list tile.
  final String title;

  /// Whether the list tile should be autofocused.
  final bool autofocus;

  /// Whether or not [variableName] can be `null`.
  final bool nullable;

  /// Build the widget.
  @override
  Widget build(final BuildContext context) {
    final future = getOtherVariableNames();
    return CommonShortcuts(
      deleteCallback: nullable ? () => onChanged(null) : null,
      child: FutureBuilder(
        future: future,
        builder: (final context, final snapshot) {
          if (snapshot.hasError) {
            final error = snapshot.error;
            final stackTrace = snapshot.stackTrace;
            return ListTile(
              autofocus: autofocus,
              title: Text(error.toString()),
              subtitle: Text(stackTrace.toString()),
              onTap: () => setClipboardText('$error\n$stackTrace'),
            );
          }
          if (snapshot.hasData) {
            final variableNames = snapshot.requireData;
            return TextListTile(
              value: variableName ?? '',
              onChanged: (final value) {
                if (value.isEmpty) {
                  onChanged(null);
                }
                onChanged(value);
              },
              header: title,
              autofocus: autofocus,
              labelText: title,
              title: title,
              validator: (final value) {
                if (value == null || value.isEmpty) {
                  if (nullable) {
                    return null;
                  }
                  return Intl.message('You must provide a value');
                }
                if (variableNames.contains(value)) {
                  return Intl.message('That name is already taken');
                } else if (variableNameRegExp.firstMatch(value) == null) {
                  return Intl.message('Invalid name');
                }
                return null;
              },
            );
          }
          return ListTile(
            autofocus: autofocus,
            title: Text(title),
            subtitle: const LoadingWidget(),
            onTap: () {},
          );
        },
      ),
    );
  }
}
