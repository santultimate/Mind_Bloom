# Amélioration du Système de Vies - Mind Bloom

## Problèmes Identifiés

1. **Timer de vie non visible** : Le compte à rebours n'était pas affiché dans l'interface
2. **Pas de possibilité d'obtenir des vies gratuites** : Aucun moyen d'obtenir des vies après épuisement
3. **Interface non mise à jour** : Le timer ne se mettait pas à jour en temps réel

## Solutions Implémentées

### 1. Correction de l'Affichage du Timer

#### Modifications dans `LivesWidget` :

```dart
// Ajout d'un timer pour mettre à jour l'interface
Timer? _updateTimer;

@override
void initState() {
  super.initState();
  // ... autres initialisations ...
  
  // Mettre à jour l'interface toutes les secondes pour le timer
  _updateTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
    if (mounted) {
      setState(() {});
    }
  });
}

@override
void dispose() {
  _blinkController.dispose();
  _updateTimer?.cancel(); // Nettoyer le timer
  super.dispose();
}
```

#### Affichage du Timer :
```dart
// Timer si pas de vies
if (userProvider.lives < userProvider.maxLives) ...[
  const SizedBox(width: 12),
  Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: Colors.blue.withValues(alpha: 0.3),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.timer, color: Colors.blue, size: 16),
        const SizedBox(width: 4),
        Text(
          _formatTime(userProvider.timeUntilNextLife),
          style: const TextStyle(
            color: Colors.blue,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  ),
],
```

### 2. Système de Vies Gratuites par Publicité

#### Bouton "Vie Gratuite" :
```dart
// Bouton pour regarder une pub et obtenir une vie
if (userProvider.lives == 0) ...[
  const SizedBox(width: 12),
  GestureDetector(
    onTap: () => _showWatchAdDialog(context, userProvider),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.green.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.play_circle, color: Colors.green, size: 16),
          const SizedBox(width: 4),
          const Text(
            'Vie gratuite',
            style: TextStyle(
              color: Colors.green,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ),
  ),
],
```

#### Dialogue de Confirmation :
```dart
void _showWatchAdDialog(BuildContext context, UserProvider userProvider) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text('Vie Gratuite', style: TextStyle(color: Colors.white)),
        content: const Text(
          'Regardez une publicité pour obtenir une vie gratuite !',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _watchAdForLife(userProvider);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            child: const Text('Regarder la Pub'),
          ),
        ],
      );
    },
  );
}
```

#### Simulation de Publicité :
```dart
void _watchAdForLife(UserProvider userProvider) {
  // Afficher un dialogue de chargement
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.grey[900],
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(color: Colors.green),
            const SizedBox(height: 16),
            const Text('Publicité en cours...', style: TextStyle(color: Colors.white)),
          ],
        ),
      );
    },
  );

  // Simuler la durée de la publicité (3 secondes)
  Timer(const Duration(seconds: 3), () {
    Navigator.of(context).pop(); // Fermer le dialogue de chargement
    
    // Donner une vie
    userProvider.addLives(1);
    
    // Afficher un message de succès
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Vie obtenue ! Vous pouvez continuer à jouer.'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  });
}
```

## Fonctionnalités du Système de Vies

### 1. Timer de Régénération
- ⏰ **Durée** : 30 minutes par vie
- 📱 **Affichage** : Compte à rebours en temps réel (MM:SS)
- 🔄 **Mise à jour** : Interface mise à jour toutes les secondes
- 💾 **Persistance** : Sauvegarde automatique des données

### 2. Vies Gratuites par Publicité
- 🎬 **Déclenchement** : Bouton visible quand 0 vies
- ⏱️ **Simulation** : Publicité de 3 secondes
- 🎁 **Récompense** : 1 vie gratuite après visionnage
- ✅ **Feedback** : Message de confirmation

### 3. Interface Utilisateur
- 💖 **Icône de cœur** : Affichage du nombre de vies
- ⏰ **Timer visuel** : Compte à rebours avec icône
- 🎬 **Bouton publicité** : Appel visuel pour vies gratuites
- 🎨 **Design cohérent** : Couleurs et styles harmonieux

## Tests Effectués

### 1. Affichage du Timer
- ✅ Timer visible quand vies < 5
- ✅ Mise à jour en temps réel
- ✅ Format MM:SS correct
- ✅ Disparition quand vies = 5

### 2. Système de Publicités
- ✅ Bouton visible quand 0 vies
- ✅ Dialogue de confirmation
- ✅ Simulation de publicité
- ✅ Attribution de vie après visionnage
- ✅ Message de succès

### 3. Persistance des Données
- ✅ Sauvegarde automatique
- ✅ Restauration au redémarrage
- ✅ Synchronisation des timers

## Prochaines Étapes

### 1. Intégration de Vraies Publicités
Pour la production, remplacer la simulation par de vraies publicités :

```dart
// Utiliser AdProvider pour les vraies publicités
final adProvider = Provider.of<AdProvider>(context, listen: false);
await adProvider.showRewardedAd(
  onReward: () => userProvider.addLives(1),
  rewardType: 'life',
);
```

### 2. Limites et Restrictions
- Limiter le nombre de vies gratuites par jour
- Ajouter un cooldown entre les publicités
- Implémenter un système de récompenses progressives

### 3. Analytics et Métriques
- Tracker les vues de publicités
- Mesurer le taux de conversion
- Analyser l'engagement utilisateur

## Conclusion

✅ **Timer de vie visible** : Affichage en temps réel du compte à rebours

✅ **Vies gratuites par publicité** : Système complet de récompenses

✅ **Interface utilisateur améliorée** : Design cohérent et intuitif

✅ **Persistance des données** : Sauvegarde automatique des préférences

Le système de vies est maintenant complet et fonctionnel. Les utilisateurs peuvent voir le temps restant avant la prochaine vie et obtenir des vies gratuites en regardant des publicités quand leurs vies sont épuisées.
