import 'dart:math';

import 'package:hashpass/Util/http.dart';

class AdsHelper {
  static Future<int> getAdType() async {
    if (!await HTTPRequest.checkUserConnection()) {
      return 1;
    }

    final _random = Random();
    int number = 1 + _random.nextInt(10 - 1);
    switch (number) {
      case 10:
        return 3; //No ad.
      case 1:
        return 2; //Video ad.
      case 2:
        return 2;
      case 4:
        return 2;
      default:
        return 1; //Banner Ad.;
    }
  }
}
