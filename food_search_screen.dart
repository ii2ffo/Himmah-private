import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../state/app_state.dart';
import 'coach_screen.dart';
import 'goals_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('حسابي')),
      body: ListView(padding: const EdgeInsets.all(18), children: [
        Card(child: Padding(padding: const EdgeInsets.all(20), child: Row(children: [
          const CircleAvatar(radius: 34, backgroundColor: AppColors.darkGreen, child: Icon(Icons.person, color: Colors.white, size: 38)),
          const SizedBox(width: 16),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(state.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)), const Text('عضو همّة', style: TextStyle(color: AppColors.muted))])),
        ]))),
        const SizedBox(height: 14),
        Card(child: Column(children: [
          ListTile(
            leading: const Icon(Icons.flag_outlined),
            title: const Text('الأهداف'),
            subtitle: Text('${state.calorieGoal} سعرة • ${state.proteinGoal} جم بروتين'),
            trailing: const Icon(Icons.chevron_left),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const GoalsScreen())),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.smart_toy_outlined),
            title: const Text('مدرب همّة'),
            subtitle: const Text('إجابات ذكية مبنية على بياناتك'),
            trailing: const Icon(Icons.chevron_left),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CoachScreen())),
          ),
          const Divider(height: 1),
          const ListTile(leading: Icon(Icons.notifications_outlined), title: Text('الإشعارات'), trailing: Switch(value: true, onChanged: null)),
          const Divider(height: 1),
          const ListTile(leading: Icon(Icons.language), title: Text('اللغة'), trailing: Text('العربية')),
          const Divider(height: 1),
          const ListTile(leading: Icon(Icons.health_and_safety_outlined), title: Text('ربط البيانات الصحية'), subtitle: Text('قريبًا: Apple Health وHealth Connect'), trailing: Icon(Icons.chevron_left)),
        ])),
        const SizedBox(height: 14),
        OutlinedButton.icon(onPressed: state.logout, icon: const Icon(Icons.logout), label: const Text('تسجيل الخروج')),
      ]),
    );
  }
}
