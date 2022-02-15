import 'package:flutter/material.dart';
import '../sharelib.dart';
import 'dart:math' as math;

class WheelTextPosition {
  
  WheelTextPosition({required this.title, required this.startRadian,required this.sweepRadian});
  
  String title;
  double startRadian;
  double sweepRadian;
}
  
class WheelWidget extends StatefulWidget{
  const WheelWidget( {
            Key? key,
            required this.canvasSize, 
            required this.radius, 
            required this.itemRepeat, 
            required this.itemPercent, 
            required this.itemColor, 
            required this.textStyle 
          }) : super(key: key);

  final Size canvasSize;
  final double radius; 
  final int itemRepeat;
  final Map<String, double> itemPercent;
  final Map<String, Color>  itemColor;
  final TextStyle textStyle;

  @override   
  State<WheelWidget> createState() => WheelWidgetState();
  
}

class WheelWidgetState extends State<WheelWidget> {
 
  DrawRouletteWheel? dRW;
   
  String getTitleFromRadian(double radian) {
    return dRW!.getTitleFromRadian(radian);    
  }
 
  @override 
  Widget build(BuildContext context) {

    dRW ??= DrawRouletteWheel(
                        widget.radius, 
                        widget.itemRepeat, 
                        widget.itemPercent, 
                        widget.itemColor, 
                        widget.textStyle,
                );

    return CustomPaint(
                size: widget.canvasSize, 
                painter: dRW,
    );  
  } 
}
 
class DrawRouletteWheel extends CustomPainter {

  DrawRouletteWheel(this.radius, this.itemRepeat,  this.itemPercent, this.itemColor, this.textStyle) {
    diameter = radius * 2;
  }

  Map<String, double> itemPercent;
  Map<String, Color> itemColor;
  TextStyle textStyle;
  double radius = 0.0;
  double diameter = 0.0;
  int itemRepeat = 0;
 
  static double textRotateRadian =  getRadianFromAngle(90);

  final defaultPaint = Paint()
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

  double wheelRectStartPointX = 0.0;
  double wheelRectStartPointY = 0.0; 

  List<WheelTextPosition> disPercent = []; 

  String getTitleFromRadian(double radian){

    for (var element in disPercent) {
      if (radian >= element.startRadian) 
      { 
        if (radian <= (element.startRadian + element.sweepRadian)){
          return element.title;
        }
      }
    }

    return "Unknow";
  }

  void drawRouletteWheel(Canvas canvas, Size size) {

    double startAngle = 0, sweepAngle = 0; 

    // 1.　Create a rectagle object to define the range and positio of the drawing pie chart.  
    Rect rect = Offset(wheelRectStartPointX, wheelRectStartPointY) & Size(diameter, diameter);

   
    for(int repeat = 0; repeat < itemRepeat; repeat++){
      itemPercent.keys.toList().forEach((element) {
        defaultPaint.color = itemColor.containsKey(element) ?  itemColor[element]!:Colors.white; 

        // 2.　Draw an equal-scale pie chart according to the project scale.
        sweepAngle = 360 * itemPercent[element]! / itemRepeat;
        canvas.drawArc(rect, getRadianFromAngle(startAngle),  getRadianFromAngle(sweepAngle), true, defaultPaint);
        
        // 3.　Store the start and the end angles of each sector.
        disPercent.add(WheelTextPosition(
            title:element, 
            startRadian:getRadianFromAngle(startAngle), 
            sweepRadian:getRadianFromAngle(sweepAngle )
        ));
 
        startAngle = startAngle + sweepAngle;
         
      });
    }
  }

  void drawWheelText(Canvas canvas, List<WheelTextPosition> disText){

    // 1. Set the starting position of the title at an angle of 0 degrees.
    canvas.translate(wheelRectStartPointX + radius , wheelRectStartPointY + radius);

    double radian = 0.0;
    for (var element in disText) {

      // 2. calculate the starting radian of the title on the side of the wheel
      radian = calculateStartRadianForString(element);

      // 3. Add the calculated radian by 90 degrees 
      radian += textRotateRadian;
      
      for (int i = 0; i< element.title.length; i++){
        canvas.save();            

        // 4. Rotate each character of the title in order according to the starting radian. 
        radian = drawWheelCharWithAngle(canvas,  element.title[i], radian );

        canvas.restore();
      }
    }

  }

  double calculateStartRadianForString( WheelTextPosition whellText ) {  

    // 1. Generate title length.
    var _textPainter = TextPainter(
            textDirection: TextDirection.ltr,
            text: TextSpan(text: whellText.title, style:textStyle,),
          );
   
    _textPainter.layout(minWidth: 0,  maxWidth: double.maxFinite);
    
    // 2. Caculate arc length based on ratio of title to raidus.
    double stringWidthForRadian =  math.asin( _textPainter.width / radius); 
    
    return whellText.startRadian + (whellText.sweepRadian - stringWidthForRadian) / 2 ;
  }
 
  double drawWheelCharWithAngle(Canvas canvas, String disChar, double curRadian) {
    
    // 1. Generate character length.
    var _textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      text: TextSpan(text: disChar, style:textStyle,),
    );
    
    _textPainter.layout(minWidth: 0,  maxWidth: double.maxFinite);

    // 2. Calculate character print position.
    double radiusWithHeight = radius +_textPainter.height;
    double shiftPointX = radiusWithHeight * math.sin(curRadian);  // sin(90):1
    double shiftPointY = radiusWithHeight * math.cos(curRadian) ; // cos(90):0

    // 3. adjust the print starting position of the canvas.
    canvas.translate(shiftPointX,  -shiftPointY);

    // 4. Caculate radian based on ratio of character to raidus.
    curRadian = (curRadian +  math.asin( _textPainter.width / radius));

    // 5. Rotate the canvas by arc
    canvas.rotate(curRadian);

    _textPainter.paint(canvas, Offset.zero); 
    return curRadian; 

  }

  @override
  void paint(Canvas canvas, Size size) {

    wheelRectStartPointX = (size.width - diameter) / 2;
    wheelRectStartPointY = (size.height - diameter) / 2;    
   
    disPercent.clear();

    drawRouletteWheel(canvas,  size);
   
    drawWheelText(canvas, disPercent);
  }

  @override
  bool shouldRepaint(DrawRouletteWheel oldDelegate) => false;
}


