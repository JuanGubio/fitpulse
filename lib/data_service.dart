import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class WorkoutSession {
  final String id;
  final String name;
  final DateTime date;
  final int duration; // in minutes
  final int caloriesBurned;
  final List<String> exercises;

  WorkoutSession({
    required this.id,
    required this.name,
    required this.date,
    required this.duration,
    required this.caloriesBurned,
    required this.exercises,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'date': date.toIso8601String(),
    'duration': duration,
    'caloriesBurned': caloriesBurned,
    'exercises': exercises,
  };

  factory WorkoutSession.fromJson(Map<String, dynamic> json) => WorkoutSession(
    id: json['id'],
    name: json['name'],
    date: DateTime.parse(json['date']),
    duration: json['duration'],
    caloriesBurned: json['caloriesBurned'],
    exercises: List<String>.from(json['exercises']),
  );
}

class MealEntry {
  final String id;
  final String name;
  final DateTime date;
  final int calories;
  final String type; // breakfast, lunch, dinner, snack

  MealEntry({
    required this.id,
    required this.name,
    required this.date,
    required this.calories,
    required this.type,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'date': date.toIso8601String(),
    'calories': calories,
    'type': type,
  };

  factory MealEntry.fromJson(Map<String, dynamic> json) => MealEntry(
    id: json['id'],
    name: json['name'],
    date: DateTime.parse(json['date']),
    calories: json['calories'],
    type: json['type'],
  );
}

class WeightEntry {
  final String id;
  final DateTime date;
  final double weight;

  WeightEntry({
    required this.id,
    required this.date,
    required this.weight,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'date': date.toIso8601String(),
    'weight': weight,
  };

  factory WeightEntry.fromJson(Map<String, dynamic> json) => WeightEntry(
    id: json['id'],
    date: DateTime.parse(json['date']),
    weight: json['weight'],
  );
}

class DataService {
  static const String _workoutsKey = 'workouts';
  static const String _mealsKey = 'meals';
  static const String _weightsKey = 'weights';
  static const String _userStatsKey = 'userStats';

  // Workout methods
  static Future<void> saveWorkoutSession(WorkoutSession session) async {
    final prefs = await SharedPreferences.getInstance();
    final workouts = await getWorkoutSessions();
    workouts.add(session);

    final workoutsJson = workouts.map((w) => w.toJson()).toList();
    await prefs.setString(_workoutsKey, jsonEncode(workoutsJson));
  }

  static Future<List<WorkoutSession>> getWorkoutSessions() async {
    final prefs = await SharedPreferences.getInstance();
    final workoutsJson = prefs.getString(_workoutsKey);

    if (workoutsJson == null) return [];

    final workoutsData = jsonDecode(workoutsJson) as List;
    return workoutsData.map((w) => WorkoutSession.fromJson(w)).toList();
  }

  static Future<List<WorkoutSession>> getWorkoutsForDate(DateTime date) async {
    final allWorkouts = await getWorkoutSessions();
    return allWorkouts.where((workout) =>
      workout.date.year == date.year &&
      workout.date.month == date.month &&
      workout.date.day == date.day
    ).toList();
  }

  // Meal methods
  static Future<void> saveMealEntry(MealEntry meal) async {
    final prefs = await SharedPreferences.getInstance();
    final meals = await getMealEntries();
    meals.add(meal);

    final mealsJson = meals.map((m) => m.toJson()).toList();
    await prefs.setString(_mealsKey, jsonEncode(mealsJson));
  }

  static Future<List<MealEntry>> getMealEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final mealsJson = prefs.getString(_mealsKey);

    if (mealsJson == null) return [];

    final mealsData = jsonDecode(mealsJson) as List;
    return mealsData.map((m) => MealEntry.fromJson(m)).toList();
  }

  static Future<List<MealEntry>> getMealsForDate(DateTime date) async {
    final allMeals = await getMealEntries();
    return allMeals.where((meal) =>
      meal.date.year == date.year &&
      meal.date.month == date.month &&
      meal.date.day == date.day
    ).toList();
  }

  static Future<int> getTotalCaloriesForDate(DateTime date) async {
    final meals = await getMealsForDate(date);
    return meals.fold<int>(0, (sum, meal) => sum + meal.calories);
  }

  // Weight methods
  static Future<void> saveWeightEntry(WeightEntry weight) async {
    final prefs = await SharedPreferences.getInstance();
    final weights = await getWeightEntries();
    weights.add(weight);

    final weightsJson = weights.map((w) => w.toJson()).toList();
    await prefs.setString(_weightsKey, jsonEncode(weightsJson));
  }

  static Future<List<WeightEntry>> getWeightEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final weightsJson = prefs.getString(_weightsKey);

    if (weightsJson == null) return [];

    final weightsData = jsonDecode(weightsJson) as List;
    return weightsData.map((w) => WeightEntry.fromJson(w)).toList();
  }

  static Future<double?> getLatestWeight() async {
    final weights = await getWeightEntries();
    if (weights.isEmpty) return null;

    weights.sort((a, b) => b.date.compareTo(a.date));
    return weights.first.weight;
  }

  // Statistics methods
  static Future<Map<String, dynamic>> getUserStats() async {
    final prefs = await SharedPreferences.getInstance();
    final statsJson = prefs.getString(_userStatsKey);

    if (statsJson != null) {
      return jsonDecode(statsJson);
    }

    // Default stats
    return {
      'totalWorkouts': 0,
      'totalCaloriesBurned': 0,
      'totalMealsLogged': 0,
      'currentStreak': 0,
      'longestStreak': 0,
      'joinDate': DateTime.now().toIso8601String(),
    };
  }

  static Future<void> updateUserStats(Map<String, dynamic> stats) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userStatsKey, jsonEncode(stats));
  }

  static Future<void> incrementWorkoutCount() async {
    final stats = await getUserStats();
    stats['totalWorkouts'] = (stats['totalWorkouts'] ?? 0) + 1;
    await updateUserStats(stats);
  }

  static Future<void> addCaloriesBurned(int calories) async {
    final stats = await getUserStats();
    stats['totalCaloriesBurned'] = (stats['totalCaloriesBurned'] ?? 0) + calories;
    await updateUserStats(stats);
  }

  static Future<void> incrementMealCount() async {
    final stats = await getUserStats();
    stats['totalMealsLogged'] = (stats['totalMealsLogged'] ?? 0) + 1;
    await updateUserStats(stats);
  }

  // Calendar data for progress screen
  static Future<Map<DateTime, List<String>>> getCalendarData() async {
    final workouts = await getWorkoutSessions();
    final meals = await getMealEntries();

    final Map<DateTime, List<String>> calendarData = {};

    // Add workout days
    for (final workout in workouts) {
      final date = DateTime(workout.date.year, workout.date.month, workout.date.day);
      calendarData[date] = calendarData[date] ?? [];
      if (!calendarData[date]!.contains('workout')) {
        calendarData[date]!.add('workout');
      }
    }

    // Add meal days
    for (final meal in meals) {
      final date = DateTime(meal.date.year, meal.date.month, meal.date.day);
      calendarData[date] = calendarData[date] ?? [];
      if (!calendarData[date]!.contains('meal')) {
        calendarData[date]!.add('meal');
      }
    }

    return calendarData;
  }

  // Weekly progress
  static Future<Map<String, dynamic>> getWeeklyProgress() async {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekEnd = weekStart.add(const Duration(days: 6));

    final workouts = await getWorkoutSessions();
    final meals = await getMealEntries();

    final weeklyWorkouts = workouts.where((w) =>
      w.date.isAfter(weekStart.subtract(const Duration(days: 1))) &&
      w.date.isBefore(weekEnd.add(const Duration(days: 1)))
    ).toList();

    final weeklyMeals = meals.where((m) =>
      m.date.isAfter(weekStart.subtract(const Duration(days: 1))) &&
      m.date.isBefore(weekEnd.add(const Duration(days: 1)))
    ).toList();

    final totalCaloriesBurned = weeklyWorkouts.fold(0, (sum, w) => sum + w.caloriesBurned);
    final totalCaloriesConsumed = weeklyMeals.fold(0, (sum, m) => sum + m.calories);

    return {
      'workoutsThisWeek': weeklyWorkouts.length,
      'mealsThisWeek': weeklyMeals.length,
      'caloriesBurned': totalCaloriesBurned,
      'caloriesConsumed': totalCaloriesConsumed,
      'netCalories': totalCaloriesConsumed - totalCaloriesBurned,
    };
  }

  // Clear all data (for testing or reset)
  static Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_workoutsKey);
    await prefs.remove(_mealsKey);
    await prefs.remove(_weightsKey);
    await prefs.remove(_userStatsKey);
  }
}