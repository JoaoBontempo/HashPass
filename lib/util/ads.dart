import 'dart:math';

enum ADType {
  NONE(''),
  VIDEO('ca-app-pub-2117228224971128/8210053549'),
  BANNER('ca-app-pub-2117228224971128/9690427305'),
  GENERAL('ca-app-pub-2117228224971128~4230023543');

  final String id;
  const ADType(this.id);
}

class AdsHelper {
  static Future<ADType> getAdType() async {
    int number = 1 + Random().nextInt(10 - 1);
    switch (number) {
      case 10:
        return ADType.NONE;

      case 1:
      case 2:
      case 4:
        return ADType.VIDEO;

      default:
        return ADType.BANNER;
    }
  }
}
