import 'package:flutter/material.dart';
import 'package:flutter_idraw/idraw_widgets/index.dart';

enum SceneState { prepared, start, stop, complete }

typedef Callback = void Function(SceneState state, Scene scene);

abstract class Scene implements IScene {
  Scene({required this.config}) {
    sceneId = runtimeType.toString();
  }

  static const double modelWidth = 1080;
  static const double modelHeight = 1920;

  String sceneId = '';

  List<SceneElement> elements = [];
  SceneConfig config;
  SceneState state = SceneState.complete;
  Paint scenePaint = Paint();
  int count = 0;
  int oldFrame = 0;
  Callback? callback;

  int currentFrame = 0;
  int totalFrames = 0;

  ///屏幕size
  Size size = Size.zero;

  ///屏幕与模板密度
  late double density;
  double centerX = 0;
  double centerY = 0;

  ///顶部状态栏高度
  late double padingTop;
  //是否横屏
  late bool isLandscape;

  ////////////////////////////////////////////////////////

  addListener(Callback listener) {
    callback = listener;
  }

  removeListener() {
    callback = null;
  }

  initScene(MediaQueryData queryData) async {
    size = queryData.size;
    centerX = size.width / 2;
    centerY = size.height / 2;
    isLandscape = size.width > size.height;
    padingTop = queryData.padding.top;
    density = modelWidth / (isLandscape ? size.height : size.width);
    totalFrames = initTotalFrames();
    if (elements.isEmpty) {
      elements.addAll(await initElements());
    }
  }

  tryInit(MediaQueryData queryData) async {
    if (size != queryData.size) {
      await initScene(queryData);
    }
    state = SceneState.prepared;
    if (callback != null) {
      callback!(state, this);
    }
  }

  Future<List<SceneElement>> initElements();
  int initTotalFrames();

  @override
  render(Canvas canvas) {
    if (state == SceneState.start || state == SceneState.prepared) {
      state = SceneState.start;
      canvas.save();
      canvas.translate(centerX, centerY);
      for (var element in elements) {
        if (element.visible) element.onDraw(canvas, scenePaint);
      }
      canvas.restore();
      oldFrame = currentFrame;
    }
  }

  @override
  preFrame() {
    if (count++ % 3 == 0) currentFrame++;
    if (oldFrame == currentFrame) return;
    if (currentFrame <= totalFrames) {
      for (int index = 0; index < elements.length; index++) {
        elements[index].preFrame(currentFrame);
      }
      // oldFrame = currentFrame;
      return;
    }
    checkState();
  }

  checkState() {
    currentFrame = 0;
    config.resetCount -= 1;
    if (config.resetCount < 1) {
      state = SceneState.complete;
      if (callback != null) {
        callback!(state, this);
      }
      return;
    }
  }

  SceneElement? getElement(String id) {
    SceneElement? e;
    for (var element in elements) {
      if (element.runtimeType.toString() == id) {
        e = element;
      }
    }
    return e;
  }
}
