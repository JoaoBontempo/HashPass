import 'package:flutter/material.dart';
import 'package:hashpass/Widgets/interface/label.dart';

class HashPassRadioButton<T> extends StatefulWidget {
  HashPassRadioButton({
    Key? key,
    required this.label,
    required this.value,
    required this.group,
    required this.onSelect,
  }) : super(key: key);
  final T value;
  T group;
  final String label;
  final Function(T) onSelect;

  @override
  _HashPassaadioButtonState<T> createState() => _HashPassaadioButtonState<T>();
}

class _HashPassaadioButtonState<T> extends State<HashPassRadioButton<T>> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Radio<dynamic>(
          value: widget.value,
          groupValue: widget.group,
          onChanged: (value) => widget.onSelect(value),
        ),
        GestureDetector(
          onTap: () {
            widget.onSelect(widget.value);
          },
          child: HashPassLabel(text: widget.label),
        ),
      ],
    );
  }
}
