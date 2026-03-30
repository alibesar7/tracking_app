import 'package:tracking_app/generated/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class DefaultErrorWidget extends StatelessWidget {
  final String? message;
  final VoidCallback? onRetry;

  const DefaultErrorWidget({super.key, this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 60),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              message ?? LocaleKeys.something_went_wrong.tr(),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18),
            ),
          ),
          if (onRetry != null)
            ElevatedButton(
              onPressed: onRetry,
              child: Text(
                LocaleKeys.resend.tr(),
              ), // Assuming you have a 'retry' key
            ),
        ],
      ),
    );
  }
}
