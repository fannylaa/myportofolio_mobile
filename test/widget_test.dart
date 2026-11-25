import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/main.dart';
import 'package:portfolio/services/api_client.dart';

void main() {
  testWidgets('home page renders', (tester) async {
    await tester.pumpWidget(MyApp(apiClient: ApiClient()));
    expect(find.text('Selamat datang di Portfolio'), findsOneWidget);
  });
}
