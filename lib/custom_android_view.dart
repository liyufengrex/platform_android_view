import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef OnViewCreated = Function(CustomViewController);

///自定义AndroidView
class CustomAndroidView extends StatefulWidget {
  final OnViewCreated onViewCreated;

  const CustomAndroidView(this.onViewCreated, {Key? key}) : super(key: key);

  @override
  State<CustomAndroidView> createState() => _CustomAndroidViewState();
}

class _CustomAndroidViewState extends State<CustomAndroidView> {
  late MethodChannel _channel;

  @override
  Widget build(BuildContext context) {
    return _getPlatformFaceView();
  }

  Widget _getPlatformFaceView() {
    return AndroidView(
      viewType: 'com.rex.custom.android/customView',
      onPlatformViewCreated: _onPlatformViewCreated,
      creationParams: const <String, dynamic>{'initParams': 'hello world'},
      creationParamsCodec: const StandardMessageCodec(),
    );
  }

  void _onPlatformViewCreated(int id) {
    _channel = MethodChannel('com.rex.custom.android/customView$id');
    final controller = CustomViewController._(
      _channel,
    );
    widget.onViewCreated(controller);
  }
}

class CustomViewController {
  final MethodChannel _channel;
  final StreamController<String> _controller = StreamController<String>();

  CustomViewController._(
    this._channel,
  ) {
    _channel.setMethodCallHandler(
      (call) async {
        switch (call.method) {
          case 'getMessageFromAndroidView':
            // 从native端获取数据
            final result = call.arguments as String;
            _controller.sink.add(result);
            break;
        }
      },
    );
  }

  Stream<String> get customDataStream => _controller.stream;

  // 发送数据给native
  Future<void> sendMessageToAndroidView(String message) async {
    await _channel.invokeMethod(
      'getMessageFromFlutterView',
      message,
    );
  }
}
