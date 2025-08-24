// features/landing/landing_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(children: [
                  Expanded(
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('NRCS', style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      Text('A modern control room for live news rundowns.', style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 20),
                      Row(children: [
                        ElevatedButton(onPressed: () => Get.toNamed('/login'), child: const Text('Log in')),
                        const SizedBox(width: 12),
                        OutlinedButton(onPressed: () => Get.toNamed('/create-account'), child: const Text('Create account')),
                      ])
                    ]),
                  ),
                  Expanded(
                    child: Center(
                      child: Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Container(
                          width: 420,
                          height: 340,
                          padding: const EdgeInsets.all(18),
                          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: const [
                            Icon(Icons.timeline, size: 56, color: Colors.indigo),
                            SizedBox(height: 12),
                            Text('Rundown editor, real-time updates and granular permissions.', textAlign: TextAlign.center),
                          ]),
                        ),
                      ),
                    ),
                  ),
                ]),
              ),
            ),
            Container(
              color: Colors.indigo.shade50,
              padding: const EdgeInsets.all(18),
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: const [Text('Built for speed • Realtime • Collaborative')]),
            )
          ],
        ),
      ),
    );
  }
}
