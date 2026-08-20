import 'package:dk_docs/app/clients/socket_client.dart';
import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' show Socket;

class SocketRepo {
  final _client = SocketClient.instance;

  Socket get socket => _client.socket!;

  void joinRoom(String documentId) {
    if (socket.connected) {
      debugPrint('📄 Joining: $documentId');
      socket.emit('join', documentId);
      return;
    }

    debugPrint('⏳ Waiting for socket connection...');

    socket.once('connect', (_) {
      debugPrint('🔥 Connected, now joining: $documentId');
      socket.emit('join', documentId);
    });
  }

  void typing(Map<String, dynamic> data) {
    socket.emit('typing', data);
  }

  void changeListener(Function(Map<String, dynamic>) omChangeListener) {
    socket.on('changes', (data) => omChangeListener(data));
  }
}
