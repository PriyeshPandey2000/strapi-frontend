import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/bloc/chat_bloc.dart';
import 'package:frontend/services/websocket_service.dart'; // Import WebSocketService class
import 'package:web_socket_channel/web_socket_channel.dart';


class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late WebSocketService webSocketService; // Declare WebSocketService instance
  TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize WebSocketService with WebSocketChannel
    final channel = WebSocketChannel.connect(Uri.parse('wss://strapi-backend-6y46.onrender.com/ws'));
    webSocketService = WebSocketService(channel);

    // Receive messages and update UI
    webSocketService.receiveMessages((message) {
      // Update UI to display received message
      setState(() {
        // Add received message to list of messages
        context.read<ChatBloc>().add(ChatMessageReceived(message));
      });
    });
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Chat'),
    ),
    body: BlocBuilder<ChatBloc, List<String>>(
      builder: (context, messages) {
        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                reverse: true, // Scroll to the bottom when a new message is added
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: messages
                        .map((message) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        mainAxisAlignment: message.startsWith('Sent:') ? MainAxisAlignment.end : MainAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: message.startsWith('Sent:') ? Colors.blue : Colors.green,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Text(
                              message.replaceAll('Sent:', ''), // Remove 'Sent:' from the message
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ))
                        .toList(),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      decoration: const InputDecoration(
                        hintText: 'Type your message...',
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      String message = messageController.text;
                      if (message.isNotEmpty) {
                        // Send message to WebSocket server
                        webSocketService.sendMessage(message);
                        // Dispatch an event to the ChatBloc to send the message
                        context.read<ChatBloc>().add(ChatMessageSent('Sent: $message'));
                        // Clear the text field
                        messageController.clear();
                      }
                    },
                    child: const Text('Send'),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    ),
  );
}
  @override
  void dispose() {
    // Close WebSocket connection when screen is disposed
    webSocketService.closeConnection();
    super.dispose();
  }
}
