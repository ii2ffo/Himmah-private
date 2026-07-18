import 'package:flutter/material.dart';

class FoodEntry {
  FoodEntry({required this.name, required this.calories, required this.protein});
  final String name;
  final int calories;
  final int protein;
}

class WorkoutEntry {
  WorkoutEntry({required this.name, required this.minutes});
  final String name;
  final int minutes;
}

class AppState extends ChangeNotifier {
  bool isLoggedIn = false;
  String name = 'محمد';
  int calorieGoal = 2200;
  int proteinGoal = 160;
  int waterMl = 1800;
  int steps = 8420;
  double weight = 91.2;

  final List<FoodEntry> foods = [
    FoodEntry(name: 'فطور', calories: 540, protein: 32),
    FoodEntry(name: 'حليب بروتين', calories: 230, protein: 34),
    FoodEntry(name: 'دجاج وأرز', calories: 690, protein: 58),
  ];

  final List<WorkoutEntry> workouts = [
    WorkoutEntry(name: 'تمرين دفع Push', minutes: 45),
  ];

  int get caloriesConsumed => foods.fold(0, (sum, item) => sum + item.calories);
  int get proteinConsumed => foods.fold(0, (sum, item) => sum + item.protein);
  int get caloriesRemaining => (calorieGoal - caloriesConsumed).clamp(0, calorieGoal);

  void login(String value) {
    if (value.trim().isNotEmpty) name = value.trim();
    isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    isLoggedIn = false;
    notifyListeners();
  }

  void addFood(String name, int calories, int protein) {
    foods.add(FoodEntry(name: name, calories: calories, protein: protein));
    notifyListeners();
  }

  void removeFood(int index) {
    foods.removeAt(index);
    notifyListeners();
  }

  void addWater(int ml) {
    waterMl = (waterMl + ml).clamp(0, 6000);
    notifyListeners();
  }

  void updateWeight(double value) {
    weight = value;
    notifyListeners();
  }

  void addWorkout(String name, int minutes) {
    workouts.add(WorkoutEntry(name: name, minutes: minutes));
    notifyListeners();
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
