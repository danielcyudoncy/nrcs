// core/network/ws_client.dart
import 'dart:async';
import 'dart:math';
import 'package:web_socket_channel/web_socket_channel.dart';

class WSClient {
  final WebSocketChannel? channel;
  WSClient.connect(String url) : channel = WebSocketChannel.connect(Uri.parse(url));

  // demo factory: simulate server events on a timer
  WSClient.demo(void Function(Map<String, dynamic>) onEvent) : channel = null {
    final rnd = Random();
    Timer.periodic(Duration(seconds: 6), (t) {
      // randomly choose reorder or update
      if (rnd.nextBool()) {
        final from = rnd.nextInt(5);
        final to = rnd.nextInt(5);
        onEvent({'type': 'reorder', 'from': from, 'to': to});
      } else {
        // emit an update for a random id placeholder; consumers must handle missing ids
        onEvent({'type': 'update', 'id': null, 'slug': 'Updated ${DateTime.now().millisecondsSinceEpoch}'});
      }
    });
  }
}
