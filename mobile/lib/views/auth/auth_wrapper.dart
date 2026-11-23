import 'dart:async';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'splash_page.dart';
import 'login_page.dart';
import 'beranda_page.dart';
import 'reset_password_page.dart';

import '../../services/profile_service.dart';

//import '../admin/admin_shell.dart';

// ==========================================
// AUTH WRAPPER
// ==========================================

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  final SupabaseClient _supabase = Supabase.instance.client;

  StreamSubscription<AuthState>? _authSubscription;

  late Widget _destination;

  bool _isLoading = false;
  bool _isPasswordRecovery = false;

  String? _errorMessage;

  int _resolutionId = 0;

  @override
  void initState() {
    super.initState();

    // Halaman pertama ketika aplikasi dibuka.
    _destination = _buildSplashPage();

    // Dengarkan perubahan autentikasi Supabase.
    _authSubscription = _supabase.auth.onAuthStateChange.listen(
      _handleAuthState,
      onError: (Object error, StackTrace stackTrace) {
        debugPrint('Supabase Auth Error: $error');

        if (!mounted) return;

        setState(() {
          _isLoading = false;
          _errorMessage = 'Terjadi kesalahan autentikasi: $error';
        });
      },
    );

    // Jika sebelumnya sudah login, periksa sesi dan role.
    if (_supabase.auth.currentSession != null) {
      _isLoading = true;
      unawaited(_initializeAuth());
    }
  }

  // ========================================
  // SPLASH SCREEN
  // ========================================

  Widget _buildSplashPage() {
    return SplashPage(onStart: _openLogin);
  }

  // Tombol Mulai Jelajah menuju Login.
  void _openLogin() {
    if (!mounted) return;

    setState(() {
      _destination = const LoginPage();
      _isLoading = false;
      _errorMessage = null;
    });
  }

  // ========================================
  // INITIALIZE AUTH
  // ========================================

  Future<void> _initializeAuth() async {
    if (_supabase.auth.currentSession != null) {
      await _resolveDestination();
    }
  }

  // ========================================
  // AUTH STATE LISTENER
  // ========================================

  void _handleAuthState(AuthState state) {
    if (!mounted) return;

    debugPrint('AUTH EVENT: ${state.event}');
    debugPrint('SESSION ADA: ${state.session != null}');

    // Initial session sudah ditangani initState.
    if (state.event == AuthChangeEvent.initialSession) {
      return;
    }

    // Jika pengguna membuka link reset password.
    if (state.event == AuthChangeEvent.passwordRecovery) {
      _resolutionId++;

      setState(() {
        _isPasswordRecovery = true;
        _isLoading = false;
        _errorMessage = null;
      });

      return;
    }

    // Jika pengguna logout.
    if (state.event == AuthChangeEvent.signedOut) {
      _resolutionId++;

      setState(() {
        _isPasswordRecovery = false;
        _destination = const LoginPage();
        _isLoading = false;
        _errorMessage = null;
      });

      return;
    }

    // Pertahankan halaman reset password selama proses reset.
    if (_isPasswordRecovery) return;

    // Jika berhasil login.
    if (state.session != null) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      unawaited(_resolveDestination());
    }
  }

  // ========================================
  // MEMERIKSA PROFIL DAN ROLE
  // ========================================

  Future<void> _resolveDestination() async {
    final requestId = ++_resolutionId;

    try {
      // Pastikan profil pengguna tersedia.
      final profile = await ProfileService().ensureUserProfile();

      if (!mounted || requestId != _resolutionId) return;

      if (profile == null) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Profil pengguna tidak ditemukan atau gagal dimuat.';
        });

        return;
      }

      // Periksa status akun.
      if (profile['status'] == false) {
        setState(() {
          _isLoading = false;
          _errorMessage =
              'Akun Anda sedang tidak aktif. Silakan hubungi Admin.';
        });

        return;
      }

      // Ambil role dari tabel user Supabase.
      final String role = (profile['role'] ?? '')
          .toString()
          .trim()
          .toLowerCase();

      Widget destination;

      if (role == 'user') {
        // Pengguna biasa menuju beranda.
        destination = const BerandaPage();
      } else if (role == 'admin') {
        //destination = const AdminShell();
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Role pengguna tidak dikenali: $role';
        });

        return;
      }

      if (!mounted || requestId != _resolutionId) return;

      setState(() {
       /// _destination = destination;
        _isLoading = false;
        _errorMessage = null;
      });

      debugPrint('ROLE USER: $role');
      debugPrint('Navigasi berhasil ditentukan.');
    } catch (e) {
      debugPrint('Error memuat profil: $e');

      if (!mounted || requestId != _resolutionId) return;

      setState(() {
        _isLoading = false;
        _errorMessage = 'Gagal memuat data pengguna: $e';
      });
    }
  }

  // ========================================
  // COBA MEMUAT ULANG PROFIL
  // ========================================

  Future<void> _retryLoad() async {
    if (_supabase.auth.currentSession == null) {
      _openLogin();
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    await _resolveDestination();
  }

  // ========================================
  // LOGOUT
  // ========================================

  Future<void> _logout() async {
    try {
      await _supabase.auth.signOut();
    } catch (e) {
      debugPrint('Error logout: $e');
    }
  }

  // ========================================
  // LOADING PAGE
  // ========================================

  Widget _buildLoadingPage() {
    return const Scaffold(
      backgroundColor: Color(0xFFF8FAFC),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Color(0xFF0066FF)),
            SizedBox(height: 20),
            Text(
              'Memuat TernateSpot...',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  // ========================================
  // ERROR PAGE
  // ========================================

  Widget _buildErrorPage() {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 60),
              const SizedBox(height: 20),
              const Text(
                'Terjadi Kesalahan',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                _errorMessage ?? 'Terjadi kesalahan.',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 25),
              ElevatedButton(
                onPressed: _retryLoad,
                child: const Text('Coba Lagi'),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: _logout,
                child: const Text('Kembali ke Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ========================================
  // BUILD
  // ========================================

  @override
  Widget build(BuildContext context) {
    if (_isPasswordRecovery) {
      return const ResetPasswordPage();
    }

    if (_isLoading) {
      return _buildLoadingPage();
    }

    if (_errorMessage != null) {
      return _buildErrorPage();
    }

    return _destination;
  }

  // ========================================
  // DISPOSE
  // ========================================

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}
