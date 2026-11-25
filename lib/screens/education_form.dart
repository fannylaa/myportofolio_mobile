import 'package:material_ui/material_ui.dart';
import 'package:portfolio/widgets/left_drawer.dart';

class EducationFormPage extends StatefulWidget {
  const EducationFormPage({super.key});

  @override
  State<EducationFormPage> createState() => _EducationFormPageState();
}

class _EducationFormPageState extends State<EducationFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _institutionController = TextEditingController();
  final _degreeController = TextEditingController();
  final _fieldOfStudyController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();

  DateTime? _startDate;
  DateTime? _endDate;
  bool _hasTriedSave = false;

  @override
  void dispose() {
    _institutionController.dispose();
    _degreeController.dispose();
    _fieldOfStudyController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate({required bool isStartDate}) async {
    final currentDate = isStartDate ? _startDate : _endDate;
    final startDate = _startDate;
    var initialDate =
        currentDate ??
        (isStartDate ? DateTime.now() : startDate ?? DateTime.now());
    if (!isStartDate && startDate != null && initialDate.isBefore(startDate)) {
      initialDate = startDate;
    }

    final selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: isStartDate ? DateTime(1900) : startDate ?? DateTime(1900),
      lastDate: DateTime(2100, 12, 31),
      helpText: isStartDate ? 'Pilih tanggal mulai' : 'Pilih tanggal selesai',
    );

    if (!mounted || selectedDate == null) return;

    setState(() {
      if (isStartDate) {
        _startDate = selectedDate;
        _startDateController.text = _formatDate(selectedDate);
      } else {
        _endDate = selectedDate;
        _endDateController.text = _formatDate(selectedDate);
      }
    });

    if (_hasTriedSave) _formKey.currentState?.validate();
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  Widget _buildRequiredTextField({
    required TextEditingController controller,
    required String label,
    required String emptyMessage,
  }) {
    return TextFormField(
      controller: controller,
      maxLength: 80,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) return emptyMessage;
        return null;
      },
    );
  }

  Widget _buildDateField({required bool isStartDate}) {
    final label = isStartDate ? 'Tanggal mulai' : 'Tanggal selesai';
    final controller = isStartDate ? _startDateController : _endDateController;

    return TextFormField(
      controller: controller,
      readOnly: true,
      onTap: () => _selectDate(isStartDate: isStartDate),
      decoration: InputDecoration(
        labelText: label,
        hintText: 'Pilih tanggal',
        prefixIcon: const Icon(Icons.calendar_month_outlined),
        suffixIcon: const Icon(Icons.edit_calendar_outlined),
        border: const OutlineInputBorder(),
      ),
      validator: (value) {
        final date = isStartDate ? _startDate : _endDate;
        if (date == null || value == null || value.trim().isEmpty) {
          return '$label wajib dipilih.';
        }
        if (!isStartDate && _startDate != null && date.isBefore(_startDate!)) {
          return 'Tanggal selesai tidak boleh sebelum tanggal mulai.';
        }
        return null;
      },
    );
  }

  void _saveEducation() {
    setState(() => _hasTriedSave = true);
    if (!(_formKey.currentState?.validate() ?? false)) return;

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Ringkasan Pendidikan'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Institusi: ${_institutionController.text.trim()}'),
                Text('Gelar: ${_degreeController.text.trim()}'),
                Text('Program studi: ${_fieldOfStudyController.text.trim()}'),
                Text('Tanggal mulai: ${_startDateController.text}'),
                Text('Tanggal selesai: ${_endDateController.text}'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Pendidikan'),
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
                Text(
                  'Isi informasi pendidikan yang ingin ditampilkan di portofolio.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 16),
                _buildRequiredTextField(
                  controller: _institutionController,
                  label: 'Institusi',
                  emptyMessage: 'Nama institusi wajib diisi.',
                ),
                const SizedBox(height: 12),
                _buildRequiredTextField(
                  controller: _degreeController,
                  label: 'Gelar',
                  emptyMessage: 'Gelar wajib diisi.',
                ),
                const SizedBox(height: 12),
                _buildRequiredTextField(
                  controller: _fieldOfStudyController,
                  label: 'Program studi',
                  emptyMessage: 'Program studi wajib diisi.',
                ),
                const SizedBox(height: 12),
                _buildDateField(isStartDate: true),
                const SizedBox(height: 12),
                _buildDateField(isStartDate: false),
                const SizedBox(height: 20),
                FilledButton.icon(
                  onPressed: _saveEducation,
                  icon: const Icon(Icons.save_outlined),
                  label: const Text('Simpan'),
                  style: FilledButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
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
