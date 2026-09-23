import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// Toast工具类
class ToastUtil {

  static DateTime? _lastShownTime; // 上一次弹出时间

  /// 显示普通消息
  static void show(String message) {
    _showToast(message);
  }

  /// 显示成功消息
  static void showSuccess(String message) {
    _showToast(message, backgroundColor: Colors.green);
  }

  /// 显示错误消息
  static void showError(String message) {
    _showToast(message, backgroundColor: Colors.red);
  }

  /// 显示警告消息
  static void showWarning(String message) {
    _showToast(message, backgroundColor: Colors.orange);
  }

  /// 内部方法，显示Toast
  static void _showToast(
    String message, {
    Color backgroundColor = Colors.black87,
  }) {
    final now = DateTime.now();

    // 如果 1 秒内已经弹过一次，就不再弹
    if (_lastShownTime != null && now.difference(_lastShownTime!) < Duration(milliseconds: 1500)) {
      return;
    }

    _lastShownTime = now;

    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 2,
      backgroundColor: Color.fromRGBO(0, 0, 0, 0.7),
      textColor: Colors.white,
      fontSize: 12.0
    );
  }
} 