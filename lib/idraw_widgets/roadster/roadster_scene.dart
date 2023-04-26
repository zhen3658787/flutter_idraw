import 'package:flutter_idraw/idraw_widgets/index.dart';

class RoadsterScene extends Scene {
  RoadsterScene({required super.config});

  static const String id = "RoadsterScene";

  @override
  Future<List<SceneElement>> initElements() async {
    var carElement = CarElement(this);
    await carElement.init();
    var carMarkElement = CarMarkElement(this);
    await carMarkElement.init();
    var carBackLampElement = CarBackLampElement(this);
    await carBackLampElement.init();
    var carFrontLampElement = CarFrontLampElement(this);
    await carFrontLampElement.init();
    var carCloudElement = CarCloudElement(this);
    await carCloudElement.init();
    return [
      carBackLampElement,
      carElement,
      carMarkElement,
      carFrontLampElement,
      carCloudElement,
    ];
  }

  @override
  int initTotalFrames() {
    return 234;
  }
  ///////////////////////////////////////////////////////
}
