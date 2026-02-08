import 'package:flutter/material.dart';
import 'dart:async';
import 'approutes.dart';


class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
    @override
    void initState() {
      super.initState();
      Timer(const Duration(seconds: 3), () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const StartScreen()));
      }
      );
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: Container(
          color: Colors.blue,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('../assets/images/logo.png', width: 200, height: 200),
                const SizedBox(height: 20),
                const CircularProgressIndicator(constraints: BoxConstraints(minWidth: 100, minHeight: 100)),
              ],
            )
          ),
        ),
      );
    }
  }