import 'package:flutter/material.dart';
import 'package:hashpass/widgets/interface/label.dart';

class HashPassSwitch extends StatefulWidget {
  HashPassSwitch({
    Key? key,
    required this.onChange,
    required this.value,
    required this.label,
    this.labelSize,
    this.labelWeight,
    this.useState = true,
  }) : super(key: key);
  final Function(bool) onChange;
  final String label;
  final double? labelSize;
  final FontWeight? labelWeight;
  final bool useState;
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
          fontWeight: widget.labelWeight,
        ),
        Transform.scale(
          scaleX: 0.7,
          scaleY: 0.63,
          child: Switch(
            value: widget.value,
            onChanged: (checked) {
              if (widget.useState) {
                setState(() {
                  widget.value = checked;
                });
              }
              widget.onChange(checked);
            },
          ),
        ),
      ],
    );
  }
}
