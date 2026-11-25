import 'package:material_ui/material_ui.dart';
import 'package:portfolio/screens/menu.dart';
import 'package:portfolio/services/api_client.dart';
import 'package:portfolio/services/auth_state.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp(apiClient: ApiClient()));
}

class MyApp extends StatelessWidget {
  const MyApp({required this.apiClient, super.key});

  final ApiClient apiClient;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ApiClient>.value(value: apiClient),
        ChangeNotifierProvider<AuthState>(
          create: (context) => AuthState(context.read<ApiClient>()),
        ),
      ],
      child: MaterialApp(
        title: 'Portfolio',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: const MyHomePage(),
      ),
    );
  }
}
