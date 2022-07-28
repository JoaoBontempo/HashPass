import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../Util/util.dart';

class AppSearchText extends StatefulWidget {
  const AppSearchText({
    Key? key,
    required this.placeholder,
    required this.controller,
    this.obscureText = false,
    this.validator,
    required this.onChange,
    this.keyboardType,
    this.formatter,
    this.fontSize = 15,
    this.dark = false,
    this.fontColor,
    this.borderColor,
    this.textAlign = TextAlign.start,
    this.labelStyle,
  }) : super(key: key);

  final String placeholder;
  final TextEditingController controller;
  final bool obscureText;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String> onChange;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? formatter;
  final double? fontSize;
  final bool dark;
  final Color? fontColor;
  final Color? borderColor;
  final TextAlign textAlign;
  final TextStyle? labelStyle;

  @override
  State<AppSearchText> createState() => _AppSearchTextState();
}

class _AppSearchTextState extends State<AppSearchText> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(22, 10, 22, 10),
      height: 40,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(15)),
      ),
      child: TextFormField(
        textAlign: widget.textAlign,
        style: TextStyle(
          fontSize: widget.fontSize,
          color: widget.fontColor ?? Theme.of(context).textTheme.bodyText1?.color,
        ),
        controller: widget.controller,
        obscureText: widget.obscureText,
        validator: widget.validator,
        onChanged: (text) => widget.onChange(text),
        keyboardType: widget.keyboardType,
        inputFormatters: widget.formatter,
        cursorColor: Colors.grey,
        decoration: InputDecoration(
          enabledBorder: Util.bordaPadrao(Colors.transparent),
          focusedBorder: Util.bordaPadrao(Colors.transparent),
          border: Util.bordaPadrao(Colors.transparent),
          hintText: widget.placeholder,
          hintStyle: const TextStyle(color: Colors.grey),
          icon: IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.search,
              color: Colors.grey,
            ),
          ),
          suffixIcon: widget.controller.text.isNotEmpty
              ? GestureDetector(
                  child: const Icon(
                    Icons.close,
                    color: Colors.grey,
                  ),
                  onTap: () {
                    widget.controller.clear();
                    widget.onChange('');
                    Get.focusScope!.unfocus();
                    widget.controller.text = '';
                  },
                )
              : null,
        ),
      ),
    );
  }
}
