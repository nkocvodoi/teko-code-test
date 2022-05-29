import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('City Information widget has a city, sunrise, sunset',
      (WidgetTester tester) async {

    final cityFinder = find.text('London');
    final sunriseFinder = find.text('7:24 AM');
    final sunsetFinder = find.text('6:07 PM');

    expect(cityFinder, findsOneWidget);
    expect(sunriseFinder, findsOneWidget);
    expect(sunsetFinder, findsOneWidget);
  });
}
