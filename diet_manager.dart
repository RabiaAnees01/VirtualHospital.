import 'package:flutter/material.dart';
import 'package:virtual_hospital/screens/daily_diet_plan.dart';
class DietManagerScreen extends StatelessWidget {
  const DietManagerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F6F0),
      appBar: AppBar(title: const Text("Diet Manager"), backgroundColor: Colors.transparent, elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Recommended Meals", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 15),
            Row(
              children: [
                _buildMealCard("Oats & Berries", "Breakfast", "350 cal", const Color(0xFFE8F5E9)),
                const SizedBox(width: 15),
                _buildMealCard("Grilled Salmon", "Lunch", "450 cal", const Color(0xFFFDF2F2)),
              ],
            ),
            const SizedBox(height: 30),
            _buildCalorieProgress(),
          ],
        ),
      ),
    );
  }

  Widget _buildMealCard(String title, String type, String cals, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(25)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.restaurant, color: Color(0xFF5D4037)),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(type, style: const TextStyle(fontSize: 12, color: Colors.black54)),
            const SizedBox(height: 5),
            Text(cals, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
          ],
        ),
      ),
    );
  }
// Dashboard Screen ke andar Navigator update karein:
Widget _buildCompactCard(BuildContext context, String title, IconData icon, Color color, Widget nextScreen) {
  return GestureDetector(
    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => nextScreen)),
    child: Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: const Color(0xFF5D4037)),
          const SizedBox(height: 10),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF5D4037), fontSize: 13)),
        ],
      ),
    ),
  );
}

// Dashboard ke GridView mein is tarah call karein:
// _buildCompactCard(context, "Chat with AI", Icons.chat_bubble_outline, Color(0xFFE8F5E9), AIChatScreen()),
// _buildCompactCard(context, "Exercise & Yoga", Icons.self_improvement, Color(0xFFFDF2F2), YogaGuideScreen()),
// _buildCompactCard(context, "Daily Health", Icons.favorite_border, Color(0xFFFDEFEF), HealthTrackerScreen()),
// _buildCompactCard(context, "Diet Plan", Icons.restaurant_menu, Color(0xFFEFEBE9), DailyDietPlanScreen()),
  Widget _buildCalorieProgress() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25)),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Calories Today", style: TextStyle(fontWeight: FontWeight.bold)),
              Text("90%", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 10),
          LinearProgressIndicator(value: 0.9, backgroundColor: Colors.grey[200], color: const Color(0xFF5D4037)),
        ],
      ),
    );
  }
}