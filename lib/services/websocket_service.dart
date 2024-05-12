import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  final WebSocketChannel channel;

  WebSocketService(this.channel);

  // Method to send a message to the server
  void sendMessage(String message) {
    channel.sink.add(message);
  }

  // Method to receive messages from the server
  void receiveMessages(Function(String) onMessageReceived) {
    channel.stream.listen(
      (message) {
        onMessageReceived(message);
      },
      onError: (error) {
        print('WebSocket error: $error');
      },
      onDone: () {
        print('WebSocket connection closed');
      },
    );
  }

  // Method to close the WebSocket connection
  void closeConnection() {
    channel.sink.close();
  }
}
