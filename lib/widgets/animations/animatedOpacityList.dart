import 'package:flutter/material.dart';

class AnimatedOpacitytList extends StatefulWidget {
  const AnimatedOpacitytList({
    Key? key,
    required this.widgets,
    required this.duration,
  }) : super(key: key);
  final List<Widget> widgets;
  final int duration;

  @override
  State<AnimatedOpacitytList> createState() => _AnimatedOpacitytListState();
}

class _AnimatedOpacitytListState extends State<AnimatedOpacitytList> {
  late final List<double> opacities = List.generate(widget.widgets.length, (index) => 0, growable: false);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => setState(() {
        opacities[0] = 1;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.widgets.map((_widget) {
        int index = widget.widgets.indexOf(_widget);
        return AnimatedOpacity(
          opacity: opacities[index],
          duration: Duration(milliseconds: widget.duration),
          onEnd: () => setState(() {
            if (!(index == widget.widgets.length - 1)) opacities[index + 1] = 1;
          }),
          child: _widget,
        );
      }).toList(),
    );
  }
}
