import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _ageController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _goalWeightController = TextEditingController();

  String _gender = 'Masculino';
  String _activityLevel = 'Moderado';
  String _goal = 'Perder peso';

  final List<String> genders = ['Masculino', 'Femenino', 'Otro'];
  final List<String> activityLevels = [
    'Sedentario',
    'Ligero',
    'Moderado',
    'Activo',
    'Muy activo',
  ];
  final List<String> goals = [
    'Perder peso',
    'Ganar masa muscular',
    'Mantener peso',
    'Mejorar condición física',
  ];

  bool _isLoading = false;

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Simulate saving
    await Future.delayed(const Duration(seconds: 1));

    final prefs = await SharedPreferences.getInstance();
    final profileData = {
      'age': int.tryParse(_ageController.text) ?? 25,
      'weight': double.tryParse(_weightController.text) ?? 70.0,
      'height': double.tryParse(_heightController.text) ?? 170.0,
      'goalWeight': double.tryParse(_goalWeightController.text) ?? 65.0,
      'gender': _gender,
      'activityLevel': _activityLevel,
      'goal': _goal,
    };

    await prefs.setString('userProfileData', profileData.toString());

    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/welcome');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primary, AppColors.secondary, AppColors.accent],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          LucideIcons.user,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Configura tu perfil',
                              style: GoogleFonts.poppins(
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Cuéntanos más sobre ti para personalizar tu experiencia',
                              style: GoogleFonts.nunito(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Progress indicator
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.check_circle,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Paso 1 de 2 completado',
                          style: GoogleFonts.nunito(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          width: 100,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: 0.5,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Form card
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Información personal',
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: AppColors.foreground,
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Age
                        TextFormField(
                          controller: _ageController,
                          decoration: InputDecoration(
                            labelText: 'Edad',
                            prefixIcon: const Icon(LucideIcons.calendar),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Por favor ingresa tu edad';
                            }
                            final age = int.tryParse(value!);
                            if (age == null || age < 13 || age > 100) {
                              return 'Ingresa una edad válida (13-100 años)';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

                        // Gender
                        DropdownButtonFormField<String>(
                          value: _gender,
                          decoration: InputDecoration(
                            labelText: 'Género',
                            prefixIcon: const Icon(LucideIcons.users),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          items: genders.map((gender) {
                            return DropdownMenuItem(
                              value: gender,
                              child: Text(gender),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() => _gender = value!);
                          },
                        ),

                        const SizedBox(height: 24),

                        Text(
                          'Medidas corporales',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: AppColors.foreground,
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Current Weight
                        TextFormField(
                          controller: _weightController,
                          decoration: InputDecoration(
                            labelText: 'Peso actual (kg)',
                            prefixIcon: const Icon(LucideIcons.weight),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Por favor ingresa tu peso actual';
                            }
                            final weight = double.tryParse(value!);
                            if (weight == null || weight < 30 || weight > 300) {
                              return 'Ingresa un peso válido';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

                        // Current Body Fat (optional)
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Grasa corporal actual (%) - Opcional',
                            prefixIcon: const Icon(LucideIcons.percent),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                        ),

                        const SizedBox(height: 16),

                        // Height
                        TextFormField(
                          controller: _heightController,
                          decoration: InputDecoration(
                            labelText: 'Altura (cm)',
                            prefixIcon: const Icon(LucideIcons.ruler),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Por favor ingresa tu altura';
                            }
                            final height = double.tryParse(value!);
                            if (height == null ||
                                height < 100 ||
                                height > 250) {
                              return 'Ingresa una altura válida';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

                        // Goal weight
                        TextFormField(
                          controller: _goalWeightController,
                          decoration: InputDecoration(
                            labelText: 'Peso objetivo (kg)',
                            prefixIcon: const Icon(LucideIcons.target),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Por favor ingresa tu peso objetivo';
                            }
                            final goalWeight = double.tryParse(value!);
                            if (goalWeight == null ||
                                goalWeight < 30 ||
                                goalWeight > 300) {
                              return 'Ingresa un peso válido';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

                        // Waist circumference
                        TextFormField(
                          decoration: InputDecoration(
                            labelText:
                                'Circunferencia de cintura (cm) - Opcional',
                            prefixIcon: const Icon(LucideIcons.ruler),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                        ),

                        const SizedBox(height: 16),

                        // Hip circumference
                        TextFormField(
                          decoration: InputDecoration(
                            labelText:
                                'Circunferencia de cadera (cm) - Opcional',
                            prefixIcon: const Icon(LucideIcons.ruler),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                        ),

                        const SizedBox(height: 24),

                        Text(
                          'Estilo de vida',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: AppColors.foreground,
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Activity level
                        DropdownButtonFormField<String>(
                          value: _activityLevel,
                          decoration: InputDecoration(
                            labelText: 'Nivel de actividad',
                            prefixIcon: const Icon(LucideIcons.activity),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          items: activityLevels.map((level) {
                            return DropdownMenuItem(
                              value: level,
                              child: Text(level),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() => _activityLevel = value!);
                          },
                        ),

                        const SizedBox(height: 16),

                        // Goal
                        DropdownButtonFormField<String>(
                          value: _goal,
                          decoration: InputDecoration(
                            labelText: 'Objetivo principal',
                            prefixIcon: const Icon(LucideIcons.target),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          items: goals.map((goal) {
                            return DropdownMenuItem(
                              value: goal,
                              child: Text(goal),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() => _goal = value!);
                          },
                        ),

                        const SizedBox(height: 32),

                        // Save button
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _saveProfile,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 4,
                              shadowColor: AppColors.primary.withOpacity(0.3),
                            ),
                            child: _isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Guardar y continuar',
                                        style: GoogleFonts.nunito(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w900,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      const Icon(
                                        Icons.arrow_forward,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _ageController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _goalWeightController.dispose();
    super.dispose();
  }
}
