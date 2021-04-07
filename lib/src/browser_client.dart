import 'dart:async';
import 'dart:html';
import 'dart:typed_data';

import 'package:flutter_image/src/base_client.dart';

Client createClient() => BrowserClient();

class BrowserClient implements Client {
  @override
  Future<Request> get(Uri uri) {
    final HttpRequest xhr = HttpRequest();

    xhr.open('get', uri.toString());
    xhr.responseType = 'arraybuffer';

    return Future.sync(() => BrowserRequest(xhr));
  }
}

class BrowserRequest extends Request {
  BrowserRequest(this._inner);
  final HttpRequest _inner;

  @override
  Future<Response> send() {
    final Completer<Response> completer = Completer<Response>();

    _inner.onLoad.first.then((_) {
      Uint8List bytes;
      if (_inner.status == 200) {
        bytes = (_inner.response as ByteBuffer).asUint8List();
      }
      completer.complete(Response(bytes, _inner.status));
    });

    _inner.onError.first.then((_) {
      completer.completeError(ClientError('XMLHttpRequest error.'), StackTrace.current);
    });

    _inner.send();

    return completer.future;
  }

  @override
  void close() {
    _inner.abort();
  }
}
