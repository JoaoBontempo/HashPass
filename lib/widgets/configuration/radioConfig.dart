import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hashpass/widgets/data/radioButton.dart';
import 'package:hashpass/widgets/interface/label.dart';

class HashPassRadioConfig<T> extends StatefulWidget {
  HashPassRadioConfig({
    Key? key,
    required this.label,
    this.description = "",
    required this.group,
    required this.values,
    required this.onSelect,
    required this.icon,
  }) : super(key: key);
  T group;
  final String label;
  final String description;
  final List<T> values;
  final Function(T) onSelect;
  final IconData icon;

  @override
  State<HashPassRadioConfig<T>> createState() => _HashPassRadioConfigState<T>();
}

class _HashPassRadioConfigState<T> extends State<HashPassRadioConfig<T>> {
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
                        widget.icon,
                        color: Colors.grey,
                        size: 30,
                      ),
                    ),
                    HashPassLabel(
                      text: widget.label,
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
                Visibility(
                  visible: widget.description.isNotEmpty,
                  child: HashPassLabel(
                    style: Get.textTheme.headline1,
                    text: widget.description,
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
              children: widget.values.map((value) {
                return HashPassRadioButton<T>(
                  label: value.toString(),
                  value: value,
                  group: widget.group,
                  onSelect: (value) => {widget.onSelect(value)},
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
