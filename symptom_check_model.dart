
import 'package:cloud_firestore/cloud_firestore.dart';

class SymptomCheckModel {
  final String id;
  final String userId;
  final String userName;
  final List<String> symptoms;
  final Map<String, dynamic> results;
  final DateTime createdAt;
  final String? notes;

  SymptomCheckModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.symptoms,
    required this.results,
    required this.createdAt,
    this.notes,
  });

  // Convert ke Map untuk Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'symptoms': symptoms,
      'results': results,
      'createdAt': Timestamp.fromDate(createdAt),
      'notes': notes,
    };
  }

  // Create dari Firestore Document
  factory SymptomCheckModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return SymptomCheckModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? '',
      symptoms: List<String>.from(data['symptoms'] ?? []),
      results: Map<String, dynamic>.from(data['results'] ?? {}),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      notes: data['notes'],
    );
  }

  // Convert ke Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'symptoms': symptoms,
      'results': results,
      'createdAt': createdAt,
      'notes': notes,
    };
  }

  // Create dari Map
  factory SymptomCheckModel.fromMap(Map<String, dynamic> map) {
    return SymptomCheckModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? '',
      symptoms: List<String>.from(map['symptoms'] ?? []),
      results: Map<String, dynamic>.from(map['results'] ?? {}),
      createdAt: map['createdAt'] is Timestamp
          ? (map['createdAt'] as Timestamp).toDate()
          : map['createdAt'] ?? DateTime.now(),
      notes: map['notes'],
    );
  }
}