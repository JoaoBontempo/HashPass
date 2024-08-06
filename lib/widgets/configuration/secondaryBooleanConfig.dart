import 'package:flutter/material.dart';
import 'package:hashpass/widgets/data/switch.dart';
import 'package:hashpass/widgets/interface/label.dart';

class SecondaryBooleanConfigWidget extends StatelessWidget {
  const SecondaryBooleanConfigWidget({
    Key? key,
    required this.onChange,
    required this.description,
    required this.label,
    required this.value,
  }) : super(key: key);
  final Function(bool) onChange;
  final String description;
  final String label;
  final bool value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HashPassSwitch(
            onChange: onChange,
            value: value,
            label: label,
            labelSize: 13.5,
          ),
          HashPassLabel(
            text: description,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ],
      ),
    );
  }
}
