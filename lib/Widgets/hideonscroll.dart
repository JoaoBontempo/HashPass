import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../Util/util.dart';

class AnimatedHide extends StatefulWidget {
  const AnimatedHide({
    Key? key,
    required this.child,
    required this.controller,
    this.duration = const Duration(milliseconds: 500),
    this.height = 50,
  }) : super(key: key);
  final Widget child;
  final ScrollController controller;
  final Duration duration;
  final double height;

  @override
  AnimatedHideState createState() => AnimatedHideState();
}

class AnimatedHideState extends State<AnimatedHide> {
  bool isVisible = true;
  bool canHide = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(scrollListener);
  }

  @override
  void dispose() {
    widget.controller.removeListener(scrollListener);
    super.dispose();
  }

  void scrollListener() {
    if (Util.isInFilter) {
      showWidget();
      return;
    }
    if (Util.senhas.isEmpty) {
      hide();
      return;
    }
    final scrollDirection = widget.controller.position.userScrollDirection;
    if (scrollDirection == ScrollDirection.forward) {
      showWidget();
    } else if (scrollDirection == ScrollDirection.reverse) {
      hide();
    }
  }

  void showWidget() {
    if (!isVisible) {
      setState(
        () {
          canHide = false;
          isVisible = true;
        },
      );
    }
  }

  void hide() {
    if (isVisible) {
      setState(
        () {
          canHide = false;
          isVisible = false;
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      height: isVisible ? widget.height : 0,
      width: isVisible ? MediaQuery.of(context).size.width : 0,
      onEnd: () {
        setState(() {
          if (!isVisible) {
            canHide = true;
          }
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
