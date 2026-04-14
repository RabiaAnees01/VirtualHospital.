import 'package:flutter/material.dart';
import 'dashboard.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFEF9E7), Color(0xFFFADBD8)], // Soft Peach Gradient
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.health_and_safety_outlined, size: 80, color: Color(0xFF5D4037)),
              const Text("VirtualHospital", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF5D4037))),
              const SizedBox(height: 40),
              _buildInput("Email Address"),
              const SizedBox(height: 15),
              _buildInput("Phone Number"),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const DashboardScreen())),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFBCAAA4), // Muted Brown button
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: const Text("Continue", style: TextStyle(color: Colors.white, fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInput(String hint) {
    return TextField(
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white.withOpacity(0.9),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
      ),
    );
  }
}