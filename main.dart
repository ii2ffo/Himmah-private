import 'package:flutter/material.dart';
import '../../core/app_theme.dart';
import '../../state/app_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final nameController = TextEditingController(text: 'محمد');

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  color: AppColors.darkGreen,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: const Icon(Icons.bolt_rounded, size: 52, color: AppColors.lime),
              ),
              const SizedBox(height: 24),
              const Text('همّة', textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 42, fontWeight: FontWeight.w900)),
              const SizedBox(height: 8),
              const Text('خطتك الصحية في مكان واحد', textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.muted, fontSize: 16)),
              const Spacer(),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'اسمك',
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),
              const SizedBox(height: 14),
              FilledButton(
                onPressed: () => AppStateScope.of(context).login(nameController.text),
                style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(56)),
                child: const Text('ابدأ الآن', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
              ),
              const SizedBox(height: 10),
              const Text('بالاستمرار أنت توافق على الشروط وسياسة الخصوصية',
                  textAlign: TextAlign.center, style: TextStyle(fontSize: 11, color: AppColors.muted)),
            ],
          ),
        ),
      ),
    );
  }
}
