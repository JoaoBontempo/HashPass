import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hashpass/themes/colors.dart';
import 'package:hashpass/themes/theme.dart';
import 'package:hashpass/widgets/interface/label.dart';

class HashPassDropDown<T> extends StatelessWidget {
  HashPassDropDown({
    Key? key,
    required this.itens,
    required this.onChange,
    required this.hintText,
    required this.selectedItem,
    this.isLightBackground = false,
  }) : super(key: key);
  final List<T> itens;
  final Function(T) onChange;
  final String hintText;
  final bool isLightBackground;
  T selectedItem;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<T>(
      items: itens.map<DropdownMenuItem<T>>((T item) {
        return DropdownMenuItem<T>(
          value: item,
          child: Text(item.toString()),
        );
      }).toList(),
      onChanged: (selectedItem) => onChange(selectedItem!),
      dropdownColor: HashPassTheme.isDarkMode
          ? Colors.grey.shade900
          : isLightBackground
              ? Colors.grey.shade300
              : AppColors.ACCENT_LIGHT,
      hint: HashPassLabel(
        text: hintText,
        color: Colors.grey,
        textAlign: TextAlign.center,
      ),
      icon: RotatedBox(
        quarterTurns: 1,
        child: Icon(
          Icons.chevron_right,
          color: isLightBackground
              ? AppColors.SECONDARY_LIGHT
              : Get.theme.highlightColor,
        ),
      ),
      iconSize: 24,
      elevation: 16,
      style: TextStyle(
        color: isLightBackground
            ? AppColors.SECONDARY_LIGHT
            : Colors.grey.shade300,
        fontWeight: FontWeight.bold,
      ),
      underline: Container(
        height: 2,
        color: isLightBackground
            ? AppColors.SECONDARY_LIGHT
            : Get.theme.highlightColor,
      ),
      value: selectedItem,
    );
  }

  value(item) => item.value();
}
