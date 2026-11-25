import 'package:material_ui/material_ui.dart';
import 'package:portfolio/screens/login_screen.dart';
import 'package:portfolio/services/auth_state.dart';
import 'package:provider/provider.dart';

/// Opens the login page when needed and reports whether the user logged in.
Future<bool> ensureLoggedIn(BuildContext context) async {
  if (context.read<AuthState>().isLoggedIn) return true;

  final loggedIn = await Navigator.push<bool>(
    context,
    MaterialPageRoute<bool>(builder: (_) => const LoginScreen()),
  );
  return loggedIn ?? false;
}
