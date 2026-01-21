
import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../utils/extensions.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _ageController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String _selectedGender = 'Laki-laki';
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _ageController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    // Validate form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Check password match
    if (_passwordController.text != _confirmPasswordController.text) {
      _showSnackBar('Password tidak cocok', isError: true);
      return;
    }

    // Set loading state
    setState(() => _isLoading = true);

    try {
      final name = _nameController.text.trim();
      final email = _emailController.text.trim().toLowerCase();
      final ageText = _ageController.text.trim();
      final password = _passwordController.text;

      final age = int.tryParse(ageText);
      if (age == null) {
        throw Exception('Umur tidak valid');
      }

      print('📝 Starting registration...');
      print('Email: $email');
      print('Name: $name');

      // Call register
      final result = await AuthService().registerUser(
        email: email,
        password: password,
        fullName: name,
        age: age,
        gender: _selectedGender,
      );

      print('📦 Result: $result');

      // Stop loading
      if (mounted) {
        setState(() => _isLoading = false);
      }

      // Show result
      if (mounted) {
        _showSnackBar(
          result['message'] ?? 'Unknown error',
          isError: result['success'] != true,
        );
      }

      // Navigate if success
      if (result['success'] == true) {
        print('✅ Registration successful');
        await Future.delayed(const Duration(milliseconds: 800));
        if (mounted) {
          Navigator.pop(context);
        }
      }

    } catch (e) {
      print('💥 Exception: $e');
      
      if (mounted) {
        setState(() => _isLoading = false);
        _showSnackBar('Error: ${e.toString()}', isError: true);
      }
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        duration: Duration(seconds: isError ? 4 : 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color(0xFF4C9EEB),
              Color(0xFF2196F3),
              Color(0xFF1976D2),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // App Bar
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: _isLoading ? null : () => Navigator.pop(context),
                    ),
                    const Text(
                      'Daftar Akun',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(30),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Buat Akun Baru',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2C3E50),
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'Bergabung dengan MediSense sekarang!',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF7F8C8D),
                                ),
                              ),
                              const SizedBox(height: 30),

                              // Nama Lengkap
                              _buildTextField(
                                controller: _nameController,
                                label: 'Nama Lengkap',
                                icon: Icons.person_outline,
                                enabled: !_isLoading,
                                validator: (value) {
                                  if (value?.isEmpty ?? true) {
                                    return 'Nama tidak boleh kosong';
                                  }
                                  if (value!.length < 3) {
                                    return 'Nama minimal 3 karakter';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),

                              // Email
                              _buildTextField(
                                controller: _emailController,
                                label: 'Email',
                                icon: Icons.email_outlined,
                                keyboardType: TextInputType.emailAddress,
                                enabled: !_isLoading,
                                validator: (value) {
                                  if (value?.isEmpty ?? true) {
                                    return 'Email tidak boleh kosong';
                                  }
                                  if (!value!.isValidEmail()) {
                                    return 'Format email tidak valid';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),

                              // Row untuk Umur dan Jenis Kelamin (FIXED OVERFLOW)
                              Row(
                                children: [
                                  // Umur
                                  Expanded(
                                    flex: 2,
                                    child: _buildTextField(
                                      controller: _ageController,
                                      label: 'Umur',
                                      icon: Icons.cake_outlined,
                                      keyboardType: TextInputType.number,
                                      enabled: !_isLoading,
                                      validator: (value) {
                                        if (value?.isEmpty ?? true) {
                                          return 'Wajib';
                                        }
                                        final age = int.tryParse(value!);
                                        if (age == null || age < 10 || age > 100) {
                                          return '10-100';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                  
                                  // Jenis Kelamin (FIXED)
                                  Expanded(
                                    flex: 3,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12),
                                      decoration: BoxDecoration(
                                        color: _isLoading 
                                            ? Colors.grey[200]
                                            : const Color(0xFFF5F7FA),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                          value: _selectedGender,
                                          isExpanded: true,
                                          icon: const Icon(
                                            Icons.arrow_drop_down,
                                            color: Color(0xFF4C9EEB),
                                          ),
                                          style: const TextStyle(
                                            color: Color(0xFF2C3E50),
                                            fontSize: 14,
                                          ),
                                          items: ['Laki-laki', 'Perempuan']
                                              .map((String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    value == 'Laki-laki'
                                                        ? Icons.male
                                                        : Icons.female,
                                                    color: const Color(0xFF4C9EEB),
                                                    size: 20,
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Text(value),
                                                ],
                                              ),
                                            );
                                          }).toList(),
                                          onChanged: _isLoading
                                              ? null
                                              : (value) {
                                                  setState(() {
                                                    _selectedGender = value!;
                                                  });
                                                },
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),

                              // Password
                              _buildTextField(
                                controller: _passwordController,
                                label: 'Password',
                                icon: Icons.lock_outline,
                                obscureText: !_isPasswordVisible,
                                enabled: !_isLoading,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isPasswordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: const Color(0xFF4C9EEB),
                                  ),
                                  onPressed: _isLoading
                                      ? null
                                      : () => setState(() =>
                                          _isPasswordVisible = !_isPasswordVisible),
                                ),
                                validator: (value) {
                                  if (value?.isEmpty ?? true) {
                                    return 'Password tidak boleh kosong';
                                  }
                                  if (value!.length < 6) {
                                    return 'Password minimal 6 karakter';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),

                              // Konfirmasi Password
                              _buildTextField(
                                controller: _confirmPasswordController,
                                label: 'Konfirmasi Password',
                                icon: Icons.lock_outline,
                                obscureText: !_isConfirmPasswordVisible,
                                enabled: !_isLoading,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isConfirmPasswordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: const Color(0xFF4C9EEB),
                                  ),
                                  onPressed: _isLoading
                                      ? null
                                      : () => setState(() =>
                                          _isConfirmPasswordVisible =
                                              !_isConfirmPasswordVisible),
                                ),
                                validator: (value) {
                                  if (value?.isEmpty ?? true) {
                                    return 'Konfirmasi password wajib';
                                  }
                                  if (value != _passwordController.text) {
                                    return 'Password tidak cocok';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 30),

                              // Tombol Daftar
                              SizedBox(
                                width: double.infinity,
                                height: 55,
                                child: ElevatedButton(
                                  onPressed: _isLoading ? null : _register,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF4C9EEB),
                                    disabledBackgroundColor: Colors.grey[400],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    elevation: 5,
                                  ),
                                  child: _isLoading
                                      ? const Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              height: 20,
                                              width: 20,
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 2,
                                              ),
                                            ),
                                            SizedBox(width: 15),
                                            Text(
                                              'Mendaftar...',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        )
                                      : const Text(
                                          'Daftar Sekarang',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Link ke Login
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Sudah punya akun? ',
                                    style: TextStyle(
                                      color: Color(0xFF7F8C8D),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: _isLoading
                                        ? null
                                        : () => Navigator.pop(context),
                                    child: Text(
                                      'Masuk',
                                      style: TextStyle(
                                        color: _isLoading
                                            ? Colors.grey
                                            : const Color(0xFF4C9EEB),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscureText = false,
    bool enabled = true,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      enabled: enabled,
      style: TextStyle(
        color: enabled ? Colors.black : Colors.grey,
      ),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF4C9EEB).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: enabled ? const Color(0xFF4C9EEB) : Colors.grey,
          ),
        ),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: enabled ? const Color(0xFFF5F7FA) : Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xFF4C9EEB), width: 2),
        ),
      ),
      validator: validator,
    );
  }
}