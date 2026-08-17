import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/main.dart';

void main() {
  testWidgets('Tourist Safety app loads', (WidgetTester tester) async {
    await tester.pumpWidget(const TouristSafetyApp());

    expect(find.text('AI Based Smart Tourist Safety'), findsOneWidget);
  });
}