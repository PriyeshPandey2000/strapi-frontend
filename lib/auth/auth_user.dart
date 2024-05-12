import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthService {
  final String baseUrl = "http://localhost:1337"; // Replace with your Strapi backend URL

  Future<Map<String, dynamic>> signUp(String username, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/local/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'username': username,
        'email': email,
        'password': password,
      }),
    );

    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> signIn(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/local'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'identifier': email,
        'password': password,
      }),
    );

    return jsonDecode(response.body);
  }

  Future<void> signOut(String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/logout'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to logout');
    }
  }
}

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  final AuthService _authService = AuthService();

  String _authStatus = '';
  String _token = '';

  Future<void> _signUp() async {
    try {
      final Map<String, dynamic> response = await _authService.signUp(
        _usernameController.text,
        _emailController.text,
        _passwordController.text,
      );
      setState(() {
        _authStatus = response['message'];
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _signIn() async {
    try {
      final Map<String, dynamic> response = await _authService.signIn(
        _emailController.text,
        _passwordController.text,
      );
      setState(() {
        _authStatus = response['message'];
        _token = response['jwt'];
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _signOut() async {
    try {
      await _authService.signOut(_token);
      setState(() {
        _authStatus = 'Logged out';
        _token = '';
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Authentication Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _signUp,
              child: const Text('Sign Up'),
            ),
            ElevatedButton(
              onPressed: _signIn,
              child: const Text('Sign In'),
            ),
            ElevatedButton(
              onPressed: _signOut,
              child: const Text('Sign Out'),
            ),
            const SizedBox(height: 20),
            Text(_authStatus),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    title: 'Authentication Example',
    home: AuthPage(),
  ));
}
