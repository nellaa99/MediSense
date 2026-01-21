
import 'package:cloud_firestore/cloud_firestore.dart';

class SymptomTrackModel {
  final String id;
  final String userId;
  final String userName;
  final List<String> symptoms;
  final Map<String, dynamic> results;
  final DateTime createdAt;
  final String notes;

  SymptomTrackModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.symptoms,
    required this.results,
    required this.createdAt,
    this.notes = '',
  });

  // ==================== TO MAP ====================
  Map<String, dynamic> toMap() {
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

  // ==================== TO JSON ====================
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'symptoms': symptoms,
      'results': results,
      'createdAt': createdAt.toIso8601String(),
      'notes': notes,
    };
  }

  // ==================== FROM MAP ====================
  factory SymptomTrackModel.fromMap(Map<String, dynamic> map) {
    return SymptomTrackModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? 'Unknown',
      symptoms: List<String>.from(map['symptoms'] ?? []),
      results: Map<String, dynamic>.from(map['results'] ?? {}),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      notes: map['notes'] ?? '',
    );
  }

  // ==================== FROM JSON ====================
  factory SymptomTrackModel.fromJson(Map<String, dynamic> json) {
    return SymptomTrackModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? 'Unknown',
      symptoms: List<String>.from(json['symptoms'] ?? []),
      results: Map<String, dynamic>.from(json['results'] ?? {}),
      createdAt: DateTime.parse(json['createdAt']),
      notes: json['notes'] ?? '',
    );
  }

  // ==================== FROM FIRESTORE ====================
  factory SymptomTrackModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return SymptomTrackModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? 'Unknown',
      symptoms: List<String>.from(data['symptoms'] ?? []),
      results: Map<String, dynamic>.from(data['results'] ?? {}),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      notes: data['notes'] ?? '',
    );
  }

  // ==================== IS TODAY ====================
  bool isToday() {
    final now = DateTime.now();
    return createdAt.year == now.year &&
        createdAt.month == now.month &&
        createdAt.day == now.day;
  }

  // ==================== GET SYMPTOMS COUNT ====================
  int getSymptomsCount() {
    return symptoms.length;
  }

  // ==================== GET SEVERITY LEVEL ====================
  int getSeverityLevel() {
    final severity = results['severity']?.toString().toLowerCase() ?? '';
    switch (severity) {
      case 'ringan':
        return 1;
      case 'sedang':
        return 2;
      case 'berat':
        return 3;
      default:
        return 0;
    }
  }

  // ==================== COPY WITH ====================
  SymptomTrackModel copyWith({
    String? id,
    String? userId,
    String? userName,
    List<String>? symptoms,
    Map<String, dynamic>? results,
    DateTime? createdAt,
    String? notes,
  }) {
    return SymptomTrackModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      symptoms: symptoms ?? this.symptoms,
      results: results ?? this.results,
      createdAt: createdAt ?? this.createdAt,
      notes: notes ?? this.notes,
    );
  }
}

// ==================== EXTENSIONS ====================
extension DateTimeExtension on DateTime {
  String toFormattedString() {
    return '${year}-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
  }

  DateTime addDays(int days) {
    return add(Duration(days: days));
  }
}

extension ListExtension<T> on List<T> {
  List<T> takeFirst(int count) {
    if (count >= length) return this;
    return sublist(0, count);
  }
}