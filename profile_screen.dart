import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import 'home_screen.dart';
import 'nutrition_screen.dart';
import 'profile_screen.dart';
import 'progress_screen.dart';
import 'workouts_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  final _screens = const [
    HomeScreen(),
    NutritionScreen(),
    WorkoutsScreen(),
    ProgressScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _screens),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        onPressed: () {
          showModalBottomSheet<void>(
            context: context,
            showDragHandle: true,
            builder: (context) => const _QuickAddSheet(),
          );
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'الرئيسية'),
          NavigationDestination(icon: Icon(Icons.restaurant_menu), label: 'التغذية'),
          NavigationDestination(icon: Icon(Icons.fitness_center), label: 'التمارين'),
          NavigationDestination(icon: Icon(Icons.insights_outlined), label: 'التقدم'),
          NavigationDestination(icon: Icon(Icons.person_outline), label: 'حسابي'),
        ],
      ),
    );
  }
}

class _QuickAddSheet extends StatelessWidget {
  const _QuickAddSheet();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('إضافة سريعة', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _QuickAction(icon: Icons.restaurant, label: 'وجبة'),
                _QuickAction(icon: Icons.monitor_weight_outlined, label: 'وزن'),
                _QuickAction(icon: Icons.water_drop_outlined, label: 'ماء'),
                _QuickAction(icon: Icons.fitness_center, label: 'تمرين'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: (MediaQuery.sizeOf(context).width - 64) / 2,
      child: OutlinedButton.icon(
        onPressed: () => Navigator.pop(context),
        icon: Icon(icon),
        label: Text(label),
        style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 18)),
      ),
    );
  }
}
