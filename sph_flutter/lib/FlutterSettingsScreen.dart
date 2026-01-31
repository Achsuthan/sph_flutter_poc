// lib/screens/flutter_settings_screen.dart
import 'package:flutter/material.dart';

class FlutterSettingsScreen extends StatefulWidget {
  const FlutterSettingsScreen({Key? key}) : super(key: key);

  @override
  State<FlutterSettingsScreen> createState() => _FlutterSettingsScreenState();
}

class _FlutterSettingsScreenState extends State<FlutterSettingsScreen> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  double _fontSize = 16.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Settings'),
        backgroundColor: Colors.deepOrange,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Icon(
            Icons.settings_outlined,
            size: 100,
            color: Colors.deepOrange,
          ),
          const SizedBox(height: 20),
          const Text(
            'Flutter Settings Screen',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text(
            '✅ This is a PRESENTED (Modal) Flutter screen',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 40),

          // Settings Card 1
          Card(
            elevation: 3,
            child: SwitchListTile(
              title: const Text('Enable Notifications'),
              subtitle: const Text('Receive push notifications'),
              secondary: const Icon(Icons.notifications),
              value: _notificationsEnabled,
              onChanged: (bool value) {
                setState(() {
                  _notificationsEnabled = value;
                });
              },
            ),
          ),

          const SizedBox(height: 10),

          // Settings Card 2
          Card(
            elevation: 3,
            child: SwitchListTile(
              title: const Text('Dark Mode'),
              subtitle: const Text('Use dark theme'),
              secondary: const Icon(Icons.dark_mode),
              value: _darkModeEnabled,
              onChanged: (bool value) {
                setState(() {
                  _darkModeEnabled = value;
                });
              },
            ),
          ),

          const SizedBox(height: 10),

          // Settings Card 3 - Slider
          Card(
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.font_download),
                      const SizedBox(width: 16),
                      Text(
                        'Font Size: ${_fontSize.round()}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  Slider(
                    value: _fontSize,
                    min: 12,
                    max: 24,
                    divisions: 12,
                    label: _fontSize.round().toString(),
                    onChanged: (double value) {
                      setState(() {
                        _fontSize = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 40),

          // Close Button
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close),
            label: const Text('Close Settings'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepOrange,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ],
      ),
    );
  }
}
