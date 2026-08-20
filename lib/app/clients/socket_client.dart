import 'package:dk_docs/shared/resources/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketClient {
  io.Socket? socket;
  static SocketClient? _instance;

  SocketClient._internal() {
    final uri = Constants.serverBaseUrl;
    socket = io.io(uri, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket!.onConnect((_) {
      debugPrint('SOCKET CONNECTED: ${socket!.id}');
    });

    socket!.onConnectError((error) {
      debugPrint('SOCKET CONNECTION ERROR: $error');
    });

    socket!.onError((error) {
      debugPrint('SOCKET ERROR: $error');
    });

    socket!.onDisconnect((_) {
      debugPrint('SOCKET DISCONNECTED');
    });
    socket?.connect();
  }

  static SocketClient get instance {
    return _instance ??= SocketClient._internal();
  }
}
