import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';
import '../data_service.dart';

class WeightData {
  final String week;
  final double weight;

  const WeightData({required this.week, required this.weight});
}

class CalendarDay {
  final int day;
  final bool workout;
  final bool meal;
  final bool faceExercise;

  const CalendarDay({
    required this.day,
    required this.workout,
    required this.meal,
    required this.faceExercise,
  });
}

class ProgressScreen extends StatefulWidget {
  final bool showAppBar;

  const ProgressScreen({super.key, this.showAppBar = true});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();

  // Method to refresh the screen from outside
  static void refresh(BuildContext context) {
    final state = context.findAncestorStateOfType<_ProgressScreenState>();
    state?._loadCalendarData();
  }
}

class _ProgressScreenState extends State<ProgressScreen> {
  final List<WeightData> weightData = [
    WeightData(week: "Sem 1", weight: 78.0),
    WeightData(week: "Sem 2", weight: 77.5),
    WeightData(week: "Sem 3", weight: 76.8),
    WeightData(week: "Sem 4", weight: 75.2),
  ];

  Map<String, Map<String, dynamic>> calendarData = {};
  int selectedDay = -1;
  Map<String, dynamic>? selectedDayData;
  bool showDayDetail = false;

  int totalWorkouts = 0;
  int currentStreak = 3;
  double kgLost = 2.8;

  @override
  void initState() {
    super.initState();
    _loadCalendarData();
  }

  Future<void> _loadCalendarData() async {
    final calendar = await DataService.getCalendarData();
    final userStats = await DataService.getUserStats();

    setState(() {
      // Convert DateTime keys to string keys for compatibility
      calendarData = {};
      calendar.forEach((date, activities) {
        final dateStr = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
        calendarData[dateStr] = {
          'workout': activities.contains('workout'),
          'meal': activities.contains('meal'),
          'faceExercise': false, // Not implemented yet
        };
      });

      totalWorkouts = userStats['totalWorkouts'] ?? 0;
      currentStreak = userStats['currentStreak'] ?? 0;
      kgLost = 2.8; // This would need weight tracking implementation
    });
  }

  void _calculateStats() {
    // Stats are now loaded from DataService in _loadCalendarData
    setState(() {});
  }

  List<CalendarDay> generateCalendar() {
    final now = DateTime.now();
    final year = now.year;
    final month = now.month;
    final daysInMonth = DateTime(year, month + 1, 0).day;

    final calendar = <CalendarDay>[];
    for (int day = 1; day <= daysInMonth; day++) {
      final dateStr = '$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
      final data = calendarData[dateStr] ?? {};
      calendar.add(CalendarDay(
        day: day,
        workout: data['workout'] ?? false,
        meal: data['meal'] ?? false,
        faceExercise: data['faceExercise'] ?? false,
      ));
    }
    return calendar;
  }

  void openDayDetail(int day) {
    final now = DateTime.now();
    final year = now.year;
    final month = now.month;
    final dateStr = '$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
    final data = calendarData[dateStr];

    if (data != null && (data['workout'] == true || data['meal'] == true || data['faceExercise'] == true)) {
      setState(() {
        selectedDay = day;
        selectedDayData = data;
        showDayDetail = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final monthData = generateCalendar();

    return Scaffold(
      appBar: widget.showAppBar ? AppBar(
        title: Text(
          'Progreso',
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
      body: CustomScrollView(
        slivers: [
          // Header
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.secondary, AppColors.primary, AppColors.accent],
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tu progreso',
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.3),
                            offset: const Offset(0, 2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Visualiza tu evolución',
                      style: GoogleFonts.nunito(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Stats Summary
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Icon(
                              LucideIcons.activity,
                              color: AppColors.primary,
                              size: 32,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '$totalWorkouts',
                              style: GoogleFonts.poppins(
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                                color: AppColors.foreground,
                              ),
                            ),
                            Text(
                              'Entrenamientos',
                              style: GoogleFonts.nunito(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppColors.mutedForeground,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Icon(
                              LucideIcons.flame,
                              color: AppColors.accent,
                              size: 32,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '$currentStreak',
                              style: GoogleFonts.poppins(
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                                color: AppColors.foreground,
                              ),
                            ),
                            Text(
                              'Días racha',
                              style: GoogleFonts.nunito(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppColors.mutedForeground,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Icon(
                              LucideIcons.trending_down,
                              color: AppColors.secondary,
                              size: 32,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '-$kgLost',
                              style: GoogleFonts.poppins(
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                                color: AppColors.foreground,
                              ),
                            ),
                            Text(
                              'kg perdidos',
                              style: GoogleFonts.nunito(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppColors.mutedForeground,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Weight Progress Chart
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Evolución de peso',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: AppColors.foreground,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...weightData.map((data) {
                        final maxWeight = weightData.map((d) => d.weight).reduce((a, b) => a > b ? a : b);
                        final progress = data.weight / maxWeight;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 60,
                                child: Text(
                                  data.week,
                                  style: GoogleFonts.nunito(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.mutedForeground,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: FractionallySizedBox(
                                    alignment: Alignment.centerLeft,
                                    widthFactor: progress,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [AppColors.primary, AppColors.secondary],
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Padding(
                                          padding: const EdgeInsets.only(right: 12),
                                          child: Text(
                                            '${data.weight} kg',
                                            style: GoogleFonts.nunito(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w900,
                                              color: Colors.white,
                                            ),
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
                      }),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Activity Calendar
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(16),
              child: Card(
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Calendario de actividad',
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: AppColors.foreground,
                            ),
                          ),
                          Icon(
                            LucideIcons.calendar,
                            color: AppColors.primary,
                            size: 24,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Legend
                      Wrap(
                        spacing: 16,
                        runSpacing: 8,
                        children: [
                          _buildLegendItem('Entrenamiento', AppColors.primary),
                          _buildLegendItem('Alimentación', AppColors.accent),
                          _buildLegendItem('Ejercicios faciales', AppColors.secondary),
                          _buildLegendItem('Sin actividad', Colors.grey),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Calendar Grid
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 7,
                          crossAxisSpacing: 4,
                          mainAxisSpacing: 4,
                        ),
                        itemCount: monthData.length,
                        itemBuilder: (context, index) {
                          final data = monthData[index];
                          final bothComplete = data.workout && data.meal;
                          Color bgColor;

                          if (bothComplete) {
                            bgColor = AppColors.secondary;
                          } else if (data.workout) {
                            bgColor = AppColors.primary;
                          } else if (data.faceExercise) {
                            bgColor = AppColors.accent;
                          } else {
                            bgColor = Colors.grey.withOpacity(0.3);
                          }

                          final hasActivity = data.workout || data.meal || data.faceExercise;

                          return GestureDetector(
                            onTap: hasActivity ? () => openDayDetail(data.day) : null,
                            child: Container(
                              decoration: BoxDecoration(
                                color: bgColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Text(
                                    '${data.day}',
                                    style: GoogleFonts.nunito(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w900,
                                      color: hasActivity ? Colors.white : AppColors.mutedForeground,
                                    ),
                                  ),
                                  if (bothComplete)
                                    Positioned(
                                      bottom: 2,
                                      child: Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 10,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Achievements
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(16),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary.withOpacity(0.05),
                        AppColors.secondary.withOpacity(0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Logros recientes',
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: AppColors.foreground,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildAchievement(
                          'Racha de $currentStreak días',
                          'Continúa así',
                          LucideIcons.flame,
                          AppColors.accent,
                        ),
                        const SizedBox(height: 12),
                        _buildAchievement(
                          '$totalWorkouts entrenamientos completados',
                          'Vas por buen camino',
                          LucideIcons.activity,
                          AppColors.primary,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),

      // Day Detail Modal
      floatingActionButton: showDayDetail
          ? Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: Card(
                  margin: const EdgeInsets.all(32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Detalles del día',
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: AppColors.foreground,
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (selectedDayData != null) ...[
                          Text(
                            'Día $selectedDay',
                            style: GoogleFonts.nunito(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.mutedForeground,
                            ),
                          ),
                          const SizedBox(height: 16),
                          if (selectedDayData!['workout'] == true)
                            _buildActivityCard(
                              'Entrenamiento completado',
                              'Realizaste ejercicios este día',
                              LucideIcons.dumbbell,
                              AppColors.primary,
                            ),
                          if (selectedDayData!['meal'] == true)
                            _buildActivityCard(
                              'Plan alimenticio seguido',
                              'Cumpliste tu plan de comidas',
                              LucideIcons.utensils_crossed,
                              AppColors.accent,
                            ),
                          if (selectedDayData!['faceExercise'] == true)
                            _buildActivityCard(
                              'Ejercicios faciales',
                              'Completaste tu rutina facial',
                              LucideIcons.activity,
                              AppColors.secondary,
                            ),
                        ],
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () => setState(() => showDayDetail = false),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                          ),
                          child: Text(
                            'Cerrar',
                            style: GoogleFonts.nunito(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: GoogleFonts.nunito(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: AppColors.mutedForeground,
          ),
        ),
      ],
    );
  }

  Widget _buildAchievement(String title, String subtitle, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: AppColors.foreground,
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.nunito(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.mutedForeground,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityCard(String title, String subtitle, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: AppColors.foreground,
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.nunito(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.mutedForeground,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}