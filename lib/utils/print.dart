import 'package:flutter/material.dart';

///全局打印快捷方法
p(String? mes, [Widget? widget]) {
  debugPrint("${widget?.runtimeType}>>>>>$mes");
}
