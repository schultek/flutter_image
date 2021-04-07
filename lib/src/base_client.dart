import 'dart:typed_data';

abstract class Client {
  Future<Request> get(Uri uri);
}

abstract class Request {
  Future<Response> send();
  void close();
}

class Response {
  Response(this.bytes, this.statusCode);
  Uint8List bytes;
  int statusCode;
}

class ClientError extends Error {
  ClientError(this.message);
  final String message;
}
