import 'package:flutter/material.dart';
import 'package:hashpass/themes/theme.dart';
import 'package:hashpass/widgets/data/dropDown.dart';
import 'package:hashpass/widgets/interface/label.dart';

class DropDownConfiguration<ConfigType> extends StatelessWidget {
  const DropDownConfiguration({
    super.key,
    required this.selectedValue,
    required this.onChange,
    required this.label,
    required this.icon,
    required this.values,
  });
  final ConfigType selectedValue;
  final List<ConfigType> values;
  final Function(ConfigType) onChange;
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                HashPassLabel(
                  text: label,
                  fontWeight: FontWeight.bold,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: HashPassDropDown<ConfigType>(
                    isLightBackground: !HashPassTheme.isDarkMode,
                    itens: values,
                    onChange: onChange,
                    hintText: '',
                    selectedItem: selectedValue,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
