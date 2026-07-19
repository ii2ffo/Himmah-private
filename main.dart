import 'package:flutter/material.dart';

import '../state/app_state.dart';

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key});

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  late final TextEditingController calories;
  late final TextEditingController protein;
  late final TextEditingController target;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final state = AppStateScope.of(context);
    calories = TextEditingController(text: state.calorieGoal.toString());
    protein = TextEditingController(text: state.proteinGoal.toString());
    target = TextEditingController(text: state.targetWeight.toStringAsFixed(1));
  }

  @override
  void dispose() {
    calories.dispose();
    protein.dispose();
    target.dispose();
    super.dispose();
  }

  void _save() {
    final c = int.tryParse(calories.text);
    final p = int.tryParse(protein.text);
    final t = double.tryParse(target.text);
    if (c == null || p == null || t == null || c < 1000 || p < 30 || t < 35) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تأكد من إدخال أهداف صحيحة')),
      );
      return;
    }
    AppStateScope.of(context).updateGoals(calories: c, protein: p, target: t);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تعديل الأهداف')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: calories,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'هدف السعرات اليومي',
              suffixText: 'سعرة',
              prefixIcon: Icon(Icons.local_fire_department_outlined),
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: protein,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'هدف البروتين اليومي',
              suffixText: 'جم',
              prefixIcon: Icon(Icons.egg_alt_outlined),
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: target,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'الوزن المستهدف',
              suffixText: 'كجم',
              prefixIcon: Icon(Icons.flag_outlined),
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: _save,
            icon: const Icon(Icons.save_outlined),
            label: const Text('حفظ الأهداف'),
          ),
        ],
      ),
    );
  }
}
