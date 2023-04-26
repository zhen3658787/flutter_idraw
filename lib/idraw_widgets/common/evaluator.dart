import 'dart:ui';
import 'dart:math';

///求值器
class Evaluator {
  int startFrame = 0;
  int endFrame = 0;
  double fromValue = 0;
  double toValue = 0;
  int steps = 1; // 步长
  int frameCount = 0;
  double gapValue = 0;

  Evaluator();

  Evaluator.fromValue(double fromValue) {
    resetEvaluator(100000, 100000, fromValue, fromValue);
  }

  Evaluator.resetEvaluator(
      int startFrame, int endFrame, double fromValue, double toValue) {
    resetEvaluator(startFrame, endFrame, fromValue, toValue);
  }

  Evaluator resetEvaluator(
      int startFrame, int endFrame, double fromValue, double toValue) {
    this.startFrame = startFrame;
    this.endFrame = endFrame;
    this.fromValue = fromValue;
    this.toValue = toValue;
    frameCount = endFrame - startFrame;
    gapValue = toValue - fromValue;
    return this;
  }

  double evaluate(int curFrame) {
    if (curFrame <= startFrame) {
      return fromValue;
    }
    if (curFrame >= endFrame) {
      return toValue;
    }

    double t = (curFrame - startFrame) / frameCount;

    double d = gapValue * t;

    return fromValue + d;
  }

  void shifting(int value) {
    fromValue += value;
    toValue += value;
  }
}

///三阶贝塞尔
class BezierCubeEvaluator {
  late Offset p1, p2, p3, p4; //依次为起点，辅助点1,辅助点2，终点
  late double startFrame;
  late double endFrame;
  late double steps;
  late double tStep;
  List<double> result = List.filled(2, 0);

  /////////////////////////////////////////////////////////
  BezierCubeEvaluator();

  BezierCubeEvaluator.resetEvaluator(
      this.startFrame, this.endFrame, this.p1, this.p2, this.p3, this.p4) {
    steps = endFrame - startFrame;
    tStep = 1 / steps;
  }

  BezierCubeEvaluator resetEvaluator(startFrame, endFrame, p1, p2, p3, p4) {
    this.startFrame = startFrame;
    this.endFrame = endFrame;
    this.p1 = p1;
    this.p2 = p2;
    this.p3 = p3;
    this.p4 = p4;
    steps = endFrame - startFrame;
    tStep = 1 / steps;
    return this;
  }

  List<double> evaluate(int curFrame, {bool reverse = false}) {
    double t;
    if (reverse) {
      if (curFrame < startFrame) {
        result[0] = p4.dx;
        result[1] = p4.dy;
        return result;
      } else if (curFrame > endFrame) {
        result[0] = p1.dx;
        result[1] = p1.dy;
        return result;
      }
      t = tStep * (endFrame - curFrame);
      result[0] = _calculate(p1.dx, p2.dx, p3.dx, p4.dx, t);
      result[1] = _calculate(p1.dy, p2.dy, p3.dy, p4.dy, t);
      return result;
    } else {
      if (curFrame < startFrame) {
        result[0] = p1.dx;
        result[1] = p1.dy;
        return result;
      } else if (curFrame > endFrame) {
        result[0] = p4.dx;
        result[1] = p4.dy;
        return result;
      }
      t = tStep * (curFrame - startFrame);
      result[0] = _calculate(p1.dx, p2.dx, p3.dx, p4.dx, t);
      result[1] = _calculate(p1.dy, p2.dy, p3.dy, p4.dy, t);
      return result;
    }
  }

  double _calculate(double p1, double p2, double p3, double p4, double t) {
    return (p1 * pow((1 - t), 3) +
        3 * p2 * t * pow((1 - t), 2) +
        3 * p3 * pow(t, 2) * (1 - t) +
        p4 * pow(t, 3));
  }
}

///二阶贝塞尔
class BezierSquareEvaluator {
  late Offset p1, p2, p3; //依次为起点，辅助点，终点
  late int startFrame;
  late int endFrame;
  late int steps;
  late double tStep;
  List<double> result = List.filled(2, 0);

  //////////////////////////////////////////////////////////
  BezierSquareEvaluator();
  BezierSquareEvaluator.resetEvaluator(
      this.p1, this.p2, this.p3, this.startFrame, this.endFrame) {
    steps = endFrame - startFrame;
    tStep = 1 / steps;
  }

  BezierSquareEvaluator resetEvaluator(p1, p2, p3, startFrame, endFrame) {
    this.p1 = p1;
    this.p2 = p2;
    this.p3 = p3;
    this.startFrame = startFrame;
    this.endFrame = endFrame;
    steps = endFrame - startFrame;
    tStep = 1 / steps;
    return this;
  }

  List<double> evaluate(int curFrame) {
    if (curFrame < startFrame) {
      result[0] = p1.dx;
      result[1] = p1.dy;
      return result;
    } else if (curFrame > endFrame) {
      result[0] = p3.dx;
      result[1] = p3.dy;
      return result;
    }
    double t = tStep * (curFrame - startFrame);
    result[0] = _calculate(p1.dx, p2.dx, p3.dx, t);
    result[1] = _calculate(p1.dy, p2.dy, p3.dy, t);
    return result;
  }

  double _calculate(double z0, double z1, double z2, double t) {
    double a1 = ((1.0 - t) * (1.0 - t) * z0);
    double a2 = (2.0 * t * (1 - t) * z1);
    double a3 = (t * t * z2);
    return a1 + a2 + a3;
  }
}
