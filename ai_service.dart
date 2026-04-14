import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AIService {
  static final AIService _instance = AIService._internal();
  factory AIService() => _instance;
  AIService._internal();
  
  // For emulator/real device
  final String _baseUrl = 'http://10.0.2.2:8000'; // Android emulator
  // For web: 'http://localhost:8000'
  
  // Store chat history
  List<Map<String, dynamic>> _chatHistory = [];
  
  // Get AI response with history
  Future<Map<String, dynamic>> getAIResponse(String userMessage) async {
    try {
      // Add to history
      _chatHistory.add({
        "role": "user",
        "message": userMessage,
        "timestamp": DateTime.now().toIso8601String()
      });
      
      // Prepare request with context
      Map<String, dynamic> requestData = {
        "message": userMessage,
        "history": _chatHistory.sublist(max(0, _chatHistory.length - 5)), // Last 5 messages
        "patient_id": "patient_001", // You can get this from Firebase auth
      };
      
      final response = await http.post(
        Uri.parse('$_baseUrl/chat'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestData),
      ).timeout(Duration(seconds: 30));
      
      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        
        // Add AI response to history
        _chatHistory.add({
          "role": "ai",
          "message": data['response'],
          "timestamp": DateTime.now().toIso8601String()
        });
        
        // Save to Firebase if needed
        await _saveChatToFirebase(userMessage, data['response']);
        
        return data;
      } else {
        return {
          "response": "Server error. Please check if Python backend is running.\n\nRun: python api.py",
          "error": true
        };
      }
    } catch (e) {
      return {
        "response": "Connection failed. Make sure:\n1. Python server is running\n2. Run: python api.py\n3. Check if port 8000 is free\n\nError: ${e.toString()}",
        "error": true
      };
    }
  }
  
  Future<void> _saveChatToFirebase(String userMsg, String aiResponse) async {
    // Implement Firebase save
    // await FirebaseFirestore.instance.collection('chats').add({...});
  }
  
  // Get diet plan based on AI analysis
  Future<Map<String, dynamic>> generateDietPlan(Map<String, dynamic> healthData) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/generate_diet'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(healthData),
      );
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return {"error": "Could not generate diet plan"};
    } catch (e) {
      return {"error": e.toString()};
    }
  }
  
  // Get exercise recommendations
  Future<Map<String, dynamic>> getExercisePlan(Map<String, dynamic> healthData) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/exercise_recommendations'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(healthData),
      );
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return {"error": "Could not generate exercise plan"};
    } catch (e) {
      return {"error": e.toString()};
    }
  }
  
  // Clear chat history
  void clearHistory() {
    _chatHistory.clear();
  }
  
  // Get chat history
  List<Map<String, dynamic>> get chatHistory => _chatHistory;
}