import 'dart:async';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ternatespot/views/auth/login_page.dart';
import 'package:ternatespot/views/auth/reset_password_page.dart';
import 'package:ternatespot/views/test/test_profile_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://ciarqtbkgdmupfiuuvab.supabase.co',
    publishableKey: 'sb_publishable_xh9OxC4GQLHuhv46L8MjQQ_5TeP1IG_',
  );

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TernateSpot',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  final _supabase = Supabase.instance.client;

  StreamSubscription<AuthState>? _authSubscription;

  bool _isPasswordRecovery = false;

  @override
  void initState() {
    super.initState();

    _authSubscription = _supabase.auth.onAuthStateChange.listen(
      (data) {
        print('========== SUPABASE AUTH ==========');
        print('EVENT: ${data.event}');
        print('SESSION ADA: ${data.session != null}');
        print('USER: ${data.session?.user.email}');
        print('===================================');

        if (!mounted) return;

        if (data.event == AuthChangeEvent.passwordRecovery) {
          print('BERHASIL: PASSWORD RECOVERY');

          setState(() {
            _isPasswordRecovery = true;
          });
        } else if (data.event == AuthChangeEvent.signedOut) {
          setState(() {
            _isPasswordRecovery = false;
          });
        } else {
          setState(() {});
        }
      },
      onError: (Object error, StackTrace stackTrace) {
        print('SUPABASE AUTH ERROR: $error');
        print(stackTrace);
      },
    );
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isPasswordRecovery) {
      return const ResetPasswordPage();
    }

    final session = _supabase.auth.currentSession;

    if (session != null) {
      return const TestProfilePage();
    }

    return const LoginPage();
  }
}
