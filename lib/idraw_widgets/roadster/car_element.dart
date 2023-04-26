import 'package:flutter/material.dart';
import 'package:flutter_idraw/assets.dart';
import 'dart:ui' as ui;

import 'package:flutter_idraw/idraw_widgets/index.dart';
import 'package:flutter_idraw/utils/utils.dart';

class CarElement extends SceneElement {
  CarElement(super.scene);
  static String get id => "CarElement";

  var evaluatorX = Evaluator();
  var evaluatorY = Evaluator();
  var evaluatorAlpha = Evaluator();
  double keyframesY = 0; //784,459
  double keyframesX = 0;
  ///////////////////////////////////////////////////////////////////////

  @override
  Future<List<Sprite>> initSprites() async {
    ui.Image ifall = await ImageLoader.loadIamge(AssetsImage.roadsterCarFall);
    var iFall = Sprite(image: ifall, density: scene.density);
    keyframesX = -iFall.width / 2;
    keyframesY = -iFall.height / 2;
    ui.Image irun1 = await ImageLoader.loadIamge(AssetsImage.roadsterCarRun1);
    ui.Image irun2 = await ImageLoader.loadIamge(AssetsImage.roadsterCarRun2);
    ui.Image icar = await ImageLoader.loadIamge(AssetsImage.roadsterCar);
    return [
      iFall,
      Sprite(image: irun1, density: scene.density),
      Sprite(image: irun2, density: scene.density),
      Sprite(image: icar, density: scene.density)
    ];
  }

  @override
  onDraw(Canvas canvas, Paint paint) {
    if (!visible) return;
    sprites[0].onDraw(canvas, paint);
  }

  @override
  preFrame(int frame) {
    if (frame >= scene.totalFrames) {
      visible = false;
      return;
    }

    if (frame == 1) {
      visible = true;
      sprites[0].setAlpha(255);
      sprites[1].setAlpha(255);
      sprites[2].setAlpha(255);
      evaluatorX.resetEvaluator(1, 1, keyframesX, keyframesX);
      evaluatorY.resetEvaluator(
          6, 11, -scene.centerY - sprites[0].height, keyframesY);
      evaluatorAlpha.resetEvaluator(200, scene.totalFrames, 255, 0);
    }

    double transX = evaluatorX.evaluate(frame);
    double transY = evaluatorY.evaluate(frame);

    if (frame == 11) {
      evaluatorY.resetEvaluator(frame, 15, transY, transY - toDp(60));
    } else if (frame == 15) {
      evaluatorY.resetEvaluator(frame, 18, transY, keyframesY);
    } else if (frame > 18 && frame < 108) {
      sprites[0] = sprites[3];
    } else if (frame > 107 && frame < 210) {
      if (frame % 2 == 0) {
        sprites[0] = sprites[1];
      } else {
        sprites[0] = sprites[2];
      }
      if (frame < 158) {
        int f = (frame - 108) % 10;
        if (f == 0) {
          evaluatorX.resetEvaluator(
              frame, frame + 5, transX, transX - toDp(20));
        } else if (f == 5) {
          evaluatorX.resetEvaluator(frame, frame + 4, transX, keyframesX);
        }
      } else if (frame == 158) {
        evaluatorX.resetEvaluator(frame, 172, transX, transX + toDp(40));
      } else if (frame == 172) {
        evaluatorX.resetEvaluator(frame, 188, transX, keyframesX);
      } else if (frame == 188) {
        evaluatorX.resetEvaluator(
            frame, 210, transX, -sprites[0].width - scene.centerX);
        evaluatorY.resetEvaluator(frame, 210, transY, transY + toDp(139));
      }
    }

    if (frame >= 200) {
      sprites[0].setAlpha(evaluatorAlpha.evaluate(frame));
    }

    sprites[0].translate(transX, transY);
  }
}
