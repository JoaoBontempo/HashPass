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
    this.padding,
    this.color,
    this.size,
    this.style,
    this.textAlign,
    this.overflow,
  }) : super(key: key);
  final String text;
  final FontWeight? fontWeight;
  final double paddingLeft;
  final double paddingRight;
  final double paddingTop;
  final double paddingBottom;
  final double? padding;
  final Color? color;
  final double? size;
  final TextStyle? style;
  final TextAlign? textAlign;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding == null
          ? EdgeInsets.only(
              top: paddingTop,
              bottom: paddingBottom,
              left: paddingLeft,
              right: paddingRight,
            )
          : EdgeInsets.all(padding!),
      child: Text(
        text,
        textAlign: textAlign,
        style: style ??
            TextStyle(
              color: color,
              fontWeight: fontWeight,
              fontSize: size,
              overflow: overflow,
            ),
      ),
    );
  }
}
