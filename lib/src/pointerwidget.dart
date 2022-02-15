import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../sharelib.dart';
 

typedef NotifyResultEvent = void Function(bool isSelection,double randian);

class WheelPointerWidget extends StatefulWidget{

  const WheelPointerWidget({
      Key? key,
      required this.canvasSize,
      required this.numberOfRevolutions,
      required this.duration,
      required this.notifyCallbackFunc,
    }):super(key: key);
  
  final Size canvasSize;
  final int numberOfRevolutions;
  final Duration duration;
  final NotifyResultEvent notifyCallbackFunc;
 
  @override 
  State<WheelPointerWidget> createState() => _WheelPointerState();
}

class _WheelPointerState extends State<WheelPointerWidget> with TickerProviderStateMixin {

  Animation<double>? _animation;
  AnimationController? _controller;
  Tween<double>? _rotationTween;   
  int pos = 0;
  bool isSelection = false; 
  
  @override
  void initState() {
    super.initState(); 
    _controller = AnimationController(vsync: this, duration: widget.duration); 
    _animation = CurvedAnimation(parent: _controller!, curve: Curves.fastLinearToSlowEaseIn);
    _rotationTween = Tween<double>(begin:  0, end: 0);
    _animation = _rotationTween!.animate(_animation!)
        ..addListener(() {
            setState(() {});
        })
        ..addStatusListener((status) {

          if (status == AnimationStatus.completed){
            isSelection = false;

             // 1. Notify of selected radians when animation is done.
            widget.notifyCallbackFunc(isSelection, getRadianFromAngle(pos.toDouble()));
          }
        });
  }

 
  @override 
  void didUpdateWidget (WheelPointerWidget oldWidget){
    super.didUpdateWidget(oldWidget);
    _controller!.duration = widget.duration;    
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  
  void startAnimation() {
    
    isSelection = true;
    widget.notifyCallbackFunc(isSelection, 0);
    _controller!.reset();

    // 2. Set the last end of angle as the current starting angle.
    _rotationTween!.begin = pos.toDouble();
    
    // 3. Generate a random angle from 0 to 360 degrees.  
    pos = math.Random().nextInt(360);
    
    // 4. Multiply the preset number of rotations by 360 plus a random value.
    _rotationTween!.end = widget.numberOfRevolutions * 360.0 + pos; 
     
    // 5. Starts running this animation forward 
    _controller!.forward();
   
  }

  @override 
  Widget build(BuildContext context) {
   
    var drawPointer = DrawPointer(_animation!.value);

    return GestureDetector( 
            child: CustomPaint(
              size: widget.canvasSize,
              painter: drawPointer
            ),
            onTapDown: (tapDownDetails) {              
              // 6. if the animations has been completed and determine the click position.
              if(!isSelection && drawPointer.isclick(tapDownDetails.localPosition)){               
                startAnimation();                
              }
            },
      );
  }
}

class DrawPointer extends CustomPainter{

  DrawPointer(this.angle);

  double angle;

  bool isclick(Offset offset) {
    var radius = math.pow((offset.dx - centerOffst.dx),2) + 
                math.pow((offset.dy - centerOffst.dy),2);

    return (radius <= math.pow(centerSize.width/2, 2));        
 
  }
   

  late Offset centerOffst;
  late Size centerSize;

  @override
  void paint(Canvas canvas, Size size) {   
  
    //　1.　Set the starting position of the drawing graphics on the canvas.　　
    centerOffst = Offset(size.width / 2, size.height / 2);   
    canvas.translate(centerOffst.dx, centerOffst.dy);    

    // 2.　The angle by which the pointer is rotated before drawing.
    canvas.rotate(getRadianFromAngle(angle));


    // 3.　Crate a rectangle object to define the range of the drawing arc.
    centerSize = Size(size.width / 10, size.height / 5);
    var rect = Rect.fromLTWH(0 - centerSize.width / 2, 0 - centerSize.width / 2, centerSize.width, centerSize.width); 
         
   
    // 4.　　Use Path object and Paint object to draw the shape and color of pointer
    canvas.drawPath(
          Path()
            ..arcTo(rect, getRadianFromAngle(30), getRadianFromAngle(300), false)
            ..relativeLineTo(centerSize.height, centerSize.width / 30)
            ..relativeLineTo(0, - 10 * centerSize.width / 30)
            ..relativeLineTo( centerSize.width, 17 * centerSize.width / 30)
            ..relativeLineTo(-centerSize.width, 17 * centerSize.width / 30 )
            ..relativeLineTo(0, -10 * centerSize.width / 30)
            ..close(), 
          Paint()
            ..isAntiAlias = true
            ..style = PaintingStyle.fill
            ..shader = LinearGradient(
                    begin: Alignment.bottomRight, 
                    end: Alignment.topLeft,
                    colors:  [Colors.blueGrey.withAlpha(200),  Colors.cyan.withAlpha(200)],
                    tileMode: TileMode.mirror,
                ).createShader(rect),
      );
    
    canvas.drawCircle(Offset.zero,  
                    centerSize.width * 0.2, 
                    Paint()
                      ..color=Colors.black
                      ..style = PaintingStyle.fill
                  );

    canvas.drawCircle(Offset.zero,
                    centerSize.width * 0.15, 
                    Paint()
                      ..color=Colors.red
                      ..style = PaintingStyle.fill
                  );

   
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {    
    return true;
  }
}
