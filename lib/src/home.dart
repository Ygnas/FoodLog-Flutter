import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _token = '';

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  Future<void> _loadToken() async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'jwtToken');
    setState(() {
      _token = token ?? "0";
    });
    _checkToken();
  }

  void _checkToken() {
    if (_token == "0") {
      context.go("/login");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Log'),
      ),
      body: Center(
        child: Text(
          'Token: $_token',
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
