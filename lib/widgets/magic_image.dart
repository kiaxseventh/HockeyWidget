import 'package:flutter/material.dart';
import 'package:hockeywidget/models/point.dart';

class MagicImage extends StatelessWidget {
  MagicImage({
    required this.position,
    required this.size,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  Size size;
  Point position;
  GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: position.y,
      left: position.x,
      child: Container(
        width: size.width + 2,
        height: size.height + 2,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.black,
            width: 2,
          ),
        ),
        child: GestureDetector(
          onTap: onTap,
          child: Stack(
            children: [
              Center(
                child: Transform.scale(
                  scale: 0.5,
                  child: const CircularProgressIndicator(),
                ),
              ),
              Image.network(
                'https://picsum.photos/${size.width.toInt()}/${size.height.toInt()}',
                width: size.width,
                height: size.height,
                fit: BoxFit.fill,
              )
            ],
          ),
        ),
      ),
    );
  }
}
