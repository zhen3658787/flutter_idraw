import 'package:flutter/material.dart';
import 'package:flutter_idraw/idraw_widgets/index.dart';
import 'package:flutter_idraw/utils/utils.dart';

class ShowPage extends StatefulWidget {
  const ShowPage({super.key});

  @override
  State<ShowPage> createState() => _ShowPageState();
}

class _ShowPageState extends State<ShowPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final Duration _duration = const Duration(seconds: 1);

  final SceneController _sceneController = SceneController();

  final List<String> _animIds = [
    "RoadsterScene",
    "BraScene",
    "YachtScene",
  ];
  //--------------------------------------------------------------------

  sceneListener(SceneState state) {
    switch (state) {
      case SceneState.prepared:
        _controller.repeat();
        break;
      case SceneState.start:
        break;
      case SceneState.stop:
        break;
      case SceneState.complete:
        p("SceneState.complete");
        _controller.reset();
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    _sceneController.addListener(sceneListener);
    _controller = AnimationController(vsync: this, duration: _duration);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          LayoutBuilder(
            builder:
                (BuildContext buildContext, BoxConstraints boxConstraints) {
              var size =
                  Size(boxConstraints.maxWidth, boxConstraints.maxHeight);
              var queryData = MediaQuery.of(buildContext);
              _sceneController.binding(queryData);
              return AnimatedBuilder(
                animation: _controller,
                builder: (BuildContext context, Widget? child) {
                  _sceneController.tick();
                  return RepaintBoundary(
                    child: CustomPaint(
                      size: size,
                      painter: CustomCarPainter(_sceneController),
                    ),
                  );
                },
              );
            },
          ),
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Wrap(
              alignment: WrapAlignment.center,
              children: List<Widget>.generate(
                  _animIds.length,
                  (index) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: ElevatedButton(
                            onPressed: () => _handlePressed(_animIds[index]),
                            child: Text(_animIds[index])),
                      )),
            ),
          )
        ],
      ),
    );
  }

  _handlePressed(String animId) {
    _sceneController.addMessage(animId);
  }
}

class CustomCarPainter extends CustomPainter {
  final SceneController sceneController;

  ////////////////////////////////////////////////////////
  ///
  CustomCarPainter(this.sceneController);

  @override
  void paint(Canvas canvas, Size size) {
    sceneController.render(canvas);
  }

  @override
  bool shouldRepaint(covariant CustomCarPainter oldDelegate) =>
      oldDelegate.sceneController.oldId != sceneController.id;
}
