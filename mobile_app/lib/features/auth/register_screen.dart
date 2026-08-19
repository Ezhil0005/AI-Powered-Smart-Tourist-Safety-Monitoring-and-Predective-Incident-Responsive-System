import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/app_card.dart';
import '../../shared/widgets/app_text_field.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _createAccount() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Temporary registration simulation.
    // Backend authentication will be connected later.
    await Future.delayed(
      const Duration(seconds: 1),
    );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Account created successfully!',
        ),
      ),
    );

    await Future.delayed(
      const Duration(milliseconds: 700),
    );

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
    );
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your full name';
    }

    if (value.trim().length < 3) {
      return 'Name must contain at least 3 characters';
    }

    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your email';
    }

    final emailRegex = RegExp(
      r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
    );

    if (!emailRegex.hasMatch(value.trim())) {
      return 'Enter a valid email address';
    }

    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your phone number';
    }

    final phoneRegex = RegExp(r'^[0-9]{10}$');

    if (!phoneRegex.hasMatch(value.trim())) {
      return 'Enter a valid 10-digit phone number';
    }

    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }

    if (value.length < 6) {
      return 'Password must contain at least 6 characters';
    }

    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }

    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        foregroundColor: AppTheme.textPrimary,
        elevation: 0,
        title: const Text(
          'Create Account',
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(
                24,
                10,
                24,
                30,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 40,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.stretch,
                    children: [
                      // ==================================================
                      // HEADER
                      // ==================================================

                      _buildHeader(),

                      const SizedBox(height: 28),

                      // ==================================================
                      // FORM CARD
                      // ==================================================

                      AppCard(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.stretch,
                          children: [
                            const Text(
                              'Personal Information',
                              style: TextStyle(
                                color:
                                    AppTheme.textPrimary,
                                fontSize: 18,
                                fontWeight:
                                    FontWeight.w700,
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Full Name
                            AppTextField(
                              label: 'Full Name',
                              hint: 'Enter your full name',
                              prefixIcon:
                                  Icons.person_outline,
                              controller:
                                  _nameController,
                              textInputAction:
                                  TextInputAction.next,
                              validator: _validateName,
                            ),

                            const SizedBox(height: 18),

                            // Email
                            AppTextField(
                              label: 'Email',
                              hint: 'Enter your email',
                              prefixIcon:
                                  Icons.email_outlined,
                              controller:
                                  _emailController,
                              keyboardType:
                                  TextInputType.emailAddress,
                              textInputAction:
                                  TextInputAction.next,
                              validator: _validateEmail,
                            ),

                            const SizedBox(height: 18),

                            // Phone
                            AppTextField(
                              label: 'Phone Number',
                              hint: 'Enter 10-digit number',
                              prefixIcon:
                                  Icons.phone_outlined,
                              controller:
                                  _phoneController,
                              keyboardType:
                                  TextInputType.phone,
                              textInputAction:
                                  TextInputAction.next,
                              validator: _validatePhone,
                            ),

                            const SizedBox(height: 18),

                            // Password
                            AppTextField(
                              label: 'Password',
                              hint: 'Create a password',
                              prefixIcon:
                                  Icons.lock_outline,
                              controller:
                                  _passwordController,
                              obscureText:
                                  _obscurePassword,
                              textInputAction:
                                  TextInputAction.next,
                              validator:
                                  _validatePassword,
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword =
                                        !_obscurePassword;
                                  });
                                },
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons
                                          .visibility_off_outlined
                                      : Icons
                                          .visibility_outlined,
                                ),
                              ),
                            ),

                            const SizedBox(height: 18),

                            // Confirm Password
                            AppTextField(
                              label: 'Confirm Password',
                              hint: 'Re-enter your password',
                              prefixIcon:
                                  Icons.lock_reset_outlined,
                              controller:
                                  _confirmPasswordController,
                              obscureText:
                                  _obscureConfirmPassword,
                              textInputAction:
                                  TextInputAction.done,
                              validator:
                                  _validateConfirmPassword,
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _obscureConfirmPassword =
                                        !_obscureConfirmPassword;
                                  });
                                },
                                icon: Icon(
                                  _obscureConfirmPassword
                                      ? Icons
                                          .visibility_off_outlined
                                      : Icons
                                          .visibility_outlined,
                                ),
                              ),
                            ),

                            const SizedBox(height: 26),

                            // Create Account
                            AppButton(
                              text: 'Create Account',
                              icon: Icons
                                  .arrow_forward_rounded,
                              loading: _isLoading,
                              onPressed:
                                  _createAccount,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // ==================================================
                      // LOGIN LINK
                      // ==================================================

                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Already have an account?',
                            style: TextStyle(
                              color: AppTheme.textMuted,
                              fontSize: 13,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const LoginScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              'Sign In',
                              style: TextStyle(
                                fontWeight:
                                    FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // ==================================================
                      // PRIVACY MESSAGE
                      // ==================================================

                      _buildPrivacyMessage(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ==============================================================
  // HEADER
  // ==============================================================

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 76,
          height: 76,
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
                  alpha: 0.25,
                ),
                blurRadius: 24,
                spreadRadius: 3,
              ),
            ],
          ),
          child: const Icon(
            Icons.person_add_alt_1_rounded,
            color: Colors.white,
            size: 38,
          ),
        ),

        const SizedBox(height: 18),

        const Text(
          'Join Tourist Safety',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 25,
            fontWeight: FontWeight.w800,
          ),
        ),

        const SizedBox(height: 7),

        Text(
          'Create your account and travel with confidence',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppTheme.textSecondary.withValues(
              alpha: 0.8,
            ),
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  // ==============================================================
  // PRIVACY MESSAGE
  // ==============================================================

  Widget _buildPrivacyMessage() {
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
        children: [
          const Icon(
            Icons.verified_user_outlined,
            color: AppTheme.secondary,
            size: 19,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Your information is kept secure and private.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.textSecondary.withValues(
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