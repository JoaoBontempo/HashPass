import 'package:flutter/material.dart';
import 'package:hashpass/Widgets/interface/label.dart';

class HashPassSwitch extends StatefulWidget {
  HashPassSwitch({
    Key? key,
    required this.onChange,
    required this.value,
    required this.label,
    this.labelSize,
  }) : super(key: key);
  final Function(bool) onChange;
  final String label;
  final double? labelSize;
  bool value;

  @override
  State<HashPassSwitch> createState() => _HashPassSwitchState();
}

class _HashPassSwitchState extends State<HashPassSwitch> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        HashPassLabel(
          text: widget.label,
          size: widget.labelSize,
        ),
        Switch(
          value: widget.value,
          onChanged: (checked) => widget.onChange(checked),
        ),
      ],
    );
  }
}