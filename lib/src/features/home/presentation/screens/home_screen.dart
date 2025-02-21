import 'dart:developer';

import 'package:flutter/material.dart';
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

  @override
  void initState() {
    _controller1 = Flutter3DController();
    _controller2 = Flutter3DController();
    // _controller.setCameraOrbit(theta, phi, radius)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller1.playAnimation(animationName: 'idle');
      _controller2.playAnimation(animationName: 'idle');
    });
    super.initState();
  }

  void getAnimations() async {
    final animations1 = await _controller1.getAvailableAnimations();
    final animation2 = await _controller2.getAvailableAnimations();

    log("current Animations: $animations1, $animation2");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        _controller1.playAnimation(animationName: 'jump');
                        _controller2.playAnimation(animationName: 'jump');
                      },
                      child: const Text('jump')),
                  ElevatedButton(
                      onPressed: () {
                        _controller1.playAnimation(animationName: 'talking');
                        _controller2.playAnimation(animationName: 'talking');
                      },
                      child: const Text('talk')),
                  ElevatedButton(
                      onPressed: () {
                        _controller1.resetAnimation();
                        _controller2.resetAnimation();
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
                    width: 200,
                    child: Flutter3DViewer(
                      controller: _controller1,
                      src: 'assets/models/lola.glb',
                      onLoad: (modelAddress) {
                        _controller1.playAnimation(animationName: 'idle');
                      },
                      onError: (e) {
                        log(e.toString());
                      },
                    ),
                  ),
                  SizedBox(
                    width: 200,
                    child: Flutter3DViewer(
                      controller: _controller2,
                      src: 'assets/models/sub_zero.glb',
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
      // floatingActionButton: IconButton(
      //     onPressed: () {
      //       _controller.playAnimation(
      //           animationName:
      //               'Armature.001|F_Jog_Jump_Small_001|F_Jog_Jump_Small_001:BaseAnim');
      //       getAnimations();
      //     },
      //     icon: const Icon(Icons.add)),
    );
  }
}
