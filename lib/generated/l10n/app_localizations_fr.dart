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
  String get coins => 'Pièces';

  @override
  String get gems => 'Gemmes';

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
  String get save => 'Sauvegarder';

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

    return 'Niveau $idString échoué';
  }

  @override
  String get gamePaused => 'Jeu en pause';

  @override
  String get whatWouldYouLikeToDo => 'Que souhaitez-vous faire ?';

  @override
  String get freeLife => 'Vie gratuite';

  @override
  String get watchAdForLife =>
      'Regardez une publicité pour obtenir une vie gratuite !';

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
  String get currentStreak => 'Série Actuelle';

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
  String get usernameUpdated => 'Nom d\'utilisateur mis à jour';

  @override
  String get world => 'Monde';

  @override
  String levelCompleted(int id) {
    final intl.NumberFormat idNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String idString = idNumberFormat.format(id);

    return 'Niveau $idString terminé !';
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
    return 'Bonus';
  }

  @override
  String get active => 'Actifs';

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
      'Terminez les niveaux précédents pour débloquer celui-ci.';

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
  String get analyzeUsage => 'Analyser les habitudes d\'utilisation';

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
  String get dataSharing => 'Partage de données';

  @override
  String get dataSharingDescription =>
      'Nous ne vendons, n\'échangeons ou ne transférons pas vos informations personnelles à des tiers sans votre consentement, sauf comme décrit dans cette politique.';

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
      'Retirer votre consentement au traitement des données';

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
      'Vous n\'avez plus de vies. Regardez une publicité pour obtenir une vie gratuite, attendez qu\'elles se rechargent ou achetez-en plus.';

  @override
  String get wait => 'Attendre';

  @override
  String get noLevelLoaded => 'Aucun niveau chargé';

  @override
  String get backToMenu => 'Retour au menu';

  @override
  String get youHaveUsedAllMoves => 'Vous avez utilisé tous vos coups';

  @override
  String get aboutTheGame => 'À propos du jeu';

  @override
  String get flutterDeveloper => 'Développeur Flutter';

  @override
  String get readOurTermsOfService => 'Lire nos conditions d\'utilisation';

  @override
  String get discoverHowWeProtectYourData =>
      'Découvrez comment nous protégeons vos données';

  @override
  String get movesRemaining => 'Coups restants';

  @override
  String get noMovesPossible =>
      'Aucun coup possible. Utilisez le bouton mélanger !';

  @override
  String get activeEvent => 'ÉVÉNEMENT ACTIF';

  @override
  String daysRemaining(int count) {
    return '$count jours restants';
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
  String get plant => 'Plante';

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
  String get pop => 'Éclater';

  @override
  String notEnoughCurrency(String currency) {
    return 'Pas assez de $currency';
  }

  @override
  String purchaseSuccess(String item) {
    return 'Achat réussi : $item';
  }

  @override
  String get lives5 => '5 Vies';

  @override
  String get lives5Description => 'Pack de vies';

  @override
  String get lives10 => '10 Vies';

  @override
  String get lives10Description => 'Pack de vies';

  @override
  String get coins100 => '100 Pièces';

  @override
  String get coins100Description => 'Petit pack de pièces';

  @override
  String get coins500 => '500 Pièces';

  @override
  String get coins500Description => 'Pack moyen de pièces';

  @override
  String get coins1000 => '1000 Pièces';

  @override
  String get coins1000Description => 'Grand pack de pièces';

  @override
  String get gems50 => '50 Gemmes';

  @override
  String get gems50Description => 'Pack de gemmes';

  @override
  String get shuffler => 'Mélangeur';

  @override
  String get shufflerDescription => 'Mélange les tuiles sur la grille';

  @override
  String get hintDescription => 'Révèle un coup possible';

  @override
  String get removeAds => 'Supprimer les pubs';

  @override
  String get removeAdsDescription =>
      'Supprime toutes les publicités de l\'application';

  @override
  String plantLevel(int level) {
    return 'Niveau $level';
  }

  @override
  String get unlockCondition => 'Condition de déverrouillage';

  @override
  String get bonuses => 'Bonus';

  @override
  String extraMoves(int value) {
    return '+$value coups supplémentaires';
  }

  @override
  String get scoreMultiplier => 'Multiplicateur de score';

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
  String get inProgress => 'EN COURS';

  @override
  String rewardClaimedMessage(String achievementTitle) {
    return 'Récompense pour $achievementTitle réclamée !';
  }

  @override
  String get confirmedBeginner => 'Débutant Confirmé';

  @override
  String get confirmedBeginnerDescription => 'Terminez 10 niveaux';

  @override
  String get expertInTheMaking => 'Expert en Formation';

  @override
  String get expertInTheMakingDescription => 'Terminez 50 niveaux';

  @override
  String get perfectionist => 'Perfectionniste';

  @override
  String get perfectionistDescription => 'Terminez un niveau avec 3 étoiles';

  @override
  String get scorer => 'Marqueur';

  @override
  String get scorerDescription => 'Marquez 1 000 points en un niveau';

  @override
  String get scoreMaster => 'Maître du Score';

  @override
  String get scoreMasterDescription => 'Marquez 5 000 points en un niveau';

  @override
  String get accumulator => 'Accumulateur';

  @override
  String get accumulatorDescription => 'Marquez un total de 100 000 points';

  @override
  String get beginnerBotanist => 'Botaniste Débutant';

  @override
  String get beginnerBotanistDescription => 'Débloquez votre première plante';

  @override
  String get collector => 'Collectionneur';

  @override
  String get collectorDescription => 'Débloquez 5 plantes';

  @override
  String get rarityHunter => 'Chasseur de Rareté';

  @override
  String get rarityHunterDescription =>
      'Débloquez une plante 4 étoiles ou plus';

  @override
  String get comboMaster => 'Maître des Combos';

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
  String get loyalDescription => 'Connectez-vous 7 jours d\'affilée';

  @override
  String get sharer => 'Partageur';

  @override
  String get sharerDescription => 'Partagez votre score 3 fois';

  @override
  String userLevel(int level) {
    return 'Niveau $level';
  }

  @override
  String get completedLevels => 'Niveaux Terminés';

  @override
  String get detailedStats => 'Statistiques Détaillées';

  @override
  String get totalCoins => 'Pièces Totales';

  @override
  String get starsEarned => 'Étoiles Gagnées';

  @override
  String get highestLevel => 'Niveau le Plus Élevé';

  @override
  String get quickActions => 'Actions Rapides';

  @override
  String get reviewTutorial => 'Revoir le Tutoriel';

  @override
  String get shareProfile => 'Partager le Profil';

  @override
  String get recentAchievements => 'Réalisations Récentes';

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
  String get shareComingSoon => 'Le partage arrive bientôt...';

  @override
  String get acceptanceOfTerms => '1. Acceptation des Conditions';

  @override
  String get acceptanceOfTermsContent =>
      'En utilisant l\'application Mind Bloom, vous acceptez d\'être lié par ces conditions d\'utilisation. Si vous n\'acceptez pas ces conditions, veuillez ne pas utiliser notre application.';

  @override
  String get serviceDescription => '2. Description du Service';

  @override
  String get serviceDescriptionContent =>
      'Mind Bloom est un jeu de puzzle mobile développé par YACOUBA SANTARA. L\'application propose des mécaniques de match-3 avec des éléments de progression RPG dans un univers de jardin magique.';

  @override
  String get authorizedUse => '3. Usage Autorisé';

  @override
  String get authorizedUseContent =>
      'Vous pouvez utiliser Mind Bloom uniquement à des fins personnelles et non commerciales. Il est interdit de :\n\n• Copier, modifier ou distribuer l\'application\n• Utiliser l\'application à des fins commerciales sans autorisation\n• Tenter de contourner les mesures de sécurité\n• Utiliser l\'application d\'une manière qui nuit aux autres utilisateurs';

  @override
  String get intellectualProperty => '4. Contenu et Propriété Intellectuelle';

  @override
  String get intellectualPropertyContent =>
      'Tous les éléments de Mind Bloom, y compris mais sans s\'y limiter aux graphismes, sons, code source et design, sont la propriété exclusive de YACOUBA SANTARA et sont protégés par les lois sur le droit d\'auteur.';

  @override
  String get inAppPurchases => '5. Achats In-App';

  @override
  String get inAppPurchasesContent =>
      'L\'application peut contenir des achats in-app pour des vies supplémentaires, des boosters ou d\'autres éléments de jeu. Tous les achats sont finaux et non remboursables, sauf si la loi applicable l\'exige.';

  @override
  String get advertisements => '6. Publicités';

  @override
  String get advertisementsContent =>
      'Mind Bloom peut afficher des publicités de tiers. Ces publicités sont gérées par des partenaires publicitaires et nous ne sommes pas responsables du contenu de ces publicités.';

  @override
  String get liabilityLimitation => '7. Limitation de Responsabilité';

  @override
  String get liabilityLimitationContent =>
      'L\'application est fournie \'en l\'état\' sans garantie d\'aucune sorte. Nous ne serons pas responsables des dommages directs, indirects, accessoires ou consécutifs résultant de l\'utilisation de l\'application.';

  @override
  String get termsModifications => '8. Modifications des Conditions';

  @override
  String get termsModificationsContent =>
      'Nous nous réservons le droit de modifier ces conditions d\'utilisation à tout moment. Les modifications prendront effet dès leur publication dans l\'application. Votre utilisation continue de l\'application constitue votre acceptation des conditions modifiées.';

  @override
  String get termination => '9. Résiliation';

  @override
  String get terminationContent =>
      'Nous nous réservons le droit de suspendre ou de résilier votre accès à l\'application à tout moment, sans préavis, en cas de violation de ces conditions d\'utilisation.';

  @override
  String get applicableLaw => '10. Droit Applicable';

  @override
  String get applicableLawContent =>
      'Ces conditions d\'utilisation sont régies par le droit français. Tout litige sera soumis à la juridiction exclusive des tribunaux français.';

  @override
  String get contact => 'Contact';

  @override
  String get contactContent =>
      'Pour toute question concernant ces conditions d\'utilisation, vous pouvez nous contacter à :';

  @override
  String get dataStorage => '4. Stockage et Sécurité des Données';

  @override
  String get dataStorageContent =>
      'Vos données sont stockées en sécurité :\\n\\n• Chiffrement : Les données sensibles sont chiffrées\\n• Accès Limité : Seul le personnel autorisé peut accéder aux données\\n• Sauvegarde : Des sauvegardes régulières sont effectuées\\n• Durée : Les données ne sont conservées que le temps nécessaire';

  @override
  String get cookies => '5. Cookies et Technologies Similaires';

  @override
  String get cookiesContent =>
      'L\'application peut utiliser :\n\n• Cookies Locaux : Pour sauvegarder vos préférences de jeu\n• Identifiants Publicitaires : Pour personnaliser les publicités\n• Analyses : Pour comprendre l\'utilisation de l\'application\n\nVous pouvez désactiver ces fonctionnalités dans les paramètres de votre appareil.';

  @override
  String get thirdPartyAds => '7. Publicités et Partenaires Tiers';

  @override
  String get thirdPartyAdsContent =>
      'L\'application peut afficher des publicités via des partenaires tiers comme Google AdMob. Ces partenaires peuvent collecter des informations pour personnaliser les publicités. Vous pouvez :\n\n• Désactiver la personnalisation des publicités dans les paramètres\n• Utiliser les paramètres de confidentialité de votre appareil\n• Contacter directement les partenaires publicitaires';

  @override
  String get minorsData => '8. Données des Mineurs';

  @override
  String get minorsDataContent =>
      'Mind Bloom ne collecte pas sciemment d\'informations personnelles d\'enfants de moins de 13 ans. Si nous découvrons qu\'un enfant de moins de 13 ans nous a fourni des informations personnelles, nous les supprimerons immédiatement.';

  @override
  String get policyChanges => '9. Modifications de cette Politique';

  @override
  String get policyChangesContent =>
      'Nous pouvons modifier cette politique de confidentialité à tout moment. Les modifications importantes seront communiquées via l\'application ou par e-mail. Nous vous encourageons à consulter régulièrement cette politique.';

  @override
  String get legalBasis => '10. Base Légale du Traitement';

  @override
  String get legalBasisContent =>
      'Nous traitons vos données personnelles sur la base de :\n\n• Exécution du Contrat : Pour fournir le service de jeu\n• Intérêt Légitime : Pour améliorer l\'application et prévenir la fraude\n• Consentement : Pour les publicités personnalisées et les communications marketing';

  @override
  String get contactDPO => 'Contact et DPO';

  @override
  String get contactDPOContent =>
      'Pour toute question concernant cette politique de confidentialité ou pour exercer vos droits, contactez-nous :';

  @override
  String get responseTime =>
      'Nous nous engageons à répondre à votre demande dans les 30 jours.';

  @override
  String get introduction => 'Introduction';

  @override
  String get account => 'Compte';

  @override
  String get enterNewUsername => 'Entrez un nouveau nom d\'utilisateur';

  @override
  String get theme => 'Thème';

  @override
  String get lightTheme => 'Clair';

  @override
  String get darkTheme => 'Sombre';

  @override
  String get systemTheme => 'Système';

  @override
  String get themeDescription => 'Choisissez entre thème clair et sombre';

  @override
  String get shareProfileMessage =>
      'Découvrez mes progrès dans Mind Bloom ! Pouvez-vous battre mon score ?';

  @override
  String get levelsCompleted => 'Niveaux Terminés';

  @override
  String get watchAdForLifeDescription =>
      'Regardez une courte vidéo pour gagner une vie et continuer à jouer !';

  @override
  String get earnOneLife => 'Gagnez 1 Vie';

  @override
  String get lifeEarned => 'Vie gagnée ! Vous pouvez continuer à jouer.';

  @override
  String get noAdAvailable =>
      'Aucune pub disponible pour le moment. Veuillez réessayer plus tard.';

  @override
  String get adError =>
      'Erreur lors du chargement de la pub. Veuillez réessayer.';

  @override
  String get timeRemaining => 'Temps';

  @override
  String get nextLife => 'Prochaine vie';

  @override
  String get watchAdForFreeLife =>
      'Regardez une pub pour obtenir une vie gratuite !';

  @override
  String get dailyRewards => 'Récompenses Quotidiennes';

  @override
  String get claimReward => 'Réclamer !';

  @override
  String get rewardAlreadyClaimed => 'Récompense déjà réclamée';

  @override
  String get nextRewardIn => 'Prochaine récompense dans :';

  @override
  String get howItWorks => 'Comment ça marche ?';

  @override
  String get dailyRewardInfo1 =>
      'Connectez-vous chaque jour pour réclamer votre récompense';

  @override
  String get dailyRewardInfo2 =>
      'Plus votre série est longue, meilleures sont les récompenses';

  @override
  String get dailyRewardInfo3 => 'Le 7ème jour offre une récompense légendaire';

  @override
  String get dailyRewardInfo4 => 'Les récompenses se réinitialisent à minuit';

  @override
  String rewardOfDay(int day) {
    return 'Récompense du Jour $day';
  }

  @override
  String get legendaryStreak => 'Série Légendaire !';

  @override
  String get perfectPerformance => 'Performance Parfaite! Bonus x2';

  @override
  String get milestoneLevel => 'Niveau Milestone! Bonus spécial';

  @override
  String get rewardsClaimed => 'Récompenses obtenues';

  @override
  String comboBonus(int multiplier) {
    return 'Bonus Combo x$multiplier';
  }

  @override
  String get spectacularCombo => 'Combo Spectaculaire !';

  @override
  String megaMatch(int count) {
    return 'Méga Match de $count tuiles !';
  }

  @override
  String get globalProgress => 'Progression globale';

  @override
  String collectTilesObjective(int count, String tileName) {
    return 'Collectez $count $tileName';
  }

  @override
  String clearBlockersObjective(int count) {
    return 'Détruisez $count bloqueurs';
  }

  @override
  String reachScoreObjective(int count) {
    return 'Atteignez $count points';
  }

  @override
  String freeCreatureObjective(int count) {
    return 'Libérez $count créatures';
  }

  @override
  String clearJellyObjective(int count) {
    return 'Détruisez $count gelées';
  }

  @override
  String get coinsBonus => 'Bonus Pièces';

  @override
  String get gemsGratuits => 'Gemmes Gratuites';

  @override
  String get watchAdForCoins => 'Regardez une pub pour obtenir des pièces';

  @override
  String get watchAdForGems => 'Regardez une pub pour obtenir des gemmes';

  @override
  String get watchButton => 'REGARDER';

  @override
  String get debugUnlockAllLevels => 'Déverrouiller tous les niveaux (DEBUG)';

  @override
  String get debugUnlockAllLevelsDescription =>
      'Fonction de test pour déverrouiller tous les niveaux';

  @override
  String get shareScore => 'Partager le score';

  @override
  String get shareScoreTitle => 'Partager mon score';

  @override
  String shareScoreMessage(int score, int level) {
    return 'J\'ai obtenu $score points au niveau $level dans Mind Bloom ! Peux-tu faire mieux ? 🌱';
  }

  @override
  String get shareScoreSuccess => 'Score partagé avec succès !';

  @override
  String get shareScoreError => 'Erreur lors du partage du score';

  @override
  String get quit => 'Quitter';

  @override
  String get winterSolstice => 'Solstice d\'Hiver';

  @override
  String get winterSolsticeDescription =>
      'Éclairez la nuit avec des cristaux de glace';

  @override
  String get valentineDay => 'Jour de la Saint-Valentin';

  @override
  String get valentineDayDescription =>
      'Partagez l\'amour avec des fleurs romantiques';

  @override
  String get shareAchievements => 'Partageur de Badges';

  @override
  String get shareAchievementsDescription =>
      'Partagez 5 achievements avec vos amis';

  @override
  String get socialButterfly => 'Papillon Social';

  @override
  String get socialButterflyDescription =>
      'Partagez 10 achievements avec vos amis';

  @override
  String get shareThisBadge => 'Partager ce badge';

  @override
  String get shareMyAchievements => 'Partager mes achievements';

  @override
  String badgeShared(String badgeTitle) {
    return 'Badge \"$badgeTitle\" partagé ! 🎉';
  }

  @override
  String get achievementsShared => 'Mes achievements partagés ! 🎉';

  @override
  String get newWorldUnlocked => 'Nouveau Monde Débloqué';

  @override
  String get continueGame => 'Continuer';

  @override
  String livesLimitedToMax(int actualAdded, int maxLives) {
    return 'Seulement $actualAdded vies ajoutées (limite: $maxLives vies)';
  }

  @override
  String get easterEvent => 'Pâques Magique';

  @override
  String get easterEventDescription => 'Découvrez des œufs magiques cachés';

  @override
  String get halloweenEvent => 'Halloween Enchanté';

  @override
  String get halloweenEventDescription =>
      'Plantez des citrouilles mystérieuses';

  @override
  String get christmasEvent => 'Noël Féerique';

  @override
  String get christmasEventDescription =>
      'Décorez votre jardin avec des étoiles de Noël';

  @override
  String get newYearEvent => 'Nouvel An Luminieux';

  @override
  String get newYearEventDescription =>
      'Commencez l\'année avec des feux d\'artifice magiques';

  @override
  String get thanksgivingEvent => 'Action de Grâce';

  @override
  String get thanksgivingEventDescription =>
      'Récoltez l\'abondance avec gratitude';

  @override
  String get motherDayEvent => 'Fête des Mères';

  @override
  String get motherDayEventDescription =>
      'Offrez des fleurs en hommage aux mères';

  @override
  String get fatherDayEvent => 'Fête des Pères';

  @override
  String get fatherDayEventDescription =>
      'Cultivez la force avec des plantes robustes';

  @override
  String get springCleaningEvent => 'Nettoyage de Printemps';

  @override
  String get springCleaningEventDescription =>
      'Rafraîchissez votre jardin pour une nouvelle saison';

  @override
  String get summerFestivalEvent => 'Festival d\'Été';

  @override
  String get summerFestivalEventDescription =>
      'Grand festival estival avec de nombreuses récompenses';

  @override
  String get harvestFestivalEvent => 'Festival de la Récolte';

  @override
  String get harvestFestivalEventDescription =>
      'Célébrez l\'abondance de l\'automne';

  @override
  String get winterFestivalEvent => 'Festival d\'Hiver';

  @override
  String get winterFestivalEventDescription =>
      'Éclairez la saison sombre avec des cristaux';

  @override
  String get specialUpdateEvent => 'Mise à Jour Spéciale';

  @override
  String get specialUpdateEventDescription =>
      'Découvrez de nouvelles fonctionnalités';

  @override
  String get communityChallengeEvent => 'Défi Communautaire';

  @override
  String get communityChallengeEventDescription =>
      'Relevez des défis avec toute la communauté';

  @override
  String get limitedTimeEvent => 'Événement à Durée Limitée';

  @override
  String get limitedTimeEventDescription =>
      'Profitez de cet événement unique avant qu\'il ne disparaisse';

  @override
  String get birthdayEvent => 'Anniversaire de Mind Bloom';

  @override
  String get birthdayEventDescription =>
      'Célébrez un an de Mind Bloom avec des surprises';

  @override
  String get milestoneEvent => 'Événement Milestone';

  @override
  String get milestoneEventDescription => 'Célébrez les grandes étapes du jeu';

  @override
  String get earthDayEvent => 'Jour de la Terre';

  @override
  String get earthDayEventDescription =>
      'Protégez la nature avec des plantes écologiques';

  @override
  String get independenceDayEvent => 'Fête Nationale';

  @override
  String get independenceDayEventDescription =>
      'Célébrez avec des plantes patriotiques';

  @override
  String completeActions(int target, String actionType) {
    return 'Effectuez $target actions $actionType';
  }

  @override
  String playConsecutiveDays(int target) {
    return 'Jouez $target jours consécutifs';
  }

  @override
  String completeLevelsWithStars(int target, int stars) {
    return 'Terminez $target niveaux avec $stars étoiles';
  }

  @override
  String completeQuests(int target, String questType) {
    return 'Terminez $target quêtes $questType';
  }

  @override
  String collectItems(int target, String itemType) {
    return 'Collectez $target objets $itemType';
  }

  @override
  String completeLevelsInDays(int target, int days) {
    return 'Terminez $target niveaux en $days jours';
  }

  @override
  String giveGifts(int target) {
    return 'Offrez $target cadeaux';
  }

  @override
  String get exploreNewFeatures => 'Explorez les nouvelles fonctionnalités';

  @override
  String get loadingEvents => 'Chargement des événements...';

  @override
  String get activeEvents => 'Événements Actifs';

  @override
  String get thisMonth => 'Ce Mois';

  @override
  String get upcomingEvents => 'Événements à Venir';

  @override
  String get lastDay => 'Dernier jour';

  @override
  String daysLeft(int count) {
    return '$count jours';
  }

  @override
  String inDays(int count) {
    return 'Dans $count jours';
  }

  @override
  String get finished => 'Terminé';

  @override
  String challengesCount(int count) {
    return 'Défis ($count)';
  }

  @override
  String get eventStatistics => 'Statistiques des Événements';

  @override
  String get filterEvents => 'Filtrer les événements';

  @override
  String get filterFeatureComingSoon => 'Fonctionnalité de filtrage à venir...';

  @override
  String participatingInEvent(String eventName) {
    return 'Participation à \"$eventName\" en cours...';
  }

  @override
  String get fullLives => 'Vies complètes';

  @override
  String get refillAllLives => 'Remplit toutes vos vies (5/5)';

  @override
  String get threeLives => '3 Vies';

  @override
  String get addThreeLives => 'Ajoute 3 vies (max 5 vies)';

  @override
  String get twoHundredCoins => '200 Pièces';

  @override
  String get smallCoinBoost => 'Un petit boost de pièces';

  @override
  String get fiveHundredCoins => '500 Pièces';

  @override
  String get goodCoinStock => 'Un bon stock de pièces';

  @override
  String get thousandCoins => '1000 Pièces';

  @override
  String get bigCoinStock => 'Un gros stock de pièces';

  @override
  String get twentyFiveGems => '25 Gemmes';

  @override
  String get preciousGems => 'Gemmes précieuses pour les achats premium';

  @override
  String get shuffleGrid => 'Mélange la grille pour de nouveaux mouvements';

  @override
  String get revealWinningMove => 'Révèle un mouvement gagnant';

  @override
  String get bonusMoves => 'Mouvements bonus';

  @override
  String get fiveExtraMoves => '+5 mouvements pour le niveau actuel';

  @override
  String get doubleScoreThreeLevels => 'x2 score pendant 3 niveaux';

  @override
  String get experienceBoost => 'Boost d\'expérience';

  @override
  String get hundredXpBoost => '+100 XP pour progresser plus vite';

  @override
  String get skipLevel => 'Passer un niveau';

  @override
  String get unlockNextLevel => 'Débloque le niveau suivant';

  @override
  String get unlockAllLevels => 'Débloquer tous les niveaux';

  @override
  String get accessAllLevels => 'Accès à tous les niveaux du jeu';

  @override
  String get natureTheme => 'Thème Nature';

  @override
  String get natureThemeDescription =>
      'Nouveau thème visuel avec des couleurs naturelles';

  @override
  String get oceanTheme => 'Thème Océan';

  @override
  String get oceanThemeDescription =>
      'Thème aquatique avec des couleurs bleues';

  @override
  String get goldFrame => 'Cadre doré';

  @override
  String get goldFrameDescription => 'Cadre doré pour votre avatar';

  @override
  String get playWithoutAds => 'Jouez sans interruption publicitaire';

  @override
  String get premiumPack => 'Pack Premium';

  @override
  String get allPremiumBenefits => 'Tous les avantages premium + 100 gemmes';

  @override
  String get cosmetics => 'Cosmétiques';

  @override
  String get freeRewards => '🎁 Récompenses Gratuites';

  @override
  String get world_garden_beginnings => 'Jardin des Débuts';

  @override
  String get world_garden_beginnings_description =>
      'Commencez votre aventure dans ce jardin paisible où les premières graines de votre voyage prennent vie.';

  @override
  String get world_valley_flowers => 'Vallée des Fleurs';

  @override
  String get world_valley_flowers_description =>
      'Explorez une vallée colorée où fleurissent les plus belles créations de la nature.';

  @override
  String get world_lunar_forest => 'Forêt Lunaire';

  @override
  String get world_lunar_forest_description =>
      'Plongez dans l\'obscurité mystérieuse de cette forêt baignée par la lumière lunaire.';

  @override
  String get world_solar_meadow => 'Prairie Solaire';

  @override
  String get world_solar_meadow_description =>
      'Baignez-vous dans la chaleur bienfaisante de cette prairie dorée par le soleil.';

  @override
  String get world_crystal_caverns => 'Cavernes Cristallines';

  @override
  String get world_crystal_caverns_description =>
      'Découvrez les trésors cachés dans ces grottes scintillantes de cristaux précieux.';

  @override
  String get world_mystic_swamps => 'Marécages Mystiques';

  @override
  String get world_mystic_swamps_description =>
      'Naviguez dans les eaux troubles de ces marécages emplis de magie ancienne.';

  @override
  String get world_burning_lands => 'Terres Ardentes';

  @override
  String get world_burning_lands_description =>
      'Survivez à la chaleur intense de ces terres volcaniques en éruption permanente.';

  @override
  String get world_eternal_glacier => 'Glacier Éternel';

  @override
  String get world_eternal_glacier_description =>
      'Bravez le froid glacial de ces étendues blanches immaculées.';

  @override
  String get world_lost_rainbow => 'Arc-en-Ciel Perdu';

  @override
  String get world_lost_rainbow_description =>
      'Retrouvez les couleurs perdues de cet arc-en-ciel légendaire aux teintes magiques.';

  @override
  String get world_celestial_garden => 'Jardin Céleste';

  @override
  String get world_celestial_garden_description =>
      'Accédez au jardin ultime où les étoiles fleurissent et les rêves deviennent réalité.';

  @override
  String get worlds => 'Mondes';

  @override
  String get levels => 'Niveaux';

  @override
  String get enter => 'Entrer';

  @override
  String get tutorial_welcome_title => 'Bienvenue dans Mind Bloom !';

  @override
  String get tutorial_welcome_description =>
      'Découvrez le monde magique des plantes et des puzzles';

  @override
  String get tutorial_matching_title => 'Faites des correspondances';

  @override
  String get tutorial_matching_description =>
      'Échangez les tuiles pour créer des lignes de 3 ou plus de la même couleur';

  @override
  String get tutorial_objectives_title => 'Objectifs du niveau';

  @override
  String get tutorial_objectives_description =>
      'Chaque niveau a des objectifs spécifiques à atteindre pour progresser';

  @override
  String get tutorial_hint_title => 'Bouton Indice';

  @override
  String get tutorial_hint_description =>
      'Utilisez l\'indice pour révéler un mouvement gagnant quand vous êtes bloqué';

  @override
  String get tutorial_shuffle_title => 'Bouton Mélanger';

  @override
  String get tutorial_shuffle_description =>
      'Mélangez la grille pour obtenir de nouveaux mouvements possibles';

  @override
  String get tutorial_stars_title => 'Gagnez des étoiles';

  @override
  String get tutorial_stars_description =>
      'Plus vous atteignez d\'objectifs, plus vous gagnez d\'étoiles';

  @override
  String get tutorial_collection_title => 'Collection de plantes';

  @override
  String get tutorial_collection_description =>
      'Débloquez de nouvelles plantes magiques avec des bonus spéciaux';

  @override
  String get tutorial_skip => 'Passer';

  @override
  String get tutorial_next => 'Suivant';

  @override
  String get tutorial_start => 'Commencer';

  @override
  String get tutorial_complete => 'Tutoriel terminé !';

  @override
  String get tutorial_complete_description =>
      'Vous êtes maintenant prêt à explorer le monde de Mind Bloom !';

  @override
  String get tutorial_skip_confirmation_title => 'Passer le tutoriel ?';

  @override
  String get tutorial_skip_confirmation_message =>
      'Êtes-vous sûr de vouloir passer le tutoriel ? Vous pourrez le revoir plus tard dans les paramètres.';

  @override
  String get world_completed_title =>
      'Monde Complété & Nouveau Monde Déverrouillé !';

  @override
  String get world_completed_only_title => 'Monde Complété !';

  @override
  String get world_completed_message =>
      'Félicitations ! Vous avez complété ce monde et déverrouillé un nouveau monde !';

  @override
  String get world_completed_only_message =>
      'Félicitations ! Vous avez maîtrisé tous les défis de ce monde avec brio !';

  @override
  String new_world_unlocked(String worldName) {
    return 'Nouveau monde déverrouillé : $worldName';
  }

  @override
  String get rare_items_unlocked => 'Objets Rares Débloqués !';

  @override
  String get completion_rewards => 'Récompenses de Completion';

  @override
  String get unlock_bonus => 'Bonus de déverrouillage : +5 Gemmes';

  @override
  String get back_to_menu => 'Retour au Menu';

  @override
  String get explore_new_world => 'Explorer le Nouveau Monde';

  @override
  String get continue_text => 'Continuer';

  @override
  String get new_world => 'Nouveau Monde';

  @override
  String get next_world => 'Monde Suivant';

  @override
  String get claim_rewards => 'Réclamer les récompenses';

  @override
  String get complete_all_challenges =>
      'Complétez tous les challenges pour réclamer les récompenses !';

  @override
  String get rewards_already_claimed =>
      'Récompenses déjà réclamées pour cet événement !';

  @override
  String get congratulations => 'Félicitations !';

  @override
  String get you_earned => 'Vous avez gagné :';

  @override
  String get awesome => 'Super !';

  @override
  String get check_your_collection =>
      'Vérifiez votre collection pour voir vos nouvelles plantes !';

  @override
  String get view => 'Voir';

  @override
  String get uncommon => 'Peu commun';

  @override
  String get see_worlds => 'Voir les mondes';

  @override
  String get continueButton => 'Continuer';

  @override
  String get reward_obtained => 'Récompense obtenue !';

  @override
  String get free_lives => 'Vies Gratuites';

  @override
  String get reset_data => 'Réinitialiser les données';

  @override
  String get share_continue => 'Partager et Continuer';

  @override
  String get achievement_copied =>
      '🎉 Succès copié ! Partagez votre réussite !';

  @override
  String get sharing_error => 'Erreur lors du partage';

  @override
  String get claim_error => 'Erreur lors de la réclamation';

  @override
  String get plant_lotus_cristal_description =>
      'Un lotus qui purifie l\'eau et augmente la fortune';

  @override
  String get plant_tournesol_or_name => 'Tournesol Doré';

  @override
  String get plant_rose_magique_name => 'Rose Magique';

  @override
  String get plant_lotus_cristal_name => 'Lotus de Cristal';

  @override
  String get plant_tulipe_arc_name => 'Tulipe Arc-en-ciel';

  @override
  String get plant_orchidee_lune_name => 'Orchidée de Lune';

  @override
  String get plant_marguerite_etoile_name => 'Marguerite Étoilée';

  @override
  String get plant_violette_mystique_name => 'Violette Mystique';

  @override
  String get plant_jasmin_eternel_name => 'Jasmin Éternel';

  @override
  String get plant_petunia_cosmique_name => 'Pétunia Cosmique';

  @override
  String get plant_lys_phoenix_name => 'Lys du Phénix';

  @override
  String get plant_cactus_temporel_name => 'Cactus Temporel';

  @override
  String get plant_rose_eternelle_name => 'Rose Éternelle du Jardin';

  @override
  String get plant_lotus_paradis_name => 'Lotus du Paradis des Fleurs';

  @override
  String get plant_orchidee_lunaire_name => 'Orchidée Lunaire Mystique';

  @override
  String get plant_tournesol_solaire_name => 'Tournesol du Pré Solaire';

  @override
  String get plant_cristal_vegetal_name => 'Cristal Végétal des Cavernes';

  @override
  String get plant_nymphaea_mystique_name => 'Nymphaea des Marais Mystiques';

  @override
  String get plant_flamme_vegetale_name =>
      'Flamme Végétale des Terres Ardentes';

  @override
  String get plant_glace_eternelle_name => 'Glace Éternelle du Glacier';

  @override
  String get plant_arc_en_ciel_perdu_name => 'Arc-en-ciel Perdu';

  @override
  String get plant_jardin_celeste_name => 'Jardin Céleste Ultime';

  @override
  String get plant_tournesol_or_description =>
      'Un tournesol qui suit le soleil';

  @override
  String get plant_marguerite_etoile_description =>
      'Une marguerite qui brille comme une étoile et guide les débutants';

  @override
  String get plant_violette_mystique_description =>
      'Une violette qui révèle les secrets cachés du jardin';

  @override
  String get plant_jasmin_eternel_description =>
      'Un jasmin dont le parfum transcende les dimensions temporelles';

  @override
  String get plant_petunia_cosmique_description =>
      'Un pétunia qui puise son énergie dans les étoiles';

  @override
  String get plant_orchidee_lune_description =>
      'Une orchidée qui fleurit la nuit';

  @override
  String get plant_tulipe_arc_description =>
      'Une tulipe aux couleurs changeantes';

  @override
  String get plant_rose_magique_description =>
      'Une rose magique qui pousse dans les jardins enchantés';

  @override
  String get plant_tournesol_solaire_description =>
      'Un tournesol qui absorbe l\'énergie solaire';

  @override
  String get plant_cristal_vegetal_description =>
      'Un cristal végétal qui brille de mille feux';

  @override
  String get plant_nymphaea_mystique_description =>
      'Un nénuphar mystique des eaux profondes';

  @override
  String get plant_flamme_vegetale_description =>
      'Une plante de feu qui résiste aux flammes';

  @override
  String get plant_glace_eternelle_description =>
      'Une plante de glace éternelle';

  @override
  String get plant_arc_en_ciel_perdu_description =>
      'Un arc-en-ciel perdu dans le jardin';

  @override
  String get plant_jardin_celeste_description =>
      'Un jardin céleste dans une plante';

  @override
  String get plant_lys_phoenix_description =>
      'Un lys qui renaît de ses cendres';

  @override
  String get plant_cactus_temporel_description =>
      'Un cactus qui voyage dans le temps';

  @override
  String get plant_rose_eternelle_description =>
      'Une rose éternelle qui ne se fane jamais';

  @override
  String get plant_lotus_paradis_description => 'Un lotus du paradis céleste';

  @override
  String get plant_orchidee_lunaire_description =>
      'Une orchidée qui fleurit sous la lune';
}
