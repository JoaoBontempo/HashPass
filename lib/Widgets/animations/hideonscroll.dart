import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AnimatedHide extends StatefulWidget {
  const AnimatedHide({
    Key? key,
    required this.child,
    required this.controller,
    this.duration = const Duration(milliseconds: 500),
    this.height = 50,
    required this.isVisible,
  }) : super(key: key);
  final Widget child;
  final ScrollController controller;
  final Duration duration;
  final bool isVisible;
  final double height;

  @override
  AnimatedHideState createState() => AnimatedHideState();
}

class AnimatedHideState extends State<AnimatedHide> {
  bool canHide = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      height: widget.isVisible ? widget.height : 0,
      width: widget.isVisible ? Get.size.width : 0,
      onEnd: () {
        setState(() {
          canHide = !widget.isVisible;
        });
      },
      duration: widget.duration,
      child: Visibility(
        visible: !canHide,
        child: Wrap(
          children: [
            widget.child,
          ],
        ),
      ),
    );
  }
}
