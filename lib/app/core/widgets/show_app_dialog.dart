import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../generated/locale_keys.g.dart';

Future<void> showAppDialog(
  BuildContext context, {
  required String message,
  bool isError = true,
}) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(
        "Error",
        style: Theme.of(
          context,
        ).textTheme.labelSmall?.copyWith(color: Colors.red),
      ),
      content: Text(message),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(LocaleKeys.ok.tr(), style: TextStyle(color: Colors.red)),
        ),
      ],
    ),
  );
}
