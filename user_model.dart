
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String? fullName;
  final String? email;

  final int? age;
  final String? gender;
  final String? phoneNumber;
  final String? address;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserModel({
    required this.id,
    this.fullName,
    this.email,
   
    this.age,
    this.gender,
    this.phoneNumber,
    this.address,
    this.createdAt,
    this.updatedAt,
  });


bool isValid() {
  return fullName != null &&
      fullName!.isNotEmpty &&
      email != null &&
      email!.isNotEmpty &&
      age != null &&
      age! > 0 &&
      gender != null &&
      gender!.isNotEmpty;
}


  
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'age': age,
      'gender': gender,
      'phoneNumber': phoneNumber,
      'address': address,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }


  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      fullName: data['fullName'],
      email: data['email'],
      age: data['age'],
      gender: data['gender'],
      phoneNumber: data['phoneNumber'],
      address: data['address'],
      createdAt: data['createdAt'] != null 
          ? (data['createdAt'] as Timestamp).toDate() 
          : null,
      updatedAt: data['updatedAt'] != null 
          ? (data['updatedAt'] as Timestamp).toDate() 
          : null,
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'age': age,
      'gender': gender,
      'phoneNumber': phoneNumber,
      'address': address,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }


  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      fullName: map['fullName'],
      email: map['email'],
     
      age: map['age'],
      gender: map['gender'],
      phoneNumber: map['phoneNumber'],
      address: map['address'],
      createdAt: map['createdAt'] is Timestamp
          ? (map['createdAt'] as Timestamp).toDate()
          : map['createdAt'],
      updatedAt: map['updatedAt'] is Timestamp
          ? (map['updatedAt'] as Timestamp).toDate()
          : map['updatedAt'],
    );
  }

 
  UserModel copyWith({
    String? id,
    String? fullName,
    String? email,
    String? password,
    int? age,
    String? gender,
    String? phoneNumber,
    String? address,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
     
      age: age ?? this.age,
      gender: gender ?? this.gender,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

 
  factory UserModel.empty() {
    return UserModel(
      id: '',
      fullName: '',
      email: '',
    
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, fullName: $fullName, email: $email, age: $age, gender: $gender)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.id == id &&
        other.email == email;
  }

  @override
  int get hashCode => id.hashCode ^ email.hashCode;
}