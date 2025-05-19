import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/theme_provider.dart';
import '../providers/user_provider.dart';
import 'profile_edit_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: AppTheme.getPrimaryGradient(isDarkMode),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile header
            Container(
              padding: const EdgeInsets.symmetric(vertical: 32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: AppTheme.getPrimaryGradient(isDarkMode),
                ),
              ),
              child: Center(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 60,
                            backgroundImage:
                                NetworkImage(userProvider.profileImageUrl),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors:
                                      AppTheme.getAccentGradient(isDarkMode),
                                ),
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      userProvider.username,
                      style:
                          Theme.of(context).textTheme.displayMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Admin Dinas Perhubungan',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Profile actions
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pengaturan Akun',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),

                  // Edit Profile
                  _buildProfileActionCard(
                    context,
                    icon: Icons.person,
                    title: 'Edit Profil',
                    subtitle: 'Ubah nama pengguna dan foto profil',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfileEditScreen(),
                        ),
                      );
                    },
                    isDarkMode: isDarkMode,
                  ),

                  const SizedBox(height: 16),

                  // Notification Settings
                  // _buildToggleCard(
                  //   context,
                  //   icon: Icons.notifications,
                  //   title: 'Notifikasi',
                  //   subtitle: 'Aktifkan atau nonaktifkan notifikasi',
                  //   value: userProvider.notificationsEnabled,
                  //   onChanged: (value) {
                  //     userProvider.setNotifications(value);
                  //   },
                  //   isDarkMode: isDarkMode,
                  // ),

                  // const SizedBox(height: 16),

                  // Dark Mode Toggle
                  _buildToggleCard(
                    context,
                    icon: isDarkMode ? Icons.dark_mode : Icons.light_mode,
                    title: isDarkMode ? 'Mode Gelap' : 'Mode Terang',
                    subtitle: 'Ubah tampilan aplikasi',
                    value: isDarkMode,
                    onChanged: (value) {
                      themeProvider.setDarkMode(value);
                    },
                    isDarkMode: isDarkMode,
                  ),

                  // const SizedBox(height: 24),

                  // Text(
                  //   'Lainnya',
                  //   style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  //         fontWeight: FontWeight.bold,
                  //       ),
                  // ),
                  // const SizedBox(height: 16),

                  // // Help & Support
                  // _buildProfileActionCard(
                  //   context,
                  //   icon: Icons.help_outline,
                  //   title: 'Bantuan & Dukungan',
                  //   subtitle: 'Pusat bantuan, FAQ, kontak',
                  //   onTap: () {},
                  //   isDarkMode: isDarkMode,
                  // ),

                  // const SizedBox(height: 16),

                  // // About
                  // _buildProfileActionCard(
                  //   context,
                  //   icon: Icons.info_outline,
                  //   title: 'Tentang Aplikasi',
                  //   subtitle: 'Versi, lisensi, kebijakan privasi',
                  //   onTap: () {},
                  //   isDarkMode: isDarkMode,
                  // ),

                  // const SizedBox(height: 16),

                  // // Logout
                  // _buildProfileActionCard(
                  //   context,
                  //   icon: Icons.logout,
                  //   title: 'Keluar',
                  //   subtitle: 'Keluar dari akun Anda',
                  //   onTap: () {
                  //     // Show logout confirmation dialog
                  //     showDialog(
                  //       context: context,
                  //       builder: (context) => AlertDialog(
                  //         title: const Text('Keluar'),
                  //         content:
                  //             const Text('Apakah Anda yakin ingin keluar?'),
                  //         actions: [
                  //           TextButton(
                  //             onPressed: () => Navigator.pop(context),
                  //             child: const Text('Batal'),
                  //           ),
                  //           ElevatedButton(
                  //             onPressed: () {
                  //               Navigator.pop(context);
                  //               // Navigate to login screen
                  //               Navigator.pushNamedAndRemoveUntil(
                  //                 context,
                  //                 '/',
                  //                 (route) => false,
                  //               );
                  //             },
                  //             style: ElevatedButton.styleFrom(
                  //               backgroundColor: Colors.red,
                  //             ),
                  //             child: const Text(
                  //               'Keluar',
                  //               style: TextStyle(color: Colors.white),
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     );
                  //   },
                  //   isDarkMode: isDarkMode,
                  //   isLogout: true,
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileActionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required bool isDarkMode,
    bool isLogout = false,
  }) {
    final Color iconColor = isLogout
        ? Colors.red
        : (isDarkMode ? AppTheme.primaryColorDark : AppTheme.primaryColor);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isLogout ? Colors.red : null,
                          ),
                    ),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).textTheme.bodySmall?.color,
                          ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Theme.of(context).textTheme.bodySmall?.color,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToggleCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required bool isDarkMode,
  }) {
    final Color iconColor =
        isDarkMode ? AppTheme.primaryColorDark : AppTheme.primaryColor;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).textTheme.bodySmall?.color,
                        ),
                  ),
                ],
              ),
            ),
            Switch(
              value: value,
              onChanged: onChanged,
              activeColor: iconColor,
            ),
          ],
        ),
      ),
    );
  }
}
