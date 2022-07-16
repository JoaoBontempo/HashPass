import 'package:flutter/material.dart';

class AnimtedBooleanContainer extends StatelessWidget {
  const AnimtedBooleanContainer({
    Key? key,
    required this.child,
    required this.show,
    this.duration = const Duration(milliseconds: 500),
  }) : super(key: key);
  final Widget child;
  final bool show;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: duration,
      curve: Curves.ease,
      child: SizedBox(
        height: show ? null : 0,
        width: show ? null : 0,
        child: child,
      ),
    );
  }
}
