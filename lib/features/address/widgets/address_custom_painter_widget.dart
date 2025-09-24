import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_restaurant/main.dart';

//Copy this CustomPainter code to the Bottom of the File
class AddressCustomPrinterWidget extends CustomPainter {
  late final bool isDark;
  AddressCustomPrinterWidget({required this.isDark});
@override
void paint(Canvas canvas, Size size) {



  Color primaryColor = isDark ? Colors.white.withValues(alpha:0.08) :  const Color( 0xff000000).withValues(alpha:.05);
  Color secenderyColor = isDark ? Colors.white.withValues(alpha:0.03) : const Color(0xff616161).withValues(alpha:.05);
  Color shadowColor = isDark ? Colors.white.withValues(alpha:0.01) :  const Color(0xffA3A3A3).withValues(alpha:0.05);
  Color colorOne = isDark ? Colors.white.withValues(alpha:0.01) :  const Color(0xffD3D3D3).withValues(alpha:1.0);

Paint paint0Fill = Paint()..style=PaintingStyle.fill;
paint0Fill.color = Theme.of(Get.context!).cardColor;
canvas.drawRect(Rect.fromLTWH(0,0,size.width,size.height),paint0Fill);

Path path_1 = Path();
path_1.moveTo(size.width*0.08697167,size.height*1.000407);
path_1.lineTo(size.width*0.03031500,size.height*1.000407);
path_1.lineTo(size.width*0.03031500,size.height*0.7456068);
path_1.lineTo(size.width*0.07260167,size.height*0.7456068);
path_1.lineTo(size.width*0.08697167,size.height*0.7516746);
path_1.lineTo(size.width*0.08697167,size.height*1.000407);
path_1.close();

Paint paint1Fill = Paint()..style=PaintingStyle.fill;
paint1Fill.shader = ui.Gradient.linear(Offset(size.width*0.05864333,size.height*0.9286671), Offset(size.width*0.05864333,size.height*0.7958367), [shadowColor,primaryColor], [0,0.75]);
canvas.drawPath(path_1,paint1Fill);

Path path_2 = Path();
path_2.moveTo(size.width*0.04088389,size.height*0.7456068);
path_2.lineTo(size.width*0.05495083,size.height*0.7370540);
path_2.lineTo(size.width*0.06901750,size.height*0.7456068);
path_2.lineTo(size.width*0.04088389,size.height*0.7456068);
path_2.close();

Paint paint2Fill = Paint()..style=PaintingStyle.fill;
paint2Fill.shader = ui.Gradient.linear(Offset(size.width*0.05495083,size.height*0.9286671), Offset(size.width*0.05495083,size.height*0.7958367), [shadowColor,primaryColor], [0,0.75]);
canvas.drawPath(path_2,paint2Fill);

Path path_3 = Path();
path_3.moveTo(size.width*0.1452636,size.height*1.000407);
path_3.lineTo(size.width*0.08860667,size.height*1.000407);
path_3.lineTo(size.width*0.08860667,size.height*0.7635590);
path_3.lineTo(size.width*0.1309044,size.height*0.7635590);
path_3.lineTo(size.width*0.1452636,size.height*0.7696219);
path_3.lineTo(size.width*0.1452636,size.height*1.000407);
path_3.close();

Paint paint3Fill = Paint()..style=PaintingStyle.fill;
paint3Fill.shader = ui.Gradient.linear(Offset(size.width*0.1169353,size.height*0.9286671), Offset(size.width*0.1169353,size.height*0.7958367), [shadowColor,primaryColor], [0,0.75]);
canvas.drawPath(path_3,paint3Fill);

Path path_4 = Path();
path_4.moveTo(size.width*0.09918694,size.height*0.7635590);
path_4.lineTo(size.width*0.1132428,size.height*0.7550063);
path_4.lineTo(size.width*0.1273094,size.height*0.7635590);
path_4.lineTo(size.width*0.09918694,size.height*0.7635590);
path_4.close();

Paint paint4Fill = Paint()..style=PaintingStyle.fill;
paint4Fill.shader = ui.Gradient.linear(Offset(size.width*0.1132428,size.height*0.9286671), Offset(size.width*0.1132428,size.height*0.7958367), [shadowColor,primaryColor], [0,0.75]);
canvas.drawPath(path_4,paint4Fill);

Path path_5 = Path();
path_5.moveTo(size.width*0.2135944,size.height*1.006955);
path_5.lineTo(size.width*0.3153333,size.height*1.006955);
path_5.lineTo(size.width*0.3153333,size.height*0.6905402);
path_5.lineTo(size.width*0.2357397,size.height*0.6905402);
path_5.lineTo(size.width*0.2135944,size.height*0.6941809);
path_5.lineTo(size.width*0.2135944,size.height*1.006955);
path_5.close();

Paint paint5Fill = Paint()..style=PaintingStyle.fill;
paint5Fill.shader = ui.Gradient.linear(Offset(size.width*0.2644689,size.height*0.9286671), Offset(size.width*0.2644689,size.height*0.7958367), [shadowColor,primaryColor], [0,0.75]);
canvas.drawPath(path_5,paint5Fill);

Path path_6 = Path();
path_6.moveTo(size.width*0.2357397,size.height*0.6905402);
path_6.lineTo(size.width*0.2135944,size.height*0.6941809);
path_6.lineTo(size.width*0.2135944,size.height*1.006955);
path_6.lineTo(size.width*0.2357397,size.height*1.006955);
path_6.lineTo(size.width*0.2357397,size.height*0.6905402);
path_6.close();

Paint paint6Fill = Paint()..style=PaintingStyle.fill;
paint6Fill.shader = ui.Gradient.linear(Offset(size.width*0.2246725,size.height*0.9196683), Offset(size.width*0.2246725,size.height*0.6454862), [shadowColor,secenderyColor], [0,0.75]);
canvas.drawPath(path_6,paint6Fill);

Path path_7 = Path();
path_7.moveTo(size.width*0.2261667,size.height*1.006955);
path_7.lineTo(size.width*0.1346083,size.height*1.006955);
path_7.lineTo(size.width*0.1346083,size.height*0.8218995);
path_7.lineTo(size.width*0.1519561,size.height*0.8171709);
path_7.lineTo(size.width*0.2261667,size.height*0.8171709);
path_7.lineTo(size.width*0.2261667,size.height*1.006955);
path_7.close();

Paint paint7Fill = Paint()..style=PaintingStyle.fill;
paint7Fill.shader = ui.Gradient.linear(Offset(size.width*0.1803822,size.height*0.9286671), Offset(size.width*0.1803822,size.height*0.7958367), [shadowColor,primaryColor], [0,0.75]);
canvas.drawPath(path_7,paint7Fill);

Path path_8 = Path();
path_8.moveTo(size.width*0.2967833,size.height*1.006954);
path_8.lineTo(size.width*0.3661944,size.height*1.006954);
path_8.lineTo(size.width*0.3661944,size.height*0.7174698);
path_8.lineTo(size.width*0.3199139,size.height*0.7174698);
path_8.lineTo(size.width*0.2967833,size.height*0.7235967);
path_8.lineTo(size.width*0.2967833,size.height*1.006954);
path_8.close();

Paint paint8Fill = Paint()..style=PaintingStyle.fill;
paint8Fill.shader = ui.Gradient.linear(Offset(size.width*0.3314889,size.height*0.9286671), Offset(size.width*0.3314889,size.height*0.7958367), [shadowColor,primaryColor], [0,0.75]);
canvas.drawPath(path_8,paint8Fill);

Path path_9 = Path();
path_9.moveTo(size.width*0.3560167,size.height*0.7072814);
path_9.lineTo(size.width*0.3326806,size.height*0.7072814);
path_9.lineTo(size.width*0.3326806,size.height*0.7174711);
path_9.lineTo(size.width*0.3560167,size.height*0.7174711);
path_9.lineTo(size.width*0.3560167,size.height*0.7072814);
path_9.close();

Paint paint9Fill = Paint()..style=PaintingStyle.fill;
paint9Fill.shader = ui.Gradient.linear(Offset(size.width*0.3443528,size.height*0.9286671), Offset(size.width*0.3443528,size.height*0.7958367), [shadowColor,primaryColor], [0,0.75]);
canvas.drawPath(path_9,paint9Fill);

Path path_10 = Path();
path_10.moveTo(size.width*0.5173806,size.height*1.022511);
path_10.lineTo(size.width*0.4030806,size.height*1.022511);
path_10.lineTo(size.width*0.4030806,size.height*0.7228392);
path_10.lineTo(size.width*0.5048083,size.height*0.7228392);
path_10.lineTo(size.width*0.5173806,size.height*0.7279309);
path_10.lineTo(size.width*0.5173806,size.height*1.022511);
path_10.close();

Paint paint10Fill = Paint()..style=PaintingStyle.fill;
paint10Fill.shader = ui.Gradient.linear(Offset(size.width*0.4602250,size.height*0.9442236), Offset(size.width*0.4602250,size.height*0.8113945), [shadowColor,primaryColor], [0,0.75]);
canvas.drawPath(path_10,paint10Fill);

Path path_11 = Path();
path_11.moveTo(size.width*0.5033028,size.height*0.7228392);
path_11.lineTo(size.width*0.4027778,size.height*0.7228392);
path_11.lineTo(size.width*0.4027778,size.height*1.022516);
path_11.lineTo(size.width*0.5033028,size.height*1.022516);
path_11.lineTo(size.width*0.5033028,size.height*0.7228392);
path_11.close();

Paint paint11Fill = Paint()..style=PaintingStyle.fill;
paint11Fill.shader = ui.Gradient.linear(Offset(size.width*0.4530444,size.height*1.024202), Offset(size.width*0.4530444,size.height*0.5865440), [shadowColor,secenderyColor], [0,0.75]);
canvas.drawPath(path_11,paint11Fill);

Path path_12 = Path();
path_12.moveTo(size.width*0.3326806,size.height*1.006954);
path_12.lineTo(size.width*0.4092833,size.height*1.006954);
path_12.lineTo(size.width*0.4092833,size.height*0.7866030);
path_12.lineTo(size.width*0.3895306,size.height*0.7812663);
path_12.lineTo(size.width*0.3326806,size.height*0.7812663);
path_12.lineTo(size.width*0.3326806,size.height*1.006954);
path_12.close();

Paint paint12Fill = Paint()..style=PaintingStyle.fill;
paint12Fill.shader = ui.Gradient.linear(Offset(size.width*0.3709806,size.height*0.9286671), Offset(size.width*0.3709806,size.height*0.7958367), [shadowColor,primaryColor], [0,0.75]);
canvas.drawPath(path_12,paint12Fill);

Path path_13 = Path();
path_13.moveTo(size.width*0.3895306,size.height*0.7812663);
path_13.lineTo(size.width*0.3326806,size.height*0.7812663);
path_13.lineTo(size.width*0.3326806,size.height*1.006954);
path_13.lineTo(size.width*0.3895306,size.height*1.006954);
path_13.lineTo(size.width*0.3895306,size.height*0.7812663);
path_13.close();

Paint paint13Fill = Paint()..style=PaintingStyle.fill;
paint13Fill.shader = ui.Gradient.linear(Offset(size.width*0.3611056,size.height*1.008229), Offset(size.width*0.3611056,size.height*0.6786206), [shadowColor,secenderyColor], [0,0.75]);
canvas.drawPath(path_13,paint13Fill);

Path path_14 = Path();
path_14.moveTo(size.width*0.4312028,size.height*0.7010050);
path_14.lineTo(size.width*0.4282139,size.height*0.7010050);
path_14.lineTo(size.width*0.4282139,size.height*0.7228392);
path_14.lineTo(size.width*0.4312028,size.height*0.7228392);
path_14.lineTo(size.width*0.4312028,size.height*0.7010050);
path_14.close();

Paint paint14Fill = Paint()..style=PaintingStyle.fill;
paint14Fill.shader = ui.Gradient.linear(Offset(size.width*0.4282139,size.height*0.7119196), Offset(size.width*0.4312028,size.height*0.7119196), [const Color(0xff4C4C4C).withValues(alpha:0.05),const Color(0xff2E2E2E).withValues(alpha:.02)], [0,0.75]);
canvas.drawPath(path_14,paint14Fill);

Path path_15 = Path();
path_15.moveTo(size.width*0.2889972,size.height*0.6687111);
path_15.lineTo(size.width*0.2860083,size.height*0.6687111);
path_15.lineTo(size.width*0.2860083,size.height*0.6905452);
path_15.lineTo(size.width*0.2889972,size.height*0.6905452);
path_15.lineTo(size.width*0.2889972,size.height*0.6687111);
path_15.close();

Paint paint15Fill = Paint()..style=PaintingStyle.fill;
paint15Fill.shader = ui.Gradient.linear(Offset(size.width*0.2875028,size.height*0.9286671), Offset(size.width*0.2875028,size.height*0.7958367), [shadowColor,primaryColor], [0,0.75]);
canvas.drawPath(path_15,paint15Fill);

Path path_16 = Path();
path_16.moveTo(size.width*0.9282167,size.height*0.7483656);
path_16.lineTo(size.width*0.9252278,size.height*0.7483656);
path_16.lineTo(size.width*0.9252278,size.height*0.7701997);
path_16.lineTo(size.width*0.9282167,size.height*0.7701997);
path_16.lineTo(size.width*0.9282167,size.height*0.7483656);
path_16.close();

Paint paint16Fill = Paint()..style=PaintingStyle.fill;
paint16Fill.color = const Color(0xff8E8E8E).withValues(alpha:1.0);
canvas.drawPath(path_16,paint16Fill);

Path path_17 = Path();
path_17.moveTo(size.width*0.4939778,size.height*0.7010050);
path_17.lineTo(size.width*0.4909889,size.height*0.7010050);
path_17.lineTo(size.width*0.4909889,size.height*0.7228392);
path_17.lineTo(size.width*0.4939778,size.height*0.7228392);
path_17.lineTo(size.width*0.4939778,size.height*0.7010050);
path_17.close();

Paint paint17Fill = Paint()..style=PaintingStyle.fill;
paint17Fill.shader = ui.Gradient.linear(Offset(size.width*0.4909889,size.height*0.4920339), Offset(size.width*0.4939778,size.height*0.4920339), [const Color(0xff4C4C4C).withValues(alpha:0.05),const Color(0xff2E2E2E).withValues(alpha:.02)], [0,0.75]);
canvas.drawPath(path_17,paint17Fill);

Path path_18 = Path();
path_18.moveTo(size.width*0.2860083,size.height*0.6832663);
path_18.lineTo(size.width*0.2644686,size.height*0.6832663);
path_18.lineTo(size.width*0.2644686,size.height*0.6905440);
path_18.lineTo(size.width*0.2860083,size.height*0.6905440);
path_18.lineTo(size.width*0.2860083,size.height*0.6832663);
path_18.close();

Paint paint18Fill = Paint()..style=PaintingStyle.fill;
paint18Fill.shader = ui.Gradient.linear(Offset(size.width*0.2752328,size.height*0.9286658), Offset(size.width*0.2752328,size.height*0.7958354), [shadowColor,primaryColor], [0,0.75]);
canvas.drawPath(path_18,paint18Fill);

Path path_19 = Path();
path_19.moveTo(size.width*0.5194444,size.height*1.006533);
path_19.lineTo(size.width*0.5943056,size.height*1.006533);
path_19.lineTo(size.width*0.5943056,size.height*0.7049133);
path_19.lineTo(size.width*0.5811472,size.height*0.7049133);
path_19.lineTo(size.width*0.5751583,size.height*0.6992136);
path_19.lineTo(size.width*0.5194444,size.height*0.7032173);
path_19.lineTo(size.width*0.5194444,size.height*1.006533);
path_19.close();

Paint paint19Fill = Paint()..style=PaintingStyle.fill;
paint19Fill.shader = ui.Gradient.linear(Offset(size.width*0.5568806,size.height*0.9286658), Offset(size.width*0.5568806,size.height*0.7958354), [shadowColor,primaryColor], [0,0.75]);
canvas.drawPath(path_19,paint19Fill);

Path path_20 = Path();
path_20.moveTo(size.width*0.5923889,size.height*1.006954);
path_20.lineTo(size.width*0.6785528,size.height*1.006954);
path_20.lineTo(size.width*0.6785528,size.height*0.7771445);
path_20.lineTo(size.width*0.6610000,size.height*0.7727776);
path_20.lineTo(size.width*0.5923889,size.height*0.7727776);
path_20.lineTo(size.width*0.5923889,size.height*1.006954);
path_20.close();

Paint paint20Fill = Paint()..style=PaintingStyle.fill;
paint20Fill.shader = ui.Gradient.linear(Offset(size.width*0.6354750,size.height*0.9286671), Offset(size.width*0.6354750,size.height*0.7958367), [shadowColor,primaryColor], [0,0.75]);
canvas.drawPath(path_20,paint20Fill);

Path path_21 = Path();
path_21.moveTo(size.width*0.6610111,size.height*0.7727776);
path_21.lineTo(size.width*0.5923889,size.height*0.7727776);
path_21.lineTo(size.width*0.5923889,size.height*1.006533);
path_21.lineTo(size.width*0.6610111,size.height*1.006533);
path_21.lineTo(size.width*0.6610111,size.height*0.7727776);
path_21.close();

Paint paint21Fill = Paint()..style=PaintingStyle.fill;
paint21Fill.shader = ui.Gradient.linear(Offset(size.width*0.6266944,size.height*1.010405), Offset(size.width*0.6266944,size.height*0.7117462), [shadowColor,secenderyColor], [0,0.75]);
canvas.drawPath(path_21,paint21Fill);

Path path_22 = Path();
path_22.moveTo(size.width*0.6504444,size.height*1.006954);
path_22.lineTo(size.width*0.8016472,size.height*1.006954);
path_22.lineTo(size.width*0.8016472,size.height*0.8477864);
path_22.lineTo(size.width*0.7708500,size.height*0.8447626);
path_22.lineTo(size.width*0.6504444,size.height*0.8447626);
path_22.lineTo(size.width*0.6504444,size.height*1.006954);
path_22.close();

Paint paint22Fill = Paint()..style=PaintingStyle.fill;
paint22Fill.shader = ui.Gradient.linear(Offset(size.width*0.7260500,size.height*0.9286658), Offset(size.width*0.7260500,size.height*0.7958367), [shadowColor,primaryColor], [0,0.75]);
canvas.drawPath(path_22,paint22Fill);

Path path_23 = Path();
path_23.moveTo(size.width*0.7790028,size.height*0.8447626);
path_23.lineTo(size.width*0.6586056,size.height*0.8447626);
path_23.lineTo(size.width*0.6586056,size.height*1.006665);
path_23.lineTo(size.width*0.7790028,size.height*1.006665);
path_23.lineTo(size.width*0.7790028,size.height*0.8447626);
path_23.close();

Paint paint23Fill = Paint()..style=PaintingStyle.fill;
paint23Fill.shader = ui.Gradient.linear(Offset(size.width*0.7188167,size.height*1.009345), Offset(size.width*0.7188167,size.height*0.8024912), [shadowColor,secenderyColor], [0,0.75]);
canvas.drawPath(path_23,paint23Fill);

Path path_24 = Path();
path_24.moveTo(size.width*0.6017778,size.height*1.006955);
path_24.lineTo(size.width*0.6935306,size.height*1.006955);
path_24.lineTo(size.width*0.6935306,size.height*0.8404548);
path_24.lineTo(size.width*0.6743861,size.height*0.8348769);
path_24.lineTo(size.width*0.6017778,size.height*0.8348769);
path_24.lineTo(size.width*0.6017778,size.height*1.006955);
path_24.close();

Paint paint24Fill = Paint()..style=PaintingStyle.fill;
paint24Fill.shader = ui.Gradient.linear(Offset(size.width*0.6476500,size.height*0.9286671), Offset(size.width*0.6476500,size.height*0.7958367), [shadowColor,primaryColor], [0,0.75]);
canvas.drawPath(path_24,paint24Fill);

Path path_25 = Path();
path_25.moveTo(size.width*0.7982444,size.height*1.009139);
path_25.lineTo(size.width*0.7256361,size.height*1.009139);
path_25.lineTo(size.width*0.7256361,size.height*0.7771432);
path_25.lineTo(size.width*0.7846778,size.height*0.7771432);
path_25.lineTo(size.width*0.7982444,size.height*0.7793241);
path_25.lineTo(size.width*0.7982444,size.height*1.009139);
path_25.close();

Paint paint25Fill = Paint()..style=PaintingStyle.fill;
paint25Fill.shader = ui.Gradient.linear(Offset(size.width*0.7619361,size.height*0.9286658), Offset(size.width*0.7619361,size.height*0.7958354), [shadowColor,primaryColor], [0,0.75]);
canvas.drawPath(path_25,paint25Fill);

Path path_26 = Path();
path_26.moveTo(size.width*0.7830861,size.height*0.7771445);
path_26.lineTo(size.width*0.7325139,size.height*0.7771445);
path_26.lineTo(size.width*0.7325139,size.height*0.7727776);
path_26.lineTo(size.width*0.7741083,size.height*0.7727776);
path_26.lineTo(size.width*0.7830861,size.height*0.7740515);
path_26.lineTo(size.width*0.7830861,size.height*0.7771445);
path_26.close();

Paint paint26Fill = Paint()..style=PaintingStyle.fill;
paint26Fill.shader = ui.Gradient.linear(Offset(size.width*0.7578000,size.height*0.9286658), Offset(size.width*0.7578000,size.height*0.7958367), [shadowColor,primaryColor], [0,0.75]);
canvas.drawPath(path_26,paint26Fill);

Path path_27 = Path();
path_27.moveTo(size.width*0.7707833,size.height*0.7704095);
path_27.lineTo(size.width*0.7256361,size.height*0.7704095);
path_27.lineTo(size.width*0.7256361,size.height*0.7727764);
path_27.lineTo(size.width*0.7707833,size.height*0.7727764);
path_27.lineTo(size.width*0.7707833,size.height*0.7704095);
path_27.close();

Paint paint27Fill = Paint()..style=PaintingStyle.fill;
paint27Fill.shader = ui.Gradient.linear(Offset(size.width*0.7482056,size.height*0.9286658), Offset(size.width*0.7482056,size.height*0.7958354), [shadowColor,primaryColor], [0,0.75]);
canvas.drawPath(path_27,paint27Fill);

Path path_28 = Path();
path_28.moveTo(size.width*0.9737833,size.height*0.8215327);
path_28.lineTo(size.width*0.8311556,size.height*0.8215327);
path_28.lineTo(size.width*0.8311556,size.height*0.7645289);
path_28.lineTo(size.width*0.9514417,size.height*0.7645289);
path_28.lineTo(size.width*0.9737833,size.height*0.7681658);
path_28.lineTo(size.width*0.9737833,size.height*0.8215327);
path_28.close();

Paint paint28Fill = Paint()..style=PaintingStyle.fill;
paint28Fill.shader = ui.Gradient.linear(Offset(size.width*0.9024639,size.height*0.9286671), Offset(size.width*0.9024639,size.height*0.7958367), [shadowColor,primaryColor], [0,0.75]);
canvas.drawPath(path_28,paint28Fill);

Path path_29 = Path();
path_29.moveTo(size.width*1.006097,size.height*1.006955);
path_29.lineTo(size.width*0.8098111,size.height*1.006955);
path_29.lineTo(size.width*0.8098111,size.height*0.8067362);
path_29.lineTo(size.width*0.9828361,size.height*0.8067362);
path_29.lineTo(size.width*1.006097,size.height*0.8118970);
path_29.lineTo(size.width*1.006097,size.height*1.006955);
path_29.close();

Paint paint29Fill = Paint()..style=PaintingStyle.fill;
paint29Fill.shader = ui.Gradient.linear(Offset(size.width*0.9079528,size.height*0.9286671), Offset(size.width*0.9079528,size.height*0.7958367), [shadowColor,primaryColor], [0,0.75]);
canvas.drawPath(path_29,paint29Fill);

Path path_30 = Path();
path_30.moveTo(size.width*0.02786750,size.height*1.000406);
path_30.lineTo(size.width*-0.02877861,size.height*1.000406);
path_30.lineTo(size.width*-0.02877861,size.height*0.7295955);
path_30.lineTo(size.width*0.01350839,size.height*0.7295955);
path_30.lineTo(size.width*0.02786750,size.height*0.7356621);
path_30.lineTo(size.width*0.02786750,size.height*1.000406);
path_30.close();

Paint paint30Fill = Paint()..style=PaintingStyle.fill;
paint30Fill.shader = ui.Gradient.linear(Offset(size.width*-0.04500583,size.height*0.9286658), Offset(size.width*-0.04500583,size.height*0.7958367), [shadowColor,primaryColor], [0,0.75]);
canvas.drawPath(path_30,paint30Fill);

Path path_31 = Path();
path_31.moveTo(size.width*-0.01820942,size.height*0.7295955);
path_31.lineTo(size.width*-0.004142667,size.height*0.7210477);
path_31.lineTo(size.width*0.009924083,size.height*0.7295955);
path_31.lineTo(size.width*-0.01820942,size.height*0.7295955);
path_31.close();

Paint paint31Fill = Paint()..style=PaintingStyle.fill;
paint31Fill.shader = ui.Gradient.linear(Offset(size.width*-0.4142667,size.height*0.9286658), Offset(size.width*-0.4142667,size.height*0.7958354), [shadowColor,primaryColor], [0,0.75]);
canvas.drawPath(path_31,paint31Fill);

Path path_32 = Path();
path_32.moveTo(size.width*0.02786750,size.height*0.7356621);
path_32.lineTo(size.width*0.01350844,size.height*0.7295955);
path_32.lineTo(size.width*0.01350844,size.height*1.000406);
path_32.lineTo(size.width*0.03031500,size.height*1.000406);
path_32.lineTo(size.width*0.02786750,size.height*0.7356621);
path_32.close();

Paint paint32Fill = Paint()..style=PaintingStyle.fill;
paint32Fill.shader = ui.Gradient.linear(Offset(size.width*0.02191169,size.height*0.9395415), Offset(size.width*0.02191169,size.height*0.7430477), [shadowColor,secenderyColor], [0,0.75]);
canvas.drawPath(path_32,paint32Fill);

Path path_33 = Path();
path_33.moveTo(size.width*-0.004142667,size.height*0.7210477);
path_33.lineTo(size.width*0.009924083,size.height*0.7295955);
path_33.lineTo(size.width*0.002192278,size.height*0.7295955);
path_33.lineTo(size.width*-0.004142667,size.height*0.7210477);
path_33.close();

Paint paint33Fill = Paint()..style=PaintingStyle.fill;
paint33Fill.shader = ui.Gradient.linear(Offset(size.width*0.03188333,size.height*0.7163480), Offset(size.width*0.005675694,size.height*0.7350201), [shadowColor,secenderyColor], [0,0.75]);
canvas.drawPath(path_33,paint33Fill);

Path path_34 = Path();
path_34.moveTo(size.width*0.07260194,size.height*0.7456068);
path_34.lineTo(size.width*0.07260194,size.height*1.000407);
path_34.lineTo(size.width*0.08697194,size.height*1.000407);
path_34.lineTo(size.width*0.08697194,size.height*0.7516746);
path_34.lineTo(size.width*0.07260194,size.height*0.7456068);
path_34.close();

Paint paint34Fill = Paint()..style=PaintingStyle.fill;
paint34Fill.shader = ui.Gradient.linear(Offset(size.width*0.07978139,size.height*0.9933731), Offset(size.width*0.07978139,size.height*0.6820214), [shadowColor,secenderyColor], [0,0.75]);
canvas.drawPath(path_34,paint34Fill);

Path path_35 = Path();
path_35.moveTo(size.width*0.05495083,size.height*0.7370540);
path_35.lineTo(size.width*0.06901750,size.height*0.7456068);
path_35.lineTo(size.width*0.06273667,size.height*0.7456068);
path_35.lineTo(size.width*0.05495083,size.height*0.7370540);
path_35.close();

Paint paint35Fill = Paint()..style=PaintingStyle.fill;
paint35Fill.shader = ui.Gradient.linear(Offset(size.width*0.03828500,size.height*0.7261156), Offset(size.width*0.07758972,size.height*0.7538430), [shadowColor,secenderyColor], [0,0.75]);
canvas.drawPath(path_35,paint35Fill);

Path path_36 = Path();
path_36.moveTo(size.width*0.1132428,size.height*0.7550063);
path_36.lineTo(size.width*0.1209314,size.height*0.7635590);
path_36.lineTo(size.width*0.1273094,size.height*0.7635590);
path_36.lineTo(size.width*0.1132428,size.height*0.7550063);
path_36.close();

Paint paint36Fill = Paint()..style=PaintingStyle.fill;
paint36Fill.shader = ui.Gradient.linear(Offset(size.width*0.09654472,size.height*0.7440779), Offset(size.width*0.1358494,size.height*0.7718053), [shadowColor,secenderyColor], [0,0.75]);
canvas.drawPath(path_36,paint36Fill);

Path path_37 = Path();
path_37.moveTo(size.width*0.1309047,size.height*0.7635590);
path_37.lineTo(size.width*0.1452639,size.height*0.7696219);
path_37.lineTo(size.width*0.1452639,size.height*1.000407);
path_37.lineTo(size.width*0.1309047,size.height*1.000407);
path_37.lineTo(size.width*0.1309047,size.height*0.7635590);
path_37.close();

Paint paint37Fill = Paint()..style=PaintingStyle.fill;
paint37Fill.shader = ui.Gradient.linear(Offset(size.width*0.1380844,size.height*0.9735540), Offset(size.width*0.1380844,size.height*0.7271445), [shadowColor,secenderyColor], [0,0.75]);
canvas.drawPath(path_37,paint37Fill);

Path path_38 = Path();
path_38.moveTo(size.width*-0.01685578,size.height*1.000406);
path_38.lineTo(size.width*0.09863472,size.height*1.000406);
path_38.lineTo(size.width*0.09863472,size.height*0.8698015);
path_38.lineTo(size.width*0.08307333,size.height*0.8675905);
path_38.lineTo(size.width*0.06093917,size.height*0.8662915);
path_38.lineTo(size.width*-0.01685578,size.height*0.8662915);
path_38.lineTo(size.width*-0.01685578,size.height*1.000406);
path_38.close();

Paint paint38Fill = Paint()..style=PaintingStyle.fill;
paint38Fill.shader = ui.Gradient.linear(Offset(size.width*0.04088389,size.height*0.9286658), Offset(size.width*0.04088389,size.height*0.7958354), [shadowColor,primaryColor], [0,0.75]);
canvas.drawPath(path_38,paint38Fill);

Path path_39 = Path();
path_39.moveTo(size.width*0.06579056,size.height*0.8662915);
path_39.lineTo(size.width*-0.01685578,size.height*0.8662915);
path_39.lineTo(size.width*-0.01685578,size.height*1.000406);
path_39.lineTo(size.width*0.06579056,size.height*1.000406);
path_39.lineTo(size.width*0.06579056,size.height*0.8662915);
path_39.close();

Paint paint39Fill = Paint()..style=PaintingStyle.fill;
paint39Fill.shader = ui.Gradient.linear(Offset(size.width*0.02446736,size.height*0.9904912), Offset(size.width*0.02446736,size.height*0.8331859), [shadowColor,secenderyColor], [0,0.75]);
canvas.drawPath(path_39,paint39Fill);

Path path_40 = Path();
path_40.moveTo(size.width*0.1519561,size.height*0.8171709);
path_40.lineTo(size.width*0.1346083,size.height*0.8218995);
path_40.lineTo(size.width*0.1346083,size.height*1.006955);
path_40.lineTo(size.width*0.1519561,size.height*1.006955);
path_40.lineTo(size.width*0.1519561,size.height*0.8171709);
path_40.close();

Paint paint40Fill = Paint()..style=PaintingStyle.fill;
paint40Fill.shader = ui.Gradient.linear(Offset(size.width*0.1432822,size.height*1.059121), Offset(size.width*0.1432822,size.height*0.7180000), [shadowColor,secenderyColor], [0,0.75]);
canvas.drawPath(path_40,paint40Fill);

Path path_41 = Path();
path_41.moveTo(size.width*1.048200,size.height*1.006955);
path_41.lineTo(size.width*0.9566417,size.height*1.006955);
path_41.lineTo(size.width*0.9566417,size.height*0.8218995);
path_41.lineTo(size.width*0.9739889,size.height*0.8171709);
path_41.lineTo(size.width*1.048200,size.height*0.8171709);
path_41.lineTo(size.width*1.048200,size.height*1.006955);
path_41.close();

Paint paint41Fill = Paint()..style=PaintingStyle.fill;
paint41Fill.shader = ui.Gradient.linear(Offset(size.width*1.002417,size.height*0.9286671), Offset(size.width*1.002417,size.height*0.7958367), [shadowColor,primaryColor], [0,0.75]);
canvas.drawPath(path_41,paint41Fill);

Path path_42 = Path();
path_42.moveTo(size.width*0.3199139,size.height*0.7174698);
path_42.lineTo(size.width*0.2967833,size.height*0.7235967);
path_42.lineTo(size.width*0.2967833,size.height*1.006954);
path_42.lineTo(size.width*0.3199139,size.height*1.006954);
path_42.lineTo(size.width*0.3199139,size.height*0.7174698);
path_42.close();

Paint paint42Fill = Paint()..style=PaintingStyle.fill;
paint42Fill.shader = ui.Gradient.linear(Offset(size.width*0.3083472,size.height*0.9949322), Offset(size.width*0.3083472,size.height*0.6683631), [shadowColor,secenderyColor], [0,0.75]);
canvas.drawPath(path_42,paint42Fill);

Path path_43 = Path();
path_43.moveTo(size.width*0.5751583,size.height*0.6992136);
path_43.lineTo(size.width*0.5751583,size.height*1.006533);
path_43.lineTo(size.width*0.5194444,size.height*1.006533);
path_43.lineTo(size.width*0.5194444,size.height*0.7032173);
path_43.lineTo(size.width*0.5751583,size.height*0.6992136);
path_43.close();

Paint paint43Fill = Paint()..style=PaintingStyle.fill;
paint43Fill.shader = ui.Gradient.linear(Offset(size.width*0.5473083,size.height*0.8859397), Offset(size.width*0.5473083,size.height*0.6346683), [shadowColor,secenderyColor], [0,0.75]);
canvas.drawPath(path_43,paint43Fill);

Path path_44 = Path();
path_44.moveTo(size.width*0.5671778,size.height*1.006533);
path_44.lineTo(size.width*0.6214306,size.height*1.006533);
path_44.lineTo(size.width*0.6214306,size.height*0.8153857);
path_44.lineTo(size.width*0.5998917,size.height*0.8090779);
path_44.lineTo(size.width*0.5671778,size.height*0.8090779);
path_44.lineTo(size.width*0.5671778,size.height*1.006533);
path_44.close();

Paint paint44Fill = Paint()..style=PaintingStyle.fill;
paint44Fill.shader = ui.Gradient.linear(Offset(size.width*0.5943056,size.height*0.9286658), Offset(size.width*0.5943056,size.height*0.7958354), [shadowColor,primaryColor], [0,0.75]);
canvas.drawPath(path_44,paint44Fill);

Path path_45 = Path();
path_45.moveTo(size.width*0.5917278,size.height*0.8090779);
path_45.lineTo(size.width*0.6132667,size.height*0.8153857);
path_45.lineTo(size.width*0.6132667,size.height*1.006533);
path_45.lineTo(size.width*0.5917278,size.height*1.006533);
path_45.lineTo(size.width*0.5917278,size.height*0.8090779);
path_45.close();

Paint paint45Fill = Paint()..style=PaintingStyle.fill;
paint45Fill.shader = ui.Gradient.linear(Offset(size.width*0.6025028,size.height*1.017138), Offset(size.width*0.6025028,size.height*0.7340553), [shadowColor,secenderyColor], [0,0.75]);
canvas.drawPath(path_45,paint45Fill);

Path path_46 = Path();
path_46.moveTo(size.width*0.6825500,size.height*0.8348769);
path_46.lineTo(size.width*0.7016944,size.height*0.8404548);
path_46.lineTo(size.width*0.7016944,size.height*1.006955);
path_46.lineTo(size.width*0.6825500,size.height*1.006955);
path_46.lineTo(size.width*0.6825500,size.height*0.8348769);
path_46.close();

Paint paint46Fill = Paint()..style=PaintingStyle.fill;
paint46Fill.shader = ui.Gradient.linear(Offset(size.width*0.6921222,size.height*1.087643), Offset(size.width*0.6921222,size.height*0.7335063), [shadowColor,secenderyColor], [0,0.75]);
canvas.drawPath(path_46,paint46Fill);

Path path_47 = Path();
path_47.moveTo(size.width*0.7916750,size.height*1.006954);
path_47.lineTo(size.width*0.8997889,size.height*1.006954);
path_47.lineTo(size.width*0.8997889,size.height*0.8640226);
path_47.lineTo(size.width*0.8772222,size.height*0.8595427);
path_47.lineTo(size.width*0.7916750,size.height*0.8595427);
path_47.lineTo(size.width*0.7916750,size.height*1.006954);
path_47.close();

Paint paint47Fill = Paint()..style=PaintingStyle.fill;
paint47Fill.shader = ui.Gradient.linear(Offset(size.width*0.8457333,size.height*0.9286658), Offset(size.width*0.8457333,size.height*0.7958354), [shadowColor,primaryColor], [0,0.75]);
canvas.drawPath(path_47,paint47Fill);

Path path_48 = Path();
path_48.moveTo(size.width*0.8772222,size.height*0.8595427);
path_48.lineTo(size.width*0.8997917,size.height*0.8640226);
path_48.lineTo(size.width*0.8997917,size.height*1.006954);
path_48.lineTo(size.width*0.8772222,size.height*1.006954);
path_48.lineTo(size.width*0.8772222,size.height*0.8595427);
path_48.close();

Paint paint48Fill = Paint()..style=PaintingStyle.fill;
paint48Fill.shader = ui.Gradient.linear(Offset(size.width*0.8885056,size.height*1.076077), Offset(size.width*0.8885056,size.height*0.7727035), [shadowColor,secenderyColor], [0,0.75]);
canvas.drawPath(path_48,paint48Fill);

Path path_49 = Path();
path_49.moveTo(size.width*0.7765139,size.height*0.7771432);
path_49.lineTo(size.width*0.7900833,size.height*0.7793241);
path_49.lineTo(size.width*0.7900833,size.height*1.009139);
path_49.lineTo(size.width*0.7765139,size.height*1.009139);
path_49.lineTo(size.width*0.7765139,size.height*0.7771432);
path_49.close();

Paint paint49Fill = Paint()..style=PaintingStyle.fill;
paint49Fill.shader = ui.Gradient.linear(Offset(size.width*0.7832917,size.height*1.117926), Offset(size.width*0.7832917,size.height*0.6404761), [shadowColor,secenderyColor], [0,0.75]);
canvas.drawPath(path_49,paint49Fill);

Path path_50 = Path();
path_50.moveTo(size.width*0.7659444,size.height*0.7727776);
path_50.lineTo(size.width*0.7671806,size.height*0.7729535);
path_50.lineTo(size.width*0.7749222,size.height*0.7740515);
path_50.lineTo(size.width*0.7749222,size.height*0.7771445);
path_50.lineTo(size.width*0.7659444,size.height*0.7771445);

Paint paint50Fill = Paint()..style=PaintingStyle.fill;
paint50Fill.shader = ui.Gradient.linear(Offset(size.width*0.7704278,size.height*0.7791884), Offset(size.width*0.7704278,size.height*0.7702048), [shadowColor,secenderyColor], [0,0.75]);
canvas.drawPath(path_50,paint50Fill);

Path path_51 = Path();
path_51.moveTo(size.width*0.9746722,size.height*0.8067362);
path_51.lineTo(size.width*0.9746722,size.height*1.006955);
path_51.lineTo(size.width*0.9979333,size.height*1.006955);
path_51.lineTo(size.width*0.9979333,size.height*0.8118970);
path_51.lineTo(size.width*0.9746722,size.height*0.8067362);
path_51.close();

Paint paint51Fill = Paint()..style=PaintingStyle.fill;
paint51Fill.shader = ui.Gradient.linear(Offset(size.width*0.9863028,size.height*1.039408), Offset(size.width*0.9863028,size.height*0.6444171), [shadowColor,secenderyColor], [0,0.75]);
canvas.drawPath(path_51,paint51Fill);

Path path_52 = Path();
path_52.moveTo(size.width*0.9432806,size.height*0.7645289);
path_52.lineTo(size.width*0.9432806,size.height*0.8067362);
path_52.lineTo(size.width*0.9656194,size.height*0.8067362);
path_52.lineTo(size.width*0.9656194,size.height*0.7681658);
path_52.lineTo(size.width*0.9432806,size.height*0.7645289);
path_52.close();

Paint paint52Fill = Paint()..style=PaintingStyle.fill;
paint52Fill.shader = ui.Gradient.linear(Offset(size.width*0.9544444,size.height*0.9846156), Offset(size.width*0.9544444,size.height*0.6826394), [shadowColor,secenderyColor], [0,0.75]);
canvas.drawPath(path_52,paint52Fill);

Path path_53 = Path();
path_53.moveTo(size.width*1.182619,size.height*1.006954);
path_53.lineTo(size.width*0.9863444,size.height*1.006954);
path_53.lineTo(size.width*0.9863444,size.height*0.8730013);
path_53.lineTo(size.width*1.159358,size.height*0.8730013);
path_53.lineTo(size.width*1.182619,size.height*0.8764523);
path_53.lineTo(size.width*1.182619,size.height*1.006954);
path_53.close();

Paint paint53Fill = Paint()..style=PaintingStyle.fill;
paint53Fill.shader = ui.Gradient.linear(Offset(size.width*1.084478,size.height*0.9286658), Offset(size.width*1.084478,size.height*0.7958367), [shadowColor,primaryColor], [0,0.75]);
canvas.drawPath(path_53,paint53Fill);

Path path_54 = Path();
path_54.moveTo(size.width*0.9245972,size.height*1.006954);
path_54.lineTo(size.width*1.118706,size.height*1.006954);
path_54.lineTo(size.width*1.118706,size.height*0.7104912);
path_54.lineTo(size.width*0.9494167,size.height*0.7104912);
path_54.lineTo(size.width*0.9245972,size.height*0.7119271);
path_54.lineTo(size.width*0.9245972,size.height*1.006954);
path_54.close();

Paint paint54Fill = Paint()..style=PaintingStyle.fill;
paint54Fill.shader = ui.Gradient.linear(Offset(size.width*1.021656,size.height*0.9286658), Offset(size.width*1.021656,size.height*0.7958354), [shadowColor,primaryColor], [0,0.75]);
canvas.drawPath(path_54,paint54Fill);

Path path_55 = Path();
path_55.moveTo(size.width*0.9412528,size.height*0.7104912);
path_55.lineTo(size.width*0.9164333,size.height*0.7119271);
path_55.lineTo(size.width*0.9164333,size.height*1.005920);
path_55.lineTo(size.width*0.9412528,size.height*1.005920);
path_55.lineTo(size.width*0.9412528,size.height*0.7104912);
path_55.close();

Paint paint55Fill = Paint()..style=PaintingStyle.fill;
paint55Fill.shader = ui.Gradient.linear(Offset(size.width*0.9288444,size.height*0.9286658), Offset(size.width*0.9288444,size.height*0.7958354), [shadowColor,primaryColor], [0,0.75]);
canvas.drawPath(path_55,paint55Fill);

Path path_56 = Path();
path_56.moveTo(size.width*0.9515750,size.height*0.7104912);
path_56.lineTo(size.width*1.082094,size.height*0.7104912);
path_56.lineTo(size.width*1.082094,size.height*0.7017638);
path_56.lineTo(size.width*0.9887722,size.height*0.7017638);
path_56.lineTo(size.width*0.9515750,size.height*0.7038606);
path_56.lineTo(size.width*0.9515750,size.height*0.7104912);
path_56.close();

Paint paint56Fill = Paint()..style=PaintingStyle.fill;
paint56Fill.shader = ui.Gradient.linear(Offset(size.width*1.016839,size.height*0.9286671), Offset(size.width*1.016839,size.height*0.7958367), [shadowColor,primaryColor], [0,0.75]);
canvas.drawPath(path_56,paint56Fill);

Path path_57 = Path();
path_57.moveTo(size.width*0.9969333,size.height*0.7017638);
path_57.lineTo(size.width*0.9969333,size.height*0.7104912);
path_57.lineTo(size.width*0.9597361,size.height*0.7104912);
path_57.lineTo(size.width*0.9597361,size.height*0.7038606);
path_57.lineTo(size.width*0.9969333,size.height*0.7017638);
path_57.close();

Paint paint57Fill = Paint()..style=PaintingStyle.fill;
paint57Fill.shader = ui.Gradient.linear(Offset(size.width*0.9783417,size.height*0.9286671), Offset(size.width*0.9783417,size.height*0.7958367), [shadowColor,primaryColor], [0,0.75]);
canvas.drawPath(path_57,paint57Fill);

Path path_58 = Path();
path_58.moveTo(size.width*1.033733,size.height*0.8920754);
path_58.lineTo(size.width*0.8911056,size.height*0.8920754);
path_58.lineTo(size.width*0.8911056,size.height*0.8567588);
path_58.lineTo(size.width*1.011392,size.height*0.8567588);
path_58.lineTo(size.width*1.033733,size.height*0.8590138);
path_58.lineTo(size.width*1.033733,size.height*0.8920754);
path_58.close();

Paint paint58Fill = Paint()..style=PaintingStyle.fill;
paint58Fill.shader = ui.Gradient.linear(Offset(size.width*0.9624250,size.height*0.9286658), Offset(size.width*0.9624250,size.height*0.7958354), [shadowColor,primaryColor], [0,0.75]);
canvas.drawPath(path_58,paint58Fill);

Path path_59 = Path();
path_59.moveTo(size.width*1.066047,size.height*1.006954);
path_59.lineTo(size.width*0.8697611,size.height*1.006954);
path_59.lineTo(size.width*0.8697611,size.height*0.8829108);
path_59.lineTo(size.width*1.042786,size.height*0.8829108);
path_59.lineTo(size.width*1.066047,size.height*0.8861055);
path_59.lineTo(size.width*1.066047,size.height*1.006954);
path_59.close();

Paint paint59Fill = Paint()..style=PaintingStyle.fill;
paint59Fill.shader = ui.Gradient.linear(Offset(size.width*0.9679056,size.height*0.9286658), Offset(size.width*0.9679056,size.height*0.7958354), [shadowColor,primaryColor], [0,0.75]);
canvas.drawPath(path_59,paint59Fill);

Path path_60 = Path();
path_60.moveTo(size.width*0.8943000,size.height*0.5889083);
path_60.lineTo(size.width*0.8943000,size.height*0.5902814);

Paint paint60Stroke = Paint()..style=PaintingStyle.stroke..strokeWidth=size.width*0.003111111;
paint60Stroke.color=Colors.white.withValues(alpha:1.0);
canvas.drawPath(path_60,paint60Stroke);

Paint paint60Fill = Paint()..style=PaintingStyle.fill;
paint60Fill.color = primaryColor;
canvas.drawPath(path_60,paint60Fill);

Path path_61 = Path();
path_61.moveTo(size.width*0.8943000,size.height*0.5930314);
path_61.lineTo(size.width*0.8943000,size.height*0.8448756);

Paint paint61Stroke = Paint()..style=PaintingStyle.stroke..strokeWidth=size.width*0.003111111;
paint61Stroke.color=Colors.white.withValues(alpha:1.0);
canvas.drawPath(path_61,paint61Stroke);

Paint paint61Fill = Paint()..style=PaintingStyle.fill;
paint61Fill.color = primaryColor;
canvas.drawPath(path_61,paint61Fill);

Path path_62 = Path();
path_62.moveTo(size.width*0.8943000,size.height*0.8462525);
path_62.lineTo(size.width*0.8943000,size.height*0.8476206);

Paint paint62Stroke = Paint()..style=PaintingStyle.stroke..strokeWidth=size.width*0.003111111;
paint62Stroke.color=Colors.white.withValues(alpha:1.0);
canvas.drawPath(path_62,paint62Stroke);

Paint paint62Fill = Paint()..style=PaintingStyle.fill;
paint62Fill.color = primaryColor;
canvas.drawPath(path_62,paint62Fill);

Path path_63 = Path();
path_63.moveTo(size.width*0.2449872,size.height*0.6294246);
path_63.lineTo(size.width*0.2449872,size.height*0.6300276);

Paint paint63Stroke = Paint()..style=PaintingStyle.stroke..strokeWidth=size.width*0.001361111;
paint63Stroke.color=Colors.white.withValues(alpha:1.0);
canvas.drawPath(path_63,paint63Stroke);

Paint paint63Fill = Paint()..style=PaintingStyle.fill;
paint63Fill.color = primaryColor;
canvas.drawPath(path_63,paint63Fill);

Path path_64 = Path();
path_64.moveTo(size.width*0.2449872,size.height*0.6312186);
path_64.lineTo(size.width*0.2449872,size.height*0.6783807);

Paint paint64Stroke = Paint()..style=PaintingStyle.stroke..strokeWidth=size.width*0.001361111;
paint64Stroke.color=Colors.white.withValues(alpha:1.0);
canvas.drawPath(path_64,paint64Stroke);

Paint paint64Fill = Paint()..style=PaintingStyle.fill;
paint64Fill.color = primaryColor;
canvas.drawPath(path_64,paint64Fill);

Path path_65 = Path();
path_65.moveTo(size.width*0.2449872,size.height*0.6789786);
path_65.lineTo(size.width*0.2449872,size.height*0.6795817);

Paint paint65Stroke = Paint()..style=PaintingStyle.stroke..strokeWidth=size.width*0.001361111;
paint65Stroke.color=Colors.white.withValues(alpha:1.0);
canvas.drawPath(path_65,paint65Stroke);

Paint paint65Fill = Paint()..style=PaintingStyle.fill;
paint65Fill.color = primaryColor;
canvas.drawPath(path_65,paint65Fill);

Path path_66 = Path();
path_66.moveTo(size.width*0.6273139,size.height*0.6087575);
path_66.lineTo(size.width*0.6273139,size.height*0.6098166);

Paint paint66Stroke = Paint()..style=PaintingStyle.stroke..strokeWidth=size.width*0.002388889;
paint66Stroke.color=Colors.white.withValues(alpha:1.0);
canvas.drawPath(path_66,paint66Stroke);

Paint paint66Fill = Paint()..style=PaintingStyle.fill;
paint66Fill.color = primaryColor;
canvas.drawPath(path_66,paint66Fill);

Path path_67 = Path();
path_67.moveTo(size.width*0.6273139,size.height*0.6119535);
path_67.lineTo(size.width*0.6273028,size.height*0.7605754);

Paint paint67Stroke = Paint()..style=PaintingStyle.stroke..strokeWidth=size.width*0.002388889;
paint67Stroke.color=Colors.white.withValues(alpha:1.0);
canvas.drawPath(path_67,paint67Stroke);

Paint paint67Fill = Paint()..style=PaintingStyle.fill;
paint67Fill.color = primaryColor;
canvas.drawPath(path_67,paint67Fill);

Path path_68 = Path();
path_68.moveTo(size.width*0.6273028,size.height*0.7616432);
path_68.lineTo(size.width*0.6273028,size.height*0.7626960);

Paint paint68Stroke = Paint()..style=PaintingStyle.stroke..strokeWidth=size.width*0.002388889;
paint68Stroke.color=Colors.white.withValues(alpha:1.0);
canvas.drawPath(path_68,paint68Stroke);

Paint paint68Fill = Paint()..style=PaintingStyle.fill;
paint68Fill.color = primaryColor;
canvas.drawPath(path_68,paint68Fill);

Path path_69 = Path();
path_69.moveTo(size.width*0.8386389,size.height*0.7167852);
path_69.lineTo(size.width*0.8386389,size.height*0.7173141);

Paint paint69Stroke = Paint()..style=PaintingStyle.stroke..strokeWidth=size.width*0.001194444;
paint69Stroke.color=Colors.white.withValues(alpha:1.0);
canvas.drawPath(path_69,paint69Stroke);

Paint paint69Fill = Paint()..style=PaintingStyle.fill;
paint69Fill.color = primaryColor;
canvas.drawPath(path_69,paint69Fill);

Path path_70 = Path();
path_70.moveTo(size.width*0.8386389,size.height*0.7183869);
path_70.lineTo(size.width*0.8386389,size.height*0.7543254);

Paint paint70Stroke = Paint()..style=PaintingStyle.stroke..strokeWidth=size.width*0.001194444;
paint70Stroke.color=Colors.white.withValues(alpha:1.0);
canvas.drawPath(path_70,paint70Stroke);

Paint paint70Fill = Paint()..style=PaintingStyle.fill;
paint70Fill.color = primaryColor;
canvas.drawPath(path_70,paint70Fill);

Path path_71 = Path();
path_71.moveTo(size.width*0.8386389,size.height*0.7548593);
path_71.lineTo(size.width*0.8386389,size.height*0.7553882);

Paint paint71Stroke = Paint()..style=PaintingStyle.stroke..strokeWidth=size.width*0.001194444;
paint71Stroke.color=Colors.white.withValues(alpha:1.0);
canvas.drawPath(path_71,paint71Stroke);

Paint paint71Fill = Paint()..style=PaintingStyle.fill;
paint71Fill.color = primaryColor;
canvas.drawPath(path_71,paint71Fill);

Path path_72 = Path();
path_72.moveTo(size.width*0.5628694,size.height*0.6479359);
path_72.lineTo(size.width*0.5628694,size.height*0.6484648);

Paint paint72Stroke = Paint()..style=PaintingStyle.stroke..strokeWidth=size.width*0.001194444;
paint72Stroke.color=Colors.white.withValues(alpha:1.0);
canvas.drawPath(path_72,paint72Stroke);

Paint paint72Fill = Paint()..style=PaintingStyle.fill;
paint72Fill.color = primaryColor;
canvas.drawPath(path_72,paint72Fill);

Path path_73 = Path();
path_73.moveTo(size.width*0.5628694,size.height*0.6495377);
path_73.lineTo(size.width*0.5628694,size.height*0.6854761);

Paint paint73Stroke = Paint()..style=PaintingStyle.stroke..strokeWidth=size.width*0.001194444;
paint73Stroke.color=Colors.white.withValues(alpha:1.0);
canvas.drawPath(path_73,paint73Stroke);

Paint paint73Fill = Paint()..style=PaintingStyle.fill;
paint73Fill.color = primaryColor;
canvas.drawPath(path_73,paint73Fill);

Path path_74 = Path();
path_74.moveTo(size.width*0.5628694,size.height*0.6860101);
path_74.lineTo(size.width*0.5628694,size.height*0.6865402);

Paint paint74Stroke = Paint()..style=PaintingStyle.stroke..strokeWidth=size.width*0.001194444;
paint74Stroke.color=Colors.white.withValues(alpha:1.0);
canvas.drawPath(path_74,paint74Stroke);

Paint paint74Fill = Paint()..style=PaintingStyle.fill;
paint74Fill.color = primaryColor;
canvas.drawPath(path_74,paint74Fill);

Path path_75 = Path();
path_75.moveTo(size.width*0.6760000,size.height*0.5652186);
path_75.cubicTo(size.width*0.6760000,size.height*0.5530490,size.width*0.6542000,size.height*0.5431834,size.width*0.6273139,size.height*0.5431834);
path_75.cubicTo(size.width*0.6004250,size.height*0.5431834,size.width*0.5786250,size.height*0.5530490,size.width*0.5786250,size.height*0.5652186);
path_75.cubicTo(size.width*0.5786250,size.height*0.5659234,size.width*0.5787028,size.height*0.5666244,size.width*0.5788417,size.height*0.5673153);
path_75.cubicTo(size.width*0.5784000,size.height*0.5810829,size.width*0.6273139,size.height*0.6087575,size.width*0.6273139,size.height*0.6087575);
path_75.cubicTo(size.width*0.6273139,size.height*0.6087575,size.width*0.6762389,size.height*0.5810829,size.width*0.6757833,size.height*0.5673153);
path_75.cubicTo(size.width*0.6759250,size.height*0.5666244,size.width*0.6760000,size.height*0.5659234,size.width*0.6760000,size.height*0.5652186);
path_75.close();
path_75.moveTo(size.width*0.6273139,size.height*0.5729761);
path_75.cubicTo(size.width*0.6178500,size.height*0.5729761,size.width*0.6101722,size.height*0.5695013,size.width*0.6101722,size.height*0.5652186);
path_75.cubicTo(size.width*0.6101722,size.height*0.5609347,size.width*0.6178500,size.height*0.5574598,size.width*0.6273139,size.height*0.5574598);
path_75.cubicTo(size.width*0.6367778,size.height*0.5574598,size.width*0.6444556,size.height*0.5609347,size.width*0.6444556,size.height*0.5652186);
path_75.cubicTo(size.width*0.6444556,size.height*0.5695013,size.width*0.6367778,size.height*0.5729761,size.width*0.6273139,size.height*0.5729761);
path_75.close();

Paint paint75Fill = Paint()..style=PaintingStyle.fill;
paint75Fill.color = const Color(0xffD6D6D6).withValues(alpha:1.0);
canvas.drawPath(path_75,paint75Fill);

Path path_76 = Path();
path_76.moveTo(size.width*0.2763806,size.height*0.5997312);
path_76.cubicTo(size.width*0.2763806,size.height*0.5918844,size.width*0.2623244,size.height*0.5855226,size.width*0.2449875,size.height*0.5855226);
path_76.cubicTo(size.width*0.2276503,size.height*0.5855226,size.width*0.2135944,size.height*0.5918844,size.width*0.2135944,size.height*0.5997312);
path_76.cubicTo(size.width*0.2135944,size.height*0.6001859,size.width*0.2136378,size.height*0.6006369,size.width*0.2137353,size.height*0.6010829);
path_76.cubicTo(size.width*0.2134428,size.height*0.6099585,size.width*0.2449875,size.height*0.6278028,size.width*0.2449875,size.height*0.6278028);
path_76.cubicTo(size.width*0.2449875,size.height*0.6278028,size.width*0.2765214,size.height*0.6099636,size.width*0.2762397,size.height*0.6010829);
path_76.cubicTo(size.width*0.2763372,size.height*0.6006369,size.width*0.2763806,size.height*0.6001859,size.width*0.2763806,size.height*0.5997312);
path_76.close();
path_76.moveTo(size.width*0.2449875,size.height*0.6047349);
path_76.cubicTo(size.width*0.2388800,size.height*0.6047349,size.width*0.2339311,size.height*0.6024950,size.width*0.2339311,size.height*0.5997312);
path_76.cubicTo(size.width*0.2339311,size.height*0.5969661,size.width*0.2388800,size.height*0.5947274,size.width*0.2449875,size.height*0.5947274);
path_76.cubicTo(size.width*0.2510950,size.height*0.5947274,size.width*0.2560436,size.height*0.5969661,size.width*0.2560436,size.height*0.5997312);
path_76.cubicTo(size.width*0.2560436,size.height*0.6024950,size.width*0.2510950,size.height*0.6047349,size.width*0.2449875,size.height*0.6047349);
path_76.close();

Paint paint76Fill = Paint()..style=PaintingStyle.fill;
paint76Fill.color = const Color(0xffD6D6D6).withValues(alpha:1.0);
canvas.drawPath(path_76,paint76Fill);

Path path_77 = Path();
path_77.moveTo(size.width*0.9340861,size.height*0.5581746);
path_77.cubicTo(size.width*0.9340861,size.height*0.5487362,size.width*0.9171806,size.height*0.5410854,size.width*0.8963250,size.height*0.5410854);
path_77.cubicTo(size.width*0.8754694,size.height*0.5410854,size.width*0.8585639,size.height*0.5487362,size.width*0.8585639,size.height*0.5581746);
path_77.cubicTo(size.width*0.8585639,size.height*0.5587236,size.width*0.8586194,size.height*0.5592676,size.width*0.8587389,size.height*0.5598028);
path_77.cubicTo(size.width*0.8583917,size.height*0.5704761,size.width*0.8963250,size.height*0.5919372,size.width*0.8963250,size.height*0.5919372);
path_77.cubicTo(size.width*0.8963250,size.height*0.5919372,size.width*0.9342583,size.height*0.5704761,size.width*0.9339111,size.height*0.5598028);
path_77.cubicTo(size.width*0.9340194,size.height*0.5592676,size.width*0.9340861,size.height*0.5587236,size.width*0.9340861,size.height*0.5581746);
path_77.close();
path_77.moveTo(size.width*0.8963250,size.height*0.5641935);
path_77.cubicTo(size.width*0.8889833,size.height*0.5641935,size.width*0.8830278,size.height*0.5614975,size.width*0.8830278,size.height*0.5581746);
path_77.cubicTo(size.width*0.8830278,size.height*0.5548518,size.width*0.8889833,size.height*0.5521570,size.width*0.8963250,size.height*0.5521570);
path_77.cubicTo(size.width*0.9036667,size.height*0.5521570,size.width*0.9096222,size.height*0.5548518,size.width*0.9096222,size.height*0.5581746);
path_77.cubicTo(size.width*0.9096222,size.height*0.5614975,size.width*0.9036667,size.height*0.5641935,size.width*0.8963250,size.height*0.5641935);
path_77.close();

Paint paint77Fill = Paint()..style=PaintingStyle.fill;
paint77Fill.color = Colors.white.withValues(alpha:1.0);
canvas.drawPath(path_77,paint77Fill);

Path path_78 = Path();
path_78.moveTo(size.width*0.8577083,size.height*0.6999447);
path_78.cubicTo(size.width*0.8577083,size.height*0.6951759,size.width*0.8491639,size.height*0.6913141,size.width*0.8386389,size.height*0.6913141);
path_78.cubicTo(size.width*0.8281139,size.height*0.6913141,size.width*0.8195694,size.height*0.6951809,size.width*0.8195694,size.height*0.6999447);
path_78.cubicTo(size.width*0.8195694,size.height*0.7002198,size.width*0.8196028,size.height*0.7004937,size.width*0.8196556,size.height*0.7007676);
path_78.cubicTo(size.width*0.8194833,size.height*0.7061595,size.width*0.8386389,size.height*0.7170050,size.width*0.8386389,size.height*0.7170050);
path_78.cubicTo(size.width*0.8386389,size.height*0.7170050,size.width*0.8578056,size.height*0.7061646,size.width*0.8576222,size.height*0.7007676);
path_78.cubicTo(size.width*0.8576778,size.height*0.7004987,size.width*0.8577083,size.height*0.7002236,size.width*0.8577083,size.height*0.6999447);
path_78.close();
path_78.moveTo(size.width*0.8386389,size.height*0.7029837);
path_78.cubicTo(size.width*0.8349361,size.height*0.7029837,size.width*0.8319250,size.height*0.7016206,size.width*0.8319250,size.height*0.6999447);
path_78.cubicTo(size.width*0.8319250,size.height*0.6982688,size.width*0.8349361,size.height*0.6969058,size.width*0.8386389,size.height*0.6969058);
path_78.cubicTo(size.width*0.8423417,size.height*0.6969058,size.width*0.8453528,size.height*0.6982688,size.width*0.8453528,size.height*0.6999447);
path_78.cubicTo(size.width*0.8453528,size.height*0.7016206,size.width*0.8423417,size.height*0.7029837,size.width*0.8386389,size.height*0.7029837);
path_78.close();

Paint paint78Fill = Paint()..style=PaintingStyle.fill;
paint78Fill.color = colorOne;
canvas.drawPath(path_78,paint78Fill);

Path path_79 = Path();
path_79.moveTo(size.width*0.5819389,size.height*0.6310967);
path_79.cubicTo(size.width*0.5819389,size.height*0.6263291,size.width*0.5733944,size.height*0.6224661,size.width*0.5628694,size.height*0.6224661);
path_79.cubicTo(size.width*0.5523444,size.height*0.6224661,size.width*0.5438000,size.height*0.6263329,size.width*0.5438000,size.height*0.6310967);
path_79.cubicTo(size.width*0.5438000,size.height*0.6313719,size.width*0.5438333,size.height*0.6316457,size.width*0.5438861,size.height*0.6319209);
path_79.cubicTo(size.width*0.5437139,size.height*0.6373116,size.width*0.5628694,size.height*0.6481570,size.width*0.5628694,size.height*0.6481570);
path_79.cubicTo(size.width*0.5628694,size.height*0.6481570,size.width*0.5820361,size.height*0.6373166,size.width*0.5818528,size.height*0.6319209);
path_79.cubicTo(size.width*0.5819083,size.height*0.6316508,size.width*0.5819389,size.height*0.6313769,size.width*0.5819389,size.height*0.6310967);
path_79.close();
path_79.moveTo(size.width*0.5628694,size.height*0.6341357);
path_79.cubicTo(size.width*0.5591556,size.height*0.6341357,size.width*0.5561556,size.height*0.6327739,size.width*0.5561556,size.height*0.6310967);
path_79.cubicTo(size.width*0.5561556,size.height*0.6294209,size.width*0.5591667,size.height*0.6280590,size.width*0.5628694,size.height*0.6280590);
path_79.cubicTo(size.width*0.5665722,size.height*0.6280590,size.width*0.5695833,size.height*0.6294209,size.width*0.5695833,size.height*0.6310967);
path_79.cubicTo(size.width*0.5695833,size.height*0.6327739,size.width*0.5665722,size.height*0.6341357,size.width*0.5628694,size.height*0.6341357);
path_79.close();

Paint paint79Fill = Paint()..style=PaintingStyle.fill;
paint79Fill.color = colorOne;
canvas.drawPath(path_79,paint79Fill);

}

@override
bool shouldRepaint(covariant CustomPainter oldDelegate) {
return true;
}
}