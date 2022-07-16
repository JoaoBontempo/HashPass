import 'package:flutter/material.dart';
import 'package:hashpass/Widgets/interface/label.dart';

class HashPassCheckBox extends StatefulWidget {
  HashPassCheckBox({
    Key? key,
    required this.onChange,
    required this.value,
    required this.label,
    this.labelSize,
    this.fontWeight,
    this.labelColor,
    this.scale = 1,
    this.checkColor,
    this.backgroundColor,
  }) : super(key: key);
  final Function(bool) onChange;
  final String label;
  final double? labelSize;
  final FontWeight? fontWeight;
  final Color? labelColor;
  final double scale;
  final Color? backgroundColor;
  final Color? checkColor;
  bool value;

  @override
  State<HashPassCheckBox> createState() => _HashPassCheckBoxState();
}

class _HashPassCheckBoxState extends State<HashPassCheckBox> {
  void _changeValue(bool value) {
    setState(() {
      widget.value = value;
      widget.onChange(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _changeValue(!widget.value),
      child: Row(
        children: [
          HashPassLabel(
            text: widget.label,
            color: widget.labelColor,
            fontWeight: widget.fontWeight,
            size: widget.labelSize,
          ),
          Transform.scale(
            scale: widget.scale,
            child: Checkbox(
              activeColor: widget.backgroundColor,
              checkColor: widget.checkColor,
              side: const BorderSide(width: 1.25, color: Colors.grey),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              value: widget.value,
              onChanged: (checked) => _changeValue(checked!),
            ),
          ),
        ],
      ),
    );
  }
}
