import 'package:flutter/material.dart';
import 'package:flutter_idraw/assets.dart';
import 'dart:ui' as ui;

import 'package:flutter_idraw/idraw_widgets/index.dart';
import 'package:flutter_idraw/utils/utils.dart';

class CarBackLampElement extends SceneElement {
  CarBackLampElement(super.scene);
  static String get id => "CarBackLampElement";

  var evaluatorX = Evaluator();
  var evaluatorY = Evaluator();
  var evaluatorAlpha = Evaluator();
  List<Sprite> carSprites = [];
  double carStartX = 0;
  double carStartY = 0;
  final Paint _paint = Paint();
  ///////////////////////////////////////////////////////////////////////

  @override
  Future<List<Sprite>> initSprites() async {
    ui.Image ilamp =
        await ImageLoader.loadIamge(AssetsImage.roadsterCarBackLamp);
    var iLamp = Sprite(image: ilamp, density: scene.density);
    var iLamp2 = Sprite(image: ilamp.clone(), density: scene.density);
    evaluatorY.resetEvaluator(188, 210, 0, 1);
    evaluatorX.resetEvaluator(188, 210, 0, 12);
    iLamp.setRotate(-3);
    iLamp2.setRotate(-3);
    return [iLamp, iLamp2];
  }

  @override
  onDraw(Canvas canvas, Paint paint) {
    if (!visible) return;
    sprites[0].onDraw(canvas, _paint);
    sprites[1].onDraw(canvas, _paint);
  }

  @override
  preFrame(int frame) {
    if (frame < 116) {
      visible = false;
      return;
    }
    if (frame == 116) {
      visible = true;
      if (carSprites.isEmpty) {
        CarElement carElement = scene.getElement(CarElement.id) as CarElement;
        carSprites = carElement.sprites;
      }
      carStartX = carSprites[0].transX;
      carStartY = carSprites[0].transY;
      sprites[0].setTransX(carSprites[0].width / 3);
      sprites[0].setTransY(carSprites[0].transY + sprites[0].height * 1.8);

      sprites[1].setTransX(sprites[0].transX);
      sprites[1].setTransY(sprites[0].transY - toDp(20));
      evaluatorAlpha.resetEvaluator(frame, 121, 255, 0);
    } else if (frame == 125) {
      resetPaint(255);
      evaluatorAlpha.resetEvaluator(frame, 129, 255, 0);
    } else if (frame == 135) {
      resetPaint(255);
      evaluatorAlpha.resetEvaluator(frame, 139, 255, 0);
    } else if (frame == 145) {
      resetPaint(255);
      evaluatorAlpha.resetEvaluator(frame, 149, 255, 0);
    } else if (frame == 155) {
      resetPaint(255);
      evaluatorAlpha.resetEvaluator(frame, 159, 255, 0);
    } else if (frame == 164) {
      resetPaint(255);
      evaluatorAlpha.resetEvaluator(frame, 169, 255, 0);
    } else if (frame == 188) {
      resetPaint(255);
      evaluatorAlpha.resetEvaluator(188, 200, 255, 0);
    }

    if (frame > 116) {
      double lampXD = carSprites[0].transX - carStartX;
      double lampYD = carSprites[0].transY - carStartY;
      carStartX = carSprites[0].transX;
      carStartY = carSprites[0].transY;

      sprites[0]
          .setTransX(sprites[0].transX + lampXD - evaluatorX.evaluate(frame));
      sprites[0].setTransY(sprites[0].transY + lampYD);
      sprites[1]
          .setTransX(sprites[1].transX + lampXD - evaluatorX.evaluate(frame));
      sprites[1].setTransY(sprites[1].transY + lampYD);
    }
    sprites[0].setTransY(sprites[0].transY - evaluatorY.evaluate(frame));
    sprites[1].setTransY(sprites[1].transY - evaluatorY.evaluate(frame));
    resetPaint(evaluatorAlpha.evaluate(frame).toInt());
  }

  resetPaint(int colorNum) {
    _paint.color = Colors.transparent.withAlpha(colorNum);
  }
}
