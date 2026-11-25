import 'package:material_ui/material_ui.dart';
import 'package:portfolio/screens/education_form.dart';
import 'package:portfolio/screens/menu.dart';
import 'package:portfolio/screens/project_form.dart';
import 'package:portfolio/screens/project_list_screen.dart';
import 'package:portfolio/services/auth_state.dart';
import 'package:portfolio/utils/auth_guard.dart';
import 'package:provider/provider.dart';

class ItemCard extends StatelessWidget {
  const ItemCard({super.key, required this.item});

  final ItemHomepage item;

  Future<void> _handleTap(BuildContext context) async {
    if (item.name == 'Lihat Proyek') {
      Navigator.push<void>(
        context,
        MaterialPageRoute<void>(builder: (_) => const ProjectListScreen()),
      );
      return;
    }

    if (item.name == 'Tambah Proyek') {
      final loggedIn = await ensureLoggedIn(context);
      if (!context.mounted || !loggedIn) return;
      Navigator.push<void>(
        context,
        MaterialPageRoute<void>(builder: (_) => const ProjectFormPage()),
      );
      return;
    }

    if (item.name == 'Tambah Pendidikan') {
      Navigator.push<void>(
        context,
        MaterialPageRoute<void>(builder: (_) => const EducationFormPage()),
      );
      return;
    }

    if (item.name == 'Logout') {
      final authState = context.read<AuthState>();
      if (!authState.isLoggedIn) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Kamu belum login.')));
        return;
      }

      try {
        await authState.logout();
      } catch (_) {
        // AuthState clears the local session even if the server is unreachable.
      }
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sesi di perangkat ini sudah dihapus.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: item.color,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _handleTap(context),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(item.icon, color: Colors.white, size: 30),
                const SizedBox(height: 6),
                Text(
                  item.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
