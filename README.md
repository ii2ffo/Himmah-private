import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FoodEntry {
  FoodEntry({
    required this.name,
    required this.calories,
    required this.protein,
    this.carbs = 0,
    this.fat = 0,
  });

  final String name;
  final int calories;
  final int protein;
  final int carbs;
  final int fat;

  Map<String, dynamic> toJson() => {
        'name': name,
        'calories': calories,
        'protein': protein,
        'carbs': carbs,
        'fat': fat,
      };

  factory FoodEntry.fromJson(Map<String, dynamic> json) => FoodEntry(
        name: json['name'] as String? ?? 'وجبة',
        calories: (json['calories'] as num?)?.toInt() ?? 0,
        protein: (json['protein'] as num?)?.toInt() ?? 0,
        carbs: (json['carbs'] as num?)?.toInt() ?? 0,
        fat: (json['fat'] as num?)?.toInt() ?? 0,
      );
}

class WorkoutEntry {
  WorkoutEntry({required this.name, required this.minutes, DateTime? date})
      : date = date ?? DateTime.now();
  final String name;
  final int minutes;
  final DateTime date;

  Map<String, dynamic> toJson() => {
        'name': name,
        'minutes': minutes,
        'date': date.toIso8601String(),
      };

  factory WorkoutEntry.fromJson(Map<String, dynamic> json) => WorkoutEntry(
        name: json['name'] as String? ?? 'تمرين',
        minutes: (json['minutes'] as num?)?.toInt() ?? 0,
        date: DateTime.tryParse(json['date'] as String? ?? ''),
      );
}

class WeightEntry {
  WeightEntry({required this.weight, required this.date});
  final double weight;
  final DateTime date;

  Map<String, dynamic> toJson() => {
        'weight': weight,
        'date': date.toIso8601String(),
      };

  factory WeightEntry.fromJson(Map<String, dynamic> json) => WeightEntry(
        weight: (json['weight'] as num?)?.toDouble() ?? 0,
        date: DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime.now(),
      );
}

class AppState extends ChangeNotifier {
  static const _storageKey = 'himmah_state_v3';
  bool isLoggedIn = false;
  String name = 'محمد';
  int calorieGoal = 2200;
  int proteinGoal = 160;
  int carbGoal = 250;
  int fatGoal = 70;
  int waterGoalMl = 3000;
  int waterMl = 0;
  int steps = 0;
  int stepGoal = 10000;
  double weight = 91.2;
  double startWeight = 99;
  double targetWeight = 86;
  String lastDailyReset = '';

  final List<FoodEntry> foods = [];
  final List<WorkoutEntry> workouts = [];
  final List<WeightEntry> weightHistory = [];

  int get caloriesConsumed => foods.fold(0, (sum, item) => sum + item.calories);
  int get proteinConsumed => foods.fold(0, (sum, item) => sum + item.protein);
  int get carbsConsumed => foods.fold(0, (sum, item) => sum + item.carbs);
  int get fatConsumed => foods.fold(0, (sum, item) => sum + item.fat);
  int get caloriesRemaining => (calorieGoal - caloriesConsumed).clamp(0, calorieGoal);
  int get workoutMinutesToday => workouts
      .where((item) => _sameDay(item.date, DateTime.now()))
      .fold(0, (sum, item) => sum + item.minutes);

  double get weightProgress {
    final total = (startWeight - targetWeight).abs();
    if (total == 0) return 1;
    return ((startWeight - weight).abs() / total).clamp(0, 1);
  }

  static bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  String get _todayKey {
    final now = DateTime.now();
    return '${now.year}-${now.month}-${now.day}';
  }

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey) ?? prefs.getString('himmah_state_v2');
    if (raw != null) {
      try {
        final data = jsonDecode(raw) as Map<String, dynamic>;
        isLoggedIn = data['isLoggedIn'] as bool? ?? false;
        name = data['name'] as String? ?? name;
        calorieGoal = (data['calorieGoal'] as num?)?.toInt() ?? calorieGoal;
        proteinGoal = (data['proteinGoal'] as num?)?.toInt() ?? proteinGoal;
        carbGoal = (data['carbGoal'] as num?)?.toInt() ?? carbGoal;
        fatGoal = (data['fatGoal'] as num?)?.toInt() ?? fatGoal;
        waterGoalMl = (data['waterGoalMl'] as num?)?.toInt() ?? waterGoalMl;
        waterMl = (data['waterMl'] as num?)?.toInt() ?? waterMl;
        steps = (data['steps'] as num?)?.toInt() ?? steps;
        stepGoal = (data['stepGoal'] as num?)?.toInt() ?? stepGoal;
        weight = (data['weight'] as num?)?.toDouble() ?? weight;
        startWeight = (data['startWeight'] as num?)?.toDouble() ?? startWeight;
        targetWeight = (data['targetWeight'] as num?)?.toDouble() ?? targetWeight;
        lastDailyReset = data['lastDailyReset'] as String? ?? '';
        foods.addAll((data['foods'] as List? ?? []).map(
          (e) => FoodEntry.fromJson(Map<String, dynamic>.from(e as Map)),
        ));
        workouts.addAll((data['workouts'] as List? ?? []).map(
          (e) => WorkoutEntry.fromJson(Map<String, dynamic>.from(e as Map)),
        ));
        weightHistory.addAll((data['weightHistory'] as List? ?? []).map(
          (e) => WeightEntry.fromJson(Map<String, dynamic>.from(e as Map)),
        ));
      } catch (_) {
        await prefs.remove(_storageKey);
      }
    }

    if (weightHistory.isEmpty) {
      weightHistory.add(WeightEntry(weight: weight, date: DateTime.now()));
    }
    if (lastDailyReset != _todayKey) {
      foods.clear();
      waterMl = 0;
      steps = 0;
      lastDailyReset = _todayKey;
    }
    await _save();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, jsonEncode({
      'isLoggedIn': isLoggedIn,
      'name': name,
      'calorieGoal': calorieGoal,
      'proteinGoal': proteinGoal,
      'carbGoal': carbGoal,
      'fatGoal': fatGoal,
      'waterGoalMl': waterGoalMl,
      'waterMl': waterMl,
      'steps': steps,
      'stepGoal': stepGoal,
      'weight': weight,
      'startWeight': startWeight,
      'targetWeight': targetWeight,
      'lastDailyReset': lastDailyReset,
      'foods': foods.map((e) => e.toJson()).toList(),
      'workouts': workouts.map((e) => e.toJson()).toList(),
      'weightHistory': weightHistory.map((e) => e.toJson()).toList(),
    }));
  }

  void login(String value) {
    if (value.trim().isNotEmpty) name = value.trim();
    isLoggedIn = true;
    notifyListeners();
    _save();
  }

  void logout() {
    isLoggedIn = false;
    notifyListeners();
    _save();
  }

  void addFood(String name, int calories, int protein, {int carbs = 0, int fat = 0}) {
    foods.add(FoodEntry(
      name: name,
      calories: calories,
      protein: protein,
      carbs: carbs,
      fat: fat,
    ));
    notifyListeners();
    _save();
  }

  void removeFood(int index) {
    if (index < 0 || index >= foods.length) return;
    foods.removeAt(index);
    notifyListeners();
    _save();
  }

  void clearFoods() {
    foods.clear();
    notifyListeners();
    _save();
  }

  void addWater(int ml) {
    waterMl = (waterMl + ml).clamp(0, 8000);
    notifyListeners();
    _save();
  }

  void updateSteps(int value) {
    steps = value.clamp(0, 100000);
    notifyListeners();
    _save();
  }

  void updateWeight(double value) {
    weight = value;
    weightHistory.add(WeightEntry(weight: value, date: DateTime.now()));
    notifyListeners();
    _save();
  }

  void addWorkout(String name, int minutes) {
    workouts.add(WorkoutEntry(name: name, minutes: minutes));
    notifyListeners();
    _save();
  }

  void removeWorkout(WorkoutEntry workout) {
    workouts.remove(workout);
    notifyListeners();
    _save();
  }

  void updateGoals({
    required int calories,
    required int protein,
    required double target,
    int? carbs,
    int? fat,
    int? water,
    int? stepsGoal,
  }) {
    calorieGoal = calories;
    proteinGoal = protein;
    targetWeight = target;
    if (carbs != null) carbGoal = carbs;
    if (fat != null) fatGoal = fat;
    if (water != null) waterGoalMl = water;
    if (stepsGoal != null) stepGoal = stepsGoal;
    notifyListeners();
    _save();
  }
}

class AppStateScope extends InheritedNotifier<AppState> {
  const AppStateScope({super.key, required AppState notifier, required super.child})
      : super(notifier: notifier);

  static AppState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppStateScope>();
    assert(scope != null, 'AppStateScope not found');
    return scope!.notifier!;
  }
}
