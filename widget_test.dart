import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../models/food_item.dart';
import '../state/app_state.dart';

class FoodSearchScreen extends StatefulWidget {
  const FoodSearchScreen({super.key});

  @override
  State<FoodSearchScreen> createState() => _FoodSearchScreenState();
}

class _FoodSearchScreenState extends State<FoodSearchScreen> {
  String query = '';
  String category = 'الكل';

  @override
  Widget build(BuildContext context) {
    final categories = ['الكل', ...{...foodCatalog.map((e) => e.category)}];
    final results = foodCatalog.where((item) {
      final matchesQuery = item.name.contains(query.trim());
      final matchesCategory = category == 'الكل' || item.category == category;
      return matchesQuery && matchesCategory;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('البحث عن طعام')),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 10),
          child: TextField(
            autofocus: true,
            onChanged: (value) => setState(() => query = value),
            decoration: InputDecoration(
              hintText: 'ابحث: دجاج، أرز، حليب...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none),
            ),
          ),
        ),
        SizedBox(
          height: 46,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (_, index) {
              final value = categories[index];
              return ChoiceChip(
                label: Text(value),
                selected: category == value,
                onSelected: (_) => setState(() => category = value),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: results.isEmpty
              ? const Center(child: Text('ما لقينا نتيجة، أضفها يدويًا'))
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(18, 4, 18, 24),
                  itemCount: results.length,
                  itemBuilder: (_, index) => _FoodCard(item: results[index]),
                ),
        ),
      ]),
    );
  }
}

class _FoodCard extends StatelessWidget {
  const _FoodCard({required this.item});
  final FoodItem item;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
        leading: CircleAvatar(
          backgroundColor: AppColors.primary.withValues(alpha: .1),
          child: const Icon(Icons.restaurant, color: AppColors.primary),
        ),
        title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.w800)),
        subtitle: Text('${item.serving} • ${item.protein} بروتين • ${item.carbs} كارب'),
        trailing: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text('${item.calories}', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 17)),
          const Text('سعرة', style: TextStyle(fontSize: 11, color: AppColors.muted)),
        ]),
        onTap: () {
          AppStateScope.of(context).addFood(item.name, item.calories, item.protein, carbs: item.carbs, fat: item.fat);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('تمت إضافة ${item.name}')));
          Navigator.pop(context);
        },
      ),
    );
  }
}
