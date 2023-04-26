import 'package:flutter_idraw/idraw_widgets/index.dart';

class BraScene extends Scene {
  BraScene({required super.config});

  static const String id = "BraScene";

  @override
  Future<List<SceneElement>> initElements() async {
    var barChildElement = BraChildElement(this);
    await barChildElement.init();

    var barSwingElement = BarSwingElement(this);
    await barSwingElement.init();

    var braHeartElement = BraHeartElement(this);
    await braHeartElement.init();
    return [
      barChildElement,
      barSwingElement,
      braHeartElement,
    ];
  }

  @override
  int initTotalFrames() {
    return 189;
  }
  ///////////////////////////////////////////////////////
}
