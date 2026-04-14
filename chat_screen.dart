import 'package:flutter/material.dart';
import 'package:virtual_hospital/services/ai_service.dart';

class AIChatScreen extends StatefulWidget {
  const AIChatScreen({super.key});

  @override
  State<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  final AIService _aiService = AIService();
  bool _isLoading = false;

  void _sendMessage() async {
    if (_controller.text.isEmpty) return;

    String userMsg = _controller.text;
    setState(() {
      _messages.add({"role": "user", "text": userMsg});
      _isLoading = true;
    });
    _controller.clear();

    // Call AIService
    String aiResponse = await _aiService.getAIResponse(userMsg);

    setState(() {
      _messages.add({"role": "ai", "text": aiResponse});
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AI Doctor Chat", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF5D4037),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(15),
              itemCount: _messages.length,
              itemBuilder: (context, i) {
                bool isUser = _messages[i]['role'] == 'user';
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isUser ? const Color(0xFF5D4037) : const Color(0xFFFADBD8),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      _messages[i]['text']!,
                      style: TextStyle(color: isUser ? Colors.white : const Color(0xFF5D4037)),
                    ),
                  ),
                );
              },
            ),
          ),
          if (_isLoading) const LinearProgressIndicator(color: Color(0xFF5D4037)),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(10),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(hintText: "Type symptoms...", border: InputBorder.none),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Color(0xFF5D4037)),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }
}