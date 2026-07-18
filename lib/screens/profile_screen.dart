import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../state/app_state.dart';

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
        const Card(child: Column(children: [
          ListTile(leading: Icon(Icons.flag_outlined), title: Text('الهدف'), subtitle: Text('خسارة الدهون والمحافظة على العضلات'), trailing: Icon(Icons.chevron_left)),
          Divider(height: 1),
          ListTile(leading: Icon(Icons.notifications_outlined), title: Text('الإشعارات'), trailing: Switch(value: true, onChanged: null)),
          Divider(height: 1),
          ListTile(leading: Icon(Icons.language), title: Text('اللغة'), trailing: Text('العربية')),
          Divider(height: 1),
          ListTile(leading: Icon(Icons.health_and_safety_outlined), title: Text('ربط البيانات الصحية'), subtitle: Text('Apple Health وHealth Connect'), trailing: Icon(Icons.chevron_left)),
        ])),
        const SizedBox(height: 14),
        OutlinedButton.icon(onPressed: state.logout, icon: const Icon(Icons.logout), label: const Text('تسجيل الخروج')),
      ]),
    );
  }
}
