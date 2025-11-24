import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';

class ExerciseDetailScreen extends StatefulWidget {
  final String exerciseId;

  const ExerciseDetailScreen({super.key, required this.exerciseId});

  @override
  State<ExerciseDetailScreen> createState() => _ExerciseDetailScreenState();
}

class _ExerciseDetailScreenState extends State<ExerciseDetailScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  Timer? _timer;
  int _remainingSeconds = 0;
  bool _isRunning = false;
  bool _isCompleted = false;
  int _currentExerciseIndex = 0;

  // Exercise data based on block index
  final Map<int, Map<String, dynamic>> exerciseData = {
    0: { // Calentamiento
      'title': 'Calentamiento',
      'duration': 300, // 5 minutes
      'exercises': [
        {'name': 'Marcha en el sitio', 'description': 'Marcha levantando las rodillas alternadamente', 'icon': Icons.directions_walk, 'image': 'placeholder.jpg'},
        {'name': 'Círculos de brazos', 'description': 'Haz círculos con los brazos hacia adelante y atrás', 'icon': Icons.rotate_right, 'image': 'placeholder.jpg'},
        {'name': 'Flexiones ligeras', 'description': 'Flexiones suaves para activar el pecho y tríceps', 'icon': Icons.fitness_center, 'image': 'placeholder.jpg'},
      ],
      'color': AppColors.accent,
    },
    1: { // Tren inferior
      'title': 'Tren Inferior',
      'duration': 600, // 10 minutes
      'exercises': [
        {'name': 'Sentadillas (Squats)', 'description': 'Baja el cuerpo como si te sentaras en una silla', 'icon': Icons.accessibility, 'image': 'placeholder.jpg'},
        {'name': 'Zancadas (Lunges)', 'description': 'Da un paso adelante y baja hasta que ambas rodillas formen 90°', 'icon': Icons.directions_run, 'image': 'placeholder.jpg'},
        {'name': 'Puente de glúteos', 'description': 'Levanta las caderas contrayendo los glúteos', 'icon': Icons.airline_seat_recline_normal, 'image': 'placeholder.jpg'},
      ],
      'color': AppColors.primary,
    },
    2: { // Tren superior
      'title': 'Tren Superior',
      'duration': 600, // 10 minutes
      'exercises': [
        {'name': 'Flexiones (Push-ups)', 'description': 'Baja el pecho hacia el suelo manteniendo el cuerpo recto', 'icon': Icons.fitness_center, 'image': 'placeholder.jpg'},
        {'name': 'Press con botellas', 'description': 'Empuja botellas de agua hacia arriba como si fueran mancuernas', 'icon': Icons.local_drink, 'image': 'placeholder.jpg'},
        {'name': 'Planchas dinámicas', 'description': 'Mantén la plancha y alterna levantar cada brazo', 'icon': Icons.view_stream, 'image': 'placeholder.jpg'},
      ],
      'color': AppColors.secondary,
    },
    3: { // Facial Exercises
      'title': 'Ejercicios Faciales',
      'duration': 600, // 10 minutes
      'exercises': [
        {'name': 'Ejercicios para Mandíbula y Papada', 'description': 'Estos ejercicios buscan fortalecer los músculos alrededor de la barbilla y la mandíbula para dar una apariencia más definida y reducir la papada.', 'icon': Icons.face, 'image': 'placeholder.jpg'},
        {'name': 'Boca en "O" y Sonrisa', 'description': 'Pon la boca en una "O" alargada, cubriendo los dientes con los labios. Con la boca en esa posición, intenta sonreír y elevar los pómulos. Siente la tensión. 3 series de 10 repeticiones, manteniendo 5-10 segundos.', 'icon': Icons.sentiment_satisfied, 'image': 'placeholder.jpg'},
        {'name': 'Estiramiento de Cuello/Lengua', 'description': 'Inclina la cabeza hacia atrás, mirando al techo. Mueve tu mandíbula inferior hacia adelante y/o presiona la lengua firmemente contra el paladar. 3 series, manteniendo la posición de 5 a 10 segundos.', 'icon': Icons.expand_less, 'image': 'placeholder.jpg'},
        {'name': 'Apertura de la Boca con Resistencia', 'description': 'Coloca los puños cerrados bajo la barbilla. Abre lentamente la boca mientras empujas con los puños hacia arriba, creando resistencia. Repite 10-20 veces.', 'icon': Icons.unfold_more, 'image': 'placeholder.jpg'},
        {'name': 'Hinchado de Mejillas', 'description': 'Cierra los labios. Llena de aire ambas mejillas (como un pez globo). Pasa el aire de una mejilla a la otra lentamente. Hazlo durante 30-60 segundos.', 'icon': Icons.bubble_chart, 'image': 'placeholder.jpg'},
        {'name': 'Ejercicios para Pómulos (Mejillas y Tercio Medio)', 'description': 'Estos se enfocan en los músculos cigomáticos (los que levantan los pómulos al sonreír).', 'icon': Icons.tag_faces, 'image': 'placeholder.jpg'},
        {'name': 'La Sonrisa Controlada', 'description': 'Relaja la mandíbula. Sonríe suavemente con los labios cerrados, concentrándote en levantar solo las mejillas (evita entrecerrar los ojos o arrugar la frente). 6-8 repeticiones, manteniendo 5 segundos y soltando 5 segundos.', 'icon': Icons.mood, 'image': 'placeholder.jpg'},
        {'name': 'Cara de Pez que Ríe', 'description': 'Chupa las mejillas hacia adentro (cara de pez). Mientras mantienes esa posición, intenta sonreír. 15 repeticiones, manteniendo 3 segundos la contracción.', 'icon': Icons.face_retouching_natural, 'image': 'placeholder.jpg'},
        {'name': 'Empuje con Resistencia', 'description': 'Coloca las yemas de tus dedos debajo de tus pómulos (en el borde óseo). Sostén una sonrisa ligera "empujando" los músculos hacia arriba, contra la resistencia de tus dedos. 5-6 repeticiones, manteniendo 8 segundos.', 'icon': Icons.touch_app, 'image': 'placeholder.jpg'},
        {'name': 'El "Mewing": ¿Qué es y qué dice la evidencia?', 'description': 'El "Mewing" es una técnica que se ha popularizado en redes sociales, pero es importante entenderla con base en la evidencia. Consiste en colocar toda la lengua firmemente contra el paladar superior y respirar exclusivamente por la nariz.', 'icon': Icons.info, 'image': 'placeholder.jpg'},
      ],
      'color': AppColors.primary,
    },
    4: { // Enfriamiento
      'title': 'Enfriamiento',
      'duration': 300, // 5 minutes
      'exercises': [
        {'name': 'Estiramientos', 'description': 'Estira todos los grupos musculares trabajados', 'icon': Icons.self_improvement, 'image': 'placeholder.jpg'},
        {'name': 'Respiración guiada', 'description': 'Respira profundamente para relajarte', 'icon': Icons.air, 'image': 'placeholder.jpg'},
      ],
      'color': AppColors.accent,
    },
  };

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    final blockIndex = int.tryParse(widget.exerciseId) ?? 0;
    final data = exerciseData[blockIndex] ?? exerciseData[0]!;
    _remainingSeconds = data['duration'] as int;
  }

  @override
  void dispose() {
    _animationController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    if (_isRunning) return;

    setState(() => _isRunning = true);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _completeExercise();
        }
      });
    });
  }

  void _pauseTimer() {
    setState(() => _isRunning = false);
    _timer?.cancel();
  }

  void _completeExercise() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _isCompleted = true;
    });

    // Auto-complete the block in workout screen
    final blockIndex = int.tryParse(widget.exerciseId) ?? 0;
    // This will be handled by the workout screen when we go back

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context).pop(true); // Return true to indicate completion
      }
    });
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void _nextExercise() {
    final blockIndex = int.tryParse(widget.exerciseId) ?? 0;
    final data = exerciseData[blockIndex] ?? exerciseData[0]!;
    final exercises = data['exercises'] as List<Map<String, dynamic>>;

    if (_currentExerciseIndex < exercises.length - 1) {
      setState(() {
        _currentExerciseIndex++;
        _isCompleted = false;
        _isRunning = false;
        _timer?.cancel();
        _remainingSeconds = data['duration'] as int;
      });
    } else {
      _completeExercise();
    }
  }

  void _previousExercise() {
    if (_currentExerciseIndex > 0) {
      setState(() {
        _currentExerciseIndex--;
        _isCompleted = false;
        _isRunning = false;
        _timer?.cancel();
        final blockIndex = int.tryParse(widget.exerciseId) ?? 0;
        final data = exerciseData[blockIndex] ?? exerciseData[0]!;
        _remainingSeconds = data['duration'] as int;
      });
    }
  }

  Widget _buildFacialExerciseView(Map<String, dynamic> exercise, int totalExercises, Color color) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Progress indicator for facial exercises
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(totalExercises, (index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: index == _currentExerciseIndex ? 12 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: index == _currentExerciseIndex ? color : Colors.grey.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
          const SizedBox(height: 24),

          // Exercise content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Icon
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      exercise['icon'] as IconData,
                      color: color,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Title
                  Text(
                    exercise['name'] as String,
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: AppColors.foreground,
                      height: 1.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),

                  // Description
                  Text(
                    exercise['description'] as String,
                    style: GoogleFonts.nunito(
                      fontSize: 16,
                      color: AppColors.mutedForeground,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),

          // Navigation buttons
          Row(
            children: [
              if (_currentExerciseIndex > 0)
                Expanded(
                  child: OutlinedButton(
                    onPressed: _previousExercise,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: color),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.arrow_back, color: color),
                        const SizedBox(width: 8),
                        Text(
                          'Anterior',
                          style: TextStyle(color: color, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                ),
              if (_currentExerciseIndex > 0) const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: _nextExercise,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _currentExerciseIndex == totalExercises - 1 ? 'Finalizar' : 'Siguiente',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward, color: Colors.white),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRegularExerciseList(List<Map<String, dynamic>> exercises, Color color) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: exercises.length,
      itemBuilder: (context, index) {
        final exercise = exercises[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.2)),
          ),
          child: Column(
            children: [
              // Image removed to avoid asset loading issues
              const SizedBox(height: 12),
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      exercise['icon'] as IconData,
                      color: color,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          exercise['name'] as String,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.foreground,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          exercise['description'] as String,
                          style: GoogleFonts.nunito(
                            fontSize: 14,
                            color: AppColors.mutedForeground,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final blockIndex = int.tryParse(widget.exerciseId) ?? 0;
    final data = exerciseData[blockIndex] ?? exerciseData[0]!;
    final exercises = data['exercises'] as List<Map<String, dynamic>>;
    final color = data['color'] as Color;
    final isFacialBlock = blockIndex == 3;

    // For facial exercises, show one exercise at a time
    final currentExercise = isFacialBlock ? exercises[_currentExerciseIndex] : null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          data['title'] as String,
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
        backgroundColor: color,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              color.withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: Column(
          children: [
            // Timer section
            Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: color.withOpacity(0.1),
                      border: Border.all(color: color, width: 4),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _formatTime(_remainingSeconds),
                            style: GoogleFonts.poppins(
                              fontSize: 48,
                              fontWeight: FontWeight.w900,
                              color: color,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _isCompleted ? '¡Completado!' : 'Tiempo restante',
                            style: GoogleFonts.nunito(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.mutedForeground,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (!_isCompleted) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _isRunning ? _pauseTimer : _startTimer,
                          icon: Icon(_isRunning ? Icons.pause : Icons.play_arrow),
                          label: Text(_isRunning ? 'Pausar' : 'Iniciar'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: color,
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        OutlinedButton(
                          onPressed: _completeExercise,
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: color),
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            'Completar',
                            style: TextStyle(color: color, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    ScaleTransition(
                      scale: _scaleAnimation,
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 48,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Exercises content
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: isFacialBlock
                    ? _buildFacialExerciseView(currentExercise!, exercises.length, color)
                    : _buildRegularExerciseList(exercises, color),
              ),
            ),
          ],
        ),
      ),
    );
  }
}