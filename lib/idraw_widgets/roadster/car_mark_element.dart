import 'package:flutter/material.dart';
import 'package:flutter_idraw/assets.dart';
import 'dart:ui' as ui;

import 'package:flutter_idraw/idraw_widgets/index.dart';
import 'package:flutter_idraw/utils/utils.dart';

class CarMarkElement extends SceneElement {
  CarMarkElement(super.scene);
  static String get id => "CarMarkElement";

  var evaluatorX = Evaluator();
  final Paint _paint = Paint();
  List<Sprite> carSprites = [];
  late Rect rectL;
  late Rect rectR;
  late Rect rectB;
  late Rect layerRect;
  ///////////////////////////////////////////////////////////////////////

  @override
  Future<List<Sprite>> initSprites() async {
    _paint.color = const Color.fromARGB(255, 255, 0, 255);

    ui.Image iCarMark =
        await ImageLoader.loadIamge(AssetsImage.roadsterCarMark);
    ui.Image iCarLight =
        await ImageLoader.loadIamge(AssetsImage.roadsterCarLight);

    return [
      Sprite(image: iCarMark, density: scene.density),
      Sprite(image: iCarLight, density: scene.density),
    ];
  }

  @override
  onDraw(Canvas canvas, Paint paint) {
    if (!visible) return;
    canvas.saveLayer(layerRect, paint);
    _paint.blendMode = BlendMode.clear;
    sprites[1].onDraw(canvas, paint);
    canvas.drawRect(rectL, _paint);
    canvas.drawRect(rectR, _paint);
    canvas.drawRect(rectB, _paint);
    _paint.blendMode = BlendMode.dstIn;

    sprites[0].onDraw(canvas, _paint);
    canvas.restore();
  }

  @override
  preFrame(int frame) {
    if (frame < 58 || frame >= 96) {
      visible = false;
      return;
    }

    if (frame == 58) {
      visible = true;

      evaluatorX.resetEvaluator(
        58,
        96,
        scene.centerX,
        -scene.centerX,
      );
      if (carSprites.isEmpty) {
        CarElement carElement = scene.getElement(CarElement.id) as CarElement;
        carSprites = carElement.sprites;
      }
      initDraw();
      layerRect = Rect.fromLTRB(-scene.centerX, -carSprites[0].height,
          scene.centerX, carSprites[0].height);
    }

    sprites[1].setTransX(evaluatorX.evaluate(frame));
  }

  initDraw() {
    sprites[0].setTransX(carSprites[0].transX);
    sprites[0].setTransY(carSprites[0].transY);
    sprites[1].setTransX(carSprites[0].transX);
    sprites[1].setTransY(carSprites[0].transY);
    rectL = Rect.fromLTRB(
        -scene.centerX,
        carSprites[0].transY,
        carSprites[0].transX + toDp(3),
        carSprites[0].transY + sprites[0].height);
    rectR = Rect.fromLTRB(sprites[0].width / 2 - toDp(10), sprites[0].transY,
        scene.centerX, sprites[0].transY + sprites[0].height);
    double t = rectL.bottom - toDp(3);
    double b = t + sprites[0].height;
    rectB = Rect.fromLTRB(-scene.centerX, t, scene.centerX, b);
  }
}
