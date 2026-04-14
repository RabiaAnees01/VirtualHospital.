import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Vitals Save karne ke liye
  Future<void> saveVitals(double value, String type) async {
    await _db.collection('vitals').add({
      'value': value,
      'type': type, // e.g., 'BP' or 'Sugar'
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // Graph ke liye Data Fetch karne ka Stream
  Stream<QuerySnapshot> getVitalsStream() {
    return _db.collection('vitals')
        .orderBy('timestamp', descending: false)
        .limit(10)
        .snapshots();
  }
}