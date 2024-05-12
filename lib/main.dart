import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/screens/signup_screen.dart'; // Import SignUpScreen
import 'package:frontend/bloc/chat_bloc.dart'; // Import your ChatBloc class

void main() {
  runApp(const ChatApp());
}

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ChatBloc(), // Provide ChatBloc here
      child: MaterialApp(
        title: 'Chat App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const SignUpScreen(), // Navigate to SignUpScreen initially
      ),
    );
  }
}
