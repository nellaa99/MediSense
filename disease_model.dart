class DiseaseModel {
  final String id;
  final String name;
  final List<String> symptoms;
  final String description;
  final List<String> treatment;
  final List<String> prevention;
  final String severity;
  final bool isSeasonal;

  DiseaseModel({
    required this.id,
    required this.name,
    required this.symptoms,
    required this.description,
    required this.treatment,
    required this.prevention,
    required this.severity,
    this.isSeasonal = false,
  });

  // 🔥 UNTUK SIMPAN KE FIRESTORE
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'symptoms': symptoms,
      'description': description,
      'treatment': treatment,
      'prevention': prevention,
      'severity': severity,
      'isSeasonal': isSeasonal,
    };
  }


  factory DiseaseModel.fromFirestore(
    String id,
    Map<String, dynamic> json,
  ) {
    return DiseaseModel(
      id: id,
      name: json['name'] ?? '',
      symptoms: List<String>.from(json['symptoms'] ?? []),
      description: json['description'] ?? '',
      treatment: List<String>.from(json['treatment'] ?? []),
      prevention: List<String>.from(json['prevention'] ?? []),
      severity: json['severity'] ?? '',
      isSeasonal: json['isSeasonal'] ?? false,
    );
  }
}
