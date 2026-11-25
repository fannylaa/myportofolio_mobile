import 'package:material_ui/material_ui.dart';
import 'package:portfolio/models/project.dart';
import 'package:portfolio/services/api_client.dart';
import 'package:portfolio/services/auth_state.dart';
import 'package:portfolio/utils/auth_guard.dart';
import 'package:portfolio/widgets/left_drawer.dart';
import 'package:provider/provider.dart';

class ProjectFormPage extends StatefulWidget {
  const ProjectFormPage({super.key});

  @override
  State<ProjectFormPage> createState() => _ProjectFormPageState();
}

class _ProjectFormPageState extends State<ProjectFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _techStackController = TextEditingController();
  final _projectUrlController = TextEditingController();
  final _projectImageUrlController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _techStackController.dispose();
    _projectUrlController.dispose();
    _projectImageUrlController.dispose();
    super.dispose();
  }

  String? _validateRequired(String? value, String label) {
    if (value == null || value.trim().isEmpty) return '$label wajib diisi.';
    return null;
  }

  String? _validateUrl(String? value, {bool optional = false}) {
    final url = value?.trim() ?? '';
    if (url.isEmpty && optional) return null;
    final uri = Uri.tryParse(url);
    if (uri == null ||
        !{'http', 'https'}.contains(uri.scheme.toLowerCase()) ||
        uri.host.isEmpty) {
      return 'Masukkan URL yang valid (diawali http:// atau https://).';
    }
    return null;
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _isSubmitting = true);

    try {
      final loggedIn = await ensureLoggedIn(context);
      if (!mounted || !loggedIn) return;

      final token = context.read<AuthState>().token;
      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login diperlukan untuk menyimpan proyek.'),
          ),
        );
        return;
      }

      final project = Project(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        techStack: _techStackController.text.trim(),
        projectUrl: _projectUrlController.text.trim(),
        projectImageUrl: _projectImageUrlController.text.trim(),
      );
      final createdProject = await context.read<ApiClient>().createProject(
        project,
        token: token,
      );
      if (!mounted) return;

      await showDialog<void>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Proyek berhasil ditambahkan!'),
          content: Text(
            '“${createdProject.title}” berhasil disimpan ke portofoliomu.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      if (!mounted) return;
      _formKey.currentState?.reset();
      _titleController.clear();
      _descriptionController.clear();
      _techStackController.clear();
      _projectUrlController.clear();
      _projectImageUrlController.clear();
    } on ApiException catch (error) {
      if (error.statusCode == 401) {
        final authState = context.read<AuthState>();
        try {
          await authState.logout();
        } catch (_) {
          // The local token is cleared in AuthState.logout's finally block.
        }
        if (!mounted) return;
        await ensureLoggedIn(context);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sesi berakhir. Silakan login kembali.'),
          ),
        );
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menyimpan proyek (${error.statusCode}).'),
          ),
        );
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak dapat terhubung ke server.')),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Proyek'),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      drawer: const LeftDrawer(),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _titleController,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => _validateRequired(value, 'Title'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _descriptionController,
                  minLines: 3,
                  maxLines: 5,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                  validator: (value) => _validateRequired(value, 'Description'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _techStackController,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: 'Tech Stack',
                    hintText: 'Contoh: Flutter, Django, PostgreSQL',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => _validateRequired(value, 'Tech Stack'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _projectUrlController,
                  keyboardType: TextInputType.url,
                  decoration: const InputDecoration(
                    labelText: 'Project URL',
                    hintText: 'https://example.com',
                    border: OutlineInputBorder(),
                  ),
                  validator: _validateUrl,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _projectImageUrlController,
                  keyboardType: TextInputType.url,
                  decoration: const InputDecoration(
                    labelText: 'Project Image URL (Optional)',
                    hintText: 'https://example.com/image.png',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => _validateUrl(value, optional: true),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: _isSubmitting ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  icon: _isSubmitting
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.save_outlined),
                  label: Text(_isSubmitting ? 'Menyimpan...' : 'Simpan'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
