import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/theme_provider.dart';
import '../config/app_config.dart';
import '../config/localization.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [const Color(0xFF1a1a2e), const Color(0xFF16213e)]
                : [const Color(0xFF1a237e), const Color(0xFF3949ab)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              _buildMenuItem(
                context: context,
                icon: Icons.home_outlined,
                label: context.tr('home'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              _buildMenuItem(
                context: context,
                icon: Icons.filter_list_outlined,
                label: context.tr('filter'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/filter');
                },
              ),
              _buildMenuItem(
                context: context,
                icon: Icons.file_download_outlined,
                label: context.tr('export'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/export');
                },
              ),
              _buildMenuItem(
                context: context,
                icon: Icons.settings_outlined,
                label: context.tr('settings'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/settings');
                },
              ),
              const Divider(color: Colors.white24),
              Consumer<ThemeProvider>(
                builder: (context, themeProvider, child) {
                  return _buildMenuItem(
                    context: context,
                    icon: themeProvider.isDarkMode
                        ? Icons.light_mode_outlined
                        : Icons.dark_mode_outlined,
                    label: themeProvider.isDarkMode
                        ? context.tr('light_mode')
                        : context.tr('dark_mode'),
                    onTap: () {
                      themeProvider.toggleTheme();
                    },
                  );
                },
              ),
              const Spacer(),
              _buildMenuItem(
                context: context,
                icon: Icons.logout,
                label: 'Lock App',
                onTap: () {
                  final authProvider = Provider.of<AuthProvider>(context, listen: false);
                  authProvider.logout();
                  Navigator.pushReplacementNamed(context, '/lock');
                },
              ),
              const SizedBox(height: 20),
              Text(
                'Version ${AppConfig.appVersion}',
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: const Center(
              child: Text(
                'EV',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1a237e),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'EV Student Manager',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Manage your students easily',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.white,
      ),
      title: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
    );
  }
}
