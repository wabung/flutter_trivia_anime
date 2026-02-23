import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'approutes.dart';
import '../services/animethemes_service.dart';
import '../models/anime_theme_audio.dart';
import '../services/score_service.dart';

class TriviaOpenings extends StatefulWidget {
  const TriviaOpenings({super.key});

  @override
  State<TriviaOpenings> createState() => _TriviaOpeningsState();
}

class _TriviaOpeningsState extends State<TriviaOpenings> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  AnimeThemeAudio? _correctAudio;
  List<AnimeThemeAudio> _options = [];
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

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _loadQuestion() async {
    setState(() {
      _isLoading = true;
      _error = null;
      _answered = false;
    });
    try {
      // Intentar hasta encontrar un opening con audio válido
      while (true) {
        final result = await AnimeThemesService.fetchTriviaQuestion();
        if (result == null) {
          setState(() {
            _error = 'No se pudieron cargar openings';
            _isLoading = false;
          });
          return;
        }

        final correct = result['correct'] as AnimeThemeAudio;
        try {
          await _audioPlayer.setUrl(correct.audioUrl);
          _audioPlayer.play();
          // Audio cargado correctamente, mostrar la pregunta
          setState(() {
            _correctAudio = correct;
            _options = List<AnimeThemeAudio>.from(result['options']);
            _isLoading = false;
          });
          return;
        } catch (_) {
          // Audio no disponible, intentar con otra pregunta
          continue;
        }
      }
    } catch (e) {
      setState(() {
        _error = 'Error al cargar opening: $e';
        _isLoading = false;
      });
    }
  }

  void _onOptionSelected(bool isCorrect) {
    if (_answered) return; // Evitar doble tap
    setState(() => _answered = true);

    if (isCorrect) {
      _correctCount++;
      _audioPlayer.stop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('¡Correcto!'), backgroundColor: Colors.green, duration: Duration(seconds: 2)),
      );
    } else {
      _incorrectCount++;
      _audioPlayer.stop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Incorrecto. Era: ${_correctAudio?.name}'), backgroundColor: Colors.red, duration: Duration(seconds: 2)),
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


  Widget _buildOptionButton(AnimeThemeAudio option, double anchura) {
    final isCorrect = option.id == _correctAudio?.id;
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
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
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
            Text("Pregunta ($_currentQuestion/10)", style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            Text("¿Cual es este Opening?", style: TextStyle(
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
                      : _correctAudio != null
                          ? Center(
                              child: StreamBuilder<PlayerState>(
                                stream: _audioPlayer.playerStateStream,
                                builder: (context, snapshot) {
                                  final playerState = snapshot.data;
                                  final playing = playerState?.playing ?? false;
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        iconSize: 80,
                                        color: Colors.white,
                                        icon: Icon(playing ? Icons.pause_circle_filled : Icons.play_circle_filled),
                                        onPressed: () {
                                          if (playing) {
                                            _audioPlayer.pause();
                                          } else {
                                            _audioPlayer.play();
                                          }
                                        },
                                      ),
                                      const SizedBox(height: 10),
                                      const Text('Escucha el opening', style: TextStyle(color: Colors.white, fontSize: 16)),
                                    ],
                                  );
                                },
                              ),
                            )
                          : const Center(child: Text('Sin opening', style: TextStyle(color: Colors.white))),
            ),
            // Opciones de respuesta
            if (!_isLoading && _options.length == 4) ...[
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
        ),
      );
  }
}
