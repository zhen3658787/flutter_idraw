import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../interface/interface_layer.dart';

class Sprite implements ILayer {
  Sprite({required this.image, this.density = 1}) {
    _width = image.width.toDouble();
    _height = image.height.toDouble();
    _srcRect = Rect.fromLTWH(0, 0, _width, _height);
    width = _width / density;
    height = _height / density;
    _dstRect = Rect.fromLTWH(0, 0, width, height);
  }
  bool visible = true;
  final ui.Image image;

  ///原图片宽
  late double _width;

  ///原图片高
  late double _height;

  ///根据原型图密度缩放后的宽
  late double width;

  ///根据原型图密度缩放后的高
  late double height;
  double density;
  late Rect _srcRect;
  late Rect _dstRect;
  double _alpha = 1;
  double _scaleX = 1;
  double _scaleY = 1;
  double _rotate = 0;
  double _translateX = 0;
  double _translateY = 0;

  Paint? _paint;
  Matrix4? _matrix4;
  /////////////////////////////////////////////////////////////////////
  double get transY => _translateY;
  double get transX => _translateX;
  double get scale => _scaleX;
  double get scaleY => _scaleY;
  double get alpha => _alpha;
  double get rotate => _rotate;

  Rect get dstRect => _dstRect.translate(_translateX, _translateY);
  Rect get srcRect => _srcRect.translate(_translateX, _translateY);

  Sprite clone() {
    var clone = Sprite(image: image.clone(), density: density);
    return clone;
  }

  Sprite translate(double transX, double transY) {
    _translateX = transX;
    _translateY = transY;
    return this;
  }

  Sprite setTransX(double transX) {
    _translateX = transX;
    return this;
  }

  Sprite setTransY(double transY) {
    _translateY = transY;
    return this;
  }

  Sprite setScale(double scale,
      {double scaleY = 0, double centerX = 0, double centerY = 0}) {
    _scaleX = scale;
    _scaleY = scaleY == 0 ? scale : scaleY;
    Matrix4 scaleM4;
    if (centerX == 0 && centerY == 0) {
      scaleM4 = Matrix4.diagonal3Values(_scaleX, _scaleY, 1.0);
    } else {
      Matrix4 moveCenter = Matrix4.translationValues(centerX, centerY, 0);
      Matrix4 moveBack = Matrix4.translationValues(-centerX, -centerY, 0);
      scaleM4 = Matrix4.diagonal3Values(_scaleX, _scaleY, 1.0);
      scaleM4 = moveCenter.multiplied(scaleM4).multiplied(moveBack);
    }
    _matrix4 ??= Matrix4.identity();
    _matrix4!.multiply(scaleM4);
    return this;
  }

  Sprite clearMatrix4() {
    _matrix4 = null;
    return this;
  }

  Sprite setAlpha(double aplha) {
    _alpha = aplha;
    _paint ??= Paint();
    _paint!.color = Colors.transparent.withAlpha(aplha.toInt());
    return this;
  }

  Sprite setRotate(double rotate, {double centerX = 0, double centerY = 0}) {
    _rotate = rotate;
    Matrix4 rotateM4;
    if (centerX == 0 && centerY == 0) {
      rotateM4 = Matrix4.rotationZ(pi / 180 * _rotate);
    } else {
      Matrix4 moveCenter = Matrix4.translationValues(centerX, centerY, 0);
      Matrix4 moveBack = Matrix4.translationValues(-centerX, -centerY, 0);
      rotateM4 = Matrix4.rotationZ(pi / 180 * _rotate);
      rotateM4 = moveCenter.multiplied(rotateM4).multiplied(moveBack);
    }
    _matrix4 ??= Matrix4.identity();
    _matrix4!.multiply(rotateM4);
    return this;
  }

  @override
  onDraw(Canvas canvas, Paint paint) {
    if (_matrix4 != null) {
      canvas.save();
      canvas.transform(_matrix4!.storage);
      canvas.drawImageRect(image, _srcRect, dstRect, _paint ?? paint);
      canvas.restore();
      return;
    }
    canvas.drawImageRect(image, _srcRect, dstRect, _paint ?? paint);
  }

  @override
  preFrame(int frame) {}
}
