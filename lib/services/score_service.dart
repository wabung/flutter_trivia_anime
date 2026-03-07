import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ScoreService {
  static final _firestore = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;

  /// Suma correctas al campo "respuestasCorrectas" del usuario actual
  /// en la colección "usuarios".
  static Future<void> guardarPuntuacion(int correctas) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final docRef = _firestore.collection('usuarios').doc(user.uid);

    // Usa set con merge para crear el documento si no existe,
    // o actualizar el campo si ya existe.
    await docRef.set({
      'respuestasCorrectas': FieldValue.increment(correctas),
      'email': user.email,
    }, SetOptions(merge: true));
  }

  static Future<int> obtenerPuntuacion() async {
    final user = _auth.currentUser;
    if (user == null) return 0;

    final docRef = _firestore.collection('usuarios').doc(user.uid);
    final doc = await docRef.get();
    if (doc.exists) {
      return doc.data()?['respuestasCorrectas'] ?? 0;
    }
    return 0;
  }

  static Future<int> obtenerNivel() async {
    final puntuacion = await obtenerPuntuacion();
    return puntuacion ~/ 10; // cada 10 puntos es un nivel
  }

  /// Devuelve los top 5 usuarios con mayor nivel (respuestasCorrectas).
  /// Cada elemento es un Map con 'email' y 'nivel'.
  static Future<List<Map<String, dynamic>>> obtenerTop5() async {
    final snapshot = await _firestore
        .collection('usuarios')
        .orderBy('respuestasCorrectas', descending: true)
        .limit(5)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      final respuestas = data['respuestasCorrectas'] ?? 0;
      return {
        'email': data['email'] ?? 'Desconocido',
        'nivel': respuestas ~/ 10,
        'respuestasCorrectas': respuestas,
      };
    }).toList();
  }
}
