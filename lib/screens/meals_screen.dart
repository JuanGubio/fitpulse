import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';
import '../data_service.dart';

class MealItem {
  final String meal;
  final String time;
  final int calories;
  final List<String> items;
  final IconData icon;
  final Color color;

  const MealItem({
    required this.meal,
    required this.time,
    required this.calories,
    required this.items,
    required this.icon,
    required this.color,
  });
}

class MealsScreen extends StatefulWidget {
  final bool showAppBar;

  const MealsScreen({super.key, this.showAppBar = true});

  @override
  State<MealsScreen> createState() => _MealsScreenState();
}

class _MealsScreenState extends State<MealsScreen> {
  String selectedGoal = "Bajar de peso";
  Map<String, bool> eatenMeals = {};

  final Map<String, List<MealItem>> mealPlans = {
    "Bajar de peso": [
      MealItem(
        meal: "Desayuno",
        time: "7:00 AM",
        calories: 350,
        items: ["2 huevos revueltos", "1 tostada integral", "1/2 aguacate", "Café negro"],
        icon: LucideIcons.apple,
        color: AppColors.primary,
      ),
      MealItem(
        meal: "Almuerzo",
        time: "1:00 PM",
        calories: 500,
        items: ["150g pechuga de pollo", "Ensalada verde mixta", "1 taza de arroz integral"],
        icon: LucideIcons.chef_hat,
        color: AppColors.secondary,
      ),
      MealItem(
        meal: "Cena",
        time: "7:00 PM",
        calories: 400,
        items: ["Salmón al horno 120g", "Vegetales al vapor", "Quinoa 1/2 taza"],
        icon: LucideIcons.drumstick,
        color: AppColors.accent,
      ),
      MealItem(
        meal: "Snack",
        time: "4:00 PM",
        calories: 150,
        items: ["Yogurt griego", "Almendras (10 unidades)", "1 manzana"],
        icon: LucideIcons.cookie,
        color: AppColors.primary,
      ),
    ],
    "Ganar músculo": [
      MealItem(
        meal: "Desayuno",
        time: "7:00 AM",
        calories: 550,
        items: ["3 huevos enteros", "2 tostadas", "Mantequilla de maní", "Batido de proteína"],
        icon: LucideIcons.apple,
        color: AppColors.primary,
      ),
      MealItem(
        meal: "Almuerzo",
        time: "1:00 PM",
        calories: 750,
        items: ["200g carne roja magra", "2 tazas de arroz", "Ensalada con aceite de oliva"],
        icon: LucideIcons.chef_hat,
        color: AppColors.secondary,
      ),
      MealItem(
        meal: "Cena",
        time: "7:00 PM",
        calories: 650,
        items: ["Pechuga de pollo 200g", "Pasta integral", "Brócoli y zanahoria"],
        icon: LucideIcons.drumstick,
        color: AppColors.accent,
      ),
      MealItem(
        meal: "Snack Pre-entreno",
        time: "5:00 PM",
        calories: 300,
        items: ["Batido de proteína", "Banana", "Avena"],
        icon: LucideIcons.cookie,
        color: AppColors.primary,
      ),
    ],
  };

  @override
  void initState() {
    super.initState();
    _loadEatenMeals();
  }

  Future<void> _loadEatenMeals() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString('eatenMeals');
    if (stored != null) {
      setState(() {
        eatenMeals = Map<String, bool>.from(
          (stored as Map<String, dynamic>).map(
            (key, value) => MapEntry(key, value as bool),
          ),
        );
      });
    }
  }

  Future<void> _saveEatenMeals() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('eatenMeals', eatenMeals.toString());
  }

  void handleMealEaten(String mealName) async {
    final today = DateTime.now();
    final isEaten = getMealEaten(mealName);

    if (!isEaten) {
      // Find the meal item to get calories
      final meals = mealPlans[selectedGoal]!;
      final mealItem = meals.firstWhere((meal) => meal.meal == mealName);

      // Save meal entry
      final mealEntry = MealEntry(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: mealName,
        date: today,
        calories: mealItem.calories,
        type: mealName.toLowerCase(),
      );

      await DataService.saveMealEntry(mealEntry);
      await DataService.incrementMealCount();
    }

    // Update local state
    final key = '${today.toIso8601String().split('T')[0]}-$mealName';
    setState(() {
      eatenMeals[key] = !isEaten;
    });
    _saveEatenMeals();
  }

  bool getMealEaten(String mealName) {
    final today = DateTime.now().toIso8601String().split('T')[0];
    final key = '$today-$mealName';
    return eatenMeals[key] ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final meals = mealPlans[selectedGoal]!;
    final totalCalories = meals.fold<int>(0, (sum, meal) => sum + meal.calories);
    final targetCalories = selectedGoal == "Bajar de peso" ? 1800 : 2800;
    final caloriesProgress = (totalCalories / targetCalories) * 100;

    return Scaffold(
      appBar: widget.showAppBar ? AppBar(
        title: Text(
          'Plan de comidas',
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
                  colors: [AppColors.accent, AppColors.secondary, AppColors.primary],
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Plan de comidas',
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
                      'Nutrición personalizada para tu objetivo',
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

          // Goal selector
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(16),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => setState(() => selectedGoal = "Bajar de peso"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: selectedGoal == "Bajar de peso"
                                ? AppColors.primary
                                : Colors.transparent,
                            foregroundColor: selectedGoal == "Bajar de peso"
                                ? Colors.white
                                : AppColors.primary,
                            elevation: selectedGoal == "Bajar de peso" ? 4 : 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: Text(
                            'Bajar de peso',
                            style: GoogleFonts.nunito(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => setState(() => selectedGoal = "Ganar músculo"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: selectedGoal == "Ganar músculo"
                                ? AppColors.primary
                                : Colors.transparent,
                            foregroundColor: selectedGoal == "Ganar músculo"
                                ? Colors.white
                                : AppColors.primary,
                            elevation: selectedGoal == "Ganar músculo" ? 4 : 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: Text(
                            'Ganar músculo',
                            style: GoogleFonts.nunito(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Calories progress
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Calorías del día',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: AppColors.foreground,
                            ),
                          ),
                          Chip(
                            label: Text(
                              '$totalCalories / $targetCalories kcal',
                              style: GoogleFonts.nunito(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            backgroundColor: AppColors.primary,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      LinearProgressIndicator(
                        value: caloriesProgress / 100,
                        backgroundColor: Colors.grey.withOpacity(0.2),
                        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        targetCalories - totalCalories > 0
                            ? 'Te quedan ${targetCalories - totalCalories} kcal'
                            : 'Meta alcanzada',
                        style: GoogleFonts.nunito(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.mutedForeground,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Meals list
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                meals.map((meal) {
                  final isEaten = getMealEaten(meal.meal);
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
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  color: meal.color.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Icon(
                                  meal.icon,
                                  color: meal.color,
                                  size: 28,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      meal.meal,
                                      style: GoogleFonts.poppins(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w900,
                                        color: AppColors.foreground,
                                      ),
                                    ),
                                    Text(
                                      meal.time,
                                      style: GoogleFonts.nunito(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.mutedForeground,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Chip(
                                label: Text(
                                  '${meal.calories} kcal',
                                  style: GoogleFonts.nunito(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                backgroundColor: Colors.grey.withOpacity(0.1),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          ...meal.items.map((item) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    item,
                                    style: GoogleFonts.nunito(
                                      fontSize: 14,
                                      color: AppColors.mutedForeground,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            height: 44,
                            child: ElevatedButton(
                              onPressed: () => handleMealEaten(meal.meal),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isEaten ? AppColors.primary : Colors.transparent,
                                foregroundColor: isEaten ? Colors.white : AppColors.primary,
                                side: BorderSide(
                                  color: AppColors.primary,
                                  width: isEaten ? 0 : 1,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    isEaten ? Icons.check : Icons.check,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    isEaten ? 'Comido' : 'Marcar como comido',
                                    style: GoogleFonts.nunito(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}