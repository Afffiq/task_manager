import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:my_task_manager/screens/splash_screen.dart';

void main() {
  testWidgets('Splash screen shows loading indicator', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SplashScreen(),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
