import 'package:flutter/material.dart';
import 'package:flutter_idraw/assets.dart';
import 'dart:ui' as ui;

import 'package:flutter_idraw/idraw_widgets/index.dart';
import 'package:flutter_idraw/utils/utils.dart';

class CarFrontLampElement extends SceneElement {
  CarFrontLampElement(super.scene);
  static String get id => "CarFrontLampElement";

  var evaluatorAlpha1 = Evaluator();
  var evaluatorAlpha2 = Evaluator();
  var evaluatorRotate = Evaluator();
  List<Sprite> carSprites = [];
  double carStartX = 0;
  double carStartY = 0;
  final Paint _paint = Paint();
  ///////////////////////////////////////////////////////////////////////

  @override
  Future<List<Sprite>> initSprites() async {
    ui.Image ilamp1 =
        await ImageLoader.loadIamge(AssetsImage.roadsterCarFrontLamp1);
    ui.Image ilamp2 =
        await ImageLoader.loadIamge(AssetsImage.roadsterCarFrontLamp2);
    var iLamp1 = Sprite(image: ilamp1, density: scene.density);
    var iLamp1_2 = Sprite(image: ilamp1.clone(), density: scene.density);
    var iLamp2 = Sprite(image: ilamp2, density: scene.density);
    var iLamp2_2 = Sprite(image: ilamp2.clone(), density: scene.density);
    evaluatorAlpha1.resetEvaluator(25, 32, 0, 255);
    evaluatorAlpha2.resetEvaluator(1, 1, 255, 255);
    evaluatorRotate.resetEvaluator(44, 87, 0, 360);
    return [iLamp1, iLamp1_2, iLamp2, iLamp2_2];
  }

  @override
  onDraw(Canvas canvas, Paint paint) {
    if (!visible) return;
    sprites[0].onDraw(canvas, _paint);
    sprites[1].onDraw(canvas, _paint);

    sprites[2].onDraw(canvas, _paint);
    sprites[3].onDraw(canvas, _paint);
  }

  @override
  preFrame(int frame) {
    if (frame < 29) {
      visible = false;
      return;
    }
    if (frame == 29) {
      visible = true;
      if (carSprites.isEmpty) {
        CarElement carElement = scene.getElement(CarElement.id) as CarElement;
        carSprites = carElement.sprites;
      }
      carStartX = carSprites[0].transX;
      carStartY = carSprites[0].transY;

      sprites[0].setTransX(carStartX - toDp(179));
      sprites[0].setTransY(carStartY + toDp(106));

      sprites[1].setTransX(sprites[0].transX + toDp(182));
      sprites[1].setTransY(sprites[0].transY + toDp(7));

      sprites[2].setTransX(sprites[0].transX + toDp(98));
      sprites[2].setTransY(sprites[0].transY +
          sprites[0].height / 2 +
          toDp(9) -
          sprites[2].height / 2);
      sprites[3].setTransX(sprites[2].transX + toDp(192));
      sprites[3].setTransY(sprites[2].transY + toDp(7));
    }

    if (frame > 106) {
      processLamp();
    }

    sprites[0].setAlpha(255);
    sprites[2].setAlpha(255);
    sprites[2].setRotate(evaluatorRotate.evaluate(frame),
        centerX: sprites[2].transX + sprites[2].width / 2,
        centerY: sprites[2].transY + sprites[2].height / 2);
    sprites[3].setRotate(evaluatorRotate.evaluate(frame),
        centerX: sprites[3].transX + sprites[3].width / 2,
        centerY: sprites[3].transY + sprites[3].height / 2);
    if (frame == 38) {
      sprites[0].setAlpha(0);
      sprites[2].setAlpha(0);
    } else if (frame == 42) {
      sprites[0].setAlpha(0);
      sprites[2].setAlpha(0);
    } else if (frame == 44) {
      sprites[0].setAlpha(0);
      evaluatorAlpha1.resetEvaluator(frame, 47, 0, 255);
    } else if (frame == 91) {
      evaluatorAlpha1.resetEvaluator(frame, 94, 255, 0);
    } else if (frame == 95 || frame == 96) {
      sprites[2].setAlpha(0);
    } else if (frame == 97) {
      sprites[0].setAlpha(255);
    } else if (frame == 106) {
      evaluatorAlpha1.resetEvaluator(frame, 110, 255, 0);
      evaluatorAlpha2.resetEvaluator(frame, 110, 255, 0);
    } else if (frame == 117) {
      evaluatorAlpha1.resetEvaluator(frame, 122, 0, 255);
      evaluatorAlpha2.resetEvaluator(frame, 122, 0, 255);
    } else if (frame == 138) {
      sprites[0].setAlpha(0);
      evaluatorAlpha1.resetEvaluator(frame, 143, 0, 255);
      sprites[2].setAlpha(0);
      evaluatorAlpha2.resetEvaluator(frame, 143, 0, 255);
    }
  }

  void processLamp() {
    double lampXD = carSprites[0].transX - carStartX;
    double lampYD = carSprites[0].transY - carStartY;
    carStartX = carSprites[0].transX;
    carStartY = carSprites[0].transY;

    for (var s in sprites) {
      s.setTransX(s.transX + lampXD);
      s.setTransY(s.transY + lampYD);
    }
  }
}
