import 'package:flutter/material.dart';

class HashPassLabel extends StatelessWidget {
  const HashPassLabel({
    Key? key,
    required this.text,
    this.fontWeight,
    this.paddingLeft = 0,
    this.paddingRight = 0,
    this.paddingTop = 0,
    this.paddingBottom = 0,
    this.color,
    this.size,
    this.style,
  }) : super(key: key);
  final String text;
  final FontWeight? fontWeight;
  final double paddingLeft;
  final double paddingRight;
  final double paddingTop;
  final double paddingBottom;
  final Color? color;
  final double? size;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: paddingTop,
        bottom: paddingBottom,
        left: paddingLeft,
        right: paddingRight,
      ),
      child: Text(
        text,
        style: style ??
            TextStyle(
              color: color,
              fontWeight: fontWeight,
              fontSize: size,
            ),
      ),
    );
  }
}
