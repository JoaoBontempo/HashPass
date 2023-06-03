import 'package:flutter/material.dart';
import 'package:hashpass/widgets/interface/label.dart';

class HashPassRadioButton<T> extends StatelessWidget {
  const HashPassRadioButton({
    Key? key,
    required this.label,
    required this.value,
    required this.group,
    required this.onSelect,
  }) : super(key: key);
  final T value;
  final T group;
  final String label;
  final Function(T) onSelect;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Radio<dynamic>(
          value: value,
          groupValue: group,
          onChanged: (value) => onSelect(value),
        ),
        GestureDetector(
          onTap: () => onSelect(value),
          child: HashPassLabel(text: label),
        ),
      ],
    );
  }
}
