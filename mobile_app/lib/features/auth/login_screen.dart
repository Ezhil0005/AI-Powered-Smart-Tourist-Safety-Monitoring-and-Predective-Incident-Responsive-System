import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../home/home_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController =
      TextEditingController();

  final TextEditingController _passwordController =
      TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ============================================================
  // LOGIN
  // ============================================================

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    await Future.delayed(
      const Duration(seconds: 1),
    );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const HomeScreen(),
      ),
    );
  }

  // ============================================================
  // REGISTER NAVIGATION
  // ============================================================

  void _openRegisterScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const RegisterScreen(),
      ),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,

      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 30,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        crossAxisAlignment:
                            CrossAxisAlignment.stretch,
                        children: [
                          // ==================================================
                          // LOGO
                          // ==================================================

                          _buildLogo(),

                          const SizedBox(height: 28),

                          // ==================================================
                          // TITLE
                          // ==================================================

                          const Text(
                            'Welcome Back',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppTheme.textPrimary,
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.3,
                            ),
                          ),

                          const SizedBox(height: 8),

                          Text(
                            'Sign in to continue your safe journey',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color:
                                  AppTheme.textSecondary
                                      .withValues(alpha: 0.8),
                              fontSize: 14,
                            ),
                          ),

                          const SizedBox(height: 34),

                          // ==================================================
                          // LOGIN CARD
                          // ==================================================

                          Container(
                            padding: const EdgeInsets.all(22),
                            decoration: BoxDecoration(
                              color: AppTheme.surface,
                              borderRadius:
                                  BorderRadius.circular(22),
                              border: Border.all(
                                color:
                                    AppTheme.primary
                                        .withValues(alpha: 0.15),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      AppTheme.primary
                                          .withValues(alpha: 0.08),
                                  blurRadius: 25,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.stretch,
                              children: [
                                // ==========================================
                                // EMAIL LABEL
                                // ==========================================

                                const Text(
                                  'Email',
                                  style: TextStyle(
                                    color:
                                        AppTheme.textSecondary,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),

                                const SizedBox(height: 8),

                                // ==========================================
                                // EMAIL FIELD
                                // ==========================================

                                TextFormField(
                                  controller:
                                      _emailController,
                                  keyboardType:
                                      TextInputType.emailAddress,
                                  textInputAction:
                                      TextInputAction.next,

                                  // IMPORTANT:
                                  // Black text so typed letters are visible.
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),

                                  cursorColor:
                                      AppTheme.primary,

                                  decoration:
                                      InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,

                                    hintText:
                                        'Enter your email',

                                    hintStyle:
                                        const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                    ),

                                    prefixIcon:
                                        const Icon(
                                      Icons.email_outlined,
                                      color: Colors.grey,
                                    ),

                                    border:
                                        OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(
                                        14,
                                      ),
                                      borderSide:
                                          const BorderSide(
                                        color: Colors.grey,
                                      ),
                                    ),

                                    enabledBorder:
                                        OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(
                                        14,
                                      ),
                                      borderSide:
                                          const BorderSide(
                                        color: Colors.grey,
                                      ),
                                    ),

                                    focusedBorder:
                                        OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(
                                        14,
                                      ),
                                      borderSide:
                                          const BorderSide(
                                        color: Colors.blue,
                                        width: 2,
                                      ),
                                    ),

                                    errorBorder:
                                        OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(
                                        14,
                                      ),
                                      borderSide:
                                          const BorderSide(
                                        color: Colors.red,
                                      ),
                                    ),

                                    focusedErrorBorder:
                                        OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(
                                        14,
                                      ),
                                      borderSide:
                                          const BorderSide(
                                        color: Colors.red,
                                        width: 2,
                                      ),
                                    ),
                                  ),

                                  validator: (value) {
                                    if (value == null ||
                                        value.trim().isEmpty) {
                                      return 'Please enter your email';
                                    }

                                    if (!value.contains('@')) {
                                      return 'Enter a valid email';
                                    }

                                    return null;
                                  },
                                ),

                                const SizedBox(height: 20),

                                // ==========================================
                                // PASSWORD LABEL
                                // ==========================================

                                const Text(
                                  'Password',
                                  style: TextStyle(
                                    color:
                                        AppTheme.textSecondary,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),

                                const SizedBox(height: 8),

                                // ==========================================
                                // PASSWORD FIELD
                                // ==========================================

                                TextFormField(
                                  controller:
                                      _passwordController,

                                  obscureText:
                                      _obscurePassword,

                                  textInputAction:
                                      TextInputAction.done,

                                  // IMPORTANT:
                                  // Black text so password characters
                                  // are visible when visibility is enabled.
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),

                                  cursorColor:
                                      AppTheme.primary,

                                  onFieldSubmitted: (_) {
                                    _login();
                                  },

                                  decoration:
                                      InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,

                                    hintText:
                                        'Enter your password',

                                    hintStyle:
                                        const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                    ),

                                    prefixIcon:
                                        const Icon(
                                      Icons.lock_outline,
                                      color: Colors.grey,
                                    ),

                                    suffixIcon:
                                        IconButton(
                                      icon: Icon(
                                        _obscurePassword
                                            ? Icons
                                                .visibility_off_outlined
                                            : Icons
                                                .visibility_outlined,
                                        color: Colors.grey,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _obscurePassword =
                                              !_obscurePassword;
                                        });
                                      },
                                    ),

                                    border:
                                        OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(
                                        14,
                                      ),
                                      borderSide:
                                          const BorderSide(
                                        color: Colors.grey,
                                      ),
                                    ),

                                    enabledBorder:
                                        OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(
                                        14,
                                      ),
                                      borderSide:
                                          const BorderSide(
                                        color: Colors.grey,
                                      ),
                                    ),

                                    focusedBorder:
                                        OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(
                                        14,
                                      ),
                                      borderSide:
                                          const BorderSide(
                                        color: Colors.blue,
                                        width: 2,
                                      ),
                                    ),

                                    errorBorder:
                                        OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(
                                        14,
                                      ),
                                      borderSide:
                                          const BorderSide(
                                        color: Colors.red,
                                      ),
                                    ),

                                    focusedErrorBorder:
                                        OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(
                                        14,
                                      ),
                                      borderSide:
                                          const BorderSide(
                                        color: Colors.red,
                                        width: 2,
                                      ),
                                    ),
                                  ),

                                  validator: (value) {
                                    if (value == null ||
                                        value.isEmpty) {
                                      return 'Please enter your password';
                                    }

                                    if (value.length < 6) {
                                      return 'Password must contain at least 6 characters';
                                    }

                                    return null;
                                  },
                                ),

                                const SizedBox(height: 10),

                                // ==========================================
                                // FORGOT PASSWORD
                                // ==========================================

                                Align(
                                  alignment:
                                      Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Password recovery will be added later.',
                                          ),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      'Forgot Password?',
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 10),

                                // ==========================================
                                // SIGN IN BUTTON
                                // ==========================================

                                SizedBox(
                                  height: 54,
                                  child: ElevatedButton(
                                    onPressed:
                                        _isLoading
                                            ? null
                                            : _login,
                                    child: _isLoading
                                        ? const SizedBox(
                                            width: 22,
                                            height: 22,
                                            child:
                                                CircularProgressIndicator(
                                              strokeWidth: 2.5,
                                              color:
                                                  Colors.white,
                                            ),
                                          )
                                        : const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment
                                                    .center,
                                            children: [
                                              Text(
                                                'Sign In',
                                              ),
                                              SizedBox(
                                                width: 8,
                                              ),
                                              Icon(
                                                Icons
                                                    .arrow_forward_rounded,
                                                size: 20,
                                              ),
                                            ],
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 26),

                          // ==================================================
                          // CREATE ACCOUNT
                          // ==================================================

                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have an account? ",
                                style: TextStyle(
                                  color: AppTheme.textMuted,
                                  fontSize: 13,
                                ),
                              ),
                              TextButton(
                                onPressed:
                                    _openRegisterScreen,
                                child: const Text(
                                  'Create Account',
                                  style: TextStyle(
                                    fontWeight:
                                        FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 18),

                          // ==================================================
                          // SECURITY MESSAGE
                          // ==================================================

                          _buildSafetyMessage(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ============================================================
  // LOGO
  // ============================================================

  Widget _buildLogo() {
    return Center(
      child: Container(
        width: 92,
        height: 92,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.primary,
              AppTheme.secondary,
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primary.withValues(
                alpha: 0.30,
              ),
              blurRadius: 28,
              spreadRadius: 4,
            ),
          ],
        ),
        child: Container(
          margin: const EdgeInsets.all(2),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppTheme.background,
          ),
          child: const Center(
            child: Icon(
              Icons.shield_rounded,
              color: AppTheme.secondary,
              size: 48,
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // SAFETY MESSAGE
  // ============================================================

  Widget _buildSafetyMessage() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 13,
      ),
      decoration: BoxDecoration(
        color: AppTheme.secondary.withValues(
          alpha: 0.07,
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppTheme.secondary.withValues(
            alpha: 0.12,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.verified_user_outlined,
            color: AppTheme.secondary,
            size: 19,
          ),
          const SizedBox(width: 9),
          Flexible(
            child: Text(
              'Your safety and privacy are our priority',
              textAlign: TextAlign.center,
              style: TextStyle(
                color:
                    AppTheme.textSecondary.withValues(
                  alpha: 0.85,
                ),
                fontSize: 11.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}