import 'package:flutter/material.dart';
import 'approutes.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  Widget build(BuildContext context) {
    double anchura = MediaQuery.of(context).size.width;
    double altura = MediaQuery.of(context).size.height;
    
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Stack(
            children: [
              Image(
                image: AssetImage('assets/images/banner-anime.jpg'),
                width: anchura,
                height: altura,
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
          Positioned(
            bottom: altura * 0.3,
            left: 0,
            right: 0,
            child:
              Container(
                color: Colors.black.withValues(alpha: 0.8),
                height: altura*0.1,
                child:Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const Tutorial1()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 5,
                ),
                child: Text(
                  'Empezar',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
              ),
          ),
            ],
          ),
        ),
      ),
    );
  }
}
