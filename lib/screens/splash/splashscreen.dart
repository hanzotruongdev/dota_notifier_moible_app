import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget> [
            Image.asset("assets/images/app_icon.png", width: 200, height:  200,),
            Text("DotA Notifier", style: TextStyle(
              fontSize: 20
            ))
          ]
        )
      ),
    );
  }
}
