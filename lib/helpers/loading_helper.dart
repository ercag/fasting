import 'package:fasting/widgets/text_widget.dart';
import 'package:flutter/material.dart';

class LoadingHelper {
  static bool loading = false;

  // ignore: non_constant_identifier_names
  static Widget Loading({required Widget child}) {
    return AnimatedCrossFade(
      firstChild: Padding(
          padding: const EdgeInsets.all(5),
          child: Column(
            children: [const CircularProgressIndicator(), CText("Loading")],
          )),
      secondChild: child,
      crossFadeState:
          loading ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      duration: const Duration(seconds: 1),
    );
  }
}
