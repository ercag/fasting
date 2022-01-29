import 'package:fasting/widgets/text_widget.dart';
import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key, required this.child, required this.loaded})
      : super(key: key);
  final Widget child;
  final bool loaded;
  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      firstChild: Padding(
          padding: const EdgeInsets.all(5),
          child: Column(
            children: [const CircularProgressIndicator(), CText("Loading")],
          )),
      secondChild: child,
      crossFadeState:
          loaded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      duration: const Duration(seconds: 1),
    );
  }
}
