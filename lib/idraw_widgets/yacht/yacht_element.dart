import 'dart:ui' as ui;
import 'package:flutter_idraw/assets.dart';
import 'package:flutter_idraw/idraw_widgets/index.dart';
import 'package:flutter_idraw/utils/utils.dart';

class YachtElement extends SceneElement {
  YachtElement(super.scene);

  static String get id => "YachtElement";

  var evaluatorX = Evaluator();
  late Sprite ship;
  ///////////////////////////////////////////////////////////////////
  ///
  @override
  Future<List<Sprite>> initSprites() async {
    ui.Image iship1 = await ImageLoader.loadIamge(AssetsImage.yachtShip1);
    ui.Image iship2 = await ImageLoader.loadIamge(AssetsImage.yachtShip2);
    ui.Image iship3 = await ImageLoader.loadIamge(AssetsImage.yachtShip3);
    ui.Image iship4 = await ImageLoader.loadIamge(AssetsImage.yachtShip4);
    ship = Sprite(image: iship1, density: scene.density);
    return [
      ship,
      Sprite(image: iship2, density: scene.density),
      Sprite(image: iship3, density: scene.density),
      Sprite(image: iship4, density: scene.density),
    ];
  }

  @override
  onDraw(ui.Canvas canvas, ui.Paint paint) {
    ship.onDraw(canvas, paint);
  }

  @override
  preFrame(int frame) {
    if (frame < 45 || frame > 214) {
      visible = false;
      return;
    }
    if (frame == 45) {
      visible = true;
    }
    int index = (frame - 45) % 4;
    if (index == 0) {
      ship = sprites[0];
    } else if (index == 1) {
      ship = sprites[1];
    } else if (index == 2) {
      ship = sprites[2];
    } else if (index == 3) {
      ship = sprites[3];
    }

    switch (frame) {
      case 45:
        evaluatorX.resetEvaluator(
            45, 76, scene.centerX + ship.width, toDp(550.0));
        break;
      case 77:
        evaluatorX.resetEvaluator(77, 103, toDp(550.0), toDp(102.0));
        break;
      case 104:
        evaluatorX.resetEvaluator(104, 184, toDp(102.0), toDp(22.0));
        break;
      case 185:
        evaluatorX.resetEvaluator(
            185, 214, toDp(22.0), -scene.centerX - ship.width);
        break;
    }
    ship.translate(-scene.centerX + evaluatorX.evaluate(frame), 0);
  }
}
