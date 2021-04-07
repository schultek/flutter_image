import 'base_client.dart';

/// Implemented in `browser_client.dart` and `io_client.dart`.
Client createClient() => throw UnsupportedError('Cannot create a client without dart:html or dart:io.');
