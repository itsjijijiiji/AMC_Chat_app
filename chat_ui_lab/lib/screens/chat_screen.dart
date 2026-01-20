import 'package:chat_ui_lab/services/gemini_service.dart';
import 'package:flutter/material.dart';
import '../models/chat_message.dart';
import '../widgets/message_bubble.dart';
import '../widgets/input_bar.dart';
// Note: You only need to import gemini_service once.
// import '/services/gemini_service.dart'; // This is a duplicate import

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<ChatMessage> messages = [
    // Add a welcome message from the AI to start the conversation
    ChatMessage(
      text: "Hello! How can I help you today? ✨",
      isUserMessage: false,
      timestamp: DateTime.now(),
    ),
  ];
  final ScrollController _scrollController = ScrollController();

  void addMessage(String text, bool isUser) {
    setState(() {
      messages.add(ChatMessage(
        text: text,
        isUserMessage: isUser,
        timestamp: DateTime.now(),
      ));
    });
    // A short delay ensures the new item is in the list before scrolling
    Future.delayed(Duration(milliseconds: 50), () => _scrollToBottom());
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  Future<void> handleSend(String text) async {
    addMessage(text, true); // User message

    // Show a loading indicator
    addMessage('🤖 Thinking...', false);

    try {
      final aiResponse = await GeminiService.sendMessage(text);
      // Remove loading message and add the real response
      setState(() {
        messages.removeLast();
        addMessage(aiResponse, false);
      });
    } catch (e) {
      // Handle error: remove loading and show an error message
      setState(() {
        messages.removeLast();
        addMessage('❌ Oops! Something went wrong. Please try again.', false);
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      // The AppBar now has a transparent background to blend with the gradient
      appBar: AppBar(
        title: Text('Gemini UI 🔮', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      // This makes the AppBar gradient extend behind the status bar
      extendBodyBehindAppBar: true,
      // The main content is wrapped in a Container with a gradient background
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.primary.withOpacity(0.1),
              theme.colorScheme.secondary.withOpacity(0.1),
              theme.colorScheme.background,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.4, 1.0], // Controls where the gradient colors transition
          ),
        ),
        child: Column(
          children: [
            Expanded(
              // Use a reversed list to automatically show the end.
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.only(top: 100, bottom: 10), // Padding to avoid AppBar
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return MessageBubble(
                    message: messages[index],
                  );
                },
              ),
            ),
            // The InputBar is now styled with padding and a background color
            Container(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 24), // Add bottom padding for home indicator
              color: theme.colorScheme.surface.withOpacity(0.8), // Semi-transparent background
              child: InputBar(onSendMessage: handleSend),
            ),
          ],
        ),
      ),
    );
  }
}