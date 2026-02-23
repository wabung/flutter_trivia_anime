import 'package:flutter/material.dart';
import 'approutes.dart';

class Tutorial1 extends StatefulWidget {
  const Tutorial1({super.key});

  @override
  State<Tutorial1> createState() => _Tutorial1State();
}

class _Tutorial1State extends State<Tutorial1> {
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
                image: AssetImage('../assets/images/banner-anime.jpg'),
                width: anchura,
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),

              Center(
                child: Container(
                  alignment: Alignment.center,
                  height: altura * 0.8,
                  width: anchura,
                  padding: EdgeInsets.all(30),
                  color: Colors.black.withValues(alpha: 0.8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    
                    children: [
                      Container(
                        width: anchura * 0.6,
                        height: altura * 0.3,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.blue,
                        ),
                        
                        child: Column(
                          children: [
                            Text("Trivia de Anime", style: TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold)),
                            SizedBox(height: 20),
                            Image(
                              image: AssetImage('../assets/images/adivinar.png'),
                              width: 250,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        '"Preguntas con imágenes de personajes."\n\n"Gana puntos y sube de rango."',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),

                      SizedBox(height: 30),
                      
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              SizedBox(width: 90),
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 8),
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withValues(alpha: 0.5),
                                ),
                              ),
                              SizedBox(width: 8),
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withValues(alpha: 0.5),
                                ),
                              ),
                            ],
                          ),
                          
                          SizedBox(width: 40),
                          IconButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const Tutorial2()));
                            },
                            icon: Icon(Icons.arrow_forward, color: Colors.white, size: 30),
                          ),
                        ],
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
