import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roulette_wheel_selection/roulette_wheel_selection.dart';
import 'package:roulette_wheel_selection/sharelib.dart';

void main() => runApp(const RoulettWheelSelectionApp());

class RoulettWheelSelectionApp extends StatelessWidget {
  const RoulettWheelSelectionApp({Key? key}):super(key: key);

  @override
  Widget build (BuildContext context) {
    return  MaterialApp(
            home: Scaffold(
              body: Center(         
                child: ChangeNotifierProvider(
                create: (context) =>  ChangeDataNotify<String>("未選擇"),      
                child:const RouletteWheelWidget(
                    radius: 150, 
                    textStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black45
                    ),
                    itemRepeat: 2,
                    itemPercent: {"第一項":0.4, "第二項":0.3,"第三項": 0.2, "第四項":0.1}, 
                    itemColor: {"第一項":Colors.green, "第二項":Colors.yellow ,"第三項": Colors.red, "第四項":Colors.brown},
                  ),        
                ),
              ),
            ),
      );
  }
}
 