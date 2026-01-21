
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class FirestoreService {
 
  static final FirestoreService _instance = FirestoreService._internal();
  factory FirestoreService() => _instance;
  FirestoreService._internal();

 
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

 
  static const String _usersCollection = 'users';
  static const String _symptomChecksCollection = 'symptom_checks';
  static const String _symptomTracksCollection = 'symptom_tracks';
  static const String _complaintsCollection = 'complaints';

  
  Future<bool> createUser(UserModel user) async {
    try {
      await _firestore.collection(_usersCollection).doc(user.id).set(
            user.toFirestore(),
            SetOptions(merge: false),
          );
      return true;
    } catch (e) {
      print('Error creating user: $e');
      return false;
    }
  }

 
  Future<UserModel?> getUserById(String userId) async {
    try {
      final doc = await _firestore.collection(_usersCollection).doc(userId).get();

      if (doc.exists) {
        return UserModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      print('Error getting user: $e');
      return null;
    }
  }


  Future<bool> updateUser(String userId, UserModel user) async {
    try {
      final updatedUser = user.copyWith(
        updatedAt: DateTime.now(),
      );

      await _firestore.collection(_usersCollection).doc(userId).update(
            updatedUser.toFirestore(),
          );
      return true;
    } catch (e) {
      print('Error updating user: $e');
      return false;
    }
  }

 
  Future<bool> deleteUser(String userId) async {
    try {
      await _firestore.collection(_usersCollection).doc(userId).delete();
      return true;
    } catch (e) {
      print('Error deleting user: $e');
      return false;
    }
  }


  Future<bool> isEmailExists(String email) async {
    try {
      final query = await _firestore
          .collection(_usersCollection)
          .where('email', isEqualTo: email.toLowerCase().trim())
          .limit(1)
          .get();

      return query.docs.isNotEmpty;
    } catch (e) {
      print('Error checking email: $e');
      return false;
    }
  }


  Stream<UserModel?> listenToUser(String userId) {
    return _firestore
        .collection(_usersCollection)
        .doc(userId)
        .snapshots()
        .map((doc) {
      if (doc.exists) {
        return UserModel.fromFirestore(doc);
      }
      return null;
    });
  }

 
  Future<bool> saveSymptomCheck(Map<String, dynamic> data) async {
    try {
      await _firestore.collection(_symptomChecksCollection).add(data);
      return true;
    } catch (e) {
      print('Error saving symptom check: $e');
      return false;
    }
  }


  Future<List<Map<String, dynamic>>> getSymptomCheckHistory(String userId) async {
    try {
      final query = await _firestore
          .collection(_symptomChecksCollection)
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return query.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      print('Error getting symptom check history: $e');
      return [];
    }
  }

  Future<bool> saveSymptomTrack(Map<String, dynamic> data) async {
    try {
      await _firestore.collection(_symptomTracksCollection).add(data);
      return true;
    } catch (e) {
      print('Error saving symptom track: $e');
      return false;
    }
  }


  Future<List<Map<String, dynamic>>> getSymptomTrackHistory(String userId) async {
    try {
      final query = await _firestore
          .collection(_symptomTracksCollection)
          .where('userId', isEqualTo: userId)
          .orderBy('date', descending: true)
          .get();

      return query.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      print('Error getting symptom track history: $e');
      return [];
    }
  }

  Future<bool> sendComplaint(Map<String, dynamic> data) async {
    try {
      await _firestore.collection(_complaintsCollection).add(data);
      return true;
    } catch (e) {
      print('Error sending complaint: $e');
      return false;
    }
  }

 
  Future<List<Map<String, dynamic>>> getUserComplaints(String userId) async {
    try {
      final query = await _firestore
          .collection(_complaintsCollection)
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return query.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      print('Error getting complaints: $e');
      return [];
    }
  }


  CollectionReference getCollection(String collectionName) {
    return _firestore.collection(collectionName);
  }

  /// Batch write operations
  WriteBatch getBatch() {
    return _firestore.batch();
  }

 
  Future<void> commitBatch(WriteBatch batch) async {
    await batch.commit();
  }
}