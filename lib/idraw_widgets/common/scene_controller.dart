import 'package:flutter/material.dart';
import 'package:flutter_idraw/idraw_widgets/index.dart';
import 'package:flutter_idraw/utils/utils.dart';

typedef SceneControllerListener = void Function(SceneState state);

class SceneController {
  List<String> messageList = [];
  List<Scene> cacheScenes = []; //场景集合，进来一个消息，生成一个场景
  List<Scene> scenes = []; //正在播放的场景,如果不加约束可以多个场景同时播放
  List<Scene> oldScenes = []; //可以复用的场景，不用每次都生成新的加载图片

  int maxPlay = 1; //设置最大同时播放数量
  int maxCache = 3; //设置内存中可以缓存多少个场景
  int maxOldCache = 3; //设置内存保留多少个场景
  bool canCreateScene = true;
  SceneControllerListener? _listener;
  SceneState state = SceneState.complete;

  late MediaQueryData _queryData;

  String _id = '';
  String _oldId = '';
  //////////////////////////////////////////////////////////////////////////////////
  get id {
    String temp = '';
    for (var element in scenes) {
      temp += element.currentFrame.toString();
    }
    _id = temp;
    return _id;
  }

  get oldId {
    String temp = '';
    for (var element in scenes) {
      temp += element.oldFrame.toString();
    }
    _oldId = temp;
    return _oldId;
  }

  addListener(SceneControllerListener listener) {
    _listener = listener;
  }

  removeListener() {
    _listener = null;
  }

  void addMessage(String id) {
    messageList.add(id);
    checkCache(null);
  }

  void createScene(String id) {
    Scene? scene;
    Scene? cache;
    switch (id) {
      case RoadsterScene.id:
        cache = checkOldCache(RoadsterScene.id);
        scene = cache ?? SceneFactor.createScene(SceneType.roadster);
        break;
      case BraScene.id:
        cache = checkOldCache(BraScene.id);
        scene = cache ?? SceneFactor.createScene(SceneType.bra);
        break;
      case YachtScene.id:
        cache = checkOldCache(YachtScene.id);
        scene = cache ?? SceneFactor.createScene(SceneType.yacht);
        break;
    }
    scene?.addListener(sceneListener);
    scene?.tryInit(_queryData);
    scene ?? p('没有指定的场景！！！');
  }

  sceneListener(SceneState state, Scene scene) {
    switch (state) {
      case SceneState.prepared:
        checkCache(scene);
        checkRuntime();
        break;
      case SceneState.start:
        break;
      case SceneState.stop:
        break;
      case SceneState.complete:
        checkComplete(scene);
        break;
    }
  }

  ///检查缓存
  checkCache(Scene? temp) {
    if (temp == null) {
      if (messageList.isEmpty || !canCreateScene) return;
      //刚添加消息，准备把消息转换成场景
      if (cacheScenes.length < maxCache) {
        String firstMessage = messageList.removeAt(0);
        canCreateScene = false;
        createScene(firstMessage);
      }
      return;
    }
    cacheScenes.add(temp);
    canCreateScene = true;
  }

  //检查是否可以添加到播放集合
  checkRuntime() {
    if (scenes.length < maxPlay) {
      var first = cacheScenes.removeAt(0);
      scenes.add(first);
      if (state != SceneState.complete) return;
      state = SceneState.prepared;
      if (_listener != null) _listener!(state);
    }
  }

  checkComplete(Scene temp) {
    if (oldScenes.length >= maxOldCache) {
      oldScenes.removeLast();
    }
    temp.config.reset();
    temp.removeListener();
    scenes.remove(temp);
    oldScenes.add(temp);
    if (scenes.isEmpty && cacheScenes.isEmpty && messageList.isEmpty) {
      state = SceneState.complete;
      if (_listener != null) _listener!(state);
      return;
    }

    while (cacheScenes.isNotEmpty && scenes.length < maxPlay) {
      scenes.add(cacheScenes.removeAt(0));
    }
    checkCache(null);
  }

  ///动画控制器控制的时钟
  void tick() {
    if (scenes.isEmpty) return;
    //通知可以播放场景，准备这一帧的动画
    for (int index = 0; index < scenes.length; index++) {
      scenes[index].preFrame();
    }
  }

  void render(Canvas canvas) {
    if (scenes.isEmpty) return;
    for (int index = 0; index < scenes.length; index++) {
      scenes[index].render(canvas);
    }
  }

  void binding(MediaQueryData queryData) {
    _queryData = queryData;
  }

  ///检查运行过的场景缓存，有的话复用
  Scene? checkOldCache(String id) {
    if (oldScenes.isEmpty) return null;
    for (Scene element in oldScenes) {
      if (element.sceneId == id) {
        oldScenes.remove(element);
        return element;
      }
    }
    return null;
  }
}
