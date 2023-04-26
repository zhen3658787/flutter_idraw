import 'dart:ui' as ui;

import 'package:flutter_idraw/assets.dart';
import 'package:flutter_idraw/idraw_widgets/index.dart';
import 'package:flutter_idraw/utils/utils.dart';

class BarSwingElement extends SceneElement {
  BarSwingElement(super.scene);
  static String get id => "BarSwingElement";

  final int startFrame = 66;
  final int endFrame = 117;

  late double childX, childY;
  late double mBodyX, mBodyY;
  late double mHeadX, mHeadY, mHeadRotate;
  late double mArmLX, mArmLY, mRrmRX, mRrmRY, mArmLRotate, mArmRRotate;
  late double mBraX, mBraY, mBraRotate, mBraAlpha = 0;
  late double mScale;

  late Evaluator mArmLRotateEvaluator,
      mArmRRotateEvaluator,
      mHeadTranslateEvaluator,
      mHeadRotateEvaluator,
      mBraYTranslateEvaluator,
      mBraXTranslateEvaluator,
      mBraRotateEvaluator,
      mBoyScaleEvaluator;

  late Sprite mBody, mBra, mArmLeft, mArmRight, mHeadBra, mHead;

////////////////////////////////////////////////
  @override
  Future<List<Sprite>> initSprites() async {
    ui.Image barChild = await ImageLoader.loadIamge(AssetsImage.barChild);
    ui.Image barHead = await ImageLoader.loadIamge(AssetsImage.barHead);
    ui.Image barHeadBar = await ImageLoader.loadIamge(AssetsImage.barHeadBar);
    ui.Image bar = await ImageLoader.loadIamge(AssetsImage.bar);
    ui.Image barBody = await ImageLoader.loadIamge(AssetsImage.barBody);
    ui.Image barArm = await ImageLoader.loadIamge(AssetsImage.barArm);

    Sprite child = Sprite(image: barChild, density: scene.density);
    mBra = Sprite(image: bar, density: scene.density);
    mArmRight = Sprite(image: barArm, density: scene.density);
    mBody = Sprite(image: barBody, density: scene.density);
    mHeadBra = Sprite(image: barHeadBar, density: scene.density);
    mHead = Sprite(image: barHead, density: scene.density);
    mArmLeft = Sprite(image: barArm, density: scene.density);
    //小孩坐标
    childX = scene.centerX - child.width - toDp(50);
    childY = scene.centerY - child.height - toDp(50);

    initValues();
    return [mBra, mArmRight, mBody, mHeadBra, mArmLeft];
  }

  ///初始化位置大小参数
  initValues() {
    mHeadX = childX;
    mHeadY = childY + toDp(20);

    mBodyX = mHeadX + mHeadBra.width / 2 - toDp(50);
    mBodyY = mHeadY + mHeadBra.height - toDp(60);

    mArmLX = mBodyX - mArmLeft.width + toDp(80);
    mArmLY = mBodyY + toDp(50);

    mRrmRX = mArmLX + mBody.width - toDp(40);
    mRrmRY = mArmLY;

    mBraX = mArmLX - mBra.width / 4;
    mBraY = mArmLY - mBra.height * 3 / 4;
    mArmRRotate = -45;
    mScale = 1;
    mBraAlpha = 0;
    sprites.isNotEmpty ? sprites[3] = mHeadBra : null;
    mArmLRotateEvaluator = Evaluator.resetEvaluator(69, 70, 0, 140);
    mHeadTranslateEvaluator =
        Evaluator.resetEvaluator(70, 72, mHeadY, mHeadY + toDp(6));
    mHeadRotateEvaluator = Evaluator.resetEvaluator(77, 80, 0, -20);
    mBraYTranslateEvaluator = Evaluator.resetEvaluator(1, 1, mBraY, mBraY);
    mBraRotateEvaluator = Evaluator.resetEvaluator(1, 1, 1, 1);
    mArmRRotateEvaluator = Evaluator.resetEvaluator(66, 66, 0, mArmRRotate);
    mBraXTranslateEvaluator = Evaluator.resetEvaluator(1, 1, mBraX, mBraX);
    mBoyScaleEvaluator = Evaluator.resetEvaluator(97, 117, mScale, 0.75);
  }

  @override
  onDraw(ui.Canvas canvas, ui.Paint paint) {
    if (!visible) return;
    for (var element in sprites) {
      element.onDraw(canvas, paint);
    }
    // sprites[0].onDraw(canvas, paint);
    // sprites[1].onDraw(canvas, paint);
    // sprites[2].onDraw(canvas, paint);
    // sprites[3].onDraw(canvas, paint);
    // sprites[4].onDraw(canvas, paint);
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
    }
    mArmLRotate = mArmLRotateEvaluator.evaluate(frame);
    mHeadY = mHeadTranslateEvaluator.evaluate(frame);
    mHeadRotate = mHeadRotateEvaluator.evaluate(frame);
    mArmRRotate = mArmRRotateEvaluator.evaluate(frame);
    mBraRotate = mBraRotateEvaluator.evaluate(frame);
    mBraY = mBraYTranslateEvaluator.evaluate(frame);
    mScale = mBoyScaleEvaluator.evaluate(frame);

    if (frame > 86) {
      mBraX = mBraXTranslateEvaluator.evaluate(frame);
    }

    if (frame == 70) {
      mArmLX += toDp(8);
      mArmLY += toDp(4);
      mArmLRotateEvaluator.resetEvaluator(
          frame, 72, mArmLRotate, mArmLRotate + 20);
    } else if (frame == 72) {
      mHeadTranslateEvaluator.resetEvaluator(
          frame, 74, mHeadY, mHeadY - toDp(6));
      mArmLRotateEvaluator.resetEvaluator(
          frame, 74, mArmLRotate, mArmLRotate - 20);
    } else if (frame == 74) {
      mHeadTranslateEvaluator.resetEvaluator(
          frame, 76, mHeadY, mHeadY + toDp(6));
      mArmLRotateEvaluator.resetEvaluator(
          frame, 76, mArmLRotate, mArmLRotate + 20);
    } else if (frame == 76) {
      mArmLY -= 4;
      mHeadTranslateEvaluator.resetEvaluator(
          frame, 77, mHeadY, mHeadY - toDp(6));
      mArmLRotateEvaluator.resetEvaluator(
          frame, 77, mArmLRotate, mArmLRotate - 45);
    } else if (frame == 77) {
      mArmLX -= 4;
      mArmRRotateEvaluator.resetEvaluator(
          frame, 78, mArmRRotate, mArmRRotate + 90);
      mHeadTranslateEvaluator.resetEvaluator(
          frame, 80, mHeadY, mHeadY + toDp(6));
      mArmLRotateEvaluator.resetEvaluator(
          frame, 80, mArmLRotate, mArmLRotate - 50);
    } else if (frame == 82) {
      mBraAlpha = 255;
      mHeadRotateEvaluator.resetEvaluator(frame, 86, mHeadRotate, 0);
      mHeadTranslateEvaluator.resetEvaluator(
          frame, 86, mHeadY, mHeadY - toDp(6));
    } else if (frame == 84) {
      mBraX -= mBra.width / 4;
    } else if (frame == 85) {
      mBraX = mBraX - mBra.width / 4 - mBra.height / 4;
      mBraY += 20;
      mBraRotateEvaluator.resetEvaluator(
          frame, 86, mBraRotate - 80, mBraRotate);
    } else if (frame == 86) {
      mBraRotateEvaluator.resetEvaluator(
          frame, 89, mBraRotate, mBraRotate + 80);
      mBraYTranslateEvaluator.resetEvaluator(
          frame, 89, mBraY, mBraY - mBody.height);
      mBraXTranslateEvaluator.resetEvaluator(
          frame, 89, mBraX, mBraX + toDp(30));
    } else if (frame == 87) {
      mRrmRY += 10;
      mArmRRotateEvaluator.resetEvaluator(frame, 89, 120, 200);
    } else if (frame == 89) {
      mArmRRotateEvaluator.resetEvaluator(frame, 92, mArmRRotate, 120);
      mBraRotateEvaluator.resetEvaluator(
          frame, 92, mBraRotate, mBraRotate - 80);
      mBraYTranslateEvaluator.resetEvaluator(
          frame, 92, mBraY, mBraY + mBody.height);
      mBraXTranslateEvaluator.resetEvaluator(frame, 92, mBraX, mBraX - 30);
    } else if (frame == 92) {
      mArmRRotateEvaluator.resetEvaluator(frame, 95, mArmRRotate, 200);
      mBraRotateEvaluator.resetEvaluator(
          frame, 95, mBraRotate, mBraRotate + 80);
      mBraYTranslateEvaluator.resetEvaluator(
          frame, 95, mBraY, mBraY - mBody.height);
      mBraXTranslateEvaluator.resetEvaluator(
          frame, 95, mBraX, mBraX + toDp(30));
    } else if (frame == 95) {
      mArmRRotateEvaluator.resetEvaluator(frame, 97, mArmRRotate, 120);
      mBraRotateEvaluator.resetEvaluator(
          frame, 97, mBraRotate, mBraRotate - 80);
      mBraYTranslateEvaluator.resetEvaluator(
          frame, 97, mBraY, mBraY + mBody.height);
      mBraXTranslateEvaluator.resetEvaluator(
          frame, 97, mBraX, mBraX - toDp(30));
    }
    updateSprites(frame);
  }

  updateSprites(int frame) {
    mBra.setAlpha(mBraAlpha);
    if (frame >= 82) {
      mBra.clearMatrix4().translate(mBraX, mBraY).setRotate(mBraRotate,
          centerX: mBra.width + mBraX, centerY: mBra.height + mBraY);
    }

    mBody.translate(mBodyX, mBodyY);
    if (frame == 80) {
      sprites[3] = mHead;
    }
    sprites[3].clearMatrix4().translate(mHeadX, mHeadY).setRotate(mHeadRotate,
        centerX: mHead.width / 2 + mHeadX,
        centerY: mHead.height + mHeadY - toDp(20));
    mArmLeft.clearMatrix4().translate(mArmLX, mArmLY).setRotate(
          mArmLRotate,
          centerX: mArmLX + mArmLeft.width / 2,
          centerY: mArmLY,
        );

    mArmRight.clearMatrix4();
    if (frame < 78) {
      mArmRight.translate(mRrmRX, mRrmRY).setRotate(
            mArmRRotate,
            centerX: mRrmRX + mArmLeft.width / 2,
            centerY: mRrmRY + mArmLeft.height / 2,
          );
    } else if (frame >= 78 && frame < 88) {
      mArmRight.translate(mRrmRX, mRrmRY).setRotate(
            mArmRRotate,
            centerX: mRrmRX,
            centerY: mRrmRY,
          );
    } else if (frame > 87) {
      mArmRight.translate(mRrmRX, mRrmRY).setRotate(
            mArmRRotate,
            centerX: mRrmRX + mArmRight.width / 2,
            centerY: mRrmRY,
          );
    }
  }
}
