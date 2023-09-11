import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

class Wheel extends StatefulWidget {
  Wheel({super.key});

  @override
  State<Wheel> createState() => _WheelState();
}

class _WheelState extends State<Wheel> {
  late final StreamController<int> controller;
  Timer? _spinTimer;
  Timer? _stopTimer;

  @override
  void initState() {
    super.initState();
    controller = StreamController<int>();
  }

  _startSpinning() {
    if (_spinTimer != null) return; // Avoid starting if already spinning

    _spinTimer = Timer.periodic(Duration(milliseconds: 500), (timer) {
      controller.add(Fortune.randomInt(0, 3)); // Cycle between 0, 1, 2
    });

    _stopTimer = Timer(Duration(seconds: 5), () {
      _stopSpinning();
    });
  }

  _stopSpinning() {
    _spinTimer?.cancel();
    _spinTimer = null;
    _stopTimer?.cancel();
    _stopTimer = null;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize:
            MainAxisSize.min, // This ensures the column is centered vertically

        children: [
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints.tightFor(
                  width: 600, // Adjust width as desired
                  height: 600, // Adjust height as desired
                ),
                // Wrapping the container with Center

                child: FortuneWheel(
                  selected: controller.stream,
                  animateFirst: false,
                  items: [
                    FortuneItem(
                        child: Image.network(
                      'https://picsum.photos/250?image=9',
                      height: 200,
                    )),
                    FortuneItem(
                        child: Image.network(
                      'https://picsum.photos/250?image=9',
                      height: 200,
                    )),
                    FortuneItem(
                        child: Image.network(
                      'https://picsum.photos/250?image=9',
                      height: 200,
                    )),
                    FortuneItem(
                        child: Image.network(
                      'https://picsum.photos/250?image=9',
                      height: 200,
                    )),
                    FortuneItem(
                        child: Image.network(
                      'https://picsum.photos/250?image=9',
                      height: 200,
                    )),
                    FortuneItem(
                        child: Image.network(
                      'https://picsum.photos/250?image=9',
                      height: 200,
                    )),
                    FortuneItem(
                        child: Image.network(
                      'https://picsum.photos/250?image=9',
                      height: 200,
                    )),
                    FortuneItem(
                        child: Image.network(
                      'https://picsum.photos/250?image=9',
                      height: 200,
                    )),
                    FortuneItem(
                        child: Image.network(
                      'https://picsum.photos/250?image=9',
                      height: 200,
                    )),
                    FortuneItem(
                        child: Image.network(
                      'https://picsum.photos/250?image=9',
                      height: 200,
                    )),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 20), // <-- Introducing a space of 20 logical pixels.

          ElevatedButton(
            onPressed: _startSpinning,
            child: Text("Spin"),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.close();
    _spinTimer?.cancel();
    _stopTimer?.cancel();
    super.dispose();
  }
}
