class SceneConfig {
  SceneConfig({this.fps = 24, required this.sceneId, this.resetCount = 1});
  int fps;
  String sceneId = '';
  int resetCount; //重播次数

  reset() {
    resetCount = 1;
  }
}
