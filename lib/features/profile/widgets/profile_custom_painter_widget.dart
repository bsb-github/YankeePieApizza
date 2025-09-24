import 'package:flutter/material.dart';

class ProfileCustomPainterWidget extends CustomPainter {
  final BuildContext context;

  ProfileCustomPainterWidget(this.context);

  @override
  void paint(Canvas canvas, Size size) {

    Path path_0 = Path();
    path_0.moveTo(size.width*0.5944389,size.height*0.04937106);
    path_0.cubicTo(size.width*0.6259333,size.height*0.06583372,size.width*0.6623500,size.height*0.08393632,size.width*0.7069639,size.height*0.08393632);
    path_0.lineTo(size.width*0.9722222,size.height*0.08393632);
    path_0.cubicTo(size.width*0.9875639,size.height*0.08393632,size.width,size.height*0.09041563,size.width,size.height*0.09840810);
    path_0.lineTo(size.width,size.height*1.008683);
    path_0.cubicTo(size.width,size.height*1.009482,size.width*0.9987556,size.height*1.010130,size.width*0.9972222,size.height*1.010130);
    path_0.lineTo(size.width*0.002777756,size.height*1.010130);
    path_0.cubicTo(size.width*0.001243631,size.height*1.010130,0,size.height*1.009482,0,size.height*1.008683);
    path_0.lineTo(0,size.height*0.09840810);
    path_0.cubicTo(0,size.height*0.09041563,size.width*0.01243653,size.height*0.08393632,size.width*0.02777778,size.height*0.08393632);
    path_0.lineTo(size.width*0.2930361,size.height*0.08393632);
    path_0.cubicTo(size.width*0.3376500,size.height*0.08393632,size.width*0.3740667,size.height*0.06583372,size.width*0.4055611,size.height*0.04937106);
    path_0.cubicTo(size.width*0.4297028,size.height*0.03675239,size.width*0.4631000,size.height*0.02894356,size.width*0.5000000,size.height*0.02894356);
    path_0.cubicTo(size.width*0.5369000,size.height*0.02894356,size.width*0.5702972,size.height*0.03675239,size.width*0.5944389,size.height*0.04937106);
    path_0.close();

    Paint paint0Fill = Paint()..style=PaintingStyle.fill;
    paint0Fill.color = Theme.of(context).cardColor;
    canvas.drawPath(path_0,paint0Fill);

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}