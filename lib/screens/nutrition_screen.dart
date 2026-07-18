import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../state/app_state.dart';

class NutritionScreen extends StatelessWidget {
  const NutritionScreen({super.key});

  Future<void> _addFood(BuildContext context) async {
    final name = TextEditingController();
    final calories = TextEditingController();
    final protein = TextEditingController();
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) => Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(sheetContext).viewInsets.bottom + 24),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            const Text('إضافة وجبة', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
            const SizedBox(height: 16),
            TextField(controller: name, decoration: const InputDecoration(labelText: 'اسم الوجبة')),
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
            }, child: const Text('حفظ الوجبة')),
          ]),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('التغذية')),
      floatingActionButton: FloatingActionButton.extended(onPressed: () => _addFood(context), icon: const Icon(Icons.add), label: const Text('إضافة وجبة')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 110),
        children: [
          Card(child: Padding(padding: const EdgeInsets.all(18), child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            _Value(label: 'السعرات', value: '${state.caloriesConsumed}'),
            _Value(label: 'البروتين', value: '${state.proteinConsumed} جم'),
            _Value(label: 'المتبقي', value: '${state.caloriesRemaining}'),
          ]))),
          const SizedBox(height: 14),
          ...List.generate(state.foods.length, (index) {
            final item = state.foods[index];
            return Card(child: ListTile(
              leading: const CircleAvatar(backgroundColor: Color(0xFFEAF6EF), child: Icon(Icons.restaurant, color: AppColors.primary)),
              title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.w800)),
              subtitle: Text('${item.protein} جم بروتين'),
              trailing: Row(mainAxisSize: MainAxisSize.min, children: [Text('${item.calories} سعرة', style: const TextStyle(fontWeight: FontWeight.w700)), IconButton(onPressed: () => state.removeFood(index), icon: const Icon(Icons.delete_outline))]),
            ));
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
