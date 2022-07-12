import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hashpass/Themes/colors.dart';
import 'package:hashpass/Themes/theme.dart';
import 'package:hashpass/Widgets/interface/label.dart';

class HashPassDropDown<T> extends StatelessWidget {
  HashPassDropDown({
    Key? key,
    required this.itens,
    required this.onChange,
    required this.hintText,
    required this.selectedItem,
  }) : super(key: key);
  final List<T> itens;
  final Function(T) onChange;
  final String hintText;
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
      dropdownColor: HashPassTheme.isDarkMode ? Colors.grey.shade900 : AppColors.SECONDARY_LIGHT,
      hint: HashPassLabel(
        text: hintText,
        color: Colors.grey,
        textAlign: TextAlign.center,
      ),
      icon: RotatedBox(
        quarterTurns: 1,
        child: Icon(
          Icons.chevron_right,
          color: Get.theme.highlightColor,
        ),
      ),
      iconSize: 24,
      elevation: 16,
      style: TextStyle(
        color: Colors.grey.shade300,
        fontWeight: FontWeight.bold,
      ),
      underline: Container(
        height: 2,
        color: Get.theme.highlightColor,
      ),
      value: selectedItem,
    );
  }

  value(item) => item.value();
}
