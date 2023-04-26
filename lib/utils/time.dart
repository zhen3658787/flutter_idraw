import 'utils.dart';

class Time {
  static int time = 0;
  static int fps = 0;

  static void timing() {
    if (time == 0) {
      time = DateTime.now().millisecondsSinceEpoch;
    }
    var current = DateTime.now().millisecondsSinceEpoch;
    var useTime = current - time;
    p("use time(milliseconds) : $useTime");
    time = current;
  }
}
