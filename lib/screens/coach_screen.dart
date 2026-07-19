import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import '../state/app_state.dart';

class CoachScreen extends StatefulWidget {
  const CoachScreen({super.key});

  @override
  State<CoachScreen> createState() => _CoachScreenState();
}

class _CoachScreenState extends State<CoachScreen> {
  final controller = TextEditingController();
  final List<_Message> messages = const [
    _Message('هلا! أنا مدرب همّة. اسألني عن السعرات، البروتين، الماء أو التمرين.', false),
  ].toList();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _send() {
    final text = controller.text.trim();
    if (text.isEmpty) return;
    final state = AppStateScope.of(context);
    setState(() {
      messages.add(_Message(text, true));
      messages.add(_Message(_reply(text, state), false));
      controller.clear();
    });
  }

  String _reply(String text, AppState state) {
    final q = text.toLowerCase();
    if (q.contains('سعر') || q.contains('كالوري')) {
      return 'سجلت ${state.caloriesConsumed} من ${state.calorieGoal} سعرة، والمتبقي ${state.caloriesRemaining} سعرة.';
    }
    if (q.contains('بروتين')) {
      final remaining = (state.proteinGoal - state.proteinConsumed).clamp(0, state.proteinGoal);
      return 'وصلت ${state.proteinConsumed} جم بروتين. باقي لك $remaining جم لتحقيق هدفك.';
    }
    if (q.contains('ماء') || q.contains('موية')) {
      return 'شربك المسجل ${(state.waterMl / 1000).toStringAsFixed(2)} لتر. زد الماء تدريجيًا واضغط بطاقة الماء في الرئيسية.';
    }
    if (q.contains('وزن')) {
      return 'وزنك الحالي ${state.weight.toStringAsFixed(1)} كجم وهدفك ${state.targetWeight.toStringAsFixed(1)} كجم. ركّز على متوسط الوزن الأسبوعي.';
    }
    if (q.contains('تمرين') || q.contains('حديد')) {
      return state.workouts.isEmpty
          ? 'ابدأ بتمرين مقاومة 3–4 أيام أسبوعيًا وسجل التمرين داخل التطبيق.'
          : 'آخر تمرين مسجل: ${state.workouts.last.name} لمدة ${state.workouts.last.minutes} دقيقة.';
    }
    return 'أفضل خطوة اليوم: التزم بهدف السعرات، أكمل بروتينك، وسجل وزنك صباحًا بنفس الظروف.';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('مدرب همّة')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final m = messages[index];
                return Align(
                  alignment: m.mine ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 330),
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: m.mine ? AppColors.primary : Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: m.mine ? null : Border.all(color: AppColors.border),
                    ),
                    child: Text(m.text, style: TextStyle(color: m.mine ? Colors.white : AppColors.text)),
                  ),
                );
              },
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      onSubmitted: (_) => _send(),
                      decoration: const InputDecoration(hintText: 'اكتب سؤالك...'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(onPressed: _send, icon: const Icon(Icons.send_rounded)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Message {
  const _Message(this.text, this.mine);
  final String text;
  final bool mine;
}
