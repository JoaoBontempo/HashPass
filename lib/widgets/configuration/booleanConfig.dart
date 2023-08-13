import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hashpass/widgets/data/switch.dart';
import 'package:hashpass/widgets/interface/label.dart';

class BooleanConfigWidget extends StatelessWidget {
  const BooleanConfigWidget({
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
  final bool? value;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isVisible,
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
                      icon,
                      color: Colors.grey,
                      size: 30,
                    ),
                  ),
                  Visibility(
                    visible: onlyHeader,
                    child: HashPassLabel(
                      textAlign: TextAlign.start,
                      text: label,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Visibility(
                    visible: !onlyHeader,
                    child: HashPassSwitch(
                      useState: useState,
                      labelWeight: FontWeight.bold,
                      onChange: (value) {
                        onChange?.call(value);
                      },
                      value: value ?? false,
                      label: label,
                    ),
                  )
                ],
              ),
              HashPassLabel(
                paddingLeft: 50,
                paddingRight: 10,
                text: description,
                style: Get.textTheme.headline1,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
