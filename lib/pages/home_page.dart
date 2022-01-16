import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:flutter_isolate/resource/app_strings.dart';
import 'package:flutter_isolate/util/integer_util.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Isolate _isolateFactorial;
  late ReceivePort _receivePortFactorial;
  late Isolate _isolatePower;
  late ReceivePort _receivePortPower;
  int _counter = 0;

  void _onPressedPowerButton() async {
    _receivePortPower = ReceivePort();
    _isolatePower = await Isolate.spawn(
      _calculatePower,
      [_receivePortPower.sendPort, _counter],
    );
    _receivePortPower.listen(_handleMessage);
  }

  static void _calculatePower(List<dynamic> arguments) async {
    SendPort sendPort = arguments[0];
    final res = await power(
      BigInt.two,
      BigInt.parse(arguments[1].toString()),
    );
    sendPort.send(res);
  }

  void _onPressedFactorialButton() async {
    _receivePortFactorial = ReceivePort();
    _isolateFactorial = await Isolate.spawn(
      _calculateFactorial,
      [_receivePortFactorial.sendPort, _counter],
    );
    _receivePortFactorial.listen(_handleMessage);
  }

  static void _calculateFactorial(List<dynamic> arguments) async {
    SendPort sendPort = arguments[0];
    final res = await factorial(
      BigInt.parse(arguments[1].toString()),
    );
    sendPort.send(res);
  }

  void _handleMessage(dynamic data) {
    Fluttertoast.showToast(
      msg: '${AppStrings.result}: $data',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      fontSize: 16.0,
    );
  }

  void _onPressedIncrementButton() {
    setState(() {
      _counter += 10;
      if (_counter == 1000) {
        _counter--;
      } else if (_counter > 1000) {
        _counter = 0;
      }
    });
  }

  @override
  void dispose() {
    _receivePortFactorial.close();
    _isolateFactorial.kill(priority: Isolate.immediate);
    _receivePortPower.close();
    _isolatePower.kill(priority: Isolate.immediate);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.isolateApp),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _counter.toString(),
              style: Theme.of(context).textTheme.headline4,
            ),
            const SizedBox(height: 16),
            TextButton(
              child: const Text(AppStrings.yourNumberPower),
              onPressed: _onPressedPowerButton,
            ),
            const SizedBox(height: 16),
            TextButton(
              child: const Text(AppStrings.yourNumberFactorial),
              onPressed: _onPressedFactorialButton,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onPressedIncrementButton,
        child: const Icon(Icons.add),
      ),
    );
  }
}
