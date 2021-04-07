import 'dart:io';
import 'dart:typed_data';

import 'base_client.dart';

Client createClient() => IOClient();

class IOClient extends Client {
  IOClient() : _inner = HttpClient();
  final HttpClient _inner;

  @override
  Future<Request> get(Uri uri) async {
    final HttpClientRequest request = await _inner.getUrl(uri);
    return IORequest(request);
  }
}

class IORequest extends Request {
  IORequest(this._inner);
  final HttpClientRequest _inner;

  @override
  Future<Response> send() async {
    try {
      final HttpClientResponse response = await _inner.close();
      final List<int> bytesList = await response.fold<List<int>>(
        <int>[],
        (List<int> previous, List<int> element) => previous..addAll(element),
      );

      return Response(Uint8List.fromList(bytesList), response.statusCode);
    } on SocketException catch (_) {
      rethrow;
    } catch (e) {
      throw ClientError(e.toString());
    }
  }

  @override
  void close() {
    _inner.abort();
  }
}
