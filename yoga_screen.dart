import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class YogaScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Yoga Guide"), backgroundColor: Colors.white, foregroundColor: Color(0xFF5D4037), elevation: 0),
      body: ListView(
        padding: EdgeInsets.all(15),
        children: [
          _yogaDemoCard("Gentle Yoga", "Flexibility", "https://assets10.lottiefiles.com/packages/lf20_jm9p8p.json"),
          _yogaDemoCard("Morning Cardio", "Weight Loss", "https://assets1.lottiefiles.com/packages/lf20_m6cuL6.json"),
        ],
      ),
    );
  }

  Widget _yogaDemoCard(String title, String subtitle, String animationUrl) {
    return Card(
      margin: EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          Container(
            height: 150,
            child: Lottie.network(animationUrl), // Professional Animation
          ),
          ListTile(
            title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(subtitle),
            trailing: Icon(Icons.play_circle_fill, color: Color(0xFF5D4037)),
          ),
        ],
      ),
    );
  }
}