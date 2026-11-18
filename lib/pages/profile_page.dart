import 'package:flutter/material.dart';

import '../storage/preferences_service.dart';
import 'login_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Profil', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: FutureBuilder<String>(
        future: PreferencesService.getUsername(),
        builder: (context, snapshot) {
          final username = snapshot.data ?? '';
          return ListView(
            padding: const EdgeInsets.fromLTRB(22, 28, 22, 24),
            children: [
              const CircleAvatar(
                radius: 48,
                backgroundColor: Color(0xFF292929),
                child: Icon(Icons.person, size: 54, color: Colors.white70),
              ),
              const SizedBox(height: 14),
              Text(
                username.isEmpty ? 'User' : username,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              const Text(
                'Pengguna NontonSkuy',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white54),
              ),
              const SizedBox(height: 30),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Kesan dan Pesan',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'praktikumnya seru abisss, banyak ilmu yg didapat, semoga aslabnya sehat selaluuu',
                        style: TextStyle(color: Colors.white70, height: 1.5),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 46,
                child: FilledButton.icon(
                  onPressed: () async {
                    await PreferencesService.logout();
                    if (!context.mounted) return;
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                      (route) => false,
                    );
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text('Logout'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
