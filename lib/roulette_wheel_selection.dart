library roulette_wheel_selection;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'src/displaytitlewidget.dart';
import 'src/wheelwidget.dart';
import 'src/pointerwidget.dart';
import 'sharelib.dart';

class RouletteWheelWidget extends StatefulWidget  {

  const RouletteWheelWidget({
    Key? key, 
    required this.radius, 
    required this.textStyle,
    required this.itemRepeat,
    required this.itemPercent, 
    required this.itemColor,    
  }) : super(key: key);

  final double radius;
  final TextStyle textStyle;
  final int itemRepeat;   
  final Map<String, double> itemPercent;
  final Map<String, Color> itemColor;

  @override 
  State<RouletteWheelWidget> createState() => _RouletteWheelState();
}

class _RouletteWheelState extends State<RouletteWheelWidget> {

  final GlobalKey <WheelWidgetState> _wheelWidgetKey = GlobalKey();
  
  WheelWidget? wheelWidget;

  String title = "未知"; 
 
  void notifyResultFunc(bool isSelection ,double radian) { 
   
    title = isSelection ? "選擇中" : _wheelWidgetKey.currentState!.getTitleFromRadian(radian);
    Provider.of<ChangeDataNotify<String>>(context, listen: false).changeDataFunc(title);   
  }

  @override
  Widget build(BuildContext context){
     
    wheelWidget ??=  WheelWidget ( 
                  key: _wheelWidgetKey,
                  radius: widget.radius,
                  canvasSize: Size(widget.radius*2, widget.radius*2),
                  itemRepeat: widget.itemRepeat,
                  itemPercent: widget.itemPercent,
                  itemColor:  widget.itemColor,
                  textStyle:  widget.textStyle,
                );  

    return  Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children:[                             
                ShareDataInheritedWidget<String>(
                  prvObj: title,
                  child: const  DisplayTitleWidget(),              
                ),
                SizedBox(
                  height: widget.textStyle.fontSize! * 2,
                ),        
                Stack (                
                  children:[                   
                    wheelWidget!,                           
                    WheelPointerWidget(
                        canvasSize: Size(widget.radius * 2, widget.radius * 2),
                        numberOfRevolutions: 3,
                        duration: const Duration(seconds: 7),
                        notifyCallbackFunc:notifyResultFunc,
                    ),
                  ] 
                ),
              ]
    );
  }
}
