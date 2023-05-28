import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hashpass/widgets/interface/label.dart';
import '../../util/util.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    Key? key,
    required this.label,
    this.controller,
    this.obscureText = false,
    this.validator,
    this.onChange,
    this.padding = 0,
    this.keyboardType,
    this.formatter,
    this.fontSize = 15,
    this.dark = false,
    this.fontColor,
    this.borderColor,
    this.textAlign = TextAlign.start,
    this.labelStyle,
    this.onSave,
    this.prefixIcon,
    this.suffixIcon,
    this.suffixIconClick,
    this.prefixIconClick,
    this.placeholder,
    this.icon,
    this.maxLength,
    this.onKeyboardAction,
    this.iconColor,
  }) : super(key: key);

  final String label;
  final TextEditingController? controller;
  final bool obscureText;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChange;
  final double padding;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? formatter;
  final double? fontSize;
  final bool dark;
  final Color? fontColor;
  final Color? borderColor;
  final TextAlign textAlign;
  final TextStyle? labelStyle;
  final Function(String)? onSave;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final VoidCallback? suffixIconClick;
  final VoidCallback? prefixIconClick;
  final Function(String)? onKeyboardAction;
  final String? placeholder;
  final IconData? icon;
  final int? maxLength;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: TextFormField(
        textAlign: textAlign,
        style: TextStyle(
          fontSize: fontSize,
          color: fontColor ?? Get.theme.textTheme.bodyText1?.color,
        ),
        onSaved: onSave != null ? onSave!(controller!.text) : null,
        controller: controller,
        obscureText: obscureText,
        validator: validator,
        onChanged: onChange,
        maxLength: maxLength,
        keyboardType: keyboardType,
        inputFormatters: formatter,
        onFieldSubmitted: (text) =>
            onKeyboardAction != null ? onKeyboardAction!(text) : () {},
        cursorColor: Colors.grey,
        decoration: InputDecoration(
          counterText: "",
          contentPadding: EdgeInsets.only(bottom: label.isEmpty ? 12 : 5),
          hintText: placeholder,
          label: icon == null
              ? HashPassLabel(
                  text: label,
                  paddingTop: 5,
                  paddingLeft: 10,
                )
              : Row(
                  children: [
                    FaIcon(
                      icon ?? Icons.abc,
                      color: iconColor ?? Colors.grey,
                      size: 18,
                    ),
                    HashPassLabel(
                      text: label,
                      paddingTop: 5,
                      paddingLeft: 10,
                    )
                  ],
                ),
          enabledBorder: borderColor == null
              ? Theme.of(context).inputDecorationTheme.enabledBorder
              : Util.defaultBorder(borderColor!),
          labelStyle:
              labelStyle ?? Theme.of(context).inputDecorationTheme.labelStyle,
          suffixIcon: suffixIcon != null
              ? GestureDetector(
                  onTap: () {
                    if (suffixIconClick != null) suffixIconClick!();
                  },
                  child: suffixIcon,
                )
              : null,
          prefixIcon: prefixIcon != null
              ? GestureDetector(
                  onTap: () {
                    if (prefixIconClick != null) prefixIconClick!();
                  },
                  child: prefixIcon,
                )
              : null,
        ),
      ),
    );
  }
}
