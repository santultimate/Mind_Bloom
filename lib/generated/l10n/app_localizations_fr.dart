// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Mind Bloom';

  @override
  String get home => 'Accueil';

  @override
  String get profile => 'Profil';

  @override
  String get collection => 'Collection';

  @override
  String get shop => 'Boutique';

  @override
  String get settings => 'Paramètres';

  @override
  String get about => 'À propos';

  @override
  String get level => 'Niveau';

  @override
  String get score => 'Score';

  @override
  String get moves => 'Coups';

  @override
  String get lives => 'Vies';

  @override
  String coins(int quantity) {
    return '$quantity pièces';
  }

  @override
  String gems(int count) {
    return '$count gemmes';
  }

  @override
  String get play => 'Jouer';

  @override
  String get pause => 'Pause';

  @override
  String get resume => 'Reprendre';

  @override
  String get restart => 'Recommencer';

  @override
  String get menu => 'Menu';

  @override
  String get hint => 'Indice';

  @override
  String get shuffle => 'Mélanger';

  @override
  String get next => 'Suivant';

  @override
  String get back => 'Retour';

  @override
  String get cancel => 'Annuler';

  @override
  String get confirm => 'Confirmer';

  @override
  String get save => 'Enregistrer';

  @override
  String get load => 'Charger';

  @override
  String get reset => 'Réinitialiser';

  @override
  String get delete => 'Supprimer';

  @override
  String get edit => 'Modifier';

  @override
  String get close => 'Fermer';

  @override
  String get ok => 'OK';

  @override
  String get yes => 'Oui';

  @override
  String get no => 'Non';

  @override
  String get loading => 'Chargement...';

  @override
  String get error => 'Erreur';

  @override
  String get success => 'Succès';

  @override
  String get warning => 'Attention';

  @override
  String get info => 'Information';

  @override
  String get noMovesAvailable =>
      'Aucun mouvement possible. Utilisez le bouton mélanger !';

  @override
  String get levelComplete => 'Niveau terminé !';

  @override
  String levelFailed(int id) {
    final intl.NumberFormat idNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String idString = idNumberFormat.format(id);

    return 'Niveau $idString Échoué';
  }

  @override
  String get gamePaused => 'Jeu en pause';

  @override
  String get whatWouldYouLikeToDo => 'Que souhaitez-vous faire ?';

  @override
  String get freeLife => 'Vie gratuite';

  @override
  String get watchAdForLife => 'Regarder une Pub pour une Vie';

  @override
  String get watchAd => 'Regarder la Pub';

  @override
  String get adInProgress => 'Publicité en cours...';

  @override
  String get lifeObtained => 'Vie obtenue ! Vous pouvez continuer à jouer.';

  @override
  String get music => 'Musique';

  @override
  String get soundEffects => 'Effets sonores';

  @override
  String get animations => 'Animations';

  @override
  String get vibrations => 'Vibrations';

  @override
  String get autoHints => 'Indices automatiques';

  @override
  String get language => 'Langue';

  @override
  String get english => 'English';

  @override
  String get french => 'Français';

  @override
  String get version => 'Version';

  @override
  String get developer => 'Développeur';

  @override
  String get termsOfService => 'Conditions d\'utilisation';

  @override
  String get privacyPolicy => 'Politique de confidentialité';

  @override
  String get readTermsOfService => 'Lire les conditions d\'utilisation';

  @override
  String get readPrivacyPolicy => 'Lire la politique de confidentialité';

  @override
  String get aboutGame => 'À propos du jeu';

  @override
  String get gameDescription =>
      'Mind Bloom est un jeu de puzzle magique qui combine les mécaniques classiques du match-3 avec des éléments RPG. Cultivez votre jardin enchanté en alignant des tuiles colorées et découvrez un univers unique de progression et de collection.';

  @override
  String get technologies => 'Technologies';

  @override
  String get legalInformation => 'Informations légales';

  @override
  String get license => 'Licence';

  @override
  String get licenseText =>
      'Ce projet est sous licence MIT. Vous êtes libre de l\'utiliser, le modifier et le distribuer selon les termes de cette licence.';

  @override
  String get acknowledgments => 'Remerciements';

  @override
  String get acknowledgmentsText =>
      'Un grand merci à la communauté Flutter, aux contributeurs des packages utilisés, et à tous ceux qui ont soutenu ce projet.';

  @override
  String get developedWithLove => 'Développé avec ❤️ par';

  @override
  String get quote => '\"Cultivez votre jardin intérieur, un match à la fois\"';

  @override
  String get username => 'Nom d\'utilisateur';

  @override
  String get editUsername => 'Modifier le nom d\'utilisateur';

  @override
  String get currentStreak => 'Série actuelle';

  @override
  String get bestStreak => 'Meilleure série';

  @override
  String get days => 'jours';

  @override
  String get saveData => 'Sauvegarder les données';

  @override
  String get restoreData => 'Restaurer les données';

  @override
  String get resetData => 'Réinitialiser les données';

  @override
  String get saveProgress => 'Sauvegarder vos progrès';

  @override
  String get restoreProgress => 'Restaurer vos progrès';

  @override
  String get deleteAllData => 'Supprimer toutes les données (irréversible)';

  @override
  String get resetDataConfirmation =>
      'Êtes-vous sûr de vouloir supprimer toutes vos données ? Cette action est irréversible.';

  @override
  String get dataReset => 'Données réinitialisées';

  @override
  String get dataSaved => 'Données sauvegardées avec succès';

  @override
  String get dataRestored => 'Données restaurées avec succès';

  @override
  String get saveError => 'Erreur lors de la sauvegarde';

  @override
  String get restoreError => 'Erreur lors de la restauration';

  @override
  String get usernameUpdated => 'Nom d\'utilisateur mis à jour avec succès';

  @override
  String get world => 'Monde';

  @override
  String levelCompleted(int id) {
    final intl.NumberFormat idNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String idString = idNumberFormat.format(id);

    return 'Niveau $idString Terminé !';
  }

  @override
  String get stars => 'Étoiles';

  @override
  String get movesUsed => 'Coups utilisés';

  @override
  String get nextLevel => 'Niveau suivant';

  @override
  String get retry => 'Réessayer';

  @override
  String get objectives => 'Objectifs';

  @override
  String collectTiles(int count, String type) {
    return 'Collecter $count $type';
  }

  @override
  String reachScore(int score) {
    return 'Atteindre $score points';
  }

  @override
  String completeInMoves(int moves) {
    return 'Terminer en $moves coups';
  }

  @override
  String get tileTypeFlower => 'Fleur';

  @override
  String get tileTypeLeaf => 'Feuille';

  @override
  String get tileTypeCrystal => 'Cristal';

  @override
  String get tileTypeSeed => 'Graine';

  @override
  String get tileTypeDew => 'Rosée';

  @override
  String get tileTypeSun => 'Soleil';

  @override
  String get tileTypeMoon => 'Lune';

  @override
  String get tileTypeGem => 'Gemme';

  @override
  String get achievements => 'Réalisations';

  @override
  String get events => 'Événements';

  @override
  String get tutorial => 'Tutoriel';

  @override
  String get buy => 'Acheter';

  @override
  String get price => 'Prix';

  @override
  String get owned => 'Possédé';

  @override
  String get plants => 'Plantes';

  @override
  String get unlocked => 'Débloqué';

  @override
  String get locked => 'Verrouillé';

  @override
  String get upgrade => 'Améliorer';

  @override
  String bonus(int count) {
    return '+$count bonus';
  }

  @override
  String get active => 'ACTIF';

  @override
  String get inactive => 'Inactif';

  @override
  String get filter => 'Filtrer';

  @override
  String get all => 'Tous';

  @override
  String get unlockedOnly => 'Débloqués seulement';

  @override
  String get lockedOnly => 'Verrouillés seulement';

  @override
  String get noPlantsFound => 'Aucune plante trouvée';

  @override
  String get plantDetails => 'Détails de la plante';

  @override
  String get description => 'Description';

  @override
  String get rarity => 'Rareté';

  @override
  String get common => 'Commun';

  @override
  String get rare => 'Rare';

  @override
  String get epic => 'Épique';

  @override
  String get legendary => 'Légendaire';

  @override
  String get upgradeCost => 'Coût d\'amélioration';

  @override
  String get insufficientCoins => 'Pièces insuffisantes';

  @override
  String get upgradeSuccess => 'Amélioration réussie !';

  @override
  String get noLives => 'Aucune vie';

  @override
  String get noLivesMessage =>
      'Vous n\'avez plus de vies. Regardez une publicité pour obtenir une vie gratuite ou attendez que les vies se régénèrent.';

  @override
  String get levelLocked => 'Niveau verrouillé';

  @override
  String get levelLockedMessage =>
      'Vous devez compléter le niveau précédent pour débloquer celui-ci.';

  @override
  String get firstSteps => 'Premiers Pas';

  @override
  String get firstStepsDescription => 'Terminez votre premier niveau';

  @override
  String get levelMaster => 'Maître des Niveaux';

  @override
  String get levelMasterDescription => 'Terminez 10 niveaux';

  @override
  String get scoreHunter => 'Chasseur de Scores';

  @override
  String get scoreHunterDescription =>
      'Atteignez 10 000 points en un seul niveau';

  @override
  String get comboKing => 'Roi des Combos';

  @override
  String get comboKingDescription => 'Faites un combo de 5';

  @override
  String get plantCollector => 'Collectionneur de Plantes';

  @override
  String get plantCollectorDescription => 'Débloquez 5 plantes';

  @override
  String get perfectPlayer => 'Joueur Parfait';

  @override
  String get perfectPlayerDescription => 'Terminez un niveau avec 3 étoiles';

  @override
  String get dailyChallenge => 'Défi Quotidien';

  @override
  String get weeklyEvent => 'Événement Hebdomadaire';

  @override
  String get specialOffer => 'Offre Spéciale';

  @override
  String get limitedTime => 'Temps Limité';

  @override
  String get newEvent => 'Nouvel Événement';

  @override
  String get eventDescription =>
      'Terminez des objectifs spéciaux pour gagner des récompenses exclusives !';

  @override
  String get participate => 'Participer';

  @override
  String get rewards => 'Récompenses';

  @override
  String get powerUps => 'Power-ups';

  @override
  String get bomb => 'Bombe';

  @override
  String get lightning => 'Éclair';

  @override
  String get rainbow => 'Arc-en-ciel';

  @override
  String get hammer => 'Marteau';

  @override
  String get gameplay => 'Gameplay';

  @override
  String get matchThree =>
      'Associez 3 tuiles ou plus du même type pour les effacer';

  @override
  String get combos => 'Créez des combos pour des points bonus';

  @override
  String get powerUpsUsage =>
      'Utilisez les power-ups pour vous aider dans les situations difficiles';

  @override
  String get livesSystem =>
      'Vous avez un nombre limité de vies. Regardez des publicités pour en obtenir plus !';

  @override
  String get readTermsOfUse => 'Lire les conditions d\'utilisation';

  @override
  String lastUpdated(String date) {
    return 'Dernière mise à jour : $date';
  }

  @override
  String get privacyPolicyIntroduction =>
      'Cette politique de confidentialité décrit comment Mind Bloom collecte, utilise et protège vos informations personnelles lorsque vous utilisez notre application mobile. Nous nous engageons à protéger votre vie privée et à traiter vos données avec le plus grand respect.';

  @override
  String get informationWeCollect => 'Informations que nous collectons';

  @override
  String get weCollectFollowing =>
      'Nous collectons les informations suivantes :';

  @override
  String get gameData => 'Données de jeu';

  @override
  String get gameDataDescription => 'Progression, scores, préférences de jeu';

  @override
  String get technicalData => 'Données techniques';

  @override
  String get technicalDataDescription =>
      'Version de l\'application, type d\'appareil, système d\'exploitation';

  @override
  String get usageData => 'Données d\'utilisation';

  @override
  String get usageDataDescription =>
      'Temps de jeu, fonctionnalités utilisées, métriques de performance';

  @override
  String get howWeUseData => 'Comment nous utilisons vos données';

  @override
  String get dataUsageDescription => 'Nous utilisons vos données pour :';

  @override
  String get improveGameplay => 'Améliorer l\'expérience de jeu';

  @override
  String get provideSupport => 'Fournir un support client';

  @override
  String get analyzeUsage => 'Analyser l\'utilisation de l\'application';

  @override
  String get dataProtection => 'Protection des données';

  @override
  String get dataProtectionDescription =>
      'Nous mettons en place des mesures de sécurité appropriées pour protéger vos informations personnelles contre l\'accès non autorisé, la modification, la divulgation ou la destruction.';

  @override
  String get contactUs => 'Nous contacter';

  @override
  String get contactUsDescription =>
      'Si vous avez des questions concernant cette politique de confidentialité, veuillez nous contacter à :';

  @override
  String get email => 'Email';

  @override
  String get emailAddress => 'privacy@mindbloom.com';

  @override
  String get howWeUseInformation => 'Comment nous utilisons vos informations';

  @override
  String get weUseInformationFor => 'Nous utilisons vos informations pour :';

  @override
  String get provideService => 'Fournir et améliorer le service de jeu';

  @override
  String get personalizeExperience => 'Personnaliser votre expérience de jeu';

  @override
  String get displayAds =>
      'Afficher des publicités personnalisées (avec votre consentement)';

  @override
  String get ensureSecurity => 'Assurer la sécurité et prévenir la fraude';

  @override
  String get communicateService =>
      'Communiquer avec vous concernant le service';

  @override
  String get dataSharing => 'Partage des données';

  @override
  String get dataSharingDescription =>
      'Nous ne vendons, n\'échangeons ni ne transférons vos informations personnelles à des tiers sans votre consentement, sauf comme décrit dans cette politique.';

  @override
  String get yourRights => 'Vos droits';

  @override
  String get yourRightsDescription => 'Vous avez le droit de :';

  @override
  String get accessData => 'Accéder à vos données personnelles';

  @override
  String get correctData => 'Corriger les données inexactes';

  @override
  String get deleteData => 'Supprimer vos données';

  @override
  String get withdrawConsent =>
      'Retirer le consentement pour le traitement des données';

  @override
  String get data => 'Données';

  @override
  String get audio => 'Audio';

  @override
  String get enableDisableMusic => 'Activer/désactiver la musique de fond';

  @override
  String get enableDisableSfx => 'Activer/désactiver les effets sonores';

  @override
  String get game => 'Jeu';

  @override
  String get enableDisableAnimations => 'Activer/désactiver les animations';

  @override
  String get enableDisableVibrations => 'Activer/désactiver les vibrations';

  @override
  String get musicVolume => 'Volume de la musique';

  @override
  String get effectsVolume => 'Volume des effets';

  @override
  String get experience => 'Expérience';

  @override
  String get noMoreLives => 'Plus de vies !';

  @override
  String get noMoreLivesMessage =>
      'Vous n\'avez plus de vies. Regardez une publicité pour en obtenir une gratuite, attendez qu\'elles se rechargent ou achetez-en plus.';

  @override
  String get wait => 'Attendre';

  @override
  String get noLevelLoaded => 'Aucun niveau chargé';

  @override
  String get backToMenu => 'Retour au menu';

  @override
  String get youHaveUsedAllMoves => 'Vous avez utilisé tous vos coups !';

  @override
  String get aboutTheGame => 'À propos du jeu';

  @override
  String get flutterDeveloper => 'Développeur Flutter';

  @override
  String get readOurTermsOfService => 'Lisez nos conditions d\'utilisation';

  @override
  String get discoverHowWeProtectYourData =>
      'Découvrez comment nous protégeons vos données';

  @override
  String get movesRemaining => 'Coups restants';

  @override
  String get noMovesPossible =>
      'Aucun mouvement possible. Utilisez le bouton mélanger !';

  @override
  String get activeEvent => 'ÉVÉNEMENT ACTIF';

  @override
  String daysRemaining(int days) {
    return '$days jours restants';
  }

  @override
  String startsIn(int days) {
    return 'Commence dans $days jours';
  }

  @override
  String others(int count) {
    return '+$count autres';
  }

  @override
  String get progress => 'Progression';

  @override
  String plant(int rarity) {
    return 'Plante $rarity★';
  }

  @override
  String boosters(int count) {
    return '$count boosters';
  }

  @override
  String get completed => 'TERMINÉ';

  @override
  String get challenges => 'Défis';

  @override
  String get comingSoon => 'Bientôt disponible';

  @override
  String rarePlant(int rarity) {
    return 'Plante rare $rarity étoiles';
  }

  @override
  String participationInProgress(String eventName) {
    return 'Participation à $eventName en cours...';
  }

  @override
  String get springBloom => 'Floraison de Printemps';

  @override
  String get springBloomDescription =>
      'Célébrez le renouveau avec des fleurs magiques';

  @override
  String get summerSolstice => 'Solstice d\'Été';

  @override
  String get summerSolsticeDescription =>
      'Profitez du soleil avec des plantes ensoleillées';

  @override
  String get autumnHarvest => 'Récolte d\'Automne';

  @override
  String get autumnHarvestDescription => 'Récoltez les fruits de vos efforts';

  @override
  String completeLevels(int target) {
    return 'Terminez $target niveaux';
  }

  @override
  String earnStars(int target) {
    return 'Gagnez $target étoiles';
  }

  @override
  String useBoosters(int target) {
    return 'Utilisez $target boosters';
  }

  @override
  String scorePoints(int target) {
    return 'Marquez $target points';
  }

  @override
  String get popularItems => 'Articles Populaires';

  @override
  String get currency => 'Monnaie';

  @override
  String get premium => 'Premium';

  @override
  String get pop => 'POP';

  @override
  String notEnoughCurrency(String currency) {
    return 'Vous n\'avez pas assez de $currency';
  }

  @override
  String purchaseSuccess(String item) {
    return '$item acheté avec succès !';
  }

  @override
  String get lives5 => '5 Vies';

  @override
  String get lives5Description => 'Rechargez vos vies pour continuer à jouer';

  @override
  String get lives10 => '10 Vies';

  @override
  String get lives10Description => 'Pack de vies plus important';

  @override
  String get coins100 => '100 Pièces';

  @override
  String get coins100Description => 'Petit pack de pièces';

  @override
  String get coins500 => '500 Pièces';

  @override
  String get coins500Description => 'Pack de pièces moyen';

  @override
  String get coins1000 => '1000 Pièces';

  @override
  String get coins1000Description => 'Gros pack de pièces';

  @override
  String get gems50 => '50 Gemmes';

  @override
  String get gems50Description => 'Pack de gemmes premium';

  @override
  String get shuffler => 'Mélangeur';

  @override
  String get shufflerDescription => 'Mélange automatiquement le plateau';

  @override
  String get hintDescription => 'Montre un coup possible';

  @override
  String get removeAds => 'Sans Publicités';

  @override
  String get removeAdsDescription => 'Supprime toutes les publicités';

  @override
  String plantLevel(int level) {
    return 'Niveau $level';
  }

  @override
  String get unlockCondition => 'Condition de déblocage';

  @override
  String get bonuses => 'Bonus';

  @override
  String extraMoves(int value) {
    return '+$value coups supplémentaires';
  }

  @override
  String scoreMultiplier(int value) {
    return 'Score x$value';
  }

  @override
  String coinMultiplier(int value) {
    return 'Pièces x$value';
  }

  @override
  String extraLives(int value) {
    return '+$value vie(s)';
  }

  @override
  String plantUpgraded(String plantName, int level) {
    return '$plantName améliorée au niveau $level !';
  }

  @override
  String get progression => 'Progression';

  @override
  String get social => 'Social';

  @override
  String get reward => 'Récompense';

  @override
  String get rewardClaimed => 'Récompense réclamée';

  @override
  String get inProgress => 'En cours...';

  @override
  String rewardClaimedMessage(String achievementTitle) {
    return 'Récompense de $achievementTitle réclamée !';
  }

  @override
  String get confirmedBeginner => 'Débutant Confirmé';

  @override
  String get confirmedBeginnerDescription => 'Terminez 10 niveaux';

  @override
  String get expertInTheMaking => 'Expert en Herbe';

  @override
  String get expertInTheMakingDescription => 'Terminez 50 niveaux';

  @override
  String get perfectionist => 'Perfectionniste';

  @override
  String get perfectionistDescription => 'Obtenez 3 étoiles sur un niveau';

  @override
  String get scorer => 'Scoreur';

  @override
  String get scorerDescription => 'Marquez 1,000 points en un niveau';

  @override
  String get scoreMaster => 'Maître du Score';

  @override
  String get scoreMasterDescription => 'Marquez 5,000 points en un niveau';

  @override
  String get accumulator => 'Accumulateur';

  @override
  String get accumulatorDescription => 'Marquez un total de 100,000 points';

  @override
  String get beginnerBotanist => 'Botaniste Débutant';

  @override
  String get beginnerBotanistDescription => 'Débloquez votre première plante';

  @override
  String get collector => 'Collectionneur';

  @override
  String get collectorDescription => 'Débloquez 5 plantes';

  @override
  String get rarityHunter => 'Chasseur de Raretés';

  @override
  String get rarityHunterDescription =>
      'Débloquez une plante 4 étoiles ou plus';

  @override
  String get comboMaster => 'Maître du Combo';

  @override
  String get comboMasterDescription => 'Faites un combo de 5 tuiles';

  @override
  String get legendaryCombo => 'Combo Légendaire';

  @override
  String get legendaryComboDescription => 'Faites un combo de 10 tuiles';

  @override
  String get saver => 'Économiseur';

  @override
  String get saverDescription =>
      'Terminez un niveau avec plus de 5 coups restants';

  @override
  String get loyal => 'Fidèle';

  @override
  String get loyalDescription => 'Connectez-vous 7 jours de suite';

  @override
  String get sharer => 'Partageur';

  @override
  String get sharerDescription => 'Partagez votre score 3 fois';

  @override
  String userLevel(int level) {
    return 'Niveau $level';
  }

  @override
  String get completedLevels => 'Niveaux terminés';

  @override
  String get detailedStats => 'Statistiques détaillées';

  @override
  String get totalCoins => 'Pièces totales';

  @override
  String get starsEarned => 'Étoiles gagnées';

  @override
  String get highestLevel => 'Niveau le plus élevé';

  @override
  String get quickActions => 'Actions rapides';

  @override
  String get reviewTutorial => 'Revoir le tutoriel';

  @override
  String get shareProfile => 'Partager le profil';

  @override
  String get recentAchievements => 'Réalisations récentes';

  @override
  String get firstLevelCompleted => 'Premier niveau terminé';

  @override
  String get threeStarsObtained => '3 étoiles obtenues';

  @override
  String get streakOfFive => 'Série de 5 niveaux';

  @override
  String daysAgo(int days) {
    return 'Il y a $days jours';
  }

  @override
  String get dayAgo => 'Il y a 1 jour';

  @override
  String get today => 'Aujourd\'hui';

  @override
  String get resetDataTitle => 'Réinitialiser les données ?';

  @override
  String get resetDataMessage =>
      'Cette action supprimera toutes vos données de progression. Cette action est irréversible.';

  @override
  String get shareComingSoon => 'Partage à venir...';

  @override
  String get acceptanceOfTerms => '1. Acceptation des conditions';

  @override
  String get acceptanceOfTermsContent =>
      'En utilisant l\'application Mind Bloom, vous acceptez d\'être lié par ces conditions d\'utilisation. Si vous n\'acceptez pas ces conditions, veuillez ne pas utiliser notre application.';

  @override
  String get serviceDescription => '2. Description du service';

  @override
  String get serviceDescriptionContent =>
      'Mind Bloom est un jeu de puzzle mobile développé par YACOUBA SANTARA. L\'application propose des mécaniques de match-3 avec des éléments de progression RPG dans un univers de jardin magique.';

  @override
  String get authorizedUse => '3. Utilisation autorisée';

  @override
  String get authorizedUseContent =>
      'Vous pouvez utiliser Mind Bloom à des fins personnelles et non commerciales uniquement. Il est interdit de :\n\n• Copier, modifier ou distribuer l\'application\n• Utiliser l\'application à des fins commerciales sans autorisation\n• Tenter de contourner les mesures de sécurité\n• Utiliser l\'application de manière à nuire à d\'autres utilisateurs';

  @override
  String get intellectualProperty => '4. Contenu et propriété intellectuelle';

  @override
  String get intellectualPropertyContent =>
      'Tous les éléments de Mind Bloom, incluant mais non limités aux graphismes, sons, code source, et design, sont la propriété exclusive de YACOUBA SANTARA et sont protégés par les lois sur le droit d\'auteur.';

  @override
  String get inAppPurchases => '5. Achats intégrés';

  @override
  String get inAppPurchasesContent =>
      'L\'application peut contenir des achats intégrés pour des vies supplémentaires, des boosters, ou d\'autres éléments de jeu. Tous les achats sont finaux et non remboursables, sauf disposition contraire de la loi applicable.';

  @override
  String get advertisements => '6. Publicités';

  @override
  String get advertisementsContent =>
      'Mind Bloom peut afficher des publicités tierces. Ces publicités sont gérées par des partenaires publicitaires et nous ne sommes pas responsables du contenu de ces publicités.';

  @override
  String get liabilityLimitation => '7. Limitation de responsabilité';

  @override
  String get liabilityLimitationContent =>
      'L\'application est fournie \"en l\'état\" sans garantie d\'aucune sorte. Nous ne serons pas responsables des dommages directs, indirects, accessoires ou consécutifs résultant de l\'utilisation de l\'application.';

  @override
  String get termsModifications => '8. Modifications des conditions';

  @override
  String get termsModificationsContent =>
      'Nous nous réservons le droit de modifier ces conditions d\'utilisation à tout moment. Les modifications prendront effet dès leur publication dans l\'application. Votre utilisation continue de l\'application constitue votre acceptation des conditions modifiées.';

  @override
  String get termination => '9. Résiliation';

  @override
  String get terminationContent =>
      'Nous nous réservons le droit de suspendre ou de résilier votre accès à l\'application à tout moment, sans préavis, pour violation de ces conditions d\'utilisation.';

  @override
  String get applicableLaw => '10. Droit applicable';

  @override
  String get applicableLawContent =>
      'Ces conditions d\'utilisation sont régies par le droit français. Tout litige sera soumis à la juridiction exclusive des tribunaux français.';

  @override
  String get contact => 'Contact';

  @override
  String get contactContent =>
      'Pour toute question concernant ces conditions d\'utilisation, vous pouvez nous contacter à :';

  @override
  String get dataStorage => '4. Stockage et sécurité';

  @override
  String get dataStorageContent =>
      'Vos données sont stockées de manière sécurisée :\n\n• **Chiffrement** : Les données sensibles sont chiffrées\n• **Accès limité** : Seul le personnel autorisé peut accéder aux données\n• **Sauvegarde** : Des sauvegardes régulières sont effectuées\n• **Durée** : Les données sont conservées uniquement le temps nécessaire';

  @override
  String get cookies => '5. Cookies et technologies similaires';

  @override
  String get cookiesContent =>
      'L\'application peut utiliser :\n\n• **Cookies locaux** : Pour sauvegarder vos préférences de jeu\n• **Identifiants publicitaires** : Pour personnaliser les publicités\n• **Analytics** : Pour comprendre l\'utilisation de l\'application\n\nVous pouvez désactiver ces fonctionnalités dans les paramètres de votre appareil.';

  @override
  String get thirdPartyAds => '7. Publicités et partenaires tiers';

  @override
  String get thirdPartyAdsContent =>
      'L\'application peut afficher des publicités via des partenaires tiers comme Google AdMob. Ces partenaires peuvent collecter des informations pour personnaliser les publicités. Vous pouvez :\n\n• Désactiver la personnalisation des publicités dans les paramètres\n• Utiliser les paramètres de confidentialité de votre appareil\n• Contacter directement les partenaires publicitaires';

  @override
  String get minorsData => '8. Données des mineurs';

  @override
  String get minorsDataContent =>
      'Mind Bloom ne collecte pas sciemment d\'informations personnelles d\'enfants de moins de 13 ans. Si nous découvrons qu\'un enfant de moins de 13 ans nous a fourni des informations personnelles, nous les supprimerons immédiatement.';

  @override
  String get policyChanges => '9. Modifications de cette politique';

  @override
  String get policyChangesContent =>
      'Nous pouvons modifier cette politique de confidentialité à tout moment. Les modifications importantes seront communiquées via l\'application ou par email. Nous vous encourageons à consulter régulièrement cette politique.';

  @override
  String get legalBasis => '10. Base légale du traitement';

  @override
  String get legalBasisContent =>
      'Nous traitons vos données personnelles sur la base de :\n\n• **Exécution du contrat** : Pour fournir le service de jeu\n• **Intérêt légitime** : Pour améliorer l\'application et prévenir la fraude\n• **Consentement** : Pour les publicités personnalisées et les communications marketing';

  @override
  String get contactDPO => 'Contact et DPO';

  @override
  String get contactDPOContent =>
      'Pour toute question concernant cette politique de confidentialité ou pour exercer vos droits, contactez-nous :';

  @override
  String get responseTime =>
      'Nous nous engageons à répondre à votre demande dans un délai de 30 jours.';

  @override
  String get introduction => 'Introduction';

  @override
  String get account => 'Compte';

  @override
  String get enterNewUsername => 'Entrez le nouveau nom d\'utilisateur';

  @override
  String get theme => 'Thème';

  @override
  String get lightTheme => 'Clair';

  @override
  String get darkTheme => 'Sombre';

  @override
  String get systemTheme => 'Système';

  @override
  String get themeDescription => 'Choisissez votre thème préféré';

  @override
  String get shareProfileMessage =>
      'Découvrez mes progrès dans Mind Bloom ! Pouvez-vous battre mon score ?';

  @override
  String get levelsCompleted => 'Niveaux Terminés';

  @override
  String get watchAdForLifeDescription =>
      'Regardez une courte vidéo pour gagner une vie et continuer à jouer !';

  @override
  String get earnOneLife => 'Gagner 1 Vie';

  @override
  String get lifeEarned => 'Vie gagnée ! Vous pouvez continuer à jouer.';

  @override
  String get noAdAvailable =>
      'Aucune pub disponible pour le moment. Veuillez réessayer plus tard.';

  @override
  String get adError =>
      'Erreur lors du chargement de la pub. Veuillez réessayer.';
}
