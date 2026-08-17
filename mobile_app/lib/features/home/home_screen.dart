import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tourist Safety'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome, Tourist',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Card(
              child: SizedBox(
                height: 200,
                width: double.infinity,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.map,
                        size: 60,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Tourist Location Map',
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        'GPS and offline map will be added later',
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            const Card(
              child: ListTile(
                leading: Icon(Icons.security),
                title: Text('Safety Status'),
                subtitle: Text('Current risk status'),
                trailing: Text('Safe'),
              ),
            ),

            const SizedBox(height: 10),

            Card(
              child: ListTile(
                leading: const Icon(Icons.local_hospital),
                title: const Text('Nearby Facilities'),
                subtitle: const Text(
                  'Hospitals, police stations and emergency facilities',
                ),
                onTap: () {},
              ),
            ),

            const SizedBox(height: 10),

            Card(
              child: ListTile(
                leading: const Icon(Icons.warning),
                title: const Text('Danger Zones'),
                subtitle: const Text(
                  'View nearby danger zones and alerts',
                ),
                onTap: () {},
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.sos),
                label: const Text('SOS EMERGENCY'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}