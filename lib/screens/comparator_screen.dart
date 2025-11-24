import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';
import '../firebase_service.dart';

class ComparatorScreen extends StatefulWidget {
  const ComparatorScreen({super.key});

  @override
  State<ComparatorScreen> createState() => _ComparatorScreenState();
}

class _ComparatorScreenState extends State<ComparatorScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  double height = 170.0;
  double currentWeight = 75.0;
  double targetWeight = 68.0;

  // Gemini AI state
  double _beforeWeight = 165.0;
  double _currentWeight = 154.0;
  bool _isAnalyzing = false;
  String? _analysisResult;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  double calculateBMI(double weight, double heightCm) {
    final heightM = heightCm / 100;
    return weight / (heightM * heightM);
  }

  String getBMICategory(double bmi) {
    if (bmi < 18.5) return "Delgado";
    if (bmi < 25) return "Normal";
    if (bmi < 30) return "Sobrepeso";
    return "Obeso";
  }

  @override
  Widget build(BuildContext context) {
    final currentBMI = calculateBMI(currentWeight, height);
    final targetBMI = calculateBMI(targetWeight, height);
    final weightDifference = currentWeight - targetWeight;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(
              LucideIcons.users,
              color: Colors.white,
              size: 24,
            ),
            const SizedBox(width: 12),
            Text(
              'Comparador corporal',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Comparación individual'),
            Tab(text: 'Análisis con IA'),
          ],
          labelStyle: GoogleFonts.nunito(
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
          unselectedLabelStyle: GoogleFonts.nunito(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white.withOpacity(0.7),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Individual Comparison Tab
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Configuration Card
                Card(
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
                            Icon(
                              LucideIcons.target,
                              color: AppColors.primary,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Configuración',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: AppColors.foreground,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Height Slider
                        _buildSlider(
                          label: 'Altura',
                          icon: LucideIcons.ruler,
                          value: height,
                          min: 140,
                          max: 220,
                          onChanged: (value) => setState(() => height = value),
                          unit: 'cm',
                          color: AppColors.primary,
                        ),

                        const SizedBox(height: 20),

                        // Current Weight Slider
                        _buildSlider(
                          label: 'Peso actual',
                          icon: LucideIcons.weight,
                          value: currentWeight,
                          min: 40,
                          max: 150,
                          onChanged: (value) => setState(() => currentWeight = value),
                          unit: 'kg',
                          color: AppColors.secondary,
                        ),

                        const SizedBox(height: 20),

                        // Target Weight Slider
                        _buildSlider(
                          label: 'Peso objetivo',
                          icon: LucideIcons.target,
                          value: targetWeight,
                          min: 40,
                          max: 150,
                          onChanged: (value) => setState(() => targetWeight = value),
                          unit: 'kg',
                          color: AppColors.accent,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Comparison Cards
                Row(
                  children: [
                    Expanded(
                      child: _buildBodyCard(
                        title: 'Estado actual',
                        badge: 'Tu actual',
                        weight: currentWeight,
                        bmi: currentBMI,
                        height: height,
                        color: AppColors.secondary,
                        isCurrent: true,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildBodyCard(
                        title: 'Cómo te verás',
                        badge: 'Tu meta',
                        weight: targetWeight,
                        bmi: targetBMI,
                        height: height,
                        color: AppColors.accent,
                        isCurrent: false,
                        weightDifference: weightDifference,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Motivation Card
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary.withOpacity(0.1),
                          AppColors.secondary.withOpacity(0.1),
                          AppColors.accent.withOpacity(0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(
                              LucideIcons.target,
                              color: AppColors.primary,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Tu plan personalizado',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.foreground,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  weightDifference > 0
                                      ? 'Para perder ${weightDifference.toStringAsFixed(1)} kg, necesitarás aproximadamente ${(weightDifference / 0.5).ceil()} semanas con una pérdida saludable de 0.5 kg por semana.'
                                      : 'Para ganar ${(targetWeight - currentWeight).toStringAsFixed(1)} kg de masa muscular, necesitarás aproximadamente ${((targetWeight - currentWeight) / 0.5).ceil()} semanas con un incremento saludable de 0.5 kg por semana.',
                                  style: GoogleFonts.nunito(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.mutedForeground,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                SizedBox(
                                  width: double.infinity,
                                  height: 44,
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: Text(
                                      'Iniciar mi plan',
                                      style: GoogleFonts.nunito(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.white,
                                      ),
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

                const SizedBox(height: 80),
              ],
            ),
          ),

          // AI Analysis Tab
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Card(
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
                            Icon(
                              LucideIcons.sparkles,
                              color: AppColors.primary,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Análisis con IA Gemini',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: AppColors.foreground,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Ingresa tu peso anterior y actual para obtener una visualización detallada de cómo te verías con IA avanzada.',
                          style: GoogleFonts.nunito(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.mutedForeground,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Weight input section
                        Column(
                          children: [
                            // Before weight
                            _buildWeightInput(
                              label: 'Peso anterior',
                              value: _beforeWeight,
                              onChanged: (value) => setState(() => _beforeWeight = value),
                              color: AppColors.secondary,
                            ),
                            const SizedBox(height: 20),
                            // Current weight
                            _buildWeightInput(
                              label: 'Peso actual',
                              value: _currentWeight,
                              onChanged: (value) => setState(() => _currentWeight = value),
                              color: AppColors.accent,
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Analyze button
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton.icon(
                            onPressed: _isAnalyzing ? null : _analyzeWithGemini,
                            icon: _isAnalyzing
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Icon(LucideIcons.sparkles),
                            label: Text(
                              _isAnalyzing ? 'Generando...' : 'Generar visualización con IA',
                              style: GoogleFonts.nunito(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),

                        // Analysis result
                        if (_analysisResult != null) ...[
                          const SizedBox(height: 24),
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppColors.primary.withOpacity(0.2),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      LucideIcons.brain,
                                      color: AppColors.primary,
                                      size: 24,
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      'Análisis de Gemini AI',
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w900,
                                        color: AppColors.foreground,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  _analysisResult!,
                                  style: GoogleFonts.nunito(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.mutedForeground,
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSlider({
    required String label,
    required IconData icon,
    required double value,
    required double min,
    required double max,
    required Function(double) onChanged,
    required String unit,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: GoogleFonts.nunito(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.foreground,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                '${value.toStringAsFixed(0)} $unit',
                style: GoogleFonts.nunito(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  color: color,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: (max - min).toInt(),
          onChanged: onChanged,
          activeColor: color,
          inactiveColor: color.withOpacity(0.2),
        ),
      ],
    );
  }

  Widget _buildBodyCard({
    required String title,
    required String badge,
    required double weight,
    required double bmi,
    required double height,
    required Color color,
    required bool isCurrent,
    double? weightDifference,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                badge,
                style: GoogleFonts.nunito(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: AppColors.foreground,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Icon(
                  LucideIcons.user,
                  size: 80,
                  color: color.withOpacity(0.5),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildStatRow('Peso', '${weight.toStringAsFixed(1)} kg'),
                  const SizedBox(height: 8),
                  _buildStatRow('IMC', bmi.toStringAsFixed(1)),
                  const SizedBox(height: 8),
                  _buildStatRow('Altura', '${height.toStringAsFixed(0)} cm'),
                  if (!isCurrent && weightDifference != null) ...[
                    const SizedBox(height: 8),
                    _buildStatRow(
                      'Diferencia',
                      '${weightDifference > 0 ? '-' : '+'}${weightDifference.abs().toStringAsFixed(1)} kg',
                      color: color,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value, {Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.nunito(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColors.mutedForeground,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.nunito(
            fontSize: 14,
            fontWeight: FontWeight.w900,
            color: color ?? AppColors.foreground,
          ),
        ),
      ],
    );
  }

  Widget _buildWeightInput({
    required String label,
    required double value,
    required Function(double) onChanged,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(LucideIcons.weight, color: color, size: 20),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: GoogleFonts.nunito(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.foreground,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                '${value.toStringAsFixed(0)} kg',
                style: GoogleFonts.nunito(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  color: color,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Slider(
          value: value,
          min: 40,
          max: 200,
          divisions: 160,
          onChanged: onChanged,
          activeColor: color,
          inactiveColor: color.withOpacity(0.2),
        ),
      ],
    );
  }



  Future<void> _analyzeWithGemini() async {
    print('Starting body visualization generation...');
    setState(() => _isAnalyzing = true);

    try {
      // Get user data for context
      final userProfile = await FirebaseService.getUserProfile();

      print('Calling Gemini body visualization...');
      // Generate body transformation description with Gemini
      final visualization = await FirebaseService.generateBodyVisualizationWithGemini(
        beforeWeight: _beforeWeight,
        currentWeight: _currentWeight,
        height: height,
        userProfile: userProfile,
      );

      print('Visualization generated successfully');
      setState(() {
        _analysisResult = visualization;
        _isAnalyzing = false;
      });
    } catch (e) {
      print('Error generating visualization: $e');
      setState(() {
        _analysisResult = 'Error al generar la visualización: $e';
        _isAnalyzing = false;
      });
    }
  }

}