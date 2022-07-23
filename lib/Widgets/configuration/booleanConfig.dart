import 'package:flutter/material.dart';
import 'package:hashpass/Widgets/data/switch.dart';
import 'package:hashpass/Widgets/interface/label.dart';

class BooleanConfigWidget extends StatefulWidget {
  BooleanConfigWidget({
    Key? key,
    this.isVisible = true,
    this.onlyHeader = false,
    this.onChange,
    required this.description,
    required this.label,
    required this.icon,
    this.value,
    this.useState = true,
  }) : super(key: key);
  final bool isVisible;
  final Function(bool)? onChange;
  final String description;
  final String label;
  final IconData icon;
  final bool onlyHeader;
  final bool useState;
  bool? value;

  @override
  State<BooleanConfigWidget> createState() => _BooleanConfigWidgetState();
}

class _BooleanConfigWidgetState extends State<BooleanConfigWidget> {
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.isVisible,
      child: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Visibility(
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
                  Visibility(
                    visible: widget.onlyHeader,
                    child: HashPassLabel(
                      text: widget.label,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Visibility(
                    visible: !widget.onlyHeader,
                    child: HashPassSwitch(
                      useState: widget.useState,
                      labelWeight: FontWeight.bold,
                      onChange: (value) {
                        widget.onChange!(value);
                      },
                      value: widget.value ?? false,
                      label: widget.label,
                    ),
                  )
                ],
              ),
              HashPassLabel(
                paddingLeft: 50,
                paddingRight: 10,
                text: widget.description,
                style: Theme.of(context).textTheme.headline1,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
