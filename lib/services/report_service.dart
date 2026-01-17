import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import '../models/report_model.dart';

class ReportService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Submit a new report
  Future<void> submitReport({
    required String userId,
    required String type,
    required String description,
    required Position position,
  }) async {
    await _firestore.collection('reports').add({
      'userId': userId,
      'type': type,
      'description': description,
      'location': GeoPoint(position.latitude, position.longitude),
      'reportedAt': FieldValue.serverTimestamp(),
      'status': 'pending',
    });
  }

  // Update report status (for mods/admins)
  Future<void> updateReportStatus({
    required String reportId,
    required String userId,
    required ReportStatus status,
  }) async {
    await _firestore.collection('reports').doc(reportId).update({
      'status': status.toString().split('.').last,
      'approvedBy': userId,
      'approvedAt': FieldValue.serverTimestamp(),
    });
  }

  // Get all reports (for mods/admins)
  Stream<List<ReportModel>> getReports({ReportStatus? status}) {
    Query query = _firestore.collection('reports');

    if (status != null) {
      query = query.where(
        'status',
        isEqualTo: status.toString().split('.').last,
      );
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs
          .map(
            (doc) =>
                ReportModel.fromMap(doc.data() as Map<String, dynamic>, doc.id),
          )
          .toList();
    });
  }

  // Get approved reports (for regular users)
  Stream<List<ReportModel>> getApprovedReports() {
    return _firestore
        .collection('reports')
        .where('status', isEqualTo: 'approved')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map(
                (doc) => ReportModel.fromMap(
                  doc.data() as Map<String, dynamic>,
                  doc.id,
                ),
              )
              .toList();
        });
  }
}
