
import 'package:flutter_idraw/idraw_widgets/index.dart';

class YachtScene extends Scene {
  YachtScene({required super.config});

  static const String id = "YachtScene";

  @override
  Future<List<SceneElement>> initElements() async {
    var islandElement = IslandElement(this);
    await islandElement.init();
    var treeElement = TreeElement(this);
    await treeElement.init();
    var yachtElement = YachtElement(this);
    await yachtElement.init();
    return [
      treeElement,
      islandElement,
      yachtElement,
    ];
  }

  @override
  int initTotalFrames() {
    return 265;
  }
  ///////////////////////////////////////////////////////
}
