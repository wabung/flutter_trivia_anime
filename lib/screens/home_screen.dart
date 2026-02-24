import 'package:flutter/material.dart';
import 'package:flutter_trivia_anime/screens/ranking.dart';
import 'approutes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../auth.dart';
import '../services/score_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final User? user = Auth().currentUser;

  Future<void> signOut() async {
    await Auth().signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Login()),
    );
  }

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
                image: AssetImage('assets/images/collage-manga.png'),
                width: anchura,
                height: altura,
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
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.black,
                        ),
                        child: Text(
                          '${user?.email}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    // Esperar a que se obtenga el nivel antes de mostrarlo
                      FutureBuilder<int>(
                        future: ScoreService.obtenerNivel(),
                        builder: (context, snapshot) {
                          final nivel = snapshot.data ?? 0;
                          return Text("Nivel: $nivel", style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          );
                        },
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            spacing: 10,
                            children: [
                            GestureDetector(
                                onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Confirm(tematica: 'TriviaImages'),
                                  ),
                                );
                              },
                              child:
                              Container(
                              width: anchura * 0.6,
                              height: altura * 0.22,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.blue,
                              ),
                              
                              child: Column(
                                children: [
                                  Text("Trivia de Anime", style: TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold)),
                                  SizedBox(height: 10),
                                  Image(
                                    image: AssetImage('assets/images/adivinar.png'),
                                    width: 150,
                                  ),
                                ],
                              ),
                            ),
                            
                            ),
                            GestureDetector(
                          onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Confirm(tematica: "TriviaOpenings"),
                            ),
                          );
                        },
                        child:
                        Container(
                        width: anchura * 0.6,
                        height: altura * 0.22,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.blue,
                        ),
                        
                        child: Column(
                          children: [
                            Text("Adivina el Opening", style: TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold)),
                            SizedBox(height: 10),
                            Image(
                              image: AssetImage('assets/images/headphone.png'),
                              width: 75,
                            ),
                          ],
                        ),
                      ),
                      ),
                      GestureDetector(
                          onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Ranking(),
                            ),
                          );
                        },
                        
                        child:
                        Container(
                        width: anchura * 0.6,
                        height: altura * 0.22,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.blue,
                        ),
                        child: Column(
                          children: [
                            Text(
                              "Estadísticas y rankings",
                              style: TextStyle(
                                fontSize: 28,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            Image(
                              image: AssetImage('assets/images/stats.png'),
                              width: 75,
                            ),
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
            ],
          ),
        ),
      ),
    );
  }
}
