import 'package:flutter_test/flutter_test.dart';
import 'package:apex_mobile/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: ApexApp()));
    
    // Wait for the splash screen 2-second timer to finish
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
  });
}
