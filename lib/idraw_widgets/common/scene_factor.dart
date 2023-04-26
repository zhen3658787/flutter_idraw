
import 'package:flutter_idraw/idraw_widgets/index.dart';

class SceneFactor {
  SceneFactor._();
  static Scene createScene(SceneType type) {
    Scene scene;
    switch (type) {
      case SceneType.roadster:
        scene = RoadsterScene(config: SceneConfig(sceneId: RoadsterScene.id));
        break;
      case SceneType.bra:
        scene = BraScene(config: SceneConfig(sceneId: BraScene.id));
        break;
      case SceneType.yacht:
        scene = YachtScene(config: SceneConfig(sceneId: YachtScene.id));
        break;
    }
    return scene;
  }
}

enum SceneType { roadster, bra, yacht }
