import 'dart:ui';

abstract class ILayer {
  preFrame(int frame);
  onDraw(Canvas canvas, Paint paint);
}
