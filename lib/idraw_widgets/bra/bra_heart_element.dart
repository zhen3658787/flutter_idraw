import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_idraw/assets.dart';
import 'package:flutter_idraw/idraw_widgets/index.dart';
import 'package:flutter_idraw/utils/utils.dart';

class BraHeartElement extends SceneElement {
  BraHeartElement(super.scene);
  static String get id => "BraHeartElement";

  final int startFrame = 118;

  late BezierSquareEvaluator mBezierEvaluator,
      mBezierEvaluator2,
      mBezierEvaluator3,
      mBezierEvaluator4,
      mBezierEvaluator5,
      mBezierEvaluator6,
      mBezierEvaluator7;

  late Evaluator mHeartAlphaEvaluator,
      mHeartRotateEvaluator,
      mHeartScaleEvaluator,
      mLeftAlphaEvaluator,
      mRightAlphaEvaluator,
      mLeftRotateEvaluator,
      mRightRotateEvaluator,
      mHeart2ScaleEvaluator;

  late double mHeartX, mHeartY, mHeartAlpha = 255;
  //右侧曲线
  late double mHeart2X, mHeart2Y, mRightAlpha = 255;
  late double mHeart3X, mHeart3Y;
  late double mHeart4X, mHeart4Y;
  //左侧曲线
  late double mHeart5X, mHeart5Y, mLeftAlpha = 255;
  late double mHeart6X, mHeart6Y;
  late double mHeart7X, mHeart7Y;
  double mHeartScale = 1,
      mHeartRotate = 0,
      mLeftRotate = 0,
      mRightRotate = 0,
      mHeart2Scale = 1;

  //曲线1 带白点心️轨迹
  Offset? mPointStart1;
  Offset? mPointEnd1;
  Offset? mPointAssist1;

  //曲线2 右侧曲线，通过2段贝赛尔曲线构造
  Offset? mPointStart2;
  Offset? mPointEnd2;
  Offset? mPointEnd22;
  Offset? mPointAssist2;
  Offset? mPointAssist22;

  //曲线3 左侧曲线，通过2段贝赛尔曲线构造
  Offset? mPointStart3;
  Offset? mPointEnd3;
  Offset? mPointEnd32;
  Offset? mPointAssist3;
  Offset? mPointAssist32;

  late Sprite heart1;
  late Sprite heart2;
  ////////////////////////////////////////////////
  @override
  Future<List<Sprite>> initSprites() async {
    ui.Image barHeart1 = await ImageLoader.loadIamge(AssetsImage.barHeart1);
    ui.Image barHeart2 = await ImageLoader.loadIamge(AssetsImage.barHeart2);
    heart1 = Sprite(image: barHeart1, density: scene.density);
    heart2 = Sprite(image: barHeart2, density: scene.density);
    initValues();

    return [
      heart1,
      heart2,
      Sprite(image: barHeart2, density: scene.density),
      Sprite(image: barHeart2, density: scene.density),
      Sprite(image: barHeart2, density: scene.density),
      Sprite(image: barHeart2, density: scene.density),
      Sprite(image: barHeart2, density: scene.density),
    ];
  }

  @override
  onDraw(ui.Canvas canvas, ui.Paint paint) {
    if (!visible) return;
    canvas.save();
    canvas.translate(-scene.centerX, -scene.centerY);
    for (var element in sprites) {
      element.onDraw(canvas, paint);
    }
    // sprites[0].onDraw(canvas, paint);
    // sprites[1].onDraw(canvas, paint);
    // sprites[2].onDraw(canvas, paint);
    // sprites[3].onDraw(canvas, paint);
    // sprites[4].onDraw(canvas, paint);
    // sprites[5].onDraw(canvas, paint);
    // sprites[6].onDraw(canvas, paint);
    canvas.restore();
  }

  @override
  preFrame(int frame) {
    if (frame < startFrame || frame > scene.totalFrames) {
      visible = false;
      return;
    }

    if (frame == startFrame) {
      visible = true;
      initValues();
    }

    mHeartScale = mHeartScaleEvaluator.evaluate(frame);
    mHeart2Scale = mHeart2ScaleEvaluator.evaluate(frame);
    mHeartRotate = mHeartRotateEvaluator.evaluate(frame);
    mHeartAlpha = mHeartAlphaEvaluator.evaluate(frame);
    mRightAlpha = mRightAlphaEvaluator.evaluate(frame);
    mLeftAlpha = mLeftAlphaEvaluator.evaluate(frame);
    mLeftRotate = mLeftRotateEvaluator.evaluate(frame);
    mRightRotate = mRightRotateEvaluator.evaluate(frame);

    List<double> point = mBezierEvaluator.evaluate(frame);
    mHeartX = point[0] - heart1.width / 2;
    mHeartY = point[1] - heart1.height / 2;
    List<double> point2 = mBezierEvaluator2.evaluate(frame);
    mHeart2X = point2[0] - heart2.width / 2;
    mHeart2Y = point2[1] - heart2.height / 2;

    List<double> point3 = mBezierEvaluator3.evaluate(frame);
    mHeart3X = point3[0] - heart2.width / 2;
    mHeart3Y = point3[1] - heart2.height / 2;

    List<double> point4 = mBezierEvaluator4.evaluate(frame);
    mHeart4X = point4[0] - heart2.width / 2;
    mHeart4Y = point4[1] - heart2.height / 2;

    List<double> point5 = mBezierEvaluator5.evaluate(frame);
    mHeart5X = point5[0] - heart2.width / 2;
    mHeart5Y = point5[1] - heart2.height / 2;

    List<double> point6 = mBezierEvaluator6.evaluate(frame);
    mHeart6X = point6[0] - heart2.width / 2;
    mHeart6Y = point6[1] - heart2.height / 2;

    List<double> point7 = mBezierEvaluator7.evaluate(frame);
    mHeart7X = point7[0] - heart2.width / 2;
    mHeart7Y = point7[1] - heart2.height / 2;

    if (frame == 118) {
      mHeartScaleEvaluator.resetEvaluator(frame, 123, mHeartScale, 2);
    } else if (frame == 123) {
      mHeartScaleEvaluator.resetEvaluator(frame, 131, mHeartScale, 1);
    } else if (frame == 131) {
      mHeartScaleEvaluator.resetEvaluator(frame, 136, mHeartScale, 2);
    } else if (frame == 136) {
      mHeartScaleEvaluator.resetEvaluator(frame, 140, mHeartScale, 1);
    } else if (frame == 141) {
      mHeartRotateEvaluator.resetEvaluator(frame, 179, 0, 60);
      mHeartAlphaEvaluator.resetEvaluator(frame, 189, 255, 0);
      mRightAlphaEvaluator.resetEvaluator(frame, 159, 180, 180);
      mLeftAlphaEvaluator.resetEvaluator(frame, 159, 180, 180);
      mLeftRotateEvaluator.resetEvaluator(frame, 189, -30, -10);
      mRightRotateEvaluator.resetEvaluator(frame, 159, 0, 30);
    } else if (frame == 159) {
      mBezierEvaluator2.resetEvaluator(
          mPointEnd2, mPointAssist22, mPointEnd22, frame, 189);
      mBezierEvaluator5.resetEvaluator(
          mPointEnd3, mPointAssist32, mPointEnd32, frame, 189);
      mRightAlphaEvaluator.resetEvaluator(frame, 189, 180, 0);
      mRightRotateEvaluator.resetEvaluator(frame, 189, 30, 10);
      mLeftAlphaEvaluator.resetEvaluator(frame, 189, 100, 0);
    } else if (frame == 162) {
      mBezierEvaluator3 = BezierSquareEvaluator.resetEvaluator(
          mPointEnd2!, mPointAssist22!, mPointEnd22!, frame, 192);
      mBezierEvaluator6 = BezierSquareEvaluator.resetEvaluator(
          mPointEnd3!, mPointAssist32!, mPointEnd32!, frame, 192);
    } else if (frame == 164) {
      mBezierEvaluator4 = BezierSquareEvaluator.resetEvaluator(
          mPointEnd2!, mPointAssist22!, mPointEnd22!, frame, 179);
      mBezierEvaluator7 = BezierSquareEvaluator.resetEvaluator(
          mPointEnd3!, mPointAssist32!, mPointEnd32!, frame, 179);
    }
    updateSprites(frame);
  }

  updateSprites(int frame) {
    sprites[0]
        .clearMatrix4()
        .setAlpha(mHeartAlpha)
        .translate(mHeartX, mHeartY)
        .setScale(mHeartScale,
            scaleY: mHeartScale,
            centerX: heart1.width / 2,
            centerY: heart1.height / 2)
        .setRotate(mHeartRotate, centerX: mHeartX, centerY: mHeartY);

    sprites[1]
        .clearMatrix4()
        .setAlpha(mRightAlpha)
        .translate(mHeart2X, mHeart2Y)
        .setRotate(mRightRotate, centerX: mHeart2X, centerY: mHeart2Y)
        .setScale(
          mHeart2Scale,
          scaleY: mHeart2Scale,
          centerX: mHeart2X,
          centerY: mHeart2Y,
        );

    sprites[2]
        .clearMatrix4()
        .setAlpha(mRightAlpha)
        .translate(mHeart3X, mHeart3Y)
        .setRotate(mRightRotate, centerX: mHeart3X, centerY: mHeart3Y);

    sprites[3]
        .clearMatrix4()
        .setAlpha(mRightAlpha)
        .translate(mHeart4X, mHeart4Y)
        .setRotate(mRightRotate, centerX: mHeart4X, centerY: mHeart4Y);

    sprites[4]
        .clearMatrix4()
        .setAlpha(mLeftAlpha)
        .translate(mHeart5X, mHeart5Y)
        .setRotate(mLeftRotate, centerX: mHeart5X, centerY: mHeart5Y);

    sprites[5]
        .clearMatrix4()
        .setAlpha(mLeftAlpha)
        .translate(mHeart6X, mHeart6Y)
        .setRotate(mLeftRotate, centerX: mHeart6X, centerY: mHeart6Y);

    sprites[6]
        .clearMatrix4()
        .setAlpha(mLeftAlpha)
        .translate(mHeart7X, mHeart7Y)
        .setRotate(mLeftRotate, centerX: mHeart7X, centerY: mHeart7Y);
  }

  ///初始化位置大小参数
  initValues() {
    mPointStart1 = mPointStart1 ?? getPoint(484.0, 932.0);
    mPointEnd1 = mPointEnd1 ?? getPoint(952.0, 196.0);
    mPointAssist1 = mPointAssist1 ?? getPoint(272.0, 424.0);

    //曲线2 右侧曲线，通过2段贝赛尔曲线构造
    mPointStart2 = mPointStart2 ?? getPoint(524.0, 1200.0);
    mPointEnd2 = mPointEnd2 ?? getPoint(800.0, 912.0);
    mPointEnd22 = mPointEnd22 ?? getPoint(1048.0, 708.0);
    mPointAssist2 = mPointAssist2 ?? getPoint(572.0, 912.0);
    mPointAssist22 = mPointAssist22 ?? getPoint(1000.0, 912.0);

    //曲线3 左侧曲线，通过2段贝赛尔曲线构造
    mPointStart3 = mPointStart3 ?? getPoint(448.0, 1076.0);
    mPointEnd3 = mPointEnd3 ?? getPoint(444.0, 700.0);
    mPointEnd32 = mPointEnd32 ?? getPoint(432.0, 232.0);
    mPointAssist3 = mPointAssist3 ?? getPoint(208.0, 864.0);
    mPointAssist32 = mPointAssist32 ?? getPoint(608.0, 584.0);

    mHeartX = mPointStart1!.dx - heart1.width / 2;
    mHeartY = mPointStart1!.dy - heart1.height / 2;

    mHeart2X = mPointStart2!.dx - heart2.width / 2;
    mHeart2Y = mPointStart2!.dy - heart2.height / 2;

    mHeart3X = mHeart2X;
    mHeart3Y = mHeart2Y;

    mHeart4X = mHeart2X;
    mHeart4Y = mHeart2Y;

    mHeart5X = mPointStart3!.dx - heart2.width / 2;
    mHeart5Y = mPointStart3!.dy - heart2.height / 2;

    mHeart6X = mHeart5X;
    mHeart7X = mHeart5X;

    mHeart6Y = mHeart5Y;
    mHeart7Y = mHeart5Y;

    mHeartScale = 1;

    mHeartAlpha = 255;

    mHeartScaleEvaluator =
        Evaluator.resetEvaluator(118, 123, mHeartScale, mHeartScale * 2);
    mHeart2ScaleEvaluator =
        Evaluator.resetEvaluator(141, 159, mHeart2Scale / 8, mHeart2Scale);
    mHeartRotateEvaluator = Evaluator.fromValue(0);
    mLeftRotateEvaluator = Evaluator.fromValue(0);
    mRightRotateEvaluator = Evaluator.fromValue(0);
    mHeartAlphaEvaluator = Evaluator.fromValue(mHeartAlpha);
    mRightAlphaEvaluator = Evaluator.fromValue(0);
    mLeftAlphaEvaluator = Evaluator.fromValue(0);

    mBezierEvaluator = BezierSquareEvaluator.resetEvaluator(
        mPointStart1!, mPointAssist1!, mPointEnd1!, 142, 189);
    //右侧曲线
    mBezierEvaluator2 = BezierSquareEvaluator.resetEvaluator(
        mPointStart2!, mPointAssist2!, mPointEnd2!, 142, 159);
    mBezierEvaluator3 = BezierSquareEvaluator.resetEvaluator(
        mPointStart2!, mPointAssist2!, mPointEnd2!, 145, 162);
    mBezierEvaluator4 = BezierSquareEvaluator.resetEvaluator(
        mPointStart2!, mPointAssist2!, mPointEnd2!, 147, 164);

    mBezierEvaluator5 = BezierSquareEvaluator.resetEvaluator(
        mPointStart3!, mPointAssist3!, mPointEnd3!, 142, 159);
    mBezierEvaluator6 = BezierSquareEvaluator.resetEvaluator(
        mPointStart3!, mPointAssist3!, mPointEnd3!, 145, 162);
    mBezierEvaluator7 = BezierSquareEvaluator.resetEvaluator(
        mPointStart3!, mPointAssist3!, mPointEnd3!, 147, 164);
  }

  Offset getPoint(double dx, dy) {
    return Offset(toDp(dx), toDp(dy));
  }
}
