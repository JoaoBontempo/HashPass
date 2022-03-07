import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Util/util.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    Key? key,
    required this.label,
    this.controller,
    this.obscureText = false,
    this.validator,
    this.onChange,
    this.padding,
    this.keyboardType,
    this.formatter,
    this.fontSize = 15,
    this.dark = false,
    this.fontColor,
    this.borderColor,
    this.textAlign = TextAlign.start,
    this.labelStyle,
    this.onSave,
  }) : super(key: key);

  final String label;
  final TextEditingController? controller;
  final bool obscureText;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChange;
  final double? padding;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? formatter;
  final double? fontSize;
  final bool dark;
  final Color? fontColor;
  final Color? borderColor;
  final TextAlign textAlign;
  final TextStyle? labelStyle;
  final Function(String)? onSave;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(padding!),
      child: TextFormField(
        textAlign: textAlign,
        style: TextStyle(
          fontSize: fontSize,
          color: fontColor ?? Theme.of(context).textTheme.bodyText1?.color,
        ),
        onSaved: onSave != null ? onSave!(controller!.text) : null,
        controller: controller,
        obscureText: obscureText,
        validator: validator,
        onChanged: onChange,
        keyboardType: keyboardType,
        inputFormatters: formatter,
        cursorColor: Colors.grey,
        decoration: InputDecoration(
          labelText: label,
          enabledBorder: borderColor == null ? Theme.of(context).inputDecorationTheme.enabledBorder : Util.bordaPadrao(borderColor!),
          labelStyle: labelStyle ?? Theme.of(context).inputDecorationTheme.labelStyle,
        ),
      ),
    );
  }
}
