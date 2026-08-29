import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:builme/main.dart';

void main() {
  testWidgets('BuilMe App Smoke Test', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: BuilMeApp()));
    expect(find.byType(BuilMeApp), findsOneWidget);
  });
}
