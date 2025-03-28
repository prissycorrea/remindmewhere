import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1E),
      appBar: AppBar(
        title: const Text('Perfil'),
        backgroundColor: const Color(0xFF4F66FF),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // Cartão de perfil
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF2C2C2E),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 36,
                  backgroundColor: Color(0xFF4F66FF),
                  child: Icon(Icons.person, size: 36, color: Colors.white),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Logan',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'logandev@email.com',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          const Text(
            'Configurações',
            style: TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),

          _buildSettingsItem(
            icon: Icons.notifications,
            title: 'Notificações',
            onTap: () {},
          ),
          _buildSettingsItem(
            icon: Icons.lock,
            title: 'Privacidade',
            onTap: () {},
          ),
          _buildSettingsItem(
            icon: Icons.palette,
            title: 'Tema do app',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Tema do app em breve')),
              );
            },
          ),
          _buildSettingsItem(
            icon: Icons.language,
            title: 'Idioma',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Seleção de idioma em breve')),
              );
            },
          ),

          const SizedBox(height: 30),

          const Text(
            'Sobre',
            style: TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),

          _buildSettingsItem(
            icon: Icons.info_outline,
            title: 'Sobre o app',
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'RemindMeWhere',
                applicationVersion: '1.0.0',
                applicationLegalese: '© 2025 Logan Dev',
              );
            },
          ),
          _buildSettingsItem(
            icon: Icons.logout,
            title: 'Sair',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Logout em desenvolvimento')),
              );
            },
            iconColor: Colors.redAccent,
            textColor: Colors.redAccent,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color iconColor = Colors.white,
    Color textColor = Colors.white,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
      leading: Icon(icon, color: iconColor),
      title: Text(title, style: TextStyle(color: textColor)),
      trailing: const Icon(Icons.chevron_right, color: Colors.white38),
      onTap: onTap,
    );
  }
}
