import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';
import '../data_service.dart';

class WorkoutBlock {
  final String title;
  final String duration;
  final List<String> exercises;
  final Color color;
  final IconData icon;

  const WorkoutBlock({
    required this.title,
    required this.duration,
    required this.exercises,
    required this.color,
    required this.icon,
  });
}

class WorkoutScreen extends StatefulWidget {
  final bool showAppBar;

  const WorkoutScreen({super.key, this.showAppBar = true});

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  final List<WorkoutBlock> workoutBlocks = [
    WorkoutBlock(
      title: 'Calentamiento',
      duration: '5 min',
      exercises: [
        'Marcha en el sitio',
        'Círculos de brazos',
        'Flexiones ligeras',
      ],
      color: AppColors.accent,
      icon: Icons.wb_sunny, // Icono de sol para calentamiento
    ),
    WorkoutBlock(
      title: 'Bloque 1 — Tren inferior',
      duration: '10 min',
      exercises: [
        'Sentadillas (Squats)',
        'Zancadas (Lunges)',
        'Puente de glúteos',
      ],
      color: AppColors.primary,
      icon: Icons.directions_walk, // Icono de caminar para piernas
    ),
    WorkoutBlock(
      title: 'Bloque 2 — Tren superior',
      duration: '10 min',
      exercises: [
        'Flexiones (Push-ups)',
        'Press con botellas',
        'Planchas dinámicas',
      ],
      color: AppColors.secondary,
      icon: Icons.fitness_center, // Icono de gimnasio para tren superior
    ),
    WorkoutBlock(
      title: 'Bloque 3 — Core + Facial',
      duration: '10 min',
      exercises: [
        'Abdominales bicicleta',
        'Plancha frontal',
        'Ejercicio facial',
      ],
      color: AppColors.primary,
      icon: Icons.accessibility, // Icono de accesibilidad para core
    ),
    WorkoutBlock(
      title: 'Enfriamiento',
      duration: '5 min',
      exercises: ['Estiramientos', 'Respiración guiada'],
      color: AppColors.accent,
      icon: Icons.self_improvement, // Icono de meditación para enfriamiento
    ),
  ];

  final Set<int> completedBlocks = {};

  void toggleBlock(int index) {
    setState(() {
      if (completedBlocks.contains(index)) {
        completedBlocks.remove(index);
      } else {
        completedBlocks.add(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final progress = completedBlocks.length / workoutBlocks.length;

    return Scaffold(
      appBar: widget.showAppBar ? AppBar(
        title: Text(
          'Entrenamiento de hoy',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0,
      ) : null,
      body: Column(
        children: [
          // Header (solo mostrar si no hay AppBar)
          if (!widget.showAppBar)
            Container(
              color: AppColors.primary,
              padding: const EdgeInsets.all(24),
              child: SafeArea(
                bottom: false,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Entrenamiento de fuerza',
                                style: Theme.of(context).textTheme.headlineSmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                    ),
                              ),
                              Text(
                                'Duración: 40 min • Nivel: Intermedio',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      color: Colors.white.withOpacity(0.9),
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Progress
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${completedBlocks.length} / ${workoutBlocks.length} bloques',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                '${(progress * 100).round()}%',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          LinearProgressIndicator(
                            value: progress,
                            backgroundColor: Colors.white.withOpacity(0.2),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Workout blocks
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: workoutBlocks.length,
              itemBuilder: (context, index) {
                final block = workoutBlocks[index];
                final isCompleted = completedBlocks.contains(index);

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: block.color.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                isCompleted ? Icons.check_circle : block.icon,
                                color: block.color,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    block.title,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(fontWeight: FontWeight.w900),
                                  ),
                                  Chip(
                                    label: Text(
                                      block.duration,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    backgroundColor: block.color.withOpacity(
                                      0.1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ...block.exercises.map(
                          (exercise) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              children: [
                                Text(
                                  '•',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(exercise),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: isCompleted
                                    ? null
                                    : () async {
                                        // Navigate to exercise detail
                                        final result = await Navigator.of(
                                          context,
                                        ).pushNamed('/exercise/$index');

                                        // If exercise was completed, mark block as done
                                        if (result == true && mounted) {
                                          toggleBlock(index);
                                        }
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: block.color,
                                  disabledBackgroundColor: Colors.grey,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      isCompleted
                                          ? Icons.check
                                          : Icons.play_arrow,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      isCompleted
                                          ? 'Completado'
                                          : 'Iniciar bloque',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if (!isCompleted) ...[
                              const SizedBox(width: 12),
                              OutlinedButton(
                                onPressed: () => toggleBlock(index),
                                style: OutlinedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text('Marcar como hecho'),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Complete workout button
          if (completedBlocks.length == workoutBlocks.length)
            Container(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () async {
                  // Save workout session
                  final session = WorkoutSession(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: 'Entrenamiento de fuerza',
                    date: DateTime.now(),
                    duration: 40, // 40 minutes
                    caloriesBurned: 350, // Approximate calories
                    exercises: workoutBlocks.expand((block) => block.exercises).toList(),
                  );

                  await DataService.saveWorkoutSession(session);
                  await DataService.incrementWorkoutCount();
                  await DataService.addCaloriesBurned(350);

                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          '🎯 ¡Entrenamiento completado! +35 XP y +1 día en tu racha.',
                        ),
                      ),
                    );
                    Navigator.of(context).pop(true); // Return true to indicate completion and refresh
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Finalizar entrenamiento',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
