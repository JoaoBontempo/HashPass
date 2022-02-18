import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hashpass/Util/util.dart';

import '../Themes/colors.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    Key? key,
    required this.label,
    this.controller,
    this.obscureText = false,
    this.validator,
    this.onChange,
    this.onTextChange,
    this.padding,
    this.keyboardType,
    this.formatter,
    this.fontSize = 15,
    this.dark = false,
  }) : super(key: key);

  final String label;
  final TextEditingController? controller;
  final bool obscureText;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChange;
  final ValueChanged<String>? onTextChange;
  final double? padding;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? formatter;
  final double? fontSize;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(padding!),
      child: TextFormField(
        style: TextStyle(fontSize: fontSize, color: dark ? Colors.white : Colors.black),
        controller: controller,
        obscureText: obscureText,
        validator: validator,
        onChanged: onChange,
        keyboardType: keyboardType,
        inputFormatters: formatter,
        cursorColor: dark ? Colors.white : AppColors.SECONDARY_LIGHT,
        decoration: InputDecoration(
          border: dark ? Util.bordaPadrao(AppColors.ACCENT_LIGHT_2) : Util.bordaPadrao(AppColors.SECONDARY_LIGHT),
          errorBorder: Util.bordaPadrao(Colors.redAccent),
          enabledBorder: dark ? Util.bordaPadrao(AppColors.ACCENT_LIGHT_2) : Util.bordaPadrao(AppColors.SECONDARY_LIGHT),
          focusedBorder: dark ? Util.bordaPadrao(AppColors.ACCENT_LIGHT_2) : Util.bordaPadrao(AppColors.ACCENT_LIGHT),
          isDense: true,
          labelText: label,
          labelStyle: dark ? TextStyle(color: AppColors.ACCENT_LIGHT_2, fontSize: 17) : TextStyle(color: AppColors.SECONDARY_LIGHT, fontSize: 17),
          errorStyle: const TextStyle(color: Colors.redAccent),
          filled: false,
        ),
      ),
    );
  }
}
