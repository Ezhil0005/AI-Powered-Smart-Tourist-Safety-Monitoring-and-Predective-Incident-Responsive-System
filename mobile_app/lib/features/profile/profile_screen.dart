import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../shared/widgets/app_app_bar.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/app_card.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _notificationsEnabled = true;
  bool _locationEnabled = true;

  // Temporary profile data.
  // This will later come from the backend/database.
  String _name = 'Tourist User';
  final String _email = 'tourist@example.com';
  String _phone = '+91 98765 43210';

  // ============================================================
  // EDIT PROFILE
  // ============================================================

  void _editProfile() {
    final nameController = TextEditingController(
      text: _name,
    );

    final phoneController = TextEditingController(
      text: _phone,
    );

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppTheme.surface,
          title: const Text(
            'Edit Profile',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                ),
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: Icon(
                    Icons.person_outline,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                ),
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  prefixIcon: Icon(
                    Icons.phone_outlined,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final newName = nameController.text.trim();
                final newPhone = phoneController.text.trim();

                if (newName.isNotEmpty) {
                  setState(() {
                    _name = newName;

                    if (newPhone.isNotEmpty) {
                      _phone = newPhone;
                    }
                  });
                }

                Navigator.pop(dialogContext);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Profile updated successfully',
                    ),
                  ),
                );
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    ).then((_) {
      nameController.dispose();
      phoneController.dispose();
    });
  }

  // ============================================================
  // EMERGENCY CONTACTS
  // ============================================================

  void _showEmergencyContacts() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment:
                  CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Emergency Contacts',
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 20),
                _contactTile(
                  icon: Icons.person,
                  name: 'Emergency Contact',
                  phone: '+91 98765 12345',
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(sheetContext);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Add contact feature will be implemented later.',
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: const Text(
                    'Add Emergency Contact',
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _contactTile({
    required IconData icon,
    required String name,
    required String phone,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.background,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppTheme.primary.withValues(
                alpha: 0.15,
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: AppTheme.secondary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  phone,
                  style: const TextStyle(
                    color: AppTheme.textMuted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.call_outlined,
              color: AppTheme.secondary,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // LOGOUT
  // ============================================================

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppTheme.surface,
          title: const Text(
            'Sign Out?',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: const Text(
            'Are you sure you want to sign out?',
            style: TextStyle(
              color: AppTheme.textSecondary,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Logout functionality will be connected later.',
                    ),
                  ),
                );
              },
              child: const Text(
                'Sign Out',
                style: TextStyle(
                  color: AppTheme.sos,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: const AppAppBar(
        title: 'My Profile',
        showBackButton: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
            20,
            10,
            20,
            30,
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.stretch,
            children: [
              // PROFILE HEADER
              _buildProfileHeader(),

              const SizedBox(height: 24),

              // PERSONAL INFORMATION
              const Text(
                'Personal Information',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 12),

              AppCard(
                child: Column(
                  children: [
                    _infoRow(
                      icon: Icons.person_outline,
                      title: 'Full Name',
                      value: _name,
                    ),
                    const Divider(
                      color: Colors.white12,
                      height: 24,
                    ),
                    _infoRow(
                      icon: Icons.email_outlined,
                      title: 'Email',
                      value: _email,
                    ),
                    const Divider(
                      color: Colors.white12,
                      height: 24,
                    ),
                    _infoRow(
                      icon: Icons.phone_outlined,
                      title: 'Phone',
                      value: _phone,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              AppButton(
                text: 'Edit Profile',
                icon: Icons.edit_outlined,
                outlined: true,
                onPressed: _editProfile,
              ),

              const SizedBox(height: 28),

              // SAFETY
              const Text(
                'Safety',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 12),

              AppCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    _settingsTile(
                      icon:
                          Icons.contact_emergency_outlined,
                      title: 'Emergency Contacts',
                      subtitle:
                          'Manage people to contact during emergencies',
                      onTap: _showEmergencyContacts,
                    ),
                    const Divider(
                      color: Colors.white12,
                      height: 1,
                    ),
                    _settingsTile(
                      icon: Icons.location_on_outlined,
                      title: 'Location Services',
                      subtitle:
                          'Allow the app to access your location',
                      trailing: Switch(
                        value: _locationEnabled,
                        activeThumbColor:
                            AppTheme.secondary,
                        activeTrackColor:
                            AppTheme.secondary
                                .withValues(alpha: 0.3),
                        onChanged: (value) {
                          setState(() {
                            _locationEnabled = value;
                          });
                        },
                      ),
                    ),
                    const Divider(
                      color: Colors.white12,
                      height: 1,
                    ),
                    _settingsTile(
                      icon: Icons.notifications_outlined,
                      title: 'Notifications',
                      subtitle:
                          'Receive safety and emergency alerts',
                      trailing: Switch(
                        value: _notificationsEnabled,
                        activeThumbColor:
                            AppTheme.secondary,
                        activeTrackColor:
                            AppTheme.secondary
                                .withValues(alpha: 0.3),
                        onChanged: (value) {
                          setState(() {
                            _notificationsEnabled = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // ACCOUNT
              const Text(
                'Account',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 12),

              AppCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    _settingsTile(
                      icon: Icons.lock_outline,
                      title: 'Security',
                      subtitle:
                          'Manage password and account security',
                      onTap: () {
                        _showMessage(
                          'Security settings will be added later.',
                        );
                      },
                    ),
                    const Divider(
                      color: Colors.white12,
                      height: 1,
                    ),
                    _settingsTile(
                      icon: Icons.history,
                      title: 'Trip History',
                      subtitle:
                          'View your previous trips',
                      onTap: () {
                        _showMessage(
                          'Trip history will be added later.',
                        );
                      },
                    ),
                    const Divider(
                      color: Colors.white12,
                      height: 1,
                    ),
                    _settingsTile(
                      icon: Icons.help_outline,
                      title: 'Help & Support',
                      subtitle:
                          'Get help with the application',
                      onTap: () {
                        _showMessage(
                          'Help & support will be added later.',
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // SIGN OUT
              AppButton(
                text: 'Sign Out',
                icon: Icons.logout_rounded,
                outlined: true,
                color: AppTheme.sos,
                onPressed: _showLogoutDialog,
              ),

              const SizedBox(height: 22),

              // VERSION
              const Center(
                child: Text(
                  'Tourist Safety • Version 1.0.0',
                  style: TextStyle(
                    color: AppTheme.textMuted,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // PROFILE HEADER
  // ============================================================

  Widget _buildProfileHeader() {
    return AppCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
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
                    alpha: 0.25,
                  ),
                  blurRadius: 24,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: const Icon(
              Icons.person_rounded,
              color: Colors.white,
              size: 50,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            _name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            _email,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppTheme.textMuted,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: AppTheme.secondary.withValues(
                alpha: 0.1,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.verified_user_outlined,
                  color: AppTheme.secondary,
                  size: 15,
                ),
                SizedBox(width: 6),
                Text(
                  'Verified Tourist',
                  style: TextStyle(
                    color: AppTheme.secondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // INFORMATION ROW
  // ============================================================

  Widget _infoRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: AppTheme.primary.withValues(
              alpha: 0.12,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: AppTheme.secondary,
            size: 21,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppTheme.textMuted,
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================
  // SETTINGS TILE
  // ============================================================

  Widget _settingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
    Widget? trailing,
  }) {
    return ListTile(
      onTap: trailing == null ? onTap : null,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 7,
      ),
      leading: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: AppTheme.primary.withValues(
            alpha: 0.12,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: AppTheme.secondary,
          size: 21,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: AppTheme.textPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 3),
        child: Text(
          subtitle,
          style: const TextStyle(
            color: AppTheme.textMuted,
            fontSize: 11,
          ),
        ),
      ),
      trailing: trailing ??
          const Icon(
            Icons.chevron_right_rounded,
            color: AppTheme.textMuted,
          ),
    );
  }

  // ============================================================
  // MESSAGE
  // ============================================================

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}