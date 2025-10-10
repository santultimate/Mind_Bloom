import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test Image Loading',
      home: const TestImagePage(),
    );
  }
}

class TestImagePage extends StatelessWidget {
  const TestImagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Test Image Loading')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Test de chargement de petunia_cosmique.png'),
            const SizedBox(height: 20),
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.red),
              ),
              child: Image.asset(
                'assets/images/plants/petunia_cosmique.png',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  print('Erreur: $error');
                  return const Icon(Icons.error, color: Colors.red, size: 50);
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                try {
                  final data = await rootBundle.load('assets/images/plants/petunia_cosmique.png');
                  print('✅ Image chargée avec succès: ${data.lengthInBytes} bytes');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Image chargée: ${data.lengthInBytes} bytes')),
                  );
                } catch (e) {
                  print('❌ Erreur: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erreur: $e')),
                  );
                }
              },
              child: const Text('Tester le chargement'),
            ),
          ],
        ),
      ),
    );
  }
}
