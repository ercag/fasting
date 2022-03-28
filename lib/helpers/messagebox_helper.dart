import 'package:fasting/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MessageBoxHelper {
  static show(
      BuildContext context, String title, String message, Function? onOk) {
    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: CText(title),
      content: CText(message),
      actions: [
        TextButton(
            onPressed: () {
              if (onOk != null) {
                onOk();
                Navigator.of(context).pop();
              }
            },
            child: CText(AppLocalizations.of(context)!.ok.toUpperCase())),
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static showQuestion(BuildContext context, String title, String message,
      Function? onYes, Function? onCancel) {
    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: CText(title),
      content: CText(message),
      actions: [
        TextButton(
            onPressed: () {
              if (onYes != null) onYes();
            },
            child: CText(AppLocalizations.of(context)!.yes.toUpperCase())),
        TextButton(
            onPressed: () {
              if (onCancel != null) onCancel();
            },
            child: CText(AppLocalizations.of(context)!.no.toUpperCase())),
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static displaySnackbar(BuildContext context, String message,
      Duration? duration, Function? onOk) {
    var snackBar = SnackBar(
      duration: duration ??= const Duration(seconds: 1),
      content: CText(message),
      action: SnackBarAction(
        label: AppLocalizations.of(context)!.ok.toUpperCase(),
        onPressed: () {
          if (onOk != null) onOk();
        },
      ),
    );

// Find the ScaffoldMessenger in the widget tree
// and use it to show a SnackBar.
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
