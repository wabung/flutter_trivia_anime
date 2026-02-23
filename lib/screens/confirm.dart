import 'package:flutter/material.dart';
import 'approutes.dart';

class Confirm extends StatefulWidget {
  final String tematica;

  const Confirm({super.key, required this.tematica});

  @override
  State<Confirm> createState() => _ConfirmState();
}

class _ConfirmState extends State<Confirm> {
  // Mapa de nombres a constructores de widgets
  static final Map<String, Widget Function()> _screenMap = {
    'TriviaImages': () => TriviaImages(),
    "TriviaOpenings": () => TriviaOpenings(),
  };

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
                image: AssetImage('../assets/images/collage-manga.png'),
                width: anchura,
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),

              Center(
                child: Container(
                  alignment: Alignment.center,
                  height: altura * 0.9,
                  width: anchura*0.8,
                  padding: EdgeInsets.all(30),
                  
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFFC430F8).withValues(alpha: 0.8),
                        Color(0xFF0298FB).withValues(alpha: 0.8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Column(
                    spacing: 20,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Empezar partida de trivia de anime?", style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            spacing: 10,
                            children: [
                              GestureDetector(
                                onTap: () {
                                final builder = _screenMap[widget.tematica];
                                if (builder != null) {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(builder: (context) => builder()),
                                  );
                                }
                              },
                                child: Icon(Icons.check, size: 200, color: Colors.green),
                              ),
                              SizedBox(height: 40),
                              GestureDetector(
                                onTap: () => Navigator.of(context).pop(),
                                child: Icon(Icons.close, size: 200, color: Colors.red),
                              )
                          ],
                        ),
                      ),
                      ),
                    ],
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
