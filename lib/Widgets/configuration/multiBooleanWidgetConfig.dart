import 'package:flutter/cupertino.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hashpass/Widgets/configuration/booleanConfig.dart';
import 'package:hashpass/Widgets/configuration/secondaryBooleanConfig.dart';

class MultiBooleanWConfig extends StatefulWidget {
  const MultiBooleanWConfig({
    Key? key,
    required this.headerLabel,
    required this.headerDescription,
    required this.configurations,
    required this.headerIcon,
  }) : super(key: key);
  final String headerLabel;
  final String headerDescription;
  final IconData headerIcon;
  final List<SecondaryBooleanConfigWidget> configurations;

  @override
  State<MultiBooleanWConfig> createState() => _MultiBooleanWConfigState();
}

class _MultiBooleanWConfigState extends State<MultiBooleanWConfig> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BooleanConfigWidget(
          description: widget.headerDescription,
          label: widget.headerLabel,
          icon: widget.headerIcon,
          onlyHeader: true,
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 10,
            left: 70,
          ),
          child: Column(
            children: widget.configurations,
          ),
        )
      ],
    );
  }
}
