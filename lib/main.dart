import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'features/lessons/presentation/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseConfig.initialize();
  runApp(const EngriskApp());
}

class EngriskApp extends StatelessWidget {
  const EngriskApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Engrisk',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}