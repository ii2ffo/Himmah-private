import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../state/app_state.dart';
import '../widgets/section_title.dart';
import '../widgets/stat_tile.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _editSteps(BuildContext context, AppState state) async {
    final controller = TextEditingController(text: state.steps.toString());
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: const Text('تحديث الخطوات'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(suffixText: 'خطوة'),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('إلغاء')),
            FilledButton(
              onPressed: () {
                final value = int.tryParse(controller.text);
                if (value != null) state.updateSteps(value);
                Navigator.pop(dialogContext);
              },
              child: const Text('حفظ'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final progress = (state.caloriesConsumed / state.calorieGoal).clamp(0.0, 1.0);
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 120),
        children: [
          _Header(name: state.name),
          const SizedBox(height: 18),
          _CalorieCard(state: state, progress: progress),
          const SizedBox(height: 14),
          Row(children: [
            Expanded(child: InkWell(onTap: () => _editSteps(context, state), borderRadius: BorderRadius.circular(22), child: StatTile(icon: Icons.directions_walk, label: 'الخطوات', value: '${state.steps}', unit: 'خطوة'))),
            const SizedBox(width: 12),
            Expanded(child: InkWell(
              onTap: () => state.addWater(250),
              borderRadius: BorderRadius.circular(22),
              child: StatTile(icon: Icons.water_drop_outlined, label: 'الماء', value: (state.waterMl / 1000).toStringAsFixed(2), unit: 'لتر'),
            )),
          ]),
          const SizedBox(height: 8),
          const Text('اضغط الخطوات لتحديثها، واضغط الماء لإضافة 250 مل', style: TextStyle(color: AppColors.muted, fontSize: 11)),
          const SizedBox(height: 22),
          const SectionTitle(title: 'ملخص اليوم'),
          const SizedBox(height: 10),
          Card(child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(children: [
              _SummaryRow(icon: Icons.restaurant, title: 'التغذية', subtitle: '${state.foods.length} عناصر مسجلة', trailing: '${state.caloriesConsumed} سعرة'),
              const Divider(height: 28),
              _SummaryRow(icon: Icons.fitness_center, title: 'التمرين', subtitle: state.workouts.isEmpty ? 'لم تسجل تمريناً' : state.workouts.last.name, trailing: state.workouts.isEmpty ? '--' : '${state.workouts.last.minutes} دقيقة'),
              const Divider(height: 28),
              _SummaryRow(icon: Icons.monitor_weight_outlined, title: 'الوزن', subtitle: 'آخر تسجيل', trailing: '${state.weight.toStringAsFixed(1)} كجم'),
            ]),
          )),
          const SizedBox(height: 22),
          const SectionTitle(title: 'هدف هذا الأسبوع'),
          const SizedBox(height: 10),
          const _WeeklyGoal(),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.name});
  final String name;
  @override
  Widget build(BuildContext context) => Row(children: [
    const CircleAvatar(radius: 24, backgroundColor: AppColors.darkGreen, child: Icon(Icons.person, color: Colors.white)),
    const SizedBox(width: 12),
    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('مرحباً $name 👋', style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w800)),
      const SizedBox(height: 3),
      const Text('جاهز تبدأ يومك بقوة؟', style: TextStyle(color: AppColors.muted)),
    ])),
    IconButton.filledTonal(onPressed: () {}, icon: const Icon(Icons.notifications_none)),
  ]);
}

class _CalorieCard extends StatelessWidget {
  const _CalorieCard({required this.state, required this.progress});
  final AppState state;
  final double progress;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(28), gradient: const LinearGradient(colors: [AppColors.darkGreen, Color(0xFF0C5C3C)])),
    child: Column(children: [
      Row(children: [
        const Expanded(child: Text('السعرات اليومية', style: TextStyle(color: Colors.white70, fontSize: 16))),
        Text('${(progress * 100).round()}%', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
      ]),
      const SizedBox(height: 12),
      Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        _Metric(label: 'المتبقي', value: '${state.caloriesRemaining}'),
        _Metric(label: 'المستهلك', value: '${state.caloriesConsumed}', large: true),
        _Metric(label: 'الهدف', value: '${state.calorieGoal}'),
      ]),
      const SizedBox(height: 18),
      ClipRRect(borderRadius: BorderRadius.circular(20), child: LinearProgressIndicator(value: progress, minHeight: 10, backgroundColor: Colors.white24, color: AppColors.lime)),
      const SizedBox(height: 16),
      Row(children: [
        Expanded(child: _Macro(label: 'بروتين', value: '${state.proteinConsumed} / ${state.proteinGoal} جم', progress: (state.proteinConsumed / state.proteinGoal).clamp(0, 1))),
        const SizedBox(width: 12),
        Expanded(child: _Macro(label: 'كارب', value: '${state.carbsConsumed} / ${state.carbGoal} جم', progress: (state.carbsConsumed / state.carbGoal).clamp(0, 1))),
        const SizedBox(width: 12),
        Expanded(child: _Macro(label: 'دهون', value: '${state.fatConsumed} / ${state.fatGoal} جم', progress: (state.fatConsumed / state.fatGoal).clamp(0, 1))),
      ]),
    ]),
  );
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value, this.large = false});
  final String label, value; final bool large;
  @override Widget build(BuildContext context) => Column(children: [Text(value, style: TextStyle(color: Colors.white, fontSize: large ? 34 : 21, fontWeight: FontWeight.w900)), Text(label, style: const TextStyle(color: Colors.white70))]);
}

class _Macro extends StatelessWidget {
  const _Macro({required this.label, required this.value, required this.progress});
  final String label, value; final double progress;
  @override Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)), const SizedBox(height: 5), Text(value, style: const TextStyle(color: Colors.white70, fontSize: 11)), const SizedBox(height: 7), LinearProgressIndicator(value: progress, minHeight: 5, backgroundColor: Colors.white24, color: AppColors.lime)]);
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.icon, required this.title, required this.subtitle, required this.trailing});
  final IconData icon; final String title, subtitle, trailing;
  @override Widget build(BuildContext context) => Row(children: [CircleAvatar(backgroundColor: AppColors.primary.withValues(alpha: .1), child: Icon(icon, color: AppColors.primary)), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.w700)), Text(subtitle, style: const TextStyle(color: AppColors.muted, fontSize: 12))])), Text(trailing, style: const TextStyle(fontWeight: FontWeight.w700))]);
}

class _WeeklyGoal extends StatelessWidget {
  const _WeeklyGoal();
  @override Widget build(BuildContext context) => const Card(child: Padding(padding: EdgeInsets.all(18), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('نزول 0.5 كجم', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)), SizedBox(height: 6), Text('استمر على متوسط عجز 500 سعرة يومياً', style: TextStyle(color: AppColors.muted)), SizedBox(height: 14), LinearProgressIndicator(value: .62, minHeight: 9, borderRadius: BorderRadius.all(Radius.circular(20))), SizedBox(height: 8), Text('تم إنجاز 62% من الهدف', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700))])));
}
