import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F6F0),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color(0xFF5D4037),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Profile"),
        ],
      ),
      body: Column(
        children: [
          _buildTopHeader(),
          Expanded(
            child: GridView.count(
              padding: const EdgeInsets.all(20),
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 1.0, 
              children: [
                _buildCompactCard("Chat with AI", Icons.chat_bubble_outline, const Color(0xFFE8F5E9)),
                _buildCompactCard("Exercise & Yoga", Icons.self_improvement, const Color(0xFFFDF2F2)),
                _buildCompactCard("Daily Health", Icons.favorite_border, const Color(0xFFFDEFEF)),
                _buildCompactCard("Diet Plan", Icons.restaurant_menu, const Color(0xFFEFEBE9)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopHeader() {
    return Container(
      padding: const EdgeInsets.only(top: 60, left: 25, right: 25, bottom: 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [Color(0xFFFADBD8), Color(0xFFF9F6F0)], begin: Alignment.topCenter, end: Alignment.bottomCenter)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Welcome,", style: TextStyle(color: Colors.black54)),
              Text("Patient Name!", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF5D4037))),
            ],
          ),
          const CircleAvatar(radius: 20, backgroundColor: Colors.white, child: Icon(Icons.person, color: Color(0xFF5D4037))),
        ],
      ),
    );
  }

  Widget _buildCompactCard(String title, IconData icon, Color color) {
    return Container(
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
    );
  }
}