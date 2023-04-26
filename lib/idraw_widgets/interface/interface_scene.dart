import 'dart:ui';

///场景接口
abstract class IScene {
  ///场景必须具有往下传递舞台的能力
  render(Canvas canvas);

  ///场景必须知道当前正在绘制哪一帧
  preFrame();
}
