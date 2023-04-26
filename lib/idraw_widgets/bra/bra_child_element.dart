import 'dart:ui' as ui;

import 'package:flutter_idraw/assets.dart';
import 'package:flutter_idraw/idraw_widgets/index.dart';
import 'package:flutter_idraw/utils/utils.dart';

class BraChildElement extends SceneElement {
  BraChildElement(super.scene);
  static String get id => "BraChildElement";

  final int startFrame = 1;
  final int endFrame = 65;

  late Evaluator childScaleEvaluator;
  late Evaluator childRotateEvaluator;
  late Evaluator nippleRotateEvaluator;
  late Evaluator nippleTranslateXEvaluator, nippleTranslateYEvaluator;
  double childRotate = 23.7;
  //奶嘴下落时的旋转角度
  double nippleRotate = 90;
  //小孩x轴
  double childScaleX = 1;
  //小孩y轴
  double childScaleY = 0.8;

  double childX = 0;
  double childY = 0;
  double nippleX = 0;
  double nippleY = 0;
  double bulbX = 0;
  double bulbY = 0;
  double bulbAlpha = 255;

  Sprite? child;
  Sprite? eye;
  Sprite? nipple;
  Sprite? bulb;
  ////////////////////////////////////////////////
  @override
  Future<List<Sprite>> initSprites() async {
    ui.Image ibarChild = await ImageLoader.loadIamge(AssetsImage.barChild);
    ui.Image ibarEye1 = await ImageLoader.loadIamge(AssetsImage.barEye1);
    ui.Image ibarEye2 = await ImageLoader.loadIamge(AssetsImage.barEye2);
    ui.Image ibarEye3 = await ImageLoader.loadIamge(AssetsImage.barEye3);
    ui.Image ibarNipple1 = await ImageLoader.loadIamge(AssetsImage.barNipple1);
    ui.Image ibarNipple2 = await ImageLoader.loadIamge(AssetsImage.barNipple2);
    ui.Image ibarBulb = await ImageLoader.loadIamge(AssetsImage.barBulb);

    child = Sprite(image: ibarChild, density: scene.density);
    var barEye1 = Sprite(image: ibarEye1, density: scene.density);
    var barEye2 = Sprite(image: ibarEye2, density: scene.density);
    var barEye3 = Sprite(image: ibarEye3, density: scene.density);
    var barNipple1 = Sprite(image: ibarNipple1, density: scene.density);
    var barNipple2 = Sprite(image: ibarNipple2, density: scene.density);
    bulb = Sprite(image: ibarBulb, density: scene.density);
    eye = barEye1;
    nipple = barNipple1;

    //小孩坐标
    childX = scene.centerX - child!.width - toDp(50);
    childY = scene.centerY - child!.height - toDp(50);

    initValues();

    return [
      child!,
      barEye1,
      barEye2,
      barEye3,
      barNipple1,
      barNipple2,
      bulb!,
    ];
  }

  @override
  onDraw(ui.Canvas canvas, ui.Paint paint) {
    if (!visible) return;
    child?.onDraw(canvas, paint); //小孩
    bulb?.onDraw(canvas, paint); //灯泡
    eye?.onDraw(canvas, paint); //眼睛
    nipple?.onDraw(canvas, paint); //奶嘴
  }

  @override
  preFrame(int frame) {
    if (frame < startFrame || frame > endFrame) {
      visible = false;
      return;
    }

    if (frame == startFrame) {
      visible = true;
      initValues();
      child = sprites[0];
      eye = sprites[1];
      nipple = sprites[4];
      bulb = sprites[6];
    }
    childRotate = childRotateEvaluator.evaluate(frame);
    nippleRotate = nippleRotateEvaluator.evaluate(frame);
    childScaleY = childScaleEvaluator.evaluate(frame);
    nippleX = nippleTranslateXEvaluator.evaluate(frame);
    nippleY = nippleTranslateYEvaluator.evaluate(frame);

    if (frame == 5) {
      eye = sprites[2];
    } else if (frame == 8) {
      childScaleEvaluator.resetEvaluator(8, 10, childScaleY, 1.0);
    } else if (frame == 10) {
      childScaleEvaluator.resetEvaluator(10, 12, childScaleY, 1.2);
    } else if (frame == 12) {
      childScaleEvaluator.resetEvaluator(12, 16, childScaleY, 1.0);
      eye = sprites[2];
    } else if (frame == 15) {
      eye = sprites[3];
    } else if (frame == 27) {
      nipple = sprites[5];
      nippleTranslateYEvaluator.resetEvaluator(
          27, 31, nippleY, nippleY + toDp(260));
    } else if (frame == 32) {
      nippleTranslateXEvaluator.resetEvaluator(
          32, 41, nippleX, nippleX - toDp(100));
      nippleTranslateYEvaluator.resetEvaluator(
          32, 34, nippleY, nippleY - toDp(20));
    } else if (frame == 34) {
      nippleTranslateYEvaluator.resetEvaluator(
          34, 36, nippleY, nippleY + toDp(20));
    } else if (frame == 36) {
      nippleTranslateYEvaluator.resetEvaluator(
          36, 37, nippleY, nippleY - toDp(10));
    } else if (frame == 37) {
      nippleTranslateYEvaluator.resetEvaluator(
          37, 38, nippleY, nippleY + toDp(10));
    } else if (frame == 38) {
      nippleTranslateYEvaluator.resetEvaluator(
          38, 39, nippleY, nippleY - toDp(10));
    } else if (frame == 39) {
      nippleTranslateYEvaluator.resetEvaluator(
          39, 40, nippleY, nippleY + toDp(10));
    } else if (frame == 40) {
      nippleTranslateYEvaluator.resetEvaluator(
          40, 41, nippleY, nippleY + toDp(5));
    } else if (frame == 54) {
      childScaleEvaluator.resetEvaluator(frame, 57, childScaleY, 0.75);
    } else if (frame == 57) {
      childScaleEvaluator.resetEvaluator(frame, 61, childScaleY, 1.2);
    } else if (frame == 61) {
      childScaleEvaluator.resetEvaluator(frame, 65, childScaleY, 1.0);
    }

    if (frame < 43) {
      bulbAlpha = 0;
    } else if (frame < 47) {
      bulbAlpha = 255;
    } else if (frame < 50) {
      bulbAlpha = 0;
    } else if (frame < 54) {
      bulbAlpha = 255;
    } else {
      bulbAlpha = 0;
    }
    updateSprites(frame);
  }

  updateSprites(int frame) {
    sprites[0]
        .clearMatrix4()
        .translate(childX, childY)
        .setScale(childScaleX,
            scaleY: childScaleY,
            centerX: sprites[0].width / 2,
            centerY: sprites[0].height)
        .setRotate(childRotate,
            centerX: sprites[0].width * 3 + childX,
            centerY: sprites[0].height + childY);
    eye
        ?.clearMatrix4()
        .translate(childX + toDp(40), childY + toDp(260))
        .setScale(childScaleX,
            scaleY: childScaleY,
            centerX: sprites[0].width / 2,
            centerY: sprites[0].height)
        .setRotate(childRotate,
            centerX: sprites[0].width * 3 + childX,
            centerY: sprites[0].height + childY);
    nipple?.clearMatrix4().translate(nippleX, nippleY);
    if (frame <= 27) {
      nipple
          ?.setScale(childScaleX,
              scaleY: childScaleY,
              centerX: sprites[0].width / 2,
              centerY: sprites[0].height)
          .setRotate(childRotate,
              centerX: sprites[0].width * 3 + childX,
              centerY: sprites[0].height + childY);
    } else if (frame <= 31) {
      nipple?.setRotate(nippleRotate,
          centerX: nipple!.transX + sprites[4].width / 2,
          centerY: nipple!.transY + sprites[4].height / 2);
    }
    sprites[6].translate(bulbX, bulbY);
    sprites[6].setAlpha(bulbAlpha);
  }

  ///初始化位置大小参数
  initValues() {
    //奶嘴相对身体偏移(100,400)
    nippleX = childX + toDp(100);
    nippleY = childY + toDp(400);

    //灯泡相对身体的偏移
    bulbX = childX - bulb!.width;
    bulbY = childY - bulb!.height / 2;

    childRotateEvaluator = Evaluator.resetEvaluator(1, 8, 23.7, 0);
    nippleRotateEvaluator = Evaluator.resetEvaluator(27, 32, 90, 0);
    childScaleEvaluator = Evaluator.resetEvaluator(1, 8, 1, childScaleY);
    nippleTranslateXEvaluator =
        Evaluator.resetEvaluator(27, 32, nippleX, nippleX - toDp(172));
    nippleTranslateYEvaluator =
        Evaluator.resetEvaluator(27, 32, nippleY, nippleY + toDp(300));
  }
}
