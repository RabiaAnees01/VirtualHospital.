import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:virtual_hospital/services/firebase_service.dart';

class HealthTrackerScreen extends StatefulWidget {
  const HealthTrackerScreen({super.key});

  @override
  State<HealthTrackerScreen> createState() => _HealthTrackerScreenState();
}

class _HealthTrackerScreenState extends State<HealthTrackerScreen> {
  final FirebaseService _firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F6F0), // Aesthetic Cream
      appBar: AppBar(
        title: const Text("Vitals & Progress", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: const Color(0xFF5D4037),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Stats Row
            _buildVitalsSummary(),
            const SizedBox(height: 30),
            
            const Text("Weekly Vitals Graph", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 15),
            
            // Professional Graph with Firebase Logic
            _buildProfessionalGraph(),
            
            const SizedBox(height: 30),
            const Text("Daily Tracker", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 10),
            
            // Checklist items as seen in image
            _routineItem("Yoga (7 AM)", "Set 30 Min", true),
            _routineItem("Drink Water", "Set 2.5L", false),
            
            const SizedBox(height: 20),
            
            // Add Record Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => _showAddRecordDialog(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFBCAAA4), // Muted brown
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: const Text("Add Record", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVitalsSummary() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _statBox("BP", "122/90", const Color(0xFFFDF2F2)), // Peach
        _statBox("Sugar", "90 mg/dL", const Color(0xFFE8F5E9)), // Sage
        _statBox("Temp", "98.4°F", const Color(0xFFFFF9C4)), // Yellow
      ],
    );
  }

  Widget _statBox(String label, String value, Color color) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(25)),
      child: Column(
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.black54)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildProfessionalGraph() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firebaseService.getVitalsStream(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

        List<FlSpot> spots = [];
        var docs = snapshot.data!.docs;
        for (int i = 0; i < docs.length; i++) {
          spots.add(FlSpot(i.toDouble(), docs[i]['value'].toDouble()));
        }

        return Container(
          height: 250,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 20)],
          ),
          child: LineChart(
            LineChartData(
              gridData: FlGridData(show: false),
              titlesData: FlTitlesData(show: false),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  spots: spots.isNotEmpty ? spots : [const FlSpot(0, 0)],
                  isCurved: true,
                  color: const Color(0xFFFADBD8), // Pink soft line
                  barWidth: 4,
                  belowBarData: BarAreaData(show: true, color: const Color(0xFFFADBD8).withOpacity(0.2)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _routineItem(String title, String subtitle, bool isDone) {
    return ListTile(
      leading: Icon(isDone ? Icons.check_circle : Icons.circle_outlined, color: const Color(0xFF5D4037)),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.more_horiz),
    );
  }

  void _showAddRecordDialog(BuildContext context) {
    final TextEditingController valueController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFF9F6F0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        title: const Text("New Vitals Entry"),
        content: TextField(
          controller: valueController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(hintText: "Enter value"),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              if (valueController.text.isNotEmpty) {
                _firebaseService.saveVitals(double.parse(valueController.text), "General");
                Navigator.pop(context);
              }
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }
}