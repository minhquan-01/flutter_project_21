import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MaintenanceController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Lên lịch bảo dưỡng mới
  Future<void> scheduleMaintenance({
    required String userId,
    required String bikeName,
    required String serviceType,
    required DateTime scheduledDate,
    required String note,
  }) async {
    await _db.collection('maintenance_schedules').add({
      'userId': userId,
      'bikeName': bikeName,
      'serviceType': serviceType,
      'scheduledDate': Timestamp.fromDate(scheduledDate),
      'note': note,
      'status': 'Chờ thực hiện',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Lấy danh sách lịch bảo dưỡng của user hiện tại
  Stream<QuerySnapshot> getMySchedules() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return const Stream.empty();
    
    return _db.collection('maintenance_schedules')
        .where('userId', isEqualTo: uid)
        .snapshots();
  }
}
