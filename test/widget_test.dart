import 'package:flutter_test/flutter_test.dart';
import 'package:himmah/main.dart';

void main() {
  testWidgets('يعرض الصفحة الرئيسية', (tester) async {
    await tester.pumpWidget(const HimmahApp());
    expect(find.text('مرحباً محمد 👋'), findsOneWidget);
    expect(find.text('الرئيسية'), findsOneWidget);
  });
}
