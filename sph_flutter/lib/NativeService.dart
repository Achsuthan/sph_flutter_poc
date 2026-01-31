import 'package:flutter/services.dart';

class NativeService {
  static const platform = MethodChannel('com.yourapp/native_channel');

  Future<void> callSimpleFunction() async {
    try {
      await platform.invokeMethod('simpleFunction');
    } on PlatformException catch (e) {
      print("Failed: '${e.message}'.");
    }
  }

  Future<void> pushNativeScreen(
    String screenName, {
    Map<String, dynamic>? data,
  }) async {
    try {
      await platform.invokeMethod('pushNativeScreen', {
        'screenName': screenName,
        'data': data,
      });
    } on PlatformException catch (e) {
      print("Failed to push native screen: '${e.message}'");
    }
  }

  // Pop back to previous screen
  Future<void> popScreen() async {
    try {
      await platform.invokeMethod('popScreen');
    } on PlatformException catch (e) {
      print("Failed to pop screen: '${e.message}'");
    }
  }
}
