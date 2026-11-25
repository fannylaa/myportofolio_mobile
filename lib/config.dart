/// Base URL for the Django REST Framework backend.
///
/// Android emulators reach the host machine through 10.0.2.2. For Flutter Web
/// or a physical device, override this with --dart-define=API_BASE_URL=...
const String apiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://10.0.2.2:8000',
);
