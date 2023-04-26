import 'dart:ui';
import 'package:flutter_idraw/idraw_widgets/index.dart';

abstract class SceneElement implements ILayer {
  SceneElement(this.scene);
  Scene scene;
  List<Sprite> sprites = [];
  bool visible = false;

  double toDp(double px) {
    return px / scene.density;
  }

  init() async {
    sprites.addAll(await initSprites());
  }

  Future<List<Sprite>> initSprites();

  @override
  onDraw(Canvas canvas, Paint paint);

  @override
  preFrame(int frame);
}
