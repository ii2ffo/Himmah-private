import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../state/app_state.dart';

class WorkoutsScreen extends StatelessWidget {
  const WorkoutsScreen({super.key});

  Future<void> _addWorkout(BuildContext context) async {
    final state = AppStateScope.of(context);
    final items = ['Push - دفع', 'Pull - سحب', 'Legs - أرجل', 'Upper - علوي', 'Lower - سفلي', 'مشي', 'كارديو'];
    final selected = await showModalBottomSheet<String>(
      context: context,
      builder: (sheetContext) => Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
          child: ListView(
            shrinkWrap: true,
            children: [
              const ListTile(title: Text('اختر التمرين', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900))),
              ...items.map((e) => ListTile(
                    leading: const Icon(Icons.fitness_center),
                    title: Text(e),
                    onTap: () => Navigator.pop(sheetContext, e),
                  )),
            ],
          ),
        ),
      ),
    );
    if (selected == null || !context.mounted) return;

    final controller = TextEditingController(text: '60');
    final minutes = await showDialog<int>(
      context: context,
      builder: (dialogContext) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: Text(selected),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'مدة التمرين', suffixText: 'دقيقة'),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('إلغاء')),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, int.tryParse(controller.text)),
              child: const Text('حفظ'),
            ),
          ],
        ),
      ),
    );
    if (minutes != null && minutes > 0) state.addWorkout(selected, minutes);
  }

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('التمارين')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addWorkout(context),
        icon: const Icon(Icons.add),
        label: const Text('سجل تمرين'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 110),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Row(children: [
                const Icon(Icons.local_fire_department, color: AppColors.primary, size: 34),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text('خطة الأسبوع', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
                    const Text('Push • Pull • Legs • راحة • Upper • Lower', style: TextStyle(color: AppColors.muted)),
                    const SizedBox(height: 6),
                    Text('تمرين اليوم: ${state.workoutMinutesToday} دقيقة', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700)),
                  ]),
                ),
              ]),
            ),
          ),
          const SizedBox(height: 12),
          if (state.workouts.isEmpty)
            const Padding(
              padding: EdgeInsets.only(top: 50),
              child: Center(child: Text('لا توجد تمارين مسجلة بعد', style: TextStyle(color: AppColors.muted))),
            ),
          ...state.workouts.reversed.map((workout) => Dismissible(
                key: ValueKey('${workout.date.toIso8601String()}-${workout.name}'),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(color: Colors.red.shade100, borderRadius: BorderRadius.circular(22)),
                  child: const Icon(Icons.delete_outline, color: Colors.red),
                ),
                onDismissed: (_) => state.removeWorkout(workout),
                child: Card(
                  child: ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.check)),
                    title: Text(workout.name, style: const TextStyle(fontWeight: FontWeight.w800)),
                    subtitle: Text('${workout.date.year}/${workout.date.month}/${workout.date.day}'),
                    trailing: Text('${workout.minutes} دقيقة'),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
