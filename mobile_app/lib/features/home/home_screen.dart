import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const Color cyan = Color(0xFF00E5FF);
  static const Color navy = Color(0xFF0A1128);
  static const Color blue = Color(0xFF1C3A63);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: navy,
      appBar: AppBar(
        backgroundColor: navy,
        elevation: 0,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'TOURIST SAFETY',
              style: TextStyle(
                color: Colors.white,
                fontSize: 19,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
            Text(
              'Smart Safety Monitoring',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 11,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications_none,
              color: cyan,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.person_outline,
              color: cyan,
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome, Tourist 👋',
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              'Your safety is being monitored.',
              style: TextStyle(
                color: Colors.white60,
                fontSize: 13,
              ),
            ),

            const SizedBox(height: 22),

            // SAFETY STATUS
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF123C4A),
                    Color(0xFF10233D),
                  ],
                ),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: cyan.withValues(alpha: 0.3),
                ),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.shield_rounded,
                    color: cyan,
                    size: 48,
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'YOU ARE SAFE',
                          style: TextStyle(
                            color: cyan,
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'No immediate danger detected',
                          style: TextStyle(
                            color: Colors.white60,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.check_circle,
                    color: Colors.greenAccent,
                    size: 28,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // LOCATION
            const Text(
              'CURRENT LOCATION',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),

            const SizedBox(height: 12),

            Container(
              height: 190,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF122C4A),
                    Color(0xFF0D1930),
                  ],
                ),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: cyan.withValues(alpha: 0.18),
                ),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.location_on_rounded,
                      color: cyan,
                      size: 55,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'LIVE LOCATION',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'GPS monitoring ready',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            // QUICK ACTIONS
            const Text(
              'QUICK ACTIONS',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _actionCard(
                    Icons.warning_amber_rounded,
                    'Danger Zones',
                    'View alerts',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _actionCard(
                    Icons.local_hospital_outlined,
                    'Emergency',
                    'Nearby help',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _actionCard(
                    Icons.route_outlined,
                    'Safe Route',
                    'Find safe path',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _actionCard(
                    Icons.badge_outlined,
                    'Digital ID',
                    'Secure identity',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),

            // MONITORING
            const Text(
              'SAFETY MONITORING',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),

            const SizedBox(height: 12),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.03),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: cyan.withValues(alpha: 0.15),
                ),
              ),
              child: Column(
                children: [
                  _monitorRow(
                    Icons.gps_fixed,
                    'GPS Tracking',
                    'ACTIVE',
                    Colors.greenAccent,
                  ),
                  const Divider(color: Colors.white12),
                  _monitorRow(
                    Icons.security,
                    'Risk Monitoring',
                    'ACTIVE',
                    Colors.greenAccent,
                  ),
                  const Divider(color: Colors.white12),
                  _monitorRow(
                    Icons.cloud_off,
                    'Offline Protection',
                    'READY',
                    cyan,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // SOS
            SizedBox(
              width: double.infinity,
              height: 65,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(
                  Icons.sos_rounded,
                  size: 30,
                ),
                label: const Text(
                  'SOS EMERGENCY',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD50032),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            const Center(
              child: Text(
                'Use SOS only in case of an emergency',
                style: TextStyle(
                  color: Colors.white38,
                  fontSize: 11,
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF080E21),
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: cyan,
        unselectedItemColor: Colors.white38,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.security_rounded),
            label: 'Safety',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  static Widget _actionCard(
    IconData icon,
    String title,
    String subtitle,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.035),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: cyan.withValues(alpha: 0.12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: cyan.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Icon(
              Icons.shield_outlined,
              color: cyan,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              color: Colors.white38,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  static Widget _monitorRow(
    IconData icon,
    String title,
    String status,
    Color statusColor,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          color: cyan,
          size: 22,
        ),
        const SizedBox(width: 13),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
            ),
          ),
        ),
        Text(
          status,
          style: TextStyle(
            color: statusColor,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}