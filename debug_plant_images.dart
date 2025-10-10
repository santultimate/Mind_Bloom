import 'dart:io';

void main() {
  final plantsDir = Directory('assets/images/plants');
  if (!plantsDir.existsSync()) {
    print('❌ Le dossier assets/images/plants n\'existe pas');
    return;
  }

  final files = plantsDir.listSync();
  print('📁 Images trouvées dans assets/images/plants:');
  
  for (final file in files) {
    if (file is File && file.path.endsWith('.png')) {
      final fileName = file.path.split('/').last;
      final size = file.lengthSync();
      print('✅ $fileName (${(size / 1024).toStringAsFixed(1)} KB)');
    }
  }

  // Vérifier spécifiquement petunia_cosmique.png
  final petuniaFile = File('assets/images/plants/petunia_cosmique.png');
  if (petuniaFile.existsSync()) {
    print('\n🌸 Pétunia Cosmique:');
    print('✅ Fichier existe: ${petuniaFile.path}');
    print('✅ Taille: ${(petuniaFile.lengthSync() / 1024).toStringAsFixed(1)} KB');
    
    // Vérifier que le fichier est lisible
    try {
      final bytes = petuniaFile.readAsBytesSync();
      print('✅ Fichier lisible: ${bytes.length} bytes');
    } catch (e) {
      print('❌ Erreur lecture: $e');
    }
  } else {
    print('❌ Pétunia Cosmique non trouvé');
  }
}
