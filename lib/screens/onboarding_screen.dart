import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import '../theme.dart';

class OnboardingStep {
  final String title;
  final String description;
  final IconData icon;

  const OnboardingStep({
    required this.title,
    required this.description,
    required this.icon,
  });
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int currentStep = 0;

  final List<OnboardingStep> steps = [
    OnboardingStep(
      title: 'Tu cuerpo, tu camino',
      description: 'Elige tu objetivo: bajar grasa, ganar músculo o definir tu rostro.',
      icon: LucideIcons.dumbbell,
    ),
    OnboardingStep(
      title: 'Aprende visualmente',
      description: 'Cada movimiento tiene una guía animada e instrucciones simples.',
      icon: LucideIcons.eye,
    ),
    OnboardingStep(
      title: 'Visualiza tu progreso',
      description: 'Compara tu estatura y peso con otros y mira cómo te verías.',
      icon: LucideIcons.trending_up,
    ),
    OnboardingStep(
      title: 'Come mejor, vive mejor',
      description: 'Planes alimenticios adaptados a tus metas — para ganar masa o perder peso.',
      icon: LucideIcons.utensils_crossed,
    ),
  ];

  void handleNext() {
    if (currentStep < steps.length - 1) {
      setState(() => currentStep++);
    } else {
      Navigator.of(context).pushReplacementNamed('/main');
    }
  }

  void handlePrev() {
    if (currentStep > 0) {
      setState(() => currentStep--);
    }
  }

  @override
  Widget build(BuildContext context) {
    final step = steps[currentStep];

    return Scaffold(
      body: Column(
        children: [
          // Progress bar
          Container(
            width: double.infinity,
            height: 4,
            color: AppColors.muted,
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: (currentStep + 1) / steps.length,
              child: Container(
                color: AppColors.primary,
              ),
            ),
          ),

          // Main content
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: 500,
                  ),
                  child: Card(
                    elevation: 16,
                    shadowColor: Colors.black.withOpacity(0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                        // Icon
                        Container(
                          width: 128,
                          height: 128,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.primary.withOpacity(0.2),
                                AppColors.secondary.withOpacity(0.2),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Icon(
                            step.icon,
                            size: 64,
                            color: AppColors.primary,
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Title
                        Text(
                          step.title,
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: AppColors.foreground,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 16),

                        // Description
                        Text(
                          step.description,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppColors.mutedForeground,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 32),

                        // Dots
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(steps.length, (index) {
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              width: index == currentStep ? 32 : 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: index == currentStep
                                    ? AppColors.primary
                                    : AppColors.mutedForeground.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            );
                          }),
                        ),

                        const SizedBox(height: 32),

                        // Buttons
                        Row(
                          children: [
                            if (currentStep > 0)
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: handlePrev,
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: AppColors.primary),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.chevron_left),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Anterior',
                                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            if (currentStep > 0) const SizedBox(width: 16),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: handleNext,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      currentStep == steps.length - 1
                                          ? 'Crear mi plan personalizado'
                                          : 'Siguiente',
                                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                    if (currentStep < steps.length - 1) ...[
                                      const SizedBox(width: 8),
                                      const Icon(Icons.chevron_right, color: Colors.white),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}