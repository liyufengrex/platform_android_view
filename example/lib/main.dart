import 'dart:math';

import 'package:flutter/material.dart';
import 'package:platform_android_view/custom_android_view.dart';

void main() {
  runApp(const MaterialApp(home: MyHome()));
}

class MyHome extends StatelessWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: CustomExample(),
    );
  }
}

class CustomExample extends StatefulWidget {
  const CustomExample({Key? key}) : super(key: key);

  @override
  State<CustomExample> createState() => _CustomExampleState();
}

class _CustomExampleState extends State<CustomExample> {
  String receivedData = '';
  CustomViewController? _controller;

  void _onCustomAndroidViewCreated(CustomViewController controller) {
    _controller = controller;
    _controller?.customDataStream.listen((data) {
      //接收到来自Android端的数据
      setState(() {
        receivedData = '来自Android的数据：$data';
      });
    });
  }

  Widget _buildAndroidView() {
    return Expanded(
      child: Container(
        color: Colors.blueAccent.withAlpha(60),
        child: CustomAndroidView(_onCustomAndroidViewCreated),
      ),
      flex: 1,
    );
  }

  Widget _buildFlutterView() {
    return Expanded(
      child: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              TextButton(
                onPressed: () {
                  final randomNum = Random().nextInt(10);
                  _controller
                      ?.sendMessageToAndroidView('flutter - $randomNum ');
                },
                child: const Text('发送数据给Android'),
              ),
              const SizedBox(height: 10),
              Text(receivedData),
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 15),
            child: Text(
              'Flutter - View',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      flex: 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildAndroidView(),
        _buildFlutterView(),
      ],
    );
  }
}
