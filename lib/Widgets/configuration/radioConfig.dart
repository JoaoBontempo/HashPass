import 'package:flutter/material.dart';
import 'package:hashpass/Widgets/data/radioButton.dart';
import 'package:hashpass/Widgets/interface/label.dart';

class HashPassRadioConfig<T> extends StatefulWidget {
  HashPassRadioConfig({
    Key? key,
    required this.label,
    required this.group,
    required this.values,
    required this.onSelect,
    required this.icon,
  }) : super(key: key);
  T group;
  final String label;
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
            child: Row(
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
          ),
          Padding(
            padding: const EdgeInsets.only(left: 50),
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
