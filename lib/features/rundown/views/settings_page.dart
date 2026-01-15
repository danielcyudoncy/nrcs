// features/rundown/views/settings_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nrcs/core/theme/app_theme.dart';
import 'package:nrcs/core/auth/auth_controller.dart';
import 'package:nrcs/core/utils/theme_controller.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();
    final themeCtrl = Get.find<ThemeController>();

    return Obx(
      () => Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          elevation: 0,
          title: Text(
            'Settings',
            style: AppTheme.headingSmall?.copyWith(
              color: Theme.of(context).appBarTheme.foregroundColor,
            ),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Profile card
                Card(
                  color: Theme.of(context).cardTheme.color,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: AppColors.glassBlue,
                          child: Icon(
                            Icons.person,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                auth.user.value?.displayName ?? 'User',
                                style: AppTheme.bodyLarge?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).textTheme.bodyLarge?.color,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                auth.user.value?.email ?? '—',
                                style: AppTheme.bodySmall?.copyWith(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.color
                                      ?.withAlpha(179), // 0.7 alpha
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Settings options
                Expanded(
                  child: ListView(
                    children: [
                      _buildOptionTile(
                        context,
                        Icons.notifications,
                        'Notifications',
                        'Receive real-time updates',
                        true,
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.palette,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        title: Text(
                          'Theme',
                          style: AppTheme.bodyMedium?.copyWith(
                            color: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.color,
                          ),
                        ),
                        subtitle: Text(
                          'Dark / Light appearance',
                          style: AppTheme.bodySmall?.copyWith(
                            color: Theme.of(
                              context,
                            ).textTheme.bodySmall?.color?.withAlpha(179),
                          ),
                        ),
                        trailing: Switch(
                          value: themeCtrl.isDark.value,
                          onChanged: (v) => themeCtrl.setDark(v),
                        ),
                      ),
                      _buildOptionTile(
                        context,
                        Icons.lock,
                        'Privacy',
                        'Manage permissions and access',
                        false,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Account',
                        style: AppTheme.headingSmall?.copyWith(
                          color: Theme.of(
                            context,
                          ).textTheme.displaySmall?.color,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ListTile(
                        leading: Icon(
                          Icons.person,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        title: Text(
                          'Profile',
                          style: AppTheme.bodyMedium?.copyWith(
                            color: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.color,
                          ),
                        ),
                        trailing: Icon(
                          Icons.chevron_right,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        onTap: () => Get.toNamed('/profile'),
                      ),
                    ],
                  ),
                ),

                // Logout
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error,
                      foregroundColor: AppColors.textPrimary,
                    ),
                    icon: const Icon(Icons.logout),
                    label: Text('Log out', style: AppTheme.button),
                    onPressed: () {
                      // navigate back to login/landing and clear stack
                      final authCtrl = Get.find<AuthController>();
                      authCtrl.signOut();
                      Get.offAllNamed('/login');
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOptionTile(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    bool value,
  ) {
    return Card(
      color: Theme.of(context).cardTheme.color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: AppColors.glassBlue),
        title: Text(
          title,
          style: AppTheme.bodyMedium?.copyWith(
            color: Theme.of(context).textTheme.bodyMedium?.color,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: AppTheme.bodySmall?.copyWith(
            color: Theme.of(context).textTheme.bodySmall?.color?.withAlpha(179),
          ),
        ),
        trailing: Switch(value: value, onChanged: (v) {}),
        onTap: () {},
      ),
    );
  }
}
