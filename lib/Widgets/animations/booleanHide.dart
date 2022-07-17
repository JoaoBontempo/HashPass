import 'package:flutter/material.dart';

class AnimatedBooleanContainer extends StatelessWidget {
  const AnimatedBooleanContainer(
      {Key? key,
      required this.child,
      required this.show,
      this.duration = const Duration(milliseconds: 500),
      this.behavior = Curves.ease,
      this.alignment = Alignment.center,
      this.useHeight = true,
      this.useWidth = true})
      : super(key: key);
  final Widget child;
  final bool show;
  final Duration duration;
  final Curve behavior;
  final Alignment alignment;
  final bool useHeight;
  final bool useWidth;

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: duration,
      alignment: Alignment.centerRight,
      curve: behavior,
      child: SizedBox(
        height: !useHeight
            ? null
            : show
                ? null
                : 0,
        width: !useWidth
            ? null
            : show
                ? null
                : 0,
        child: child,
      ),
    );
  }
}
