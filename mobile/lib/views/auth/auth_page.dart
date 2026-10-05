import 'package:flutter/material.dart';


class AuthPage extends StatefulWidget {
  final bool isLoginInitial;
  const AuthPage({super.key, this.isLoginInitial = true});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  late bool _isLogin;
  bool _rememberMe = false;
  bool _agreeTerms = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // Controller Masuk
  final TextEditingController _loginEmailController = TextEditingController();
  final TextEditingController _loginPasswordController = TextEditingController();

  // Controller Daftar
  final TextEditingController _registerNameController = TextEditingController();
  final TextEditingController _registerEmailController = TextEditingController();
  final TextEditingController _registerPasswordController = TextEditingController();
  final TextEditingController _registerConfirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _isLogin = widget.isLoginInitial;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 12),

              // 1. Logo TernateSpot
              Center(
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
              ),

              const SizedBox(height: 24),

              // 2. Judul & Subjudul Dinamis
              Text(
                _isLogin ? 'Selamat Datang Kembali!' : 'Buat Akun Baru',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _isLogin
                    ? 'Masuk untuk menjelajahi keindahan surga\nrempah Kota Ternate'
                    : 'Daftar untuk mulai menjelajahi pesona\nrempah Kota Ternate',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 24),

              // 3. Tab Switcher (Masuk / Daftar Akun)
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFEBF2FF),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _isLogin = true;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: _isLogin ? Colors.white : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: _isLogin
                                ? [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : [],
                          ),
                          child: Text(
                            'Masuk',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: _isLogin ? const Color(0xFF0066FF) : Colors.grey,
                              fontWeight: _isLogin ? FontWeight.bold : FontWeight.w500,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _isLogin = false;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: !_isLogin ? Colors.white : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: !_isLogin
                                ? [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : [],
                          ),
                          child: Text(
                            'Daftar Akun',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: !_isLogin ? const Color(0xFF0066FF) : Colors.grey,
                              fontWeight: !_isLogin ? FontWeight.bold : FontWeight.w500,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Form Masuk atau Form Daftar
              if (_isLogin) ...[
                _buildLoginForm(),
              ] else ...[
                _buildRegisterForm(),
              ],

              const SizedBox(height: 20),

              // Pembatas / Divider
              Row(
                children: [
                  const Expanded(child: Divider(color: Colors.grey, thickness: 0.2)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      _isLogin ? 'atau lanjutkan dengan' : 'atau daftar dengan',
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ),
                  const Expanded(child: Divider(color: Colors.grey, thickness: 0.2)),
                ],
              ),

              const SizedBox(height: 16),

              // Tombol Google
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  side: BorderSide(color: Colors.grey.shade300),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(
                      'https://upload.wikimedia.org/wikipedia/commons/5/53/Google_%22G%22_Logo.svg',
                      height: 18,
                      width: 18,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.g_mobiledata,
                        color: Colors.red,
                        size: 24,
                      ),
                    ),
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
              ),

              const SizedBox(height: 20),

              // Switcher teks bawah
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _isLogin ? 'Belum punya akun? ' : 'Sudah punya akun? ',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isLogin = !_isLogin;
                      });
                    },
                    child: Text(
                      _isLogin ? 'Daftar Sekarang' : 'Masuk Sekarang',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF0066FF),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Jelajah sebagai Tamu
              Center(
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  // WIDGET FORM MASUK
  Widget _buildLoginForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Email atau No. Handphone',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: _loginEmailController,
          style: const TextStyle(fontSize: 13),
          decoration: _inputDecoration(
            hintText: 'nama@email.com atau 0812...',
            prefixIcon: Icons.email_outlined,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Kata Sandi',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: _loginPasswordController,
          obscureText: _obscurePassword,
          style: const TextStyle(fontSize: 13),
          decoration: _inputDecoration(
            hintText: 'Minimal 8 karakter',
            prefixIcon: Icons.lock_outline,
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                color: Colors.grey,
                size: 20,
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
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
                    onChanged: (val) {
                      setState(() {
                        _rememberMe = val ?? false;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
                const Text('Ingat Saya', style: TextStyle(fontSize: 12)),
              ],
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ForgotPasswordPage()),
                );
              },
              child: const Text(
                'Lupa Kata Sandi?',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF0066FF),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () {},
          style: _buttonStyle(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text('Masuk ke Akun', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
              SizedBox(width: 8),
              Icon(Icons.arrow_forward_rounded, size: 18, color: Colors.white),
            ],
          ),
        ),
      ],
    );
  }

  // WIDGET FORM DAFTAR
  Widget _buildRegisterForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('Nama Lengkap', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        TextField(
          controller: _registerNameController,
          style: const TextStyle(fontSize: 13),
          decoration: _inputDecoration(
            hintText: 'Masukkan nama lengkap anda',
            prefixIcon: Icons.person_outline,
          ),
        ),
        const SizedBox(height: 16),
        const Text('Email atau No. Handphone', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        TextField(
          controller: _registerEmailController,
          style: const TextStyle(fontSize: 13),
          decoration: _inputDecoration(
            hintText: 'nama@email.com atau 0812...',
            prefixIcon: Icons.email_outlined,
          ),
        ),
        const SizedBox(height: 16),
        const Text('Kata Sandi', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        TextField(
          controller: _registerPasswordController,
          obscureText: _obscurePassword,
          style: const TextStyle(fontSize: 13),
          decoration: _inputDecoration(
            hintText: 'Minimal 8 karakter',
            prefixIcon: Icons.lock_outline,
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                color: Colors.grey,
                size: 20,
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text('Konfirmasi Kata Sandi', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        TextField(
          controller: _registerConfirmPasswordController,
          obscureText: _obscureConfirmPassword,
          style: const TextStyle(fontSize: 13),
          decoration: _inputDecoration(
            hintText: 'Ulangi kata sandi',
            prefixIcon: Icons.verified_user_outlined,
            suffixIcon: IconButton(
              icon: Icon(
                _obscureConfirmPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                color: Colors.grey,
                size: 20,
              ),
              onPressed: () {
                setState(() {
                  _obscureConfirmPassword = !_obscureConfirmPassword;
                });
              },
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 24,
              width: 24,
              child: Checkbox(
                value: _agreeTerms,
                activeColor: const Color(0xFF0066FF),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                onChanged: (val) {
                  setState(() {
                    _agreeTerms = val ?? false;
                  });
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: RichText(
                text: const TextSpan(
                  style: TextStyle(fontSize: 11, color: Colors.grey, height: 1.3),
                  children: [
                    TextSpan(text: 'Saya menyetujui '),
                    TextSpan(text: 'Syarat & Ketentuan', style: TextStyle(color: Color(0xFF0066FF), fontWeight: FontWeight.bold)),
                    TextSpan(text: ' serta '),
                    TextSpan(text: 'Kebijakan Privasi', style: TextStyle(color: Color(0xFF0066FF), fontWeight: FontWeight.bold)),
                    TextSpan(text: ' ternateSpot.'),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {},
          style: _buttonStyle(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text('Daftar Sekarang', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
              SizedBox(width: 8),
              Icon(Icons.arrow_forward_rounded, size: 18, color: Colors.white),
            ],
          ),
        ),
      ],
    );
  }

  // HELPER DEKORASI INPUT
  InputDecoration _inputDecoration({required String hintText, required IconData prefixIcon, Widget? suffixIcon}) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
      prefixIcon: Icon(prefixIcon, color: Colors.grey, size: 20),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: Colors.grey.shade50,
      contentPadding: const EdgeInsets.symmetric(vertical: 14),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
    );
  }

  // HELPER STYLE TOMBOL
  ButtonStyle _buttonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF0066FF),
      padding: const EdgeInsets.symmetric(vertical: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      elevation: 2,
    );
  }
}