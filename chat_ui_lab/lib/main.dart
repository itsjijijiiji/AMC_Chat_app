import 'package:flutter/material.dart';
import 'screens/chat_screen.dart';  // ← Points to FULL chat screen

void main() {
  runApp(ChatApp());
}

class ChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat UI Lab - Complete ✅',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.purple.shade400, // Using purple as a seed can yield great pinks
          primary: Colors.pink.shade600,      // A strong, confident pink
          secondary: Colors.deepPurple.shade400,
          brightness: Brightness.light,       // Explicitly light mode
        ),
        primarySwatch: Colors.pink,
      ),

      home: ChatScreen(),  // ← Uses your FULL ChatScreen
      debugShowCheckedModeBanner: false,  // Clean screen
    );
  }
}