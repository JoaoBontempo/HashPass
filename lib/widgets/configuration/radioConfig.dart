import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hashpass/widgets/data/radioButton.dart';
import 'package:hashpass/widgets/interface/label.dart';

class HashPassRadioConfig<T> extends StatelessWidget {
  const HashPassRadioConfig({
    Key? key,
    required this.label,
    this.description = "",
    required this.selectedValue,
    required this.values,
    required this.onSelect,
    required this.icon,
  }) : super(key: key);
  final T selectedValue;
  final String label;
  final String description;
  final List<T> values;
  final Function(T) onSelect;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Icon(
                        icon,
                        color: Colors.grey,
                        size: 30,
                      ),
                    ),
                    HashPassLabel(
                      text: label,
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
                Visibility(
                  visible: description.isNotEmpty,
                  child: HashPassLabel(
                    style: Get.textTheme.titleLarge,
                    text: description,
                    paddingLeft: 50,
                    paddingRight: 20,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 55),
            child: Column(
              children: values.map((value) {
                return HashPassRadioButton<T>(
                  label: value.toString(),
                  value: value,
                  group: selectedValue,
                  onSelect: onSelect,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
