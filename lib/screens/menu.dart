import 'package:material_ui/material_ui.dart';
import 'package:portfolio/widgets/left_drawer.dart';
import 'package:portfolio/widgets/project_card.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  // Ganti nilai ini dengan data pribadi sebelum mengumpulkan tugas.
  static const String npm = '2506547153';
  static const String nama = 'Stephanie Tamus';
  static const String kelas = 'PBP C';

  static const List<ItemHomepage> items = [
    ItemHomepage(
      name: 'Lihat Proyek',
      icon: Icons.folder_open_rounded,
      color: Color(0xFF1D4ED8),
    ),
    ItemHomepage(
      name: 'Tambah Proyek',
      icon: Icons.add_circle_outline_rounded,
      color: Color(0xFF15803D),
    ),
    ItemHomepage(
      name: 'Tambah Pendidikan',
      icon: Icons.school_outlined,
      color: Color(0xFF7C3AED),
    ),
    ItemHomepage(
      name: 'Logout',
      icon: Icons.logout_rounded,
      color: Color(0xFFB91C1C),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Portfolio',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      drawer: const LeftDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: InfoCard(title: 'NPM', content: npm),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: InfoCard(title: 'Name', content: nama),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: InfoCard(title: 'Class', content: kelas),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'Selamat datang di Portfolio',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 8),
              GridView.builder(
                primary: false,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(12),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: MediaQuery.sizeOf(context).width >= 900
                      ? 4
                      : MediaQuery.sizeOf(context).width >= 600
                      ? 3
                      : 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.15,
                ),
                itemCount: items.length,
                itemBuilder: (context, index) => ItemCard(item: items[index]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  const InfoCard({super.key, required this.title, required this.content});

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: Column(
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                content,
                maxLines: 1,
                style: Theme.of(context).textTheme.bodyMedium
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ItemHomepage {
  const ItemHomepage({
    required this.name,
    required this.icon,
    required this.color,
  });

  final String name;
  final IconData icon;
  final Color color;
}
