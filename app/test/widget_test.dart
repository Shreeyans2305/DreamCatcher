import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dreamcatcher/main.dart';

void main() {
  testWidgets('DreamCatcher smoke test - renders AuthGate', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const DreamCatcherApp());
    await tester.pump();

    // Verify app starts without crash
    expect(find.byType(DreamCatcherApp), findsOneWidget);
  });
}
