
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/symptom_track_model.dart';
import 'auth_service.dart';
import 'firestore_service.dart';

class SymptomService {
  
  static final SymptomService _instance = SymptomService._internal();
  factory SymptomService() => _instance;
  SymptomService._internal();


  final FirestoreService _firestoreService = FirestoreService();
  final AuthService _authService = AuthService();

  
  
  Future<bool> saveSymptomCheck(SymptomTrackModel model) async {
    try {
      final currentUser = _authService.currentUser;
      if (currentUser == null) {
        print('Error: User not logged in');
        return false;
      }

      
      final updatedModel = SymptomTrackModel(
        id: model.id,
        userId: currentUser.id,
        userName: currentUser.fullName ?? 'Unknown',
        symptoms: model.symptoms,
        results: model.results,
        createdAt: model.createdAt,
        notes: model.notes,
      );

      return await _firestoreService.saveSymptomCheck(
        updatedModel.toMap(),
      );
    } catch (e) {
      print('Error saving symptom check: $e');
      return false;
    }
  }

  
  Future<List<SymptomTrackModel>> getSymptomCheckHistory() async {
    try {
      final currentUser = _authService.currentUser;
      if (currentUser == null) {
        print('Error: User not logged in');
        return [];
      }

      final history = await _firestoreService.getSymptomCheckHistory(
        currentUser.id,
      );

      return history.map((data) {
        return SymptomTrackModel.fromMap(data);
      }).toList();
    } catch (e) {
      print('Error getting symptom check history: $e');
      return [];
    }
  }

  
  

  Stream<List<SymptomTrackModel>> listenToSymptomChecks() {
    final currentUser = _authService.currentUser;
    if (currentUser == null) {
      return Stream.value([]);
    }

    return FirebaseFirestore.instance
        .collection('symptom_checks')
        .where('userId', isEqualTo: currentUser.id)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return SymptomTrackModel.fromFirestore(doc);
      }).toList();
    });
  }


  Future<Map<String, dynamic>> getUserStatistics() async {
    try {
      final checks = await getSymptomCheckHistory();
      
      final now = DateTime.now();
      final weekAgo = now.subtract(const Duration(days: 7));
      final monthAgo = now.subtract(const Duration(days: 30));

      final weeklyChecks = checks.where((c) => c.createdAt.isAfter(weekAgo)).length;
      final monthlyChecks = checks.where((c) => c.createdAt.isAfter(monthAgo)).length;

      return {
        'totalChecks': checks.length,
        'weeklyChecks': weeklyChecks,
        'monthlyChecks': monthlyChecks,
        'recentChecks': checks.takeFirst(3),
      };
    } catch (e) {
      print('Error getting user statistics: $e');
      return {
        'totalChecks': 0,
        'weeklyChecks': 0,
        'monthlyChecks': 0,
        'recentChecks': <SymptomTrackModel>[],
      };
    }
  }


  Future<SymptomTrackModel?> getSymptomCheckById(String checkId) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('symptom_checks')
          .doc(checkId)
          .get();

      if (doc.exists) {
        return SymptomTrackModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      print('Error getting symptom check: $e');
      return null;
    }
  }


  Future<bool> deleteSymptomCheck(String checkId) async {
    try {
      await FirebaseFirestore.instance
          .collection('symptom_checks')
          .doc(checkId)
          .delete();
      return true;
    } catch (e) {
      print('Error deleting symptom check: $e');
      return false;
    }
  }

 
  Future<bool> updateSymptomCheck(String checkId, Map<String, dynamic> updates) async {
    try {
      await FirebaseFirestore.instance
          .collection('symptom_checks')
          .doc(checkId)
          .update(updates);
      return true;
    } catch (e) {
      print('Error updating symptom check: $e');
      return false;
    }
  }


  Future<List<SymptomTrackModel>> searchSymptomChecks(String query) async {
    try {
      final currentUser = _authService.currentUser;
      if (currentUser == null) return [];

      final checks = await getSymptomCheckHistory();
      
      return checks.where((check) {
        return check.symptoms.any((symptom) =>
            symptom.toLowerCase().contains(query.toLowerCase()));
      }).toList();
    } catch (e) {
      print('Error searching symptom checks: $e');
      return [];
    }
  }

  Future<Map<String, int>> getSymptomFrequency() async {
    try {
      final checks = await getSymptomCheckHistory();
      final Map<String, int> frequency = {};

      for (var check in checks) {
        for (var symptom in check.symptoms) {
          frequency[symptom] = (frequency[symptom] ?? 0) + 1;
        }
      }

     
      final sortedEntries = frequency.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));

      return Map.fromEntries(sortedEntries);
    } catch (e) {
      print('Error getting symptom frequency: $e');
      return {};
    }
  }

 
  Future<List<SymptomTrackModel>> getSymptomsByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final checks = await getSymptomCheckHistory();
      return checks.where((check) {
        return check.createdAt.isAfter(startDate) &&
               check.createdAt.isBefore(endDate);
      }).toList();
    } catch (e) {
      print('Error getting symptoms by date range: $e');
      return [];
    }
  }


  Future<List<SymptomTrackModel>> getTodayChecks() async {
    try {
      final checks = await getSymptomCheckHistory();
      return checks.where((check) => check.isToday()).toList();
    } catch (e) {
      print('Error getting today checks: $e');
      return [];
    }
  }


  Future<Map<String, dynamic>> getWeeklySummary() async {
    try {
      final now = DateTime.now();
      final weekAgo = now.subtract(const Duration(days: 7));
      final checks = await getSymptomsByDateRange(weekAgo, now);

      final symptomsCount = <String, int>{};
      for (var check in checks) {
        for (var symptom in check.symptoms) {
          symptomsCount[symptom] = (symptomsCount[symptom] ?? 0) + 1;
        }
      }

      return {
        'totalChecks': checks.length,
        'symptoms': symptomsCount,
        'dates': checks.map((c) => c.createdAt).toList(),
      };
    } catch (e) {
      print('Error getting weekly summary: $e');
      return {
        'totalChecks': 0,
        'symptoms': <String, int>{},
        'dates': <DateTime>[],
      };
    }
  }

 
  Future<Map<String, dynamic>> getMonthlySummary() async {
    try {
      final now = DateTime.now();
      final monthAgo = now.subtract(const Duration(days: 30));
      final checks = await getSymptomsByDateRange(monthAgo, now);

      final symptomsCount = <String, int>{};
      for (var check in checks) {
        for (var symptom in check.symptoms) {
          symptomsCount[symptom] = (symptomsCount[symptom] ?? 0) + 1;
        }
      }

      return {
        'totalChecks': checks.length,
        'symptoms': symptomsCount,
        'dates': checks.map((c) => c.createdAt).toList(),
      };
    } catch (e) {
      print('Error getting monthly summary: $e');
      return {
        'totalChecks': 0,
        'symptoms': <String, int>{},
        'dates': <DateTime>[],
      };
    }
  }

  
  

  Future<String> exportSymptomHistory() async {
    try {
      final checks = await getSymptomCheckHistory();
      final jsonList = checks.map((check) => check.toMap()).toList();
      return jsonList.toString();
    } catch (e) {
      print('Error exporting symptom history: $e');
      return '';
    }
  }


  

  Future<bool> bulkDeleteSymptomChecks(List<String> checkIds) async {
    try {
      final batch = FirebaseFirestore.instance.batch();
      
      for (var checkId in checkIds) {
        final docRef = FirebaseFirestore.instance
            .collection('symptom_checks')
            .doc(checkId);
        batch.delete(docRef);
      }
      
      await batch.commit();
      return true;
    } catch (e) {
      print('Error bulk deleting symptom checks: $e');
      return false;
    }
  }


  Future<Map<String, List<int>>> getSymptomTrends(int days) async {
    try {
      final now = DateTime.now();
      final startDate = now.subtract(Duration(days: days));
      final checks = await getSymptomsByDateRange(startDate, now);

      final trends = <String, List<int>>{};
      
  
      for (var i = 0; i < days; i++) {
        final date = startDate.addDays(i);
        final dateKey = date.toFormattedString();
        trends[dateKey] = [];
      }

    
      for (var check in checks) {
        final dateKey = check.createdAt.toFormattedString();
        if (trends.containsKey(dateKey)) {
          trends[dateKey]!.add(check.symptoms.length);
        }
      }

      return trends;
    } catch (e) {
      print('Error getting symptom trends: $e');
      return {};
    }
  }
}