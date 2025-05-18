import 'package:flutter/material.dart';
import 'package:movelytics_app/providers/firebase_auth_provider.dart';
import 'package:movelytics_app/services/firebase_auth_service.dart';
import 'package:movelytics_app/static/firebase_auth_status.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_button.dart';
import 'main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<FirebaseAuthProvider>(context);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: AppTheme.primaryGradient,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo and App Name
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.map_outlined,
                      size: 80,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Visualisasi Kepadatan\nPenumpang',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Provinsi Jawa Timur',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                  const SizedBox(height: 60),

                  // Login Card
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    elevation: 10,
                    shadowColor: Colors.black.withOpacity(0.3),
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        children: [
                          Text(
                            'Selamat Datang',
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Silakan login untuk melanjutkan',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: AppTheme.secondaryTextColor,
                                ),
                          ),
                          const SizedBox(height: 40),

                          // // Google Login Button
                          // Consumer<FirebaseAuthProvider>(
                          //   builder: (context, authProvider, _) {
                          //     if (authProvider.message != null &&
                          //         authProvider.authStatus ==
                          //             FirebaseAuthStatus.error) {
                          //       return Padding(
                          //         padding: const EdgeInsets.only(bottom: 16.0),
                          //         child: Text(
                          //           authProvider.message!,
                          //           style: TextStyle(color: Colors.red),
                          //           textAlign: TextAlign.center,
                          //         ),
                          //       );
                          //     }
                          //     return const SizedBox.shrink();
                          //   },
                          // ),

                          // Google Login Button
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: Consumer<FirebaseAuthProvider>(
                              builder: (context, authProvider, _) {
                                return switch (authProvider.authStatus) {
                                  FirebaseAuthStatus.loggingIn => CustomButton(
                                      onPressed: () {},
                                      text: 'Logging in...',
                                      icon: SizedBox(
                                        height: 24,
                                        width: 24,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  AppTheme.primaryColor),
                                        ),
                                      ),
                                      backgroundColor: Colors.white,
                                      textColor: AppTheme.textColor,
                                      borderColor: AppTheme.dividerColor,
                                      height: 56,
                                    ),
                                  _ => CustomButton(
                                      onPressed: () async {
                                        try {
                                          await authProvider.loginWithGoogle();

                                          if (authProvider.authStatus ==
                                              FirebaseAuthStatus.loggedIn) {
                                            Navigator.of(context)
                                                .pushReplacement(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const MainScreen(),
                                              ),
                                            );
                                          }
                                        } catch (e) {
                                          // Error handling is done in the provider
                                        }
                                      },
                                      text: 'Login dengan Google',
                                      icon: Image.asset(
                                        'assets/google_logo.png',
                                        height: 24,
                                        width: 24,
                                      ),
                                      backgroundColor: Colors.white,
                                      textColor: AppTheme.textColor,
                                      borderColor: AppTheme.dividerColor,
                                      height: 56,
                                    ),
                                };
                              },
                            ),
                          ),

                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),
                  Text(
                    '© 2024 Dinas Perhubungan Jawa Timur',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white.withOpacity(0.7),
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
