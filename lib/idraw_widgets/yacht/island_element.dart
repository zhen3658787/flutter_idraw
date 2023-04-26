import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_idraw/assets.dart';
import 'package:flutter_idraw/idraw_widgets/index.dart';
import 'package:flutter_idraw/utils/utils.dart';

class IslandElement extends SceneElement {
  IslandElement(super.scene);

  static String get id => "IslandElement";

  var evaluatorX = Evaluator();
  late Offset startOffset;
  late Sprite island;
  ////////////////////////////////////////////////////////////////
  @override
  Future<List<Sprite>> initSprites() async {
    ui.Image iisland = await ImageLoader.loadIamge(AssetsImage.yachtIsland);
    island = Sprite(image: iisland, density: scene.density);
    initEvaluator();
    return [island];
  }

  @override
  onDraw(ui.Canvas canvas, ui.Paint paint) {
    island.onDraw(canvas, paint);
  }

  @override
  preFrame(int frame) {
    if (frame > 214) {
      visible = false;
      return;
    }
    if (frame == 1) {
      visible = true;
      initEvaluator();
    }
    var transX = evaluatorX.evaluate(frame);
    island.setTransX(transX);
    if (frame == 104) {
      evaluatorX.resetEvaluator(frame, 185, transX, toDp(504));
    }
    if (frame == 185) {
      evaluatorX.resetEvaluator(frame, 214, transX, toDp(1080));
    }
  }

  void initEvaluator() {
    startOffset =
        Offset(-scene.centerX - island.width, -scene.centerX + toDp(853.0));
    evaluatorX.resetEvaluator(1, 114, startOffset.dx, toDp(330));
  }
}
