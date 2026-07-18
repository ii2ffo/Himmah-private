import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../state/app_state.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  Future<void> _editWeight(BuildContext context) async {
    final state = AppStateScope.of(context);
    final controller = TextEditingController(text: state.weight.toStringAsFixed(1));
    await showDialog<void>(context: context, builder: (dialogContext) => Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        title: const Text('تسجيل الوزن'),
        content: TextField(controller: controller, keyboardType: const TextInputType.numberWithOptions(decimal: true), decoration: const InputDecoration(suffixText: 'كجم')),
        actions: [TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('إلغاء')), FilledButton(onPressed: () {final value = double.tryParse(controller.text); if (value != null) state.updateWeight(value); Navigator.pop(dialogContext);}, child: const Text('حفظ'))],
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('التقدم')),
      body: ListView(padding: const EdgeInsets.all(18), children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(color: AppColors.darkGreen, borderRadius: BorderRadius.circular(28)),
          child: Column(children: [
            const Text('وزنك الحالي', style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 8),
            Text('${state.weight.toStringAsFixed(1)} كجم', style: const TextStyle(color: Colors.white, fontSize: 38, fontWeight: FontWeight.w900)),
            const SizedBox(height: 16),
            FilledButton.tonal(onPressed: () => _editWeight(context), child: const Text('تحديث الوزن')),
          ]),
        ),
        const SizedBox(height: 16),
        const Card(child: Padding(padding: EdgeInsets.all(18), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('التقدم', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          SizedBox(height: 16),
          LinearProgressIndicator(value: .58, minHeight: 12, borderRadius: BorderRadius.all(Radius.circular(20))),
          SizedBox(height: 10),
          Text('بدأت من 99 كجم — هدفك 86 كجم', style: TextStyle(color: AppColors.muted)),
        ]))),
      ]),
    );
  }
}
