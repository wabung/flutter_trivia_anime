import 'package:flutter/material.dart';
import 'approutes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../auth.dart';
import '../services/score_service.dart';

class Ranking extends StatefulWidget {
  const Ranking({super.key});

  @override
  State<Ranking> createState() => _RankingState();
}

class _RankingState extends State<Ranking> {

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
                      GestureDetector(
                        onTap: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const HomeScreen())),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Icon(Icons.arrow_back, size: 50, color: Colors.white),
                        ),
                      ),
                      Text("Ranking de usuarios con mayor nivel", style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child: FutureBuilder<List<Map<String, dynamic>>>(
                          future: ScoreService.obtenerTop5(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(color: Colors.white),
                              );
                            }
                            if (snapshot.hasError) {
                              return Center(
                                child: Text(
                                  'Error al cargar el ranking',
                                  style: TextStyle(color: Colors.white),
                                ),
                              );
                            }
                            final top5 = snapshot.data ?? [];
                            if (top5.isEmpty) {
                              return Center(
                                child: Text(
                                  'No hay datos de ranking todavía',
                                  style: TextStyle(color: Colors.white),
                                ),
                              );
                            }
                            return ListView.separated(
                              itemCount: top5.length,
                              separatorBuilder: (_, __) => const SizedBox(height: 10),
                              itemBuilder: (context, index) {
                                final jugador = top5[index];
                                final posicion = index + 1;
                                final isCurrentUser = jugador['email'] == user?.email;
                                return Container(
                                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: isCurrentUser
                                        ? Colors.amber.withValues(alpha: 0.3)
                                        : Colors.black.withValues(alpha: 0.5),
                                    border: isCurrentUser
                                        ? Border.all(color: Colors.amber, width: 2)
                                        : null,
                                  ),
                                  child: Row(
                                    children: [
                                      // Posición con medalla para top 3
                                      Text(
                                        posicion <= 3
                                            ? ['🥇', '🥈', '🥉'][posicion - 1]
                                            : '#$posicion',
                                        style: TextStyle(
                                          fontSize: posicion <= 3 ? 24 : 18,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      // Email y nivel
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              jugador['email'],
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              '${jugador['respuestasCorrectas']} respuestas correctas',
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: Colors.white70,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // Nivel
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                          color: Colors.white.withValues(alpha: 0.2),
                                        ),
                                        child: Text(
                                          'Nivel ${jugador['nivel']}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
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
