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
}
