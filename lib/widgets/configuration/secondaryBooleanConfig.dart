import 'package:flutter/material.dart';
import 'package:hashpass/widgets/data/switch.dart';
import 'package:hashpass/widgets/interface/label.dart';

class SecondaryBooleanConfigWidget extends StatefulWidget {
  SecondaryBooleanConfigWidget({
    Key? key,
    required this.onChange,
    required this.description,
    required this.label,
    required this.value,
  }) : super(key: key);
  final Function(bool) onChange;
  final String description;
  final String label;
  bool value;

  @override
  State<SecondaryBooleanConfigWidget> createState() =>
      _SecondaryBooleanConfigWidgetState();
}

class _SecondaryBooleanConfigWidgetState
    extends State<SecondaryBooleanConfigWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HashPassSwitch(
            onChange: (checked) {
              setState(() {
                widget.value = checked;
                widget.onChange(checked);
              });
            },
            value: widget.value,
            label: widget.label,
            labelSize: 13.5,
          ),
          HashPassLabel(
            text: widget.description,
            style: Theme.of(context).textTheme.headline1,
          ),
        ],
      ),
    );
  }
}
