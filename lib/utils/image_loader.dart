import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ImageLoader {
  //方法1：获取网络图片 返回ui.Image
  Future<ui.Image> getNetImage(String url,
      {int width = 16, int height = 16}) async {
    ByteData data = await NetworkAssetBundle(Uri.parse(url)).load(url);
    // final response = await Dio().get
    //  (url, options: Options(responseType: ResponseType.bytes));
    // final data = response.data;

    debugPrint("data length is ${data.buffer.asUint8List().length}");
    ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: width,
      targetHeight: height,
    );
    ui.FrameInfo fi = await codec.getNextFrame();
    return fi.image;
  }

//方法2.1：获取本地图片  返回ui.Image 需要传入BuildContext context
  Future<ui.Image> getAssetImage2(String asset, BuildContext context,
      {width, height}) async {
    ByteData data = await DefaultAssetBundle.of(context).load(asset);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width, targetHeight: height);
    ui.FrameInfo fi = await codec.getNextFrame();
    return fi.image;
  }

//方法2.2：获取本地图片 返回ui.Image 不需要传入BuildContext context
  Future<ui.Image> getAssetImage(String asset, {width, height}) async {
    ByteData data = await rootBundle.load(asset);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width, targetHeight: height);
    ui.FrameInfo fi = await codec.getNextFrame();
    return fi.image;
  }

  static Future<ui.Image> loadIamge(String path) async {
    // 加载资源文件
    final data = await rootBundle.load(path);
    // 把资源文件转换成Uint8List类型
    final bytes = data.buffer.asUint8List();
    // 解析Uint8List类型的数据图片
    final image = await decodeImageFromList(bytes);
    return image;
  }
}
