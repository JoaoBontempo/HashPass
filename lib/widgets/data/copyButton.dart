import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hashpass/widgets/interface/label.dart';

class CopyTextButton extends StatefulWidget {
  const CopyTextButton({
    Key? key,
    this.label,
    required this.textToCopy,
    this.widgetSize,
    this.labelSize,
  }) : super(key: key);
  final String? label;
  final String textToCopy;
  final double? widgetSize;
  final double? labelSize;

  @override
  State<CopyTextButton> createState() => _CopyTextButtonState();
}

class _CopyTextButtonState extends State<CopyTextButton> {
  CrossFadeState iconState = CrossFadeState.showFirst;

  late Icon copied = Icon(
    Icons.check_circle,
    color: Colors.greenAccent,
    size: widget.widgetSize,
  );

  late Icon toCopy = Icon(
    Icons.copy,
    color: Colors.grey,
    size: widget.widgetSize,
  );

  late Icon copyIcon = toCopy;

  void _copyText() {
    Clipboard.setData(ClipboardData(text: widget.textToCopy));
    setState(() {
      iconState = CrossFadeState.showSecond;
      Future.delayed(const Duration(milliseconds: 1250), () {
        setState(() {
          iconState = CrossFadeState.showFirst;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _copyText(),
      child: Row(
        children: [
          Visibility(
            visible: widget.label != null,
            child: HashPassLabel(
              size: widget.labelSize,
              text: widget.label ?? '',
              paddingRight: 7,
            ),
          ),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 400),
            firstChild: toCopy,
            secondChild: copied,
            crossFadeState: iconState,
          ),
        ],
      ),
    );
  }
}
