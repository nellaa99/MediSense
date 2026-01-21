// services/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import 'firestore_service.dart';

class AuthService {

  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();


  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = FirestoreService();


  UserModel? _currentUser;

  UserModel? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;
  User? get firebaseUser => _auth.currentUser;


  
  Future<void> initialize() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        _currentUser = await _firestoreService.getUserById(user.uid);
      }
    } catch (e) {
      print('Error initializing auth: $e');
    }
  }

  // ==================== USER REGISTRATION ====================
  
  Future<Map<String, dynamic>> registerUser({
    required String email,
    required String password,
    required String fullName,
    required int age,
    required String gender,
  }) async {
    print('🚀 Starting registration process...');
    print('   Email: $email');
    print('   Name: $fullName');
    
    try {
      // Validasi data user
      if (fullName.isEmpty || email.isEmpty || password.isEmpty) {
        return {
          'success': false,
          'message': 'Data user tidak lengkap',
        };
      }

      if (age < 10 || age > 100) {
        return {
          'success': false,
          'message': 'Umur tidak valid (10-100)',
        };
      }

      if (password.length < 6) {
        return {
          'success': false,
          'message': 'Password minimal 6 karakter',
        };
      }

      print('✅ Validation passed');
      print('🔥 Creating Firebase Auth user...');

      // Create user di Firebase Auth
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.toLowerCase().trim(),
        password: password,
      );

      print('✅ Firebase Auth user created: ${userCredential.user?.uid}');

      // PENTING: Logout dulu setelah register
      // Karena Firebase Auth otomatis login setelah register
      await _auth.signOut();
      print('🔓 Auto-signed out after registration');

      print('💾 Saving to Firestore...');

      // Create UserModel
      final newUser = UserModel(
        id: userCredential.user!.uid,
        fullName: fullName,
        email: email.toLowerCase(),
        age: age,
        gender: gender,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Simpan user ke Firestore dengan retry
      bool saved = false;
      int retryCount = 0;
      const maxRetries = 3;

      while (!saved && retryCount < maxRetries) {
        try {
          saved = await _firestoreService.createUser(newUser);
          if (saved) {
            print('✅ Firestore save successful on attempt ${retryCount + 1}');
            break;
          }
        } catch (e) {
          retryCount++;
          print('⚠️ Firestore save attempt ${retryCount} failed: $e');
          if (retryCount < maxRetries) {
            await Future.delayed(Duration(seconds: retryCount));
          }
        }
      }

      if (saved) {
        print('🎉 Registration successful!');
        
        return {
          'success': true,
          'message': 'Registrasi berhasil! Silakan login',
          'user': newUser,
        };
      } else {
        print('❌ Firestore save failed after $maxRetries attempts');
        // Jangan hapus user dari Auth, karena data mungkin sudah masuk
        // Biarkan user bisa login nanti
        return {
          'success': true, // Tetap return success
          'message': 'Akun berhasil dibuat! Silakan login',
        };
      }
      
    } on FirebaseAuthException catch (e) {
      print('❌ FirebaseAuthException: ${e.code} - ${e.message}');
      
      String message;
      switch (e.code) {
        case 'weak-password':
          message = 'Password terlalu lemah';
          break;
        case 'email-already-in-use':
          message = 'Email sudah digunakan. Silakan login atau gunakan email lain';
          break;
        case 'invalid-email':
          message = 'Format email tidak valid';
          break;
        case 'operation-not-allowed':
          message = 'Operasi tidak diizinkan';
          break;
        case 'network-request-failed':
          message = 'Koneksi internet bermasalah. Periksa WiFi/data Anda';
          break;
        default:
          message = 'Error: ${e.message}';
      }
      
      return {
        'success': false,
        'message': message,
      };
      
    } catch (e) {
      print('❌ General error: $e');
      
      return {
        'success': false,
        'message': 'Terjadi kesalahan: ${e.toString()}',
      };
    }
  }

  // ==================== USER LOGIN ====================
  
  Future<Map<String, dynamic>> loginUser(String email, String password) async {
    print('🔐 Starting login process...');
    print('   Email: $email');
    
    try {
      if (email.isEmpty || password.isEmpty) {
        return {
          'success': false,
          'message': 'Email dan password tidak boleh kosong',
        };
      }

      print('🔥 Authenticating with Firebase...');

      // Login dengan Firebase Auth
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email.toLowerCase().trim(),
        password: password,
      );

      print('✅ Auth successful: ${userCredential.user?.uid}');
      print('📥 Fetching user data from Firestore...');

      // Get user data dari Firestore dengan retry
      UserModel? user;
      int retryCount = 0;
      const maxRetries = 3;

      while (user == null && retryCount < maxRetries) {
        try {
          user = await _firestoreService.getUserById(userCredential.user!.uid);
          if (user != null) {
            print('✅ User data fetched on attempt ${retryCount + 1}');
            break;
          }
        } catch (e) {
          retryCount++;
          print('⚠️ Fetch attempt ${retryCount} failed: $e');
          if (retryCount < maxRetries) {
            await Future.delayed(Duration(seconds: retryCount));
          }
        }
      }

      if (user != null) {
        _currentUser = user;
        print('🎉 Login successful!');
        
        return {
          'success': true,
          'message': 'Login berhasil',
          'user': user,
        };
      } else {
        // Jika data tidak ditemukan di Firestore tapi Auth berhasil
        // Kemungkinan data belum sempat tersimpan saat register
        print('⚠️ User data not found in Firestore, creating now...');
        
        // Buat data user baru
        final newUser = UserModel(
          id: userCredential.user!.uid,
          fullName: userCredential.user!.displayName ?? 'User',
          email: userCredential.user!.email ?? email,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        
        await _firestoreService.createUser(newUser);
        _currentUser = newUser;
        
        return {
          'success': true,
          'message': 'Login berhasil',
          'user': newUser,
        };
      }
      
    } on FirebaseAuthException catch (e) {
      print('❌ FirebaseAuthException: ${e.code} - ${e.message}');
      
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'Email tidak terdaftar';
          break;
        case 'wrong-password':
          message = 'Password salah';
          break;
        case 'invalid-email':
          message = 'Format email tidak valid';
          break;
        case 'user-disabled':
          message = 'Akun telah dinonaktifkan';
          break;
        case 'too-many-requests':
          message = 'Terlalu banyak percobaan. Coba lagi nanti';
          break;
        case 'invalid-credential':
          message = 'Email atau password salah';
          break;
        case 'network-request-failed':
          message = 'Koneksi internet bermasalah. Periksa WiFi/data Anda';
          break;
        default:
          message = 'Email atau password salah';
      }
      
      return {
        'success': false,
        'message': message,
      };
      
    } catch (e) {
      print('❌ General error: $e');
      
      return {
        'success': false,
        'message': 'Terjadi kesalahan: ${e.toString()}',
      };
    }
  }

  // ==================== LOGOUT ====================
  
  Future<void> logout() async {
    try {
      await _auth.signOut();
      _currentUser = null;
    } catch (e) {
      print('Error logging out: $e');
    }
  }

  // ==================== UPDATE USER PROFILE ====================
  
  Future<bool> updateUserProfile(UserModel updatedUser) async {
    try {
      if (_currentUser == null) return false;

      final success = await _firestoreService.updateUser(
        _currentUser!.id,
        updatedUser,
      );

      if (success) {
        _currentUser = updatedUser;
        
        if (updatedUser.fullName != null) {
          await _auth.currentUser?.updateDisplayName(updatedUser.fullName);
        }
      }

      return success;
    } catch (e) {
      print('Error updating profile: $e');
      return false;
    }
  }

  // ==================== CHANGE PASSWORD ====================
  
  Future<Map<String, dynamic>> changePassword(
    String oldPassword,
    String newPassword,
  ) async {
    try {
      if (_currentUser == null || _auth.currentUser == null) {
        return {
          'success': false,
          'message': 'User tidak ditemukan',
        };
      }

      if (newPassword.length < 6) {
        return {
          'success': false,
          'message': 'Password baru minimal 6 karakter',
        };
      }

      final credential = EmailAuthProvider.credential(
        email: _currentUser!.email!,
        password: oldPassword,
      );

      await _auth.currentUser!.reauthenticateWithCredential(credential);
      await _auth.currentUser!.updatePassword(newPassword);

      return {
        'success': true,
        'message': 'Password berhasil diubah',
      };
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'wrong-password':
          message = 'Password lama salah';
          break;
        case 'weak-password':
          message = 'Password baru terlalu lemah';
          break;
        case 'requires-recent-login':
          message = 'Silakan login ulang untuk mengganti password';
          break;
        default:
          message = 'Gagal mengganti password: ${e.message}';
      }
      return {
        'success': false,
        'message': message,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Terjadi kesalahan: ${e.toString()}',
      };
    }
  }

  // ==================== RESET PASSWORD ====================
  
  Future<Map<String, dynamic>> resetPassword(String email) async {
    try {
      if (email.isEmpty) {
        return {
          'success': false,
          'message': 'Email tidak boleh kosong',
        };
      }

      await _auth.sendPasswordResetEmail(email: email.toLowerCase().trim());

      return {
        'success': true,
        'message': 'Link reset password telah dikirim ke email Anda',
      };
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'invalid-email':
          message = 'Format email tidak valid';
          break;
        case 'user-not-found':
          message = 'Email tidak terdaftar';
          break;
        default:
          message = 'Gagal mengirim email: ${e.message}';
      }
      return {
        'success': false,
        'message': message,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Terjadi kesalahan: ${e.toString()}',
      };
    }
  }

  // ==================== GET USER INFO ====================
  
  Map<String, dynamic> getUserInfo() {
    if (_currentUser != null) {
      return {
        'type': 'user',
        'id': _currentUser!.id,
        'name': _currentUser!.fullName,
        'email': _currentUser!.email,
        'age': _currentUser!.age,
        'gender': _currentUser!.gender,
      };
    }
    return {'type': 'guest'};
  }

  // ==================== VALIDATE SESSION ====================
  
  bool validateSession() {
    return _currentUser != null && _auth.currentUser != null;
  }

  // ==================== REFRESH USER DATA ====================
  
  Future<bool> refreshUserData() async {
    try {
      if (_auth.currentUser == null) return false;

      final user = await _firestoreService.getUserById(_auth.currentUser!.uid);
      if (user != null) {
        _currentUser = user;
        return true;
      }
      return false;
    } catch (e) {
      print('Error refreshing user data: $e');
      return false;
    }
  }

  // ==================== CHECK EMAIL REGISTERED ====================
  
  Future<bool> isEmailRegistered(String email) async {
    return await _firestoreService.isEmailExists(email);
  }

  // ==================== LISTEN TO AUTH STATE ====================
  
  Stream<User?> authStateChanges() {
    return _auth.authStateChanges();
  }

  Stream<UserModel?> userChanges() {
    if (_auth.currentUser == null) {
      return Stream.value(null);
    }
    return _firestoreService.listenToUser(_auth.currentUser!.uid);
  }
}