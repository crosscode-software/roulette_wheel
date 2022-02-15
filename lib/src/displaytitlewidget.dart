import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../sharelib.dart';


class DisplayTitleWidget extends StatelessWidget {

  const DisplayTitleWidget ({Key? key}):super(key: key);

  @override 
  Widget build(BuildContext context) {
    return Consumer<ChangeDataNotify<String>>(
          builder: (context, obj, child) {
            return Text(obj.getDataFunc(), 
                style: const TextStyle(
                    color: Colors.brown, 
                    fontSize: 24, 
                    fontWeight: FontWeight.normal,
                    fontStyle: FontStyle.normal,
                    decoration: TextDecoration.none,
                ),
            );
          }
      );
  }

}