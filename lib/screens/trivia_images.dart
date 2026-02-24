import 'package:flutter/material.dart';
import 'approutes.dart';
import '../services/anilist_service.dart';
import '../models/anilist_character.dart';
import '../services/score_service.dart';

class TriviaImages extends StatefulWidget {
  const TriviaImages({super.key});

  @override
  State<TriviaImages> createState() => _TriviaImagesState();
}

class _TriviaImagesState extends State<TriviaImages> {
  AniListCharacter? _character;
  List<AniListCharacter> _options = [];
  bool _isLoading = true;
  String? _error;
  bool _answered = false;

  int _currentQuestion = 1;
  int _correctCount = 0;
  int _incorrectCount = 0;
  bool _showResults = false;

  @override
  void initState() {
    super.initState();
    _loadQuestion();
  }

  Future<void> _loadQuestion() async {
    setState(() {
      _isLoading = true;
      _error = null;
      _answered = false;
    });
    try {
      final result = await AniListService.fetchTriviaQuestion();
      if (result != null) {
        setState(() {
          _character = result['correct'] as AniListCharacter;
          _options = List<AniListCharacter>.from(result['options']);
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = 'No se pudieron cargar personajes';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error al cargar personaje: $e';
        _isLoading = false;
      });
    }
  }

  void _onOptionSelected(bool isCorrect) {
    if (_answered) return; // Evitar doble tap
    setState(() => _answered = true);

    if (isCorrect) {
      _correctCount++;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('¡Correcto!'), backgroundColor: Colors.green, duration: Duration(seconds: 2)),
      );
    } else {
      _incorrectCount++;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Incorrecto. Era: ${_character?.name}'), backgroundColor: Colors.red, duration: Duration(seconds: 2)),
      );
    }

    Future.delayed(const Duration(seconds: 3), () {
      if (_currentQuestion >= 10) {
        ScoreService.guardarPuntuacion(_correctCount);
        setState(() => _showResults = true);
      } else {
        setState(() => _currentQuestion++);
        _loadQuestion();
      }
    });
  }


  Widget _buildOptionButton(AniListCharacter option, double anchura) {
    final isCorrect = option.id == _character?.id;
    return GestureDetector(
      onTap: () => _onOptionSelected(isCorrect),
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: _answered
              ? (isCorrect ? Colors.green : Colors.red.shade300)
              : Colors.blue,
        ),
        width: anchura * 0.3,
        child: Center(
          child: Text(
            option.name,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
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
                  child: _showResults
                      ? _buildResultsView(anchura, altura)
                      : _buildQuestionView(anchura, altura),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultsView(double anchura, double altura) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.emoji_events, size: 80, color: Colors.amber),
        const SizedBox(height: 20),
        const Text(
          '¡Trivia completada!',
          style: TextStyle(fontSize: 26, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 30),
        Text(
          'Correctas: $_correctCount / 10',
          style: const TextStyle(fontSize: 22, color: Colors.greenAccent, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Text(
          'Incorrectas: $_incorrectCount / 10',
          style: const TextStyle(fontSize: 22, color: Colors.redAccent, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 40),
        GestureDetector(
          onTap: () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
            ),
            child: const Text(
              'Volver al inicio',
              style: TextStyle(fontSize: 18, color: Color(0xFFC430F8), fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionView(double anchura, double altura) {
    return Column(
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
        Text("Pregunta ($_currentQuestion/10)", style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold),
        ),
        Text("¿Quién es este personaje?", style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold),
        ),
        Container(
          width: anchura * 0.6,
          height: altura * 0.3,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.blue,
          ),
          child: _isLoading
              ? const Center(child: CircularProgressIndicator(color: Colors.white))
              : _error != null
                  ? Center(child: Text(_error!, style: const TextStyle(color: Colors.white)))
                  : _character != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.network(
                            _character!.imageUrl,
                            fit: BoxFit.fitHeight,
                            loadingBuilder: (context, child, progress) {
                              if (progress == null) return child;
                              return const Center(child: CircularProgressIndicator(color: Colors.white));
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(child: Icon(Icons.broken_image, color: Colors.white, size: 50));
                            },
                          ),
                        )
                      : const Center(child: Text('Sin personaje', style: TextStyle(color: Colors.white))),
        ),
        // Opciones de respuesta
        if (_options.length == 4) ...[
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildOptionButton(_options[0], anchura),
                SizedBox(width: 20),
                _buildOptionButton(_options[1], anchura),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildOptionButton(_options[2], anchura),
              SizedBox(width: 20),
              _buildOptionButton(_options[3], anchura),
            ],
          ),
        ]
      ],
    );
  }
}
