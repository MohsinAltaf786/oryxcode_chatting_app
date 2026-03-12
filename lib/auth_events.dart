import 'dart:async';

class AuthEvents {
  static final _controller = StreamController<AuthEventType>.broadcast();

  static Stream<AuthEventType> get stream => _controller.stream;

  static void fire(AuthEventType event) {
    _controller.add(event);
  }
}

enum AuthEventType {
  unauthorized,
  tokenRefreshed,
}