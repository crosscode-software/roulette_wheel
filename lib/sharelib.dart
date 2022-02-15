library roulette_wheel_selection;

import 'package:flutter/material.dart';

double getRadianFromAngle(double angle){
  return 3.1416 / 180.0 * angle;
}

class ChangeDataNotify<T> extends ChangeNotifier {
  
  ChangeDataNotify(this.hookData);

  late T hookData;

  void changeDataFunc(T changeData ){
    hookData = changeData;
    notifyListeners();
  }

  T getDataFunc(){
    return hookData;
  }
}

class ShareDataInheritedWidget<T> extends InheritedWidget {
  const ShareDataInheritedWidget({
    Key? key, 
    required this.prvObj, 
    required Widget child
  }) : super(key: key, child: child);

  final T prvObj;
  
  static ShareDataInheritedWidget? of<T>(BuildContext context){
    final ShareDataInheritedWidget? inheritedObj = context.dependOnInheritedWidgetOfExactType<ShareDataInheritedWidget<T>>();
    
    assert(inheritedObj != null, "No this object found in context!");
    return inheritedObj;
  }

  @override 
  bool updateShouldNotify(ShareDataInheritedWidget<T> oldWidget) {
    return  prvObj != oldWidget.prvObj;
  }
}


