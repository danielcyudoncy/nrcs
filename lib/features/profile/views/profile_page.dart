// features/profile/views/profile_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/auth/token_provider.dart';
import '../../../core/theme/app_theme.dart' hide AppColors;
import '../../../core/utils/constants/app_colors.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Profile',
          style: AppTheme.headingSmall?.copyWith(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () => _showEditProfileDialog(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Avatar
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [AppColors.primaryColor, AppColors.secondaryColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryColor.withAlpha(
                      (0.3 * 255).round(),
                    ),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 58,
                backgroundColor: Colors.transparent,
                child: Text(
                  TokenProvider.username?.substring(0, 1).toUpperCase() ?? 'U',
                  style: AppTheme.headingLarge?.copyWith(
                    color: Colors.white,
                    fontSize: 48,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // User Info Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.backgroundCard,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withAlpha((0.1 * 255).round()),
                ),
              ),
              child: Column(
                children: [
                  _buildInfoRow('Full Name', 'John Doe'), // Mock data
                  const SizedBox(height: 16),
                  _buildInfoRow('Email', TokenProvider.username ?? 'N/A'),
                  const SizedBox(height: 16),
                  _buildInfoRow(
                    'Role',
                    TokenProvider.currentRole?.name.toUpperCase() ?? 'N/A',
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow('Member Since', 'January 2024'), // Mock data
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Permissions Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.backgroundCard,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withAlpha((0.1 * 255).round()),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Permissions',
                    style: AppTheme.headingSmall?.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  ...TokenProvider.roles.map(
                    (role) => _buildPermissionChip(role),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showChangePasswordDialog(context),
                    icon: const Icon(Icons.lock),
                    label: const Text('Change Password'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.saveColor,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _showLogoutDialog(context),
                    icon: const Icon(Icons.logout, color: Colors.red),
                    label: const Text('Logout'),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.red),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
        ),
        Text(value, style: AppTheme.bodyMedium?.copyWith(color: Colors.white)),
      ],
    );
  }

  Widget _buildPermissionChip(String permission) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withAlpha((0.2 * 255).round()),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primaryColor, width: 1),
      ),
      child: Text(
        permission.toUpperCase(),
        style: AppTheme.bodySmall?.copyWith(
          color: AppColors.primaryColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context) {
    final nameController = TextEditingController(text: 'John Doe'); // Mock data

    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.backgroundCard,
        title: Text('Edit Profile', style: AppTheme.bodyLarge),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Full Name'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              // TODO: Implement profile update
              Get.back();
              Get.snackbar('Success', 'Profile updated successfully');
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    final currentPassController = TextEditingController();
    final newPassController = TextEditingController();
    final confirmPassController = TextEditingController();

    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.backgroundCard,
        title: Text('Change Password', style: AppTheme.bodyLarge),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentPassController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Current Password'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: newPassController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'New Password'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: confirmPassController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Confirm New Password',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              // TODO: Implement password change
              Get.back();
              Get.snackbar('Success', 'Password changed successfully');
            },
            child: const Text('Change'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.backgroundCard,
        title: Text('Logout', style: AppTheme.bodyLarge),
        content: Text(
          'Are you sure you want to logout?',
          style: AppTheme.bodyMedium,
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              // TODO: Implement logout
              Get.back();
              Get.offAllNamed('/login');
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
