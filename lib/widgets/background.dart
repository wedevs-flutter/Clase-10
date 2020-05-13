import 'package:flutter/material.dart';
import 'package:quote_character/utils/my_colors.dart';

enum Type { login, register }

class BackgroundLogin extends StatelessWidget {
  final Type type;

  BackgroundLogin({this.type});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Container(
      width: size.width,
      height: size.height,
      child: Stack(
        children: <Widget>[
          Container(
            width: size.width,
            height: size.height,
            child: CustomPaint(
              painter: (type == Type.login)
                  ? _BackgroundLoginPainter()
                  : _BackgroundRegisterPainter(),
            ),
          ),
          if (type == Type.login)
            Container(
              padding: EdgeInsets.only(
                top: 50,
                left: 25,
              ),
              child: Image.asset(
                'assets/quote_mark.png',
                width: 150,
              ),
            ),
        ],
      ),
    );
  }
}

class _BackgroundLoginPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    Path path = Path();

    paint.color = MyColors.colorGreen2;
    paint.strokeWidth = 12;
    paint.style = PaintingStyle.fill;

    path.lineTo(0, size.height * 0.5);
    path.cubicTo(
      1.3 * size.width * 0.5,
      size.height * 0.5,
      size.width * 0.3,
      size.height * 0.3,
      size.width,
      size.height * 0.3,
    );
    path.lineTo(size.width, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class _BackgroundRegisterPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    Path path = Path();

    paint.color = MyColors.colorGreen1;
    paint.strokeWidth = 12;
    paint.style = PaintingStyle.fill;

    path.moveTo(0, size.height);
    path.lineTo(0, size.height * 0.8);
    path.cubicTo(
      size.width * 0.8,
      size.height * 0.8,
      size.width * 0.6,
      size.height * 0.6,
      size.width,
      size.height * 0.6,
    );
    path.lineTo(size.width, size.height);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
