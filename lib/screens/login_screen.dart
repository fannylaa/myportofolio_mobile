import 'package:material_ui/material_ui.dart';
import 'package:portfolio/services/api_client.dart';
import 'package:portfolio/services/auth_state.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _password = '';
  bool _isSubmitting = false;

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _isSubmitting = true);

    try {
      await context.read<AuthState>().login(_username.trim(), _password);
      if (!mounted) return;
      Navigator.pop(context, true);
    } on ApiException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login gagal (${error.statusCode}). Periksa akunmu.'),
        ),
      );
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
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    hintText: 'Username',
                    labelText: 'Username',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => _username = value,
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Username tidak boleh kosong.'
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: 'Password',
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => _password = value,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Password tidak boleh kosong.'
                      : null,
                  onFieldSubmitted: (_) => _isSubmitting ? null : _submit(),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isSubmitting ? null : _submit,
                  child: _isSubmitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
