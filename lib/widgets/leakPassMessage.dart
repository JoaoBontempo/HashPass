import 'package:flutter/material.dart';
import 'package:hashpass/dto/leakPassDTO.dart';
import 'package:hashpass/widgets/interface/label.dart';

class PasswordLeakMessage extends StatelessWidget {
  const PasswordLeakMessage({
    Key? key,
    required this.passwordInfo,
  }) : super(key: key);
  final PasswordLeakDTO passwordInfo;

  final Icon leakedIcon = const Icon(
    Icons.warning,
    color: Colors.white,
  );

  final Icon notLeakedIcon = const Icon(
    Icons.verified_user,
    color: Colors.black,
  );

  final Color isLeakedBackgorundColor = Colors.redAccent;
  final Color notLeakedBackgroundColor = Colors.greenAccent;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        shape: const StadiumBorder(),
        color: passwordInfo.leakCount == 0
            ? notLeakedBackgroundColor
            : isLeakedBackgorundColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 15, left: 10),
            child: passwordInfo.leakCount == 0 ? notLeakedIcon : leakedIcon,
          ),
          Expanded(
            child: HashPassLabel(
              text: passwordInfo.message,
              fontWeight: FontWeight.bold,
              size: 13,
              color: passwordInfo.leakCount == 0 ? Colors.black : Colors.white,
              paddingRight: 10,
              paddingTop: 10,
              paddingBottom: 10,
            ),
          ),
        ],
      ),
    );
  }
}
