import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../state/app_state.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  Future<void> _editWeight(BuildContext context) async {
    final state = AppStateScope.of(context);
    final controller = TextEditingController(text: state.weight.toStringAsFixed(1));
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: const Text('تسجيل الوزن'),
          content: TextField(
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(suffixText: 'كجم'),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('إلغاء')),
            FilledButton(
              onPressed: () {
                final value = double.tryParse(controller.text);
                if (value != null && value > 35 && value < 300) state.updateWeight(value);
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
    final history = state.weightHistory;
    return Scaffold(
      appBar: AppBar(title: const Text('التقدم')),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
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
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('التقدم نحو الهدف', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                const SizedBox(height: 16),
                LinearProgressIndicator(value: state.weightProgress, minHeight: 12, borderRadius: BorderRadius.circular(20)),
                const SizedBox(height: 10),
                Text('بدأت من ${state.startWeight.toStringAsFixed(1)} كجم — هدفك ${state.targetWeight.toStringAsFixed(1)} كجم', style: const TextStyle(color: AppColors.muted)),
              ]),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('رسم الوزن', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                const SizedBox(height: 18),
                SizedBox(height: 190, width: double.infinity, child: CustomPaint(painter: _WeightChartPainter(history))),
                const SizedBox(height: 8),
                Text('${history.length} تسجيلات محفوظة', style: const TextStyle(color: AppColors.muted)),
              ]),
            ),
          ),
          const SizedBox(height: 16),
          ...history.reversed.take(8).map((entry) => Card(
            child: ListTile(
              leading: const Icon(Icons.monitor_weight_outlined),
              title: Text('${entry.weight.toStringAsFixed(1)} كجم', style: const TextStyle(fontWeight: FontWeight.w800)),
              subtitle: Text('${entry.date.year}/${entry.date.month}/${entry.date.day}'),
            ),
          )),
        ],
      ),
    );
  }
}

class _WeightChartPainter extends CustomPainter {
  _WeightChartPainter(this.entries);
  final List<WeightEntry> entries;

  @override
  void paint(Canvas canvas, Size size) {
    final axis = Paint()..color = AppColors.border..strokeWidth = 1;
    canvas.drawLine(Offset(0, size.height), Offset(size.width, size.height), axis);
    canvas.drawLine(const Offset(0, 0), Offset(0, size.height), axis);
    if (entries.isEmpty) return;

    final values = entries.map((e) => e.weight).toList();
    final minV = values.reduce(math.min) - 0.5;
    final maxV = values.reduce(math.max) + 0.5;
    final range = math.max(1.0, maxV - minV);
    final path = Path();
    final line = Paint()..color = AppColors.primary..strokeWidth = 3..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
    final point = Paint()..color = AppColors.darkGreen;

    for (var i = 0; i < values.length; i++) {
      final x = values.length == 1 ? size.width / 2 : i * size.width / (values.length - 1);
      final y = size.height - ((values[i] - minV) / range * (size.height - 16)) - 8;
      if (i == 0) path.moveTo(x, y); else path.lineTo(x, y);
      canvas.drawCircle(Offset(x, y), 4, point);
    }
    canvas.drawPath(path, line);
  }

  @override
  bool shouldRepaint(covariant _WeightChartPainter oldDelegate) => oldDelegate.entries.length != entries.length;
}
