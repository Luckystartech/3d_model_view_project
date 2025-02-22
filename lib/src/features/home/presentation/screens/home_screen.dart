import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';
import 'package:flutter_joystick/flutter_joystick.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Flutter3DController _controller1;
  late Flutter3DController _controller2;
  int selectedCharacter = 0;

  late double x;
  late double y;
  late double z;

  @override
  void initState() {
    _controller1 = Flutter3DController();
    _controller2 = Flutter3DController();
    x = 0;
    y = 0;
    z = 0;
    super.initState();
  }

  void getAnimations() async {
    final animations1 = await _controller1.getAvailableAnimations();
    final animation2 = await _controller2.getAvailableAnimations();
    

    log("current Animations: $animations1, $animation2");
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context).width;
    return Focus(
      autofocus: true,
      onKeyEvent: (node, event) {
        final keyId =
            "0x${event.logicalKey.keyId.toRadixString(16).padLeft(8, '0')}";
        print(
            'pressed space bar: ${"0x${event.logicalKey.keyId.toRadixString(16).padLeft(8, '0')}"}');
        switch (keyId) {
          case '0x00000020':
            _controller1.playAnimation(animationName: 'walk_jump');
            _controller2.playAnimation(animationName: 'walk_jump');
            break;
          case '0x100000302': //Left arrow
            _controller1.setCameraTarget(x += 0.1, y, z);
            _controller2.setCameraTarget(x += 0.1, y, z);
            break;
          case '0x100000304': //Top Arrow
            _controller1.setCameraTarget(x, y -= 0.1, z);
            _controller2.setCameraTarget(x, y -= 0.1, z);
            break;
          case '0x100000303': //Right Arrow
            _controller1.setCameraTarget(x -= 0.1, y, z);
            _controller2.setCameraTarget(x -= 0.1, y, z);
            break;
          case '0x100000301': //Down
            _controller1.setCameraTarget(x, y += 0.1, z);
            _controller2.setCameraTarget(x, y += 0.1, z);
            break;
          default:
            break;
        }

        //0x100000302 L
        //0x100000304 T
        //0x100000303 R
        //0x100000301 D
        return KeyEventResult.handled;
      },
      child: Scaffold(
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniCenterFloat,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          _controller1.playAnimation(animationName: 'walk_jump');
                          _controller2.playAnimation(animationName: 'walk_jump');
                        },
                        child: const Text('jump')),
                    ElevatedButton(
                        onPressed: () {
                          _controller1.playAnimation(animationName: 'talk');
                          _controller2.playAnimation(animationName: 'talk');
                        },
                        child: const Text('talk')),
                    ElevatedButton(
                        onPressed: () {
                          _controller1.stopAnimation();
                          _controller2.stopAnimation();
                        },
                        child: const Text('stop')),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: size > 800 ? 400 : 200,
                      child: Flutter3DViewer(
                        enableTouch: true,
                        controller: _controller1,
                        src: 'assets/models/female.glb',
                        onLoad: (modelAddress) {
                          _controller1.playAnimation(animationName: 'idle');
                        },
                        onError: (e) {
                          log(e.toString());
                        },
                      ),
                    ),
                    SizedBox(
                      width: size > 800 ? 400 : 200,
                      child: Flutter3DViewer(
                        enableTouch: true,
                        controller: _controller2,
                        src: 'assets/models/female_2.glb',
                        onLoad: (modelAddress) {
                          _controller2.playAnimation(animationName: 'idle');
                        },
                        onError: (e) {
                          log(e.toString());
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Joystick(listener: (drag) {
              _controller1.setCameraTarget(-drag.x, drag.y, 0.0);
              log(drag.x.toString());
            }),
            Joystick(listener: (drag) {
              _controller2.setCameraTarget(-drag.x, drag.y, 0.0);
              log(drag.x.toString());
            }),
          ],
        ),
      ),
    );
  }
}
