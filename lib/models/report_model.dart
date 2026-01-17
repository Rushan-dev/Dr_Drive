import 'package:cloud_firestore/cloud_firestore.dart';

class ReportModel {
  final String id;
  final String userId;
  final String type; // accident, roadblock, hazard
  final String description;
  final DateTime reportedAt;
  final ReportStatus status;
  final String? approvedBy;
  final DateTime? approvedAt;
  final GeoPoint location;

  ReportModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.description,
    required this.location,
    DateTime? reportedAt,
    this.status = ReportStatus.pending,
    this.approvedBy,
    this.approvedAt,
  }) : reportedAt = reportedAt ?? DateTime.now();

  factory ReportModel.fromMap(Map<String, dynamic> data, String id) {
    return ReportModel(
      id: id,
      userId: data['userId'],
      type: data['type'],
      description: data['description'],
      location: data['location'],
      reportedAt: data['reportedAt']?.toDate(),
      status: ReportStatus.values.firstWhere(
        (e) => e.toString() == 'ReportStatus.${data['status']}',
        orElse: () => ReportStatus.pending,
      ),
      approvedBy: data['approvedBy'],
      approvedAt: data['approvedAt']?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'type': type,
      'description': description,
      'location': location,
      'reportedAt': reportedAt,
      'status': status.toString().split('.').last,
      'approvedBy': approvedBy,
      'approvedAt': approvedAt,
    };
  }
}

enum ReportStatus { pending, approved, rejected }
