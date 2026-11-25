import 'package:material_ui/material_ui.dart';
import 'package:portfolio/screens/education_form.dart';
import 'package:portfolio/screens/login_screen.dart';
import 'package:portfolio/screens/menu.dart';
import 'package:portfolio/screens/project_form.dart';
import 'package:portfolio/screens/project_list_screen.dart';
import 'package:portfolio/services/auth_state.dart';
import 'package:portfolio/utils/auth_guard.dart';
import 'package:provider/provider.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'My Portfolio',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Explore personal projects and experiences!',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Home'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute<void>(builder: (_) => const MyHomePage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.folder_open_rounded),
            title: const Text('Lihat Proyek'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute<void>(
                  builder: (_) => const ProjectListScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.add_circle_outline),
            title: const Text('Tambah Proyek'),
            onTap: () async {
              final loggedIn = await ensureLoggedIn(context);
              if (!context.mounted || !loggedIn) return;
              Navigator.pushReplacement(
                context,
                MaterialPageRoute<void>(
                  builder: (_) => const ProjectFormPage(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.school_outlined),
            title: const Text('Tambah Pendidikan'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute<void>(
                  builder: (_) => const EducationFormPage(),
                ),
              );
            },
          ),
          Consumer<AuthState>(
            builder: (context, authState, _) => ListTile(
              leading: Icon(
                authState.isLoggedIn
                    ? Icons.logout_rounded
                    : Icons.login_rounded,
              ),
              title: Text(authState.isLoggedIn ? 'Logout' : 'Login'),
              onTap: () async {
                if (!authState.isLoggedIn) {
                  await Navigator.push<bool>(
                    context,
                    MaterialPageRoute<bool>(
                      builder: (_) => const LoginScreen(),
                    ),
                  );
                  return;
                }

                try {
                  await authState.logout();
                } catch (_) {
                  // The local session is still cleared if the server is offline.
                }
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Sesi di perangkat ini sudah dihapus.'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
