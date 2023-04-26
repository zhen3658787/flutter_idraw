import 'package:flutter/material.dart';
import 'package:flutter_idraw/assets.dart';
import 'dart:ui' as ui;

import 'package:flutter_idraw/idraw_widgets/index.dart';
import 'package:flutter_idraw/utils/utils.dart';

class CarCloudElement extends SceneElement {
  CarCloudElement(super.scene);
  static String get id => "CarCloudElement";

  var evaluatorX2 = Evaluator();
  var evaluatorX4 = Evaluator();
  var evaluatorX5 = Evaluator();
  var evaluatorY0 = Evaluator();
  var evaluatorY3 = Evaluator();
  var evaluatorY4 = Evaluator();
  var evaluatorY5 = Evaluator();
  var evaluatorAlpha0 = Evaluator();
  var evaluatorAlpha1 = Evaluator();
  var evaluatorAlpha2 = Evaluator();
  var evaluatorAlpha3 = Evaluator();
  var evaluatorAlpha4 = Evaluator();
  var evaluatorAlpha5 = Evaluator();
  var evaluatorScale0 = Evaluator();
  var evaluatorScale1 = Evaluator();
  var evaluatorScale2 = Evaluator();
  var evaluatorScale3 = Evaluator();
  var evaluatorScale4 = Evaluator();
  var evaluatorScale5 = Evaluator();
  List<Sprite> carSprites = [];
  ///////////////////////////////////////////////////////////////////////

  @override
  Future<List<Sprite>> initSprites() async {
    ui.Image icloud1 =
        await ImageLoader.loadIamge(AssetsImage.roadsterCarCloud1);
    ui.Image icloud2 =
        await ImageLoader.loadIamge(AssetsImage.roadsterCarCloud2);
    ui.Image icloud3 =
        await ImageLoader.loadIamge(AssetsImage.roadsterCarCloud3);
    var iCloud0 = Sprite(image: icloud2, density: scene.density);
    var iCloud1 = Sprite(image: icloud3, density: scene.density);
    var iCloud2 = Sprite(image: icloud2.clone(), density: scene.density);
    var iCloud3 = Sprite(image: icloud3.clone(), density: scene.density);
    var iCloud4 = Sprite(image: icloud3.clone(), density: scene.density);
    var iCloud5 = Sprite(image: icloud1, density: scene.density);
    initEvaluator();
    return [
      iCloud0,
      iCloud1,
      iCloud2,
      iCloud3,
      iCloud4,
      iCloud5,
    ];
  }

  @override
  onDraw(Canvas canvas, Paint paint) {
    if (!visible) return;
    for (var element in sprites) {
      element.onDraw(canvas, paint);
    }
  }

  @override
  preFrame(int frame) {
    if (frame < 11 || frame > 43) {
      visible = false;
      return;
    } else if (frame == 11) {
      visible = true;
      if (carSprites.isEmpty) {
        CarElement carElement = scene.getElement(CarElement.id) as CarElement;
        carSprites = carElement.sprites;
      }
      initEvaluator();
    }
    processFrame(frame - 10);
  }

  //resetEvaluator
  void initEvaluator() {
    evaluatorAlpha0.resetEvaluator(7, 20, 0, 255);
    evaluatorScale0.resetEvaluator(7, 33, 0.78, 1.22);
    evaluatorY0.resetEvaluator(1, 1, 1, 1);

    evaluatorScale1.resetEvaluator(3, 25, 0.7, 1);
    evaluatorAlpha1.resetEvaluator(3, 14, 0, 255);

    evaluatorAlpha2.resetEvaluator(8, 18, 0, 255);
    evaluatorScale2.resetEvaluator(8, 29, 0.8, 1.3);
    evaluatorX2.resetEvaluator(1, 1, 1, 1);

    evaluatorAlpha3.resetEvaluator(1, 12, 0, 255);
    evaluatorScale3.resetEvaluator(1, 12, 0.65, 0.8);
    evaluatorY3.resetEvaluator(1, 1, 1, 1);

    evaluatorAlpha4.resetEvaluator(2, 14, 0, 255);
    evaluatorScale4.resetEvaluator(2, 14, 0.85, 1);
    evaluatorY4.resetEvaluator(1, 1, 1, 1);
    evaluatorX4.resetEvaluator(1, 1, 1, 1);

    evaluatorAlpha5.resetEvaluator(5, 18, 0, 255);
    evaluatorScale5.resetEvaluator(5, 18, 0.69, 0.86);
    evaluatorY5.resetEvaluator(1, 1, 1, 1);
    evaluatorX5.resetEvaluator(1, 1, 1, 1);
  }

  void processFrame(int frame) {
    double scale = evaluatorScale0.evaluate(frame);
    sprites[0]
        .clearMatrix4()
        .setAlpha(evaluatorAlpha0.evaluate(frame))
        .setTransY(evaluatorY0.evaluate(frame))
        .setScale(scale);
    if (frame == 7) {
      sprites[0]
          .setTransX(carSprites[0].transX - toDp(55))
          .setTransY(carSprites[0].transY + carSprites[0].height - toDp(140));
      evaluatorY0.resetEvaluator(
          7, 33, sprites[0].transY, sprites[0].transY - toDp(64));
    } else if (frame == 20) {
      evaluatorAlpha0.resetEvaluator(frame, 33, 255, 0);
    }

    var scale1 = evaluatorScale1.evaluate(frame);
    sprites[1]
        .clearMatrix4()
        .setScale(scale1)
        .setAlpha(evaluatorAlpha1.evaluate(frame));
    if (frame == 3) {
      sprites[1]
          .setTransX(carSprites[0].transX + toDp(60))
          .setTransY(carSprites[0].transY + carSprites[0].height - toDp(140));
    } else if (frame == 14) {
      evaluatorAlpha1.resetEvaluator(frame, 25, 255, 0);
    }

    var scale2 = evaluatorScale2.evaluate(frame);
    sprites[2]
        .clearMatrix4()
        .setAlpha(evaluatorAlpha2.evaluate(frame))
        .setTransX(evaluatorX2.evaluate(frame))
        .setScale(scale2);
    if (frame == 8) {
      sprites[2]
          .setTransX(carSprites[0].transX + toDp(250))
          .setTransY(carSprites[0].transY + carSprites[0].height - toDp(145));
      evaluatorX2.resetEvaluator(
          8, 33, sprites[2].transX, sprites[2].transX + toDp(50));
    } else if (frame == 18) {
      evaluatorAlpha2.resetEvaluator(frame, 29, 255, 0);
    }

    var scale3 = evaluatorScale3.evaluate(frame);
    sprites[3]
        .clearMatrix4()
        .setAlpha(evaluatorAlpha3.evaluate(frame))
        .setTransY(evaluatorY3.evaluate(frame))
        .setScale(scale3);
    if (frame == 1) {
      sprites[3]
          .setTransX(carSprites[0].transX + toDp(445))
          .setTransY(carSprites[0].transY + carSprites[0].height - toDp(155));
      evaluatorY3.resetEvaluator(
          1, 24, sprites[3].transY, sprites[3].transY - toDp(95));
    } else if (frame == 12) {
      evaluatorAlpha3.resetEvaluator(frame, 24, 255, 0);
      evaluatorScale3.resetEvaluator(frame, 24, 0.8, 1.35);
    }

    var scale4 = evaluatorScale4.evaluate(frame);
    sprites[4]
        .clearMatrix4()
        .setAlpha(evaluatorAlpha4.evaluate(frame))
        .setTransY(evaluatorY4.evaluate(frame))
        .setTransX(evaluatorX4.evaluate(frame))
        .setScale(scale4);
    if (frame == 2) {
      sprites[4]
          .setTransX(carSprites[0].transX + toDp(600))
          .setTransY(carSprites[0].transY + carSprites[0].height - toDp(200));
      evaluatorY4.resetEvaluator(
          2, 14, sprites[4].transY, sprites[4].transY - toDp(26));
      evaluatorX4.resetEvaluator(
          14, 26, sprites[4].transX, sprites[4].transX + toDp(16));
    } else if (frame == 14) {
      evaluatorAlpha4.resetEvaluator(frame, 26, 255, 0);
      evaluatorScale4.resetEvaluator(frame, 26, 1, 1.3);
      evaluatorY4.resetEvaluator(
          frame, 26, sprites[4].transY, sprites[4].transY - toDp(10));
    }

    var scale5 = evaluatorScale5.evaluate(frame);
    sprites[5]
        .clearMatrix4()
        .setAlpha(evaluatorAlpha5.evaluate(frame))
        .setTransY(evaluatorY5.evaluate(frame))
        .setTransX(evaluatorX5.evaluate(frame))
        .setScale(scale5);
    if (frame == 5) {
      sprites[5]
          .setTransX(carSprites[0].transX + toDp(820))
          .setTransY(carSprites[0].transY + carSprites[0].height - toDp(140));
      evaluatorY5.resetEvaluator(
          5, 18, sprites[5].transY, sprites[5].transY - toDp(25));
      evaluatorX5.resetEvaluator(
          5, 18, sprites[5].transX, sprites[5].transX + toDp(18));
    } else if (frame == 18) {
      evaluatorAlpha5.resetEvaluator(frame, 31, 255, 0);
      evaluatorScale5.resetEvaluator(frame, 31, sprites[5].scale, 1);
      evaluatorY5.resetEvaluator(
          frame, 31, sprites[5].transY, sprites[5].transY - toDp(30));
      evaluatorX5.resetEvaluator(
          frame, 31, sprites[5].transX, sprites[5].transX + toDp(28));
    }
  }
}
