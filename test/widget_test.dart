import 'package:flutter_test/flutter_test.dart';
import 'package:transport_app/main.dart';

void main() {
  testWidgets('Тест завантаження головного екрана', (WidgetTester tester) async {
    await tester.pumpWidget(const TransportApp());
    expect(find.text('Транспортний навігатор'), findsWidgets);
  });
}