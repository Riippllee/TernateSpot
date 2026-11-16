import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:ternatespot/views/auth/daftar_page.dart';
import 'package:ternatespot/views/auth/forgot_password_page.dart';

import '../../controllers/auth_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _rememberMe = false;
  bool _obscurePassword = true;
  bool _isLoginLoading = false;
  bool _isGoogleLoading = false;

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final AuthController _authController = AuthController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ==========================================
  // MENAMPILKAN PESAN
  // ==========================================

  void _showMessage(String message, {bool isError = false}) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ==========================================
  // LOGIN EMAIL & PASSWORD
  // ==========================================

  Future<void> _handleLogin() async {
    if (_isLoginLoading || _isGoogleLoading) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty) {
      _showMessage('Email tidak boleh kosong', isError: true);
      return;
    }

    if (password.isEmpty) {
      _showMessage('Kata sandi tidak boleh kosong', isError: true);
      return;
    }

    setState(() {
      _isLoginLoading = true;
    });

    try {
      final response = await _authController.login(email, password);

      if (!mounted) return;

      if (response.user == null) {
        _showMessage('Login gagal. Silakan coba lagi.', isError: true);
        return;
      }

      _showMessage('Login berhasil');

      // Navigasi akan ditangani AuthWrapper
      // berdasarkan sesi dan role pengguna.
    } on AuthException catch (e) {
      _showMessage(e.message, isError: true);
    } catch (e) {
      _showMessage('Terjadi kesalahan saat login: $e', isError: true);
    } finally {
      if (mounted) {
        setState(() {
          _isLoginLoading = false;
        });
      }
    }
  }

  // ==========================================
  // LOGIN GOOGLE
  // ==========================================

  Future<void> _handleGoogleLogin() async {
    if (_isGoogleLoading || _isLoginLoading) return;

    setState(() {
      _isGoogleLoading = true;
    });

    try {
      await _authController.loginWithGoogle();

      // Pada Flutter Web, Supabase akan mengarahkan
      // browser ke halaman autentikasi Google.
    } on AuthException catch (e) {
      _showMessage('Google Login gagal: ${e.message}', isError: true);
    } catch (e) {
      _showMessage('Terjadi kesalahan Google Login: $e', isError: true);
    } finally {
      if (mounted) {
        setState(() {
          _isGoogleLoading = false;
        });
      }
    }
  }

  // ==========================================
  // NAVIGASI DAFTAR
  // ==========================================

  void _goToRegister({bool replace = false}) {
    final route = MaterialPageRoute<void>(builder: (_) => const DaftarPage());

    if (replace) {
      Navigator.pushReplacement(context, route);
    } else {
      Navigator.push(context, route);
    }
  }

  // ==========================================
  // NAVIGASI LUPA PASSWORD
  // ==========================================

  void _goToForgotPassword() {
    Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (_) => const ForgotPasswordPage()),
    );
  }

  // ==========================================
  // WIDGET LOGO
  // ==========================================

  Widget _buildLogo() {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.landscape_rounded,
            color: Color(0xFF0066FF),
            size: 28,
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'ternateSpot',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0066FF),
                ),
              ),
              Text(
                'WISATA KOTA TERNATE',
                style: TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==========================================
  // TAB MASUK & DAFTAR
  // ==========================================

  Widget _buildTabSwitcher() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFEBF2FF),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Text(
                'Masuk',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF0066FF),
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => _goToRegister(replace: true),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: const Text(
                  'Daftar Akun',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // INPUT EMAIL
  // ==========================================

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Email',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          style: const TextStyle(fontSize: 13),
          decoration: InputDecoration(
            hintText: 'nama@email.com',
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
            prefixIcon: const Icon(
              Icons.email_outlined,
              color: Colors.grey,
              size: 20,
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF0066FF)),
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================
  // INPUT PASSWORD
  // ==========================================

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Kata Sandi',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _handleLogin(),
          style: const TextStyle(fontSize: 13),
          decoration: InputDecoration(
            hintText: 'Minimal 8 karakter',
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
            prefixIcon: const Icon(
              Icons.lock_outline,
              color: Colors.grey,
              size: 20,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: Colors.grey,
                size: 20,
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF0066FF)),
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================
  // INGAT SAYA & LUPA PASSWORD
  // ==========================================

  Widget _buildRememberAndForgot() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SizedBox(
              height: 24,
              width: 24,
              child: Checkbox(
                value: _rememberMe,
                activeColor: const Color(0xFF0066FF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                onChanged: (value) {
                  setState(() {
                    _rememberMe = value ?? false;
                  });
                },
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'Ingat Saya',
              style: TextStyle(fontSize: 12, color: Colors.black87),
            ),
          ],
        ),
        InkWell(
          onTap: _goToForgotPassword,
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'Lupa Kata Sandi?',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF0066FF),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================
  // TOMBOL LOGIN
  // ==========================================

  Widget _buildLoginButton() {
    return ElevatedButton(
      onPressed: (_isLoginLoading || _isGoogleLoading) ? null : _handleLogin,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF0066FF),
        disabledBackgroundColor: const Color(0xFF8DB8FF),
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        elevation: 2,
      ),
      child: _isLoginLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'Masuk ke Akun',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward_rounded,
                  size: 18,
                  color: Colors.white,
                ),
              ],
            ),
    );
  }

  // ==========================================
  // PEMBATAS GOOGLE LOGIN
  // ==========================================

  Widget _buildDivider() {
    return Row(
      children: const [
        Expanded(child: Divider(color: Colors.grey, thickness: 0.2)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            'atau lanjutkan dengan',
            style: TextStyle(fontSize: 11, color: Colors.grey),
          ),
        ),
        Expanded(child: Divider(color: Colors.grey, thickness: 0.2)),
      ],
    );
  }

  // ==========================================
  // TOMBOL GOOGLE LOGIN
  // ==========================================

  Widget _buildGoogleButton() {
    return OutlinedButton(
      onPressed: (_isGoogleLoading || _isLoginLoading)
          ? null
          : _handleGoogleLogin,
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12),
        side: BorderSide(color: Colors.grey.shade300),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      ),
      child: _isGoogleLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('Asset/Image/Google.jpeg', height: 18, width: 18),
                const SizedBox(width: 8),
                const Text(
                  'Google',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
    );
  }

  // ==========================================
  // LINK DAFTAR
  // ==========================================

  Widget _buildRegisterLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Belum punya akun? ',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        TextButton(
          onPressed: () => _goToRegister(),
          child: const Text(
            'Daftar Sekarang',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF0066FF),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================
  // JELAJAH SEBAGAI TAMU
  // ==========================================

  Widget _buildGuestBadge() {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.explore_outlined, size: 16, color: Colors.grey),
            SizedBox(width: 6),
            Text(
              'Jelajah sebagai Tamu',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // BUILD
  // ==========================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 12),

              _buildLogo(),

              const SizedBox(height: 28),

              const Text(
                'Selamat Datang Kembali!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Masuk untuk menjelajahi keindahan surga\nrempah Kota Ternate',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.grey, height: 1.4),
              ),

              const SizedBox(height: 24),

              _buildTabSwitcher(),

              const SizedBox(height: 24),

              _buildEmailField(),

              const SizedBox(height: 16),

              _buildPasswordField(),

              const SizedBox(height: 10),

              _buildRememberAndForgot(),

              const SizedBox(height: 24),

              _buildLoginButton(),

              const SizedBox(height: 20),

              _buildDivider(),

              const SizedBox(height: 16),

              _buildGoogleButton(),

              const SizedBox(height: 20),

              _buildRegisterLink(),

              const SizedBox(height: 16),

              _buildGuestBadge(),
            ],
          ),
        ),
      ),
    );
  }
}
