import 'package:flutter/material.dart';
import 'package:hashpass/DTO/leakPassDTO.dart';

class PasswordLeakMessage extends StatefulWidget {
  const PasswordLeakMessage({
    Key? key,
    required this.passwordInfo,
  }) : super(key: key);
  final PasswordLeakDTO passwordInfo;

  @override
  State<PasswordLeakMessage> createState() => _PasswordLeakMessageState();
}

class _PasswordLeakMessageState extends State<PasswordLeakMessage> {
  final Icon leakedIcon = const Icon(
    Icons.warning,
    color: Colors.white,
  );

  final Icon notLeakedIcon = const Icon(
    Icons.verified_user,
    color: Colors.white,
  );

  final Color isLeakedBackgorundColor = Colors.redAccent;
  final Color notLeakedBackgroundColor = Colors.greenAccent;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        shape: const StadiumBorder(),
        color: widget.passwordInfo.leakCount == 0 ? notLeakedBackgroundColor : isLeakedBackgorundColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 15, left: 10),
            child: widget.passwordInfo.leakCount == 0 ? notLeakedIcon : leakedIcon,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 10, top: 10, bottom: 10),
              child: Text(
                widget.passwordInfo.message,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
