import 'package:flutter/material.dart';

class DailyDietPlanScreen extends StatelessWidget {
  const DailyDietPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F6F0),
      appBar: AppBar(
        title: const Text("Daily Diet Plan", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: const Color(0xFF5D4037),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Meal Selector (Breakfast, Lunch, Dinner)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMealTypeChip("Breakfast", true),
                _buildMealTypeChip("Lunch", false),
                _buildMealTypeChip("Dinner", false),
              ],
            ),
            const SizedBox(height: 25),
            // Weekly Calendar View
            const Text("Weekly Schedule", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
              ),
              child: GridView.builder(
                shrinkWrap: true,
                itemCount: 7,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7),
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Text(["S", "M", "T", "W", "T", "F", "S"][index], style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      const SizedBox(height: 5),
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: index == 1 ? const Color(0xFF5D4037) : Colors.transparent,
                        child: Text("${index + 1}", style: TextStyle(fontSize: 10, color: index == 1 ? Colors.white : Colors.black)),
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 25),
            _buildRecommendedSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildMealTypeChip(String title, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF5D4037) : Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(title, style: TextStyle(color: isSelected ? Colors.white : const Color(0xFF5D4037), fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildRecommendedSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Recommended Today", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 15),
        Container(
          height: 100,
          decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(20)),
          child: const Center(child: Text("Healthy Salad & Protein Shake", style: TextStyle(color: Color(0xFF5D4037)))),
        ),
      ],
    );
  }
}