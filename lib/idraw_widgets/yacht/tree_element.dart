import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_idraw/assets.dart';
import 'package:flutter_idraw/idraw_widgets/index.dart';
import 'package:flutter_idraw/utils/utils.dart';

class TreeElement extends SceneElement {
  TreeElement(super.scene);

  static String get id => "TreeElement";

  var evaluatorLx = Evaluator();
  var evaluatorLy = Evaluator();
  var evaluatorRx = Evaluator();
  var evaluatorRy = Evaluator();
  var evaluatorRotate1 = Evaluator();
  var evaluatorRotate2 = Evaluator();
  var evaluatorRotate3 = Evaluator();
  var evaluatorRotate4 = Evaluator();
  late Offset startOffset;
  late Sprite island;
  ////////////////////////////////////////////////////////////////
  @override
  Future<List<Sprite>> initSprites() async {
    ui.Image iTrunkR = await ImageLoader.loadIamge(AssetsImage.yachtTrunkRight);
    ui.Image iLeafR = await ImageLoader.loadIamge(AssetsImage.yachtLeafRight);
    ui.Image iTrunkL = await ImageLoader.loadIamge(AssetsImage.yachtTrunkLeft);
    ui.Image iLeafL = await ImageLoader.loadIamge(AssetsImage.yachtLeafLeft);
    return [
      Sprite(image: iTrunkR, density: scene.density),
      Sprite(image: iLeafR, density: scene.density),
      Sprite(image: iTrunkL, density: scene.density),
      Sprite(image: iLeafL, density: scene.density),
    ];
  }

  @override
  onDraw(ui.Canvas canvas, ui.Paint paint) {
    for (var element in sprites) {
      element.onDraw(canvas, paint);
    }
  }

  @override
  preFrame(int frame) {
    if (frame >= scene.totalFrames) {
      visible = false;
      return;
    }
    if (frame == 1) visible = true;
    var tempFrame = frame % 50;
    if (tempFrame == 0) tempFrame = 50;
    if (tempFrame == 1) {
      initEvaluator(tempFrame);
    } else if (tempFrame == 24) {
      evaluatorRotate1.resetEvaluator(tempFrame, 50, -4, 0);
      evaluatorRotate2.resetEvaluator(tempFrame, 50, -23.2, 0);
      evaluatorRotate3.resetEvaluator(tempFrame, 50, 4, 0);
      evaluatorRotate4.resetEvaluator(tempFrame, 50, 23.2, 0);

      evaluatorLx.resetEvaluator(tempFrame, 50, -scene.centerX - toDp(110.0),
          -scene.centerX - toDp(153.0));
      evaluatorLy.resetEvaluator(tempFrame, 50, -scene.centerY + toDp(301.0),
          -scene.centerY + toDp(294.0));
      evaluatorRx.resetEvaluator(tempFrame, 50, -scene.centerX + toDp(685.0),
          -scene.centerX + toDp(728.0));
      evaluatorRy.resetEvaluator(tempFrame, 50, -scene.centerY + toDp(331.0),
          -scene.centerY + toDp(324.0));
    }

    sprites[0].clearMatrix4().setRotate(evaluatorRotate1.evaluate(tempFrame),
        centerX: -scene.centerX + toDp(1076.0),
        centerY: -scene.centerY + toDp(1140.0));
    sprites[1]
        .clearMatrix4()
        .translate(
            evaluatorRx.evaluate(tempFrame), evaluatorRy.evaluate(tempFrame))
        .setRotate(
          evaluatorRotate2.evaluate(tempFrame),
          centerX: sprites[1].transX + sprites[1].width / 2,
          centerY: sprites[1].transY + sprites[1].height / 2,
        );
    sprites[2].clearMatrix4().setRotate(evaluatorRotate3.evaluate(tempFrame),
        centerX: -scene.centerX - toDp(13.0),
        centerY: -scene.centerY + toDp(1110.0));
    sprites[3]
        .clearMatrix4()
        .translate(
            evaluatorLx.evaluate(tempFrame), evaluatorLy.evaluate(tempFrame))
        .setRotate(
          evaluatorRotate4.evaluate(tempFrame),
          centerX: sprites[3].transX + sprites[3].width / 2,
          centerY: sprites[3].transY + sprites[3].height / 2,
        );
  }

  void initEvaluator(int frame) {
    evaluatorRotate1.resetEvaluator(frame, 24, 0, -4);
    evaluatorRotate2.resetEvaluator(frame, 24, 0, -23.2);
    evaluatorRotate3.resetEvaluator(frame, 24, 0, 4);
    evaluatorRotate4.resetEvaluator(frame, 24, 0, 23.2);

    evaluatorLx.resetEvaluator(
        frame, 24, -scene.centerX - toDp(153.0), -scene.centerX - toDp(110.0));
    evaluatorLy.resetEvaluator(
        frame, 24, -scene.centerY + toDp(294.0), -scene.centerY + toDp(301.0));
    evaluatorRx.resetEvaluator(
        frame, 24, -scene.centerX + toDp(728.0), -scene.centerX + toDp(685.0));
    evaluatorRy.resetEvaluator(
        frame, 24, -scene.centerY + toDp(324.0), -scene.centerY + toDp(331.0));
  }
}
