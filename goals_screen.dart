import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../state/app_state.dart';
import 'food_search_screen.dart';

class NutritionScreen extends StatelessWidget {
  const NutritionScreen({super.key});

  Future<void> _addFoodManually(BuildContext context) async {
    final name = TextEditingController();
    final calories = TextEditingController();
    final protein = TextEditingController();
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) => Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 8, 20, MediaQuery.of(sheetContext).viewInsets.bottom + 24),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            const Text('إضافة طعام يدويًا', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
            const SizedBox(height: 16),
            TextField(controller: name, decoration: const InputDecoration(labelText: 'اسم الطعام')),
            const SizedBox(height: 12),
            TextField(controller: calories, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'السعرات')),
            const SizedBox(height: 12),
            TextField(controller: protein, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'البروتين بالجرام')),
            const SizedBox(height: 18),
            FilledButton(onPressed: () {
              final c = int.tryParse(calories.text) ?? 0;
              final p = int.tryParse(protein.text) ?? 0;
              if (name.text.trim().isNotEmpty && c > 0) {
                AppStateScope.of(context).addFood(name.text.trim(), c, p);
                Navigator.pop(sheetContext);
              }
            }, child: const Text('حفظ')),
          ]),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('التغذية'), actions: [
        IconButton(onPressed: state.clearFoods, tooltip: 'بدء يوم جديد', icon: const Icon(Icons.refresh)),
      ]),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 120),
        children: [
          Card(child: Padding(padding: const EdgeInsets.all(18), child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            _Value(label: 'السعرات', value: '${state.caloriesConsumed}'),
            _Value(label: 'البروتين', value: '${state.proteinConsumed} جم'),
            _Value(label: 'المتبقي', value: '${state.caloriesRemaining}'),
          ]))),
          const SizedBox(height: 14),
          FilledButton.icon(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FoodSearchScreen())),
            icon: const Icon(Icons.search),
            label: const Text('ابحث في قاعدة الأطعمة'),
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(onPressed: () => _addFoodManually(context), icon: const Icon(Icons.edit_outlined), label: const Text('إضافة يدوية')),
          const SizedBox(height: 18),
          Row(children: [
            const Expanded(child: Text('سجل اليوم', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w900))),
            Text('${state.foods.length} عناصر', style: const TextStyle(color: AppColors.muted)),
          ]),
          const SizedBox(height: 8),
          if (state.foods.isEmpty)
            const Card(child: Padding(padding: EdgeInsets.all(28), child: Center(child: Text('ما سجلت أي طعام اليوم')))),
          ...List.generate(state.foods.length, (index) {
            final item = state.foods[index];
            return Dismissible(
              key: ValueKey('${item.name}-$index'),
              direction: DismissDirection.endToStart,
              background: Container(alignment: Alignment.centerLeft, padding: const EdgeInsets.all(20), color: Colors.red.shade100, child: const Icon(Icons.delete)),
              onDismissed: (_) => state.removeFood(index),
              child: Card(child: ListTile(
                leading: const CircleAvatar(backgroundColor: Color(0xFFEAF6EF), child: Icon(Icons.restaurant, color: AppColors.primary)),
                title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.w800)),
                subtitle: Text('${item.protein} جم بروتين'),
                trailing: Text('${item.calories} سعرة', style: const TextStyle(fontWeight: FontWeight.w700)),
              )),
            );
          }),
        ],
      ),
    );
  }
}

class _Value extends StatelessWidget {
  const _Value({required this.label, required this.value});
  final String label, value;
  @override Widget build(BuildContext context) => Column(children: [Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900)), Text(label, style: const TextStyle(color: AppColors.muted))]);
}
