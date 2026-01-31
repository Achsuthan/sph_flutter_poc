// lib/screens/flutter_profile_screen.dart
import 'package:flutter/material.dart';

class FlutterProfileScreen extends StatelessWidget {
  final String userId;
  final String userName;

  const FlutterProfileScreen({
    Key? key,
    required this.userId,
    required this.userName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Profile'),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.person_outline, size: 100, color: Colors.teal),
              const SizedBox(height: 20),
              const Text(
                'Flutter Profile Screen',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Text('User ID: $userId', style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 10),
              Text(
                'User Name: $userName',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 40),
              const Text(
                '✅ This is a PUSHED Flutter screen',
                style: TextStyle(fontSize: 14, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back),
                label: const Text('Go Back'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
