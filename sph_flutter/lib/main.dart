// lib/main.dart
import 'package:flutter/material.dart';
import 'package:sph_flutter/FlutterProfileScreen.dart';
import 'package:sph_flutter/FlutterSettingsScreen.dart';
import 'package:sph_flutter/NativeService.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  final NativeService _nativeService = NativeService();

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
    _nativeService.callSimpleFunction();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('You have pushed the button this many times:'),
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 20),
              const Text(
                'Check Xcode console for iOS logs!',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),

              // ✅ NEW: Flutter Navigation Section
              const SizedBox(height: 40),
              const Divider(thickness: 2),
              const SizedBox(height: 20),
              const Text(
                'Navigate to Flutter Screens:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // ✅ Button 1: PUSH Flutter Profile Screen
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Regular push navigation
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FlutterProfileScreen(
                          userId: '12345',
                          userName: 'Senthu',
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.account_circle),
                  label: const Text('Push Flutter Profile (Slide Right)'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // ✅ Button 2: PRESENT Flutter Settings Screen (Modal)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Modal/Present navigation
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FlutterSettingsScreen(),
                        fullscreenDialog: true, // ✅ This makes it modal!
                      ),
                    );
                  },
                  icon: const Icon(Icons.settings_applications),
                  label: const Text('Present Flutter Settings (Slide Up)'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.deepOrange,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),

              // Native Navigation Section (Existing)
              const SizedBox(height: 40),
              const Divider(thickness: 2),
              const SizedBox(height: 20),
              const Text(
                'Navigate to Native iOS Screens:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Button 3 - Push Native Profile
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    _nativeService.pushNativeScreen(
                      'Profile',
                      data: {'userId': '12345', 'userName': 'Senthu'},
                    );
                  },
                  icon: const Icon(Icons.person),
                  label: const Text('Push Native Profile Screen'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Button 4 - Push Native Settings
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    _nativeService.pushNativeScreen('Settings');
                  },
                  icon: const Icon(Icons.settings),
                  label: const Text('Push Native Settings Screen'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Button 5 - Push Native Audio Player
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    _nativeService.pushNativeScreen('AudioPlayer');
                  },
                  icon: const Icon(Icons.music_note),
                  label: const Text('Push Native Audio Player'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment & Play Podcast',
        child: const Icon(Icons.add),
      ),
    );
  }
}
