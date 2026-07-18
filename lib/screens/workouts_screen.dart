import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../state/app_state.dart';

class WorkoutsScreen extends StatelessWidget {
  const WorkoutsScreen({super.key});

  Future<void> _addWorkout(BuildContext context) async {
    final state = AppStateScope.of(context);
    final items = ['Push - دفع', 'Pull - سحب', 'Legs - أرجل', 'Upper - علوي', 'Lower - سفلي', 'مشي'];
    final selected = await showModalBottomSheet<String>(context: context, builder: (_) => Directionality(textDirection: TextDirection.rtl, child: SafeArea(child: ListView(shrinkWrap: true, children: [
      const ListTile(title: Text('اختر التمرين', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900))),
      ...items.map((e) => ListTile(leading: const Icon(Icons.fitness_center), title: Text(e), onTap: () => Navigator.pop(context, e))),
    ]))));
    if (selected != null) state.addWorkout(selected, 60);
  }

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('التمارين')),
      floatingActionButton: FloatingActionButton.extended(onPressed: () => _addWorkout(context), icon: const Icon(Icons.add), label: const Text('سجل تمرين')),
      body: ListView(padding: const EdgeInsets.fromLTRB(18, 10, 18, 110), children: [
        const Card(child: Padding(padding: EdgeInsets.all(18), child: Row(children: [Icon(Icons.local_fire_department, color: AppColors.primary, size: 34), SizedBox(width: 14), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('خطة الأسبوع', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)), Text('Push • Pull • Legs • راحة • Upper • Lower', style: TextStyle(color: AppColors.muted))]))]))),
        const SizedBox(height: 12),
        ...state.workouts.reversed.map((workout) => Card(child: ListTile(leading: const CircleAvatar(child: Icon(Icons.check)), title: Text(workout.name, style: const TextStyle(fontWeight: FontWeight.w800)), subtitle: const Text('تم الإنجاز'), trailing: Text('${workout.minutes} دقيقة')))),
      ]),
    );
  }
}
