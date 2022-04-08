import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hockeywidget/models/point.dart';
import 'package:hockeywidget/utils/math.dart';

import 'magic_image.dart';

const double speed = 20;
const double gravity = 0.1;

class Area extends StatefulWidget {
  const Area({Key? key}) : super(key: key);

  @override
  _AreaState createState() => _AreaState();
}

class _AreaState extends State<Area> {
  Size itemSize = const Size(0, 0);
  Size sceneSize = const Size(0, 0);
  Size screenSize = const Size(0, 0);
  double moveSpeed = speed;
  Point position = Point(0, 0), step = Point(0, 0);
  Offset? delta;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      double randomSize = random(screenSize.width ~/ 7, screenSize.width ~/ 4).toDouble();

      itemSize = Size(randomSize, randomSize);
      sceneSize = Size(screenSize.width - itemSize.width, screenSize.height - itemSize.height);
      position.x = sceneSize.width / 2;
      position.y = sceneSize.height / 2;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            if (screenSize.width == 0 || screenSize.height == 0) {
              screenSize = Size(constraints.maxWidth, constraints.maxHeight);
              sceneSize = Size(screenSize.width - itemSize.width, screenSize.height - itemSize.height);
              position.x = sceneSize.width / 2;
              position.y = sceneSize.height / 2;
            }

            return GestureDetector(
              onPanUpdate: (details) => onPanUpdate(context, details),
              onPanEnd: (details) => onPanEnd(context, details),
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.white,
                  ),
                  MagicImage(
                    position: position,
                    size: itemSize,
                    onTap: () {
                      double randomWidth = random(screenSize.width ~/ 7, screenSize.width ~/ 4).toDouble();
                      double randomHeight = random(screenSize.width ~/ 7, screenSize.width ~/ 4).toDouble();

                      itemSize = Size(randomWidth, randomHeight);
                      sceneSize = Size(screenSize.width - itemSize.width, screenSize.height - itemSize.height);

                      setState(() {});
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void onPanUpdate(BuildContext context, DragUpdateDetails details) {
    delta = details.delta;
  }

  void onPanEnd(BuildContext context, DragEndDetails details) {
    if (details.primaryVelocity != null) {
      return;
    }
    step.x = delta!.dx / 20;
    step.y = delta!.dy / 20;
    startMove();
  }

  void startMove() {
    if (timer != null) {
      timer!.cancel();
    }

    timer = Timer.periodic(const Duration(microseconds: 16666), (timer) {
      move();
      setState(() {});
      if (moveSpeed <= 1) {
        timer.cancel();
        moveSpeed = speed;
      }
    });
  }

  void move() {
    if (position.x <= 0) {
      step.x = step.x.abs();
    }
    if (position.x >= sceneSize.width) {
      step.x = step.x.abs() * -1;
    }

    position.x += (step.x * moveSpeed);

    if (position.y <= 0) {
      step.y = step.y.abs();
    }

    if (position.y >= sceneSize.height) {
      step.y = step.y.abs() * -1;
    }
    position.y += (step.y * moveSpeed);
    moveSpeed -= gravity;
  }
}
