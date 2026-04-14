import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'dashboard.dart';

class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.local_hospital, size: 80, color: Color(0xFF5D4037)),
            Text("VirtualHospital", 
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Color(0xFF5D4037))),
            const SizedBox(height: 40),
            IntlPhoneField(
              decoration: InputDecoration(
                labelText: 'Phone Number',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
              ),
              initialCountryCode: 'PK',
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 55)),
              onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DashboardScreen())),
              child: Text("Login / Sign Up"),
            ),
          ],
        ),
      ),
    );
  }
}