// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Mind Bloom';

  @override
  String get home => 'Home';

  @override
  String get profile => 'Profile';

  @override
  String get collection => 'Collection';

  @override
  String get shop => 'Shop';

  @override
  String get settings => 'Settings';

  @override
  String get about => 'About';

  @override
  String get level => 'Level';

  @override
  String get score => 'Score';

  @override
  String get moves => 'Moves';

  @override
  String get lives => 'Lives';

  @override
  String coins(int quantity) {
    return '$quantity coins';
  }

  @override
  String gems(int count) {
    return '$count gems';
  }

  @override
  String get play => 'Play';

  @override
  String get pause => 'Pause';

  @override
  String get resume => 'Resume';

  @override
  String get restart => 'Restart';

  @override
  String get menu => 'Menu';

  @override
  String get hint => 'Hint';

  @override
  String get shuffle => 'Shuffle';

  @override
  String get next => 'Next';

  @override
  String get back => 'Back';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get save => 'Save';

  @override
  String get load => 'Load';

  @override
  String get reset => 'Reset';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get close => 'Close';

  @override
  String get ok => 'OK';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get loading => 'Loading...';

  @override
  String get error => 'Error';

  @override
  String get success => 'Achievements';

  @override
  String get warning => 'Warning';

  @override
  String get info => 'Information';

  @override
  String get noMovesAvailable => 'No moves available. Use the shuffle button!';

  @override
  String get levelComplete => 'Level Complete!';

  @override
  String levelFailed(int id) {
    final intl.NumberFormat idNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String idString = idNumberFormat.format(id);

    return 'Level $idString Failed';
  }

  @override
  String get gamePaused => 'Game paused';

  @override
  String get whatWouldYouLikeToDo => 'What would you like to do?';

  @override
  String get freeLife => 'Free Life';

  @override
  String get watchAdForLife => 'Watch Ad for Life';

  @override
  String get watchAd => 'Watch Ad';

  @override
  String get adInProgress => 'Ad in progress...';

  @override
  String get lifeObtained => 'Life obtained! You can continue playing.';

  @override
  String get music => 'Music';

  @override
  String get soundEffects => 'Sound Effects';

  @override
  String get animations => 'Animations';

  @override
  String get vibrations => 'Vibrations';

  @override
  String get autoHints => 'Auto Hints';

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get french => 'Français';

  @override
  String get version => 'Version';

  @override
  String get developer => 'Developer';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get readTermsOfService => 'Read the terms of service';

  @override
  String get readPrivacyPolicy => 'Read the privacy policy';

  @override
  String get aboutGame => 'About the game';

  @override
  String get gameDescription =>
      'Mind Bloom is a magical puzzle game that combines classic match-3 mechanics with RPG elements. Cultivate your enchanted garden by aligning colored tiles and discover a unique universe of progression and collection.';

  @override
  String get technologies => 'Technologies';

  @override
  String get legalInformation => 'Legal information';

  @override
  String get license => 'License';

  @override
  String get licenseText =>
      'This project is under MIT license. You are free to use, modify and distribute it according to the terms of this license.';

  @override
  String get acknowledgments => 'Acknowledgments';

  @override
  String get acknowledgmentsText =>
      'A big thank you to the Flutter community, the contributors of the packages used, and everyone who supported this project.';

  @override
  String get developedWithLove => 'Developed with ❤️ by';

  @override
  String get quote => '\"Cultivate your inner garden, one match at a time\"';

  @override
  String get username => 'Username';

  @override
  String get editUsername => 'Edit Username';

  @override
  String get currentStreak => 'Current Streak';

  @override
  String get bestStreak => 'Best Streak';

  @override
  String get days => 'days';

  @override
  String get saveData => 'Save data';

  @override
  String get restoreData => 'Restore data';

  @override
  String get resetData => 'Reset Data';

  @override
  String get saveProgress => 'Save your progress';

  @override
  String get restoreProgress => 'Restore your progress';

  @override
  String get deleteAllData => 'Delete all data (irreversible)';

  @override
  String get resetDataConfirmation =>
      'Are you sure you want to delete all your data? This action is irreversible.';

  @override
  String get dataReset => 'Data reset';

  @override
  String get dataSaved => 'Data saved successfully';

  @override
  String get dataRestored => 'Data restored successfully';

  @override
  String get saveError => 'Error saving data';

  @override
  String get restoreError => 'Error restoring data';

  @override
  String get usernameUpdated => 'Username updated successfully';

  @override
  String get world => 'World';

  @override
  String levelCompleted(int id) {
    final intl.NumberFormat idNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String idString = idNumberFormat.format(id);

    return 'Level $idString Completed!';
  }

  @override
  String get stars => 'Stars';

  @override
  String get movesUsed => 'Moves used';

  @override
  String get nextLevel => 'Next level';

  @override
  String get retry => 'Retry';

  @override
  String get objectives => 'Objectives';

  @override
  String collectTiles(int count, String type) {
    return 'Collect $count $type';
  }

  @override
  String reachScore(int score) {
    return 'Reach $score points';
  }

  @override
  String completeInMoves(int moves) {
    return 'Complete in $moves moves';
  }

  @override
  String get tileTypeFlower => 'Flower';

  @override
  String get tileTypeLeaf => 'Leaf';

  @override
  String get tileTypeCrystal => 'Crystal';

  @override
  String get tileTypeSeed => 'Seed';

  @override
  String get tileTypeDew => 'Dew';

  @override
  String get tileTypeSun => 'Sun';

  @override
  String get tileTypeMoon => 'Moon';

  @override
  String get tileTypeGem => 'Gem';

  @override
  String get achievements => 'Achievements';

  @override
  String get events => 'Events';

  @override
  String get tutorial => 'Tutorial';

  @override
  String get buy => 'Buy';

  @override
  String get price => 'Price';

  @override
  String get owned => 'Owned';

  @override
  String get plants => 'Plants';

  @override
  String get unlocked => 'Unlocked';

  @override
  String get locked => 'Locked';

  @override
  String get upgrade => 'Upgrade';

  @override
  String bonus(int count) {
    return '+$count bonus';
  }

  @override
  String get active => 'Active';

  @override
  String get inactive => 'Inactive';

  @override
  String get filter => 'Filter';

  @override
  String get all => 'All';

  @override
  String get unlockedOnly => 'Unlocked Only';

  @override
  String get lockedOnly => 'Locked Only';

  @override
  String get noPlantsFound => 'No plants found';

  @override
  String get plantDetails => 'Plant Details';

  @override
  String get description => 'Description';

  @override
  String get rarity => 'Rarity';

  @override
  String get common => 'Common';

  @override
  String get rare => 'Rare';

  @override
  String get epic => 'Epic';

  @override
  String get legendary => 'Legendary';

  @override
  String get upgradeCost => 'Upgrade Cost';

  @override
  String get insufficientCoins => 'Insufficient coins';

  @override
  String get upgradeSuccess => 'Upgrade successful!';

  @override
  String get noLives => 'No Lives';

  @override
  String get noLivesMessage =>
      'You don\'t have any lives left. Watch an ad to get a free life or wait for lives to regenerate.';

  @override
  String get levelLocked => 'Level locked';

  @override
  String get levelLockedMessage =>
      'You must complete the previous level to unlock this one.';

  @override
  String get firstSteps => 'First Steps';

  @override
  String get firstStepsDescription => 'Complete your first level';

  @override
  String get levelMaster => 'Level Master';

  @override
  String get levelMasterDescription => 'Complete 10 levels';

  @override
  String get scoreHunter => 'Score Hunter';

  @override
  String get scoreHunterDescription => 'Reach 10,000 points in a single level';

  @override
  String get comboKing => 'Combo King';

  @override
  String get comboKingDescription => 'Make a 5-combo match';

  @override
  String get plantCollector => 'Plant Collector';

  @override
  String get plantCollectorDescription => 'Unlock 5 plants';

  @override
  String get perfectPlayer => 'Perfect Player';

  @override
  String get perfectPlayerDescription => 'Complete a level with 3 stars';

  @override
  String get dailyChallenge => 'Daily Challenge';

  @override
  String get weeklyEvent => 'Weekly Event';

  @override
  String get specialOffer => 'Special Offer';

  @override
  String get limitedTime => 'Limited Time';

  @override
  String get newEvent => 'New Event';

  @override
  String get eventDescription =>
      'Complete special objectives to earn exclusive rewards!';

  @override
  String get participate => 'Participate';

  @override
  String get rewards => 'Rewards';

  @override
  String get powerUps => 'Power-ups';

  @override
  String get bomb => 'Bomb';

  @override
  String get lightning => 'Lightning';

  @override
  String get rainbow => 'Rainbow';

  @override
  String get hammer => 'Hammer';

  @override
  String get gameplay => 'Gameplay';

  @override
  String get matchThree =>
      'Match 3 or more tiles of the same type to clear them';

  @override
  String get combos => 'Create combos for bonus points';

  @override
  String get powerUpsUsage =>
      'Use power-ups to help you in difficult situations';

  @override
  String get livesSystem => 'You have limited lives. Watch ads to get more!';

  @override
  String get readTermsOfUse => 'Read the terms of use';

  @override
  String lastUpdated(String date) {
    return 'Last updated: $date';
  }

  @override
  String get privacyPolicyIntroduction =>
      'This privacy policy describes how Mind Bloom collects, uses, and protects your personal information when you use our mobile application. We are committed to protecting your privacy and treating your data with the utmost respect.';

  @override
  String get informationWeCollect => 'Information we collect';

  @override
  String get weCollectFollowing => 'We collect the following information:';

  @override
  String get gameData => 'Game Data';

  @override
  String get gameDataDescription => 'Progress, scores, game preferences';

  @override
  String get technicalData => 'Technical Data';

  @override
  String get technicalDataDescription =>
      'Application version, device type, operating system';

  @override
  String get usageData => 'Usage Data';

  @override
  String get usageDataDescription =>
      'Playtime, features used, performance metrics';

  @override
  String get howWeUseData => 'How we use your data';

  @override
  String get dataUsageDescription => 'We use your data to:';

  @override
  String get improveGameplay => 'Improve gameplay experience';

  @override
  String get provideSupport => 'Provide customer support';

  @override
  String get analyzeUsage => 'Analyze application usage';

  @override
  String get dataProtection => 'Data Protection';

  @override
  String get dataProtectionDescription =>
      'We implement appropriate security measures to protect your personal information against unauthorized access, alteration, disclosure, or destruction.';

  @override
  String get contactUs => 'Contact Us';

  @override
  String get contactUsDescription =>
      'If you have any questions about this privacy policy, please contact us at:';

  @override
  String get email => 'Email';

  @override
  String get emailAddress => 'privacy@mindbloom.com';

  @override
  String get howWeUseInformation => 'How we use your information';

  @override
  String get weUseInformationFor => 'We use your information for:';

  @override
  String get provideService => 'Provide and improve the game service';

  @override
  String get personalizeExperience => 'Personalize your game experience';

  @override
  String get displayAds =>
      'Display personalized advertisements (with your consent)';

  @override
  String get ensureSecurity => 'Ensure security and prevent fraud';

  @override
  String get communicateService => 'Communicate with you regarding the service';

  @override
  String get dataSharing => 'Data sharing';

  @override
  String get dataSharingDescription =>
      'We do not sell, trade, or otherwise transfer your personal information to third parties without your consent, except as described in this policy.';

  @override
  String get yourRights => 'Your rights';

  @override
  String get yourRightsDescription => 'You have the right to:';

  @override
  String get accessData => 'Access your personal data';

  @override
  String get correctData => 'Correct inaccurate data';

  @override
  String get deleteData => 'Delete your data';

  @override
  String get withdrawConsent => 'Withdraw consent for data processing';

  @override
  String get data => 'Data';

  @override
  String get audio => 'Audio';

  @override
  String get enableDisableMusic => 'Enable/disable background music';

  @override
  String get enableDisableSfx => 'Enable/disable sound effects';

  @override
  String get game => 'Game';

  @override
  String get enableDisableAnimations => 'Enable/disable animations';

  @override
  String get enableDisableVibrations => 'Enable/disable vibrations';

  @override
  String get musicVolume => 'Music volume';

  @override
  String get effectsVolume => 'Effects volume';

  @override
  String get experience => 'Experience';

  @override
  String get noMoreLives => 'No more lives!';

  @override
  String get noMoreLivesMessage =>
      'You have no more lives. Watch an ad to get a free life, wait for them to recharge or buy more.';

  @override
  String get wait => 'Wait';

  @override
  String get noLevelLoaded => 'No level loaded';

  @override
  String get backToMenu => 'Back to menu';

  @override
  String get youHaveUsedAllMoves => 'You have used all your moves!';

  @override
  String get aboutTheGame => 'About the game';

  @override
  String get flutterDeveloper => 'Flutter Developer';

  @override
  String get readOurTermsOfService => 'Read our terms of service';

  @override
  String get discoverHowWeProtectYourData =>
      'Discover how we protect your data';

  @override
  String get movesRemaining => 'Moves remaining';

  @override
  String get noMovesPossible => 'No moves possible. Use the shuffle button!';

  @override
  String get activeEvent => 'ACTIVE EVENT';

  @override
  String daysRemaining(int count) {
    return '$count days remaining';
  }

  @override
  String startsIn(int days) {
    return 'Starts in $days days';
  }

  @override
  String others(int count) {
    return '+$count others';
  }

  @override
  String get progress => 'Progress';

  @override
  String plant(int rarity) {
    return '$rarity★ Plant';
  }

  @override
  String boosters(int count) {
    return '$count boosters';
  }

  @override
  String get completed => 'COMPLETED';

  @override
  String get challenges => 'Challenges';

  @override
  String get comingSoon => 'Coming soon';

  @override
  String rarePlant(int rarity) {
    return 'Rare $rarity star plant';
  }

  @override
  String participationInProgress(String eventName) {
    return 'Participation in $eventName in progress...';
  }

  @override
  String get springBloom => 'Spring Bloom';

  @override
  String get springBloomDescription => 'Celebrate renewal with magical flowers';

  @override
  String get summerSolstice => 'Summer Solstice';

  @override
  String get summerSolsticeDescription => 'Enjoy the sun with sunny plants';

  @override
  String get autumnHarvest => 'Autumn Harvest';

  @override
  String get autumnHarvestDescription => 'Harvest the fruits of your efforts';

  @override
  String completeLevels(int target) {
    return 'Complete $target levels';
  }

  @override
  String earnStars(int target) {
    return 'Earn $target stars';
  }

  @override
  String useBoosters(int target) {
    return 'Use $target boosters';
  }

  @override
  String scorePoints(int target) {
    return 'Score $target points';
  }

  @override
  String get popularItems => 'Popular Items';

  @override
  String get currency => 'Currency';

  @override
  String get premium => 'Premium';

  @override
  String get pop => 'POP';

  @override
  String notEnoughCurrency(String currency) {
    return 'You don\'t have enough $currency';
  }

  @override
  String purchaseSuccess(String item) {
    return '$item purchased successfully!';
  }

  @override
  String get lives5 => '5 Lives';

  @override
  String get lives5Description => 'Recharge your lives to keep playing';

  @override
  String get lives10 => '10 Lives';

  @override
  String get lives10Description => 'Larger life pack';

  @override
  String get coins100 => '100 Coins';

  @override
  String get coins100Description => 'Small coin pack';

  @override
  String get coins500 => '500 Coins';

  @override
  String get coins500Description => 'Medium coin pack';

  @override
  String get coins1000 => '1000 Coins';

  @override
  String get coins1000Description => 'Large coin pack';

  @override
  String get gems50 => '50 Gems';

  @override
  String get gems50Description => 'Premium gem pack';

  @override
  String get shuffler => 'Shuffler';

  @override
  String get shufflerDescription => 'Automatically shuffles the board';

  @override
  String get hintDescription => 'Shows a possible move';

  @override
  String get removeAds => 'Remove ads';

  @override
  String get removeAdsDescription => 'Removes all advertisements';

  @override
  String plantLevel(int level) {
    return 'Level $level';
  }

  @override
  String get unlockCondition => 'Unlock Condition';

  @override
  String get bonuses => 'Bonuses';

  @override
  String extraMoves(int value) {
    return '+$value extra moves';
  }

  @override
  String get scoreMultiplier => 'Score multiplier';

  @override
  String coinMultiplier(int value) {
    return 'Coins x$value';
  }

  @override
  String extraLives(int value) {
    return '+$value life(s)';
  }

  @override
  String plantUpgraded(String plantName, int level) {
    return '$plantName upgraded to level $level!';
  }

  @override
  String get progression => 'Progression';

  @override
  String get social => 'Social';

  @override
  String get reward => 'Reward';

  @override
  String get rewardClaimed => 'Reward claimed';

  @override
  String get inProgress => 'In progress...';

  @override
  String rewardClaimedMessage(String achievementTitle) {
    return 'Reward for $achievementTitle claimed!';
  }

  @override
  String get confirmedBeginner => 'Confirmed Beginner';

  @override
  String get confirmedBeginnerDescription => 'Complete 10 levels';

  @override
  String get expertInTheMaking => 'Expert in the Making';

  @override
  String get expertInTheMakingDescription => 'Complete 50 levels';

  @override
  String get perfectionist => 'Perfectionist';

  @override
  String get perfectionistDescription => 'Get 3 stars on a level';

  @override
  String get scorer => 'Scorer';

  @override
  String get scorerDescription => 'Score 1,000 points in one level';

  @override
  String get scoreMaster => 'Score Master';

  @override
  String get scoreMasterDescription => 'Score 5,000 points in one level';

  @override
  String get accumulator => 'Accumulator';

  @override
  String get accumulatorDescription => 'Score a total of 100,000 points';

  @override
  String get beginnerBotanist => 'Beginner Botanist';

  @override
  String get beginnerBotanistDescription => 'Unlock your first plant';

  @override
  String get collector => 'Collector';

  @override
  String get collectorDescription => 'Unlock 5 plants';

  @override
  String get rarityHunter => 'Rarity Hunter';

  @override
  String get rarityHunterDescription => 'Unlock a 4-star or higher plant';

  @override
  String get comboMaster => 'Combo Master';

  @override
  String get comboMasterDescription => 'Make a 5-tile combo';

  @override
  String get legendaryCombo => 'Legendary Combo';

  @override
  String get legendaryComboDescription => 'Make a 10-tile combo';

  @override
  String get saver => 'Saver';

  @override
  String get saverDescription =>
      'Complete a level with more than 5 moves remaining';

  @override
  String get loyal => 'Loyal';

  @override
  String get loyalDescription => 'Log in 7 days in a row';

  @override
  String get sharer => 'Sharer';

  @override
  String get sharerDescription => 'Share your score 3 times';

  @override
  String userLevel(int level) {
    return 'Level $level';
  }

  @override
  String get completedLevels => 'Completed Levels';

  @override
  String get detailedStats => 'Detailed Statistics';

  @override
  String get totalCoins => 'Total Coins';

  @override
  String get starsEarned => 'Stars Earned';

  @override
  String get highestLevel => 'Highest Level';

  @override
  String get quickActions => 'Quick Actions';

  @override
  String get reviewTutorial => 'Review Tutorial';

  @override
  String get shareProfile => 'Share Profile';

  @override
  String get recentAchievements => 'Recent Achievements';

  @override
  String get firstLevelCompleted => 'First level completed';

  @override
  String get threeStarsObtained => '3 stars obtained';

  @override
  String get streakOfFive => 'Streak of 5 levels';

  @override
  String daysAgo(int days) {
    return '$days days ago';
  }

  @override
  String get dayAgo => '1 day ago';

  @override
  String get today => 'Today';

  @override
  String get resetDataTitle => 'Reset data?';

  @override
  String get resetDataMessage =>
      'This action will delete all your progress data. This action is irreversible.';

  @override
  String get shareComingSoon => 'Sharing coming soon...';

  @override
  String get acceptanceOfTerms => '1. Acceptance of Terms';

  @override
  String get acceptanceOfTermsContent =>
      'By using the Mind Bloom application, you agree to be bound by these terms of use. If you do not accept these terms, please do not use our application.';

  @override
  String get serviceDescription => '2. Service Description';

  @override
  String get serviceDescriptionContent =>
      'Mind Bloom is a mobile puzzle game developed by YACOUBA SANTARA. The application offers match-3 mechanics with RPG progression elements in a magical garden universe.';

  @override
  String get authorizedUse => '3. Authorized Use';

  @override
  String get authorizedUseContent =>
      'You may use Mind Bloom for personal and non-commercial purposes only. It is prohibited to:\n\n• Copy, modify or distribute the application\n• Use the application for commercial purposes without authorization\n• Attempt to bypass security measures\n• Use the application in a way that harms other users';

  @override
  String get intellectualProperty => '4. Content and Intellectual Property';

  @override
  String get intellectualPropertyContent =>
      'All elements of Mind Bloom, including but not limited to graphics, sounds, source code, and design, are the exclusive property of YACOUBA SANTARA and are protected by copyright laws.';

  @override
  String get inAppPurchases => '5. In-App Purchases';

  @override
  String get inAppPurchasesContent =>
      'The application may contain in-app purchases for additional lives, boosters, or other game elements. All purchases are final and non-refundable, except as required by applicable law.';

  @override
  String get advertisements => '6. Advertisements';

  @override
  String get advertisementsContent =>
      'Mind Bloom may display third-party advertisements. These advertisements are managed by advertising partners and we are not responsible for the content of these advertisements.';

  @override
  String get liabilityLimitation => '7. Limitation of Liability';

  @override
  String get liabilityLimitationContent =>
      'The application is provided \'as is\' without warranty of any kind. We will not be liable for direct, indirect, incidental or consequential damages resulting from the use of the application.';

  @override
  String get termsModifications => '8. Terms Modifications';

  @override
  String get termsModificationsContent =>
      'We reserve the right to modify these terms of use at any time. Modifications will take effect upon their publication in the application. Your continued use of the application constitutes your acceptance of the modified terms.';

  @override
  String get termination => '9. Termination';

  @override
  String get terminationContent =>
      'We reserve the right to suspend or terminate your access to the application at any time, without notice, for violation of these terms of use.';

  @override
  String get applicableLaw => '10. Applicable Law';

  @override
  String get applicableLawContent =>
      'These terms of use are governed by French law. Any dispute will be subject to the exclusive jurisdiction of French courts.';

  @override
  String get contact => 'Contact';

  @override
  String get contactContent =>
      'For any questions regarding these terms of use, you can contact us at:';

  @override
  String get dataStorage => '4. Data Storage and Security';

  @override
  String get dataStorageContent =>
      'Your data is stored securely:\n\n• **Encryption**: Sensitive data is encrypted\n• **Limited Access**: Only authorized personnel can access data\n• **Backup**: Regular backups are performed\n• **Duration**: Data is kept only as long as necessary';

  @override
  String get cookies => '5. Cookies and Similar Technologies';

  @override
  String get cookiesContent =>
      'The application may use:\n\n• **Local Cookies**: To save your game preferences\n• **Advertising Identifiers**: To personalize advertisements\n• **Analytics**: To understand application usage\n\nYou can disable these features in your device settings.';

  @override
  String get thirdPartyAds => '7. Third-Party Advertisements and Partners';

  @override
  String get thirdPartyAdsContent =>
      'The application may display advertisements through third-party partners like Google AdMob. These partners may collect information to personalize advertisements. You can:\n\n• Disable ad personalization in settings\n• Use your device\'s privacy settings\n• Contact advertising partners directly';

  @override
  String get minorsData => '8. Minors\' Data';

  @override
  String get minorsDataContent =>
      'Mind Bloom does not knowingly collect personal information from children under 13. If we discover that a child under 13 has provided us with personal information, we will delete it immediately.';

  @override
  String get policyChanges => '9. Changes to This Policy';

  @override
  String get policyChangesContent =>
      'We may modify this privacy policy at any time. Important changes will be communicated via the application or by email. We encourage you to regularly review this policy.';

  @override
  String get legalBasis => '10. Legal Basis for Processing';

  @override
  String get legalBasisContent =>
      'We process your personal data on the basis of:\n\n• **Contract Performance**: To provide the gaming service\n• **Legitimate Interest**: To improve the application and prevent fraud\n• **Consent**: For personalized advertisements and marketing communications';

  @override
  String get contactDPO => 'Contact and DPO';

  @override
  String get contactDPOContent =>
      'For any questions regarding this privacy policy or to exercise your rights, contact us:';

  @override
  String get responseTime =>
      'We commit to responding to your request within 30 days.';

  @override
  String get introduction => 'Introduction';

  @override
  String get account => 'Account';

  @override
  String get enterNewUsername => 'Enter new username';

  @override
  String get theme => 'Theme';

  @override
  String get lightTheme => 'Light';

  @override
  String get darkTheme => 'Dark';

  @override
  String get systemTheme => 'System';

  @override
  String get themeDescription => 'Choose your preferred theme';

  @override
  String get shareProfileMessage =>
      'Check out my progress in Mind Bloom! Can you beat my score?';

  @override
  String get levelsCompleted => 'Levels Completed';

  @override
  String get watchAdForLifeDescription =>
      'Watch a short video to earn one life and continue playing!';

  @override
  String get earnOneLife => 'Earn 1 Life';

  @override
  String get lifeEarned => 'Life earned! You can continue playing.';

  @override
  String get noAdAvailable =>
      'No ad available at the moment. Please try again later.';

  @override
  String get adError => 'Error loading ad. Please try again.';

  @override
  String get timeRemaining => 'Time';

  @override
  String get nextLife => 'Next life';

  @override
  String get watchAdForFreeLife => 'Watch an ad to get a free life!';

  @override
  String get dailyRewards => 'Daily Rewards';

  @override
  String get claimReward => 'Claim!';

  @override
  String get rewardAlreadyClaimed => 'Reward already claimed';

  @override
  String get nextRewardIn => 'Next reward in:';

  @override
  String get howItWorks => 'How it works?';

  @override
  String get dailyRewardInfo1 => 'Log in every day to claim your reward';

  @override
  String get dailyRewardInfo2 =>
      'The longer your streak, the better the rewards';

  @override
  String get dailyRewardInfo3 => 'The 7th day offers a legendary reward';

  @override
  String get dailyRewardInfo4 => 'Rewards reset at midnight';

  @override
  String rewardOfDay(int day) {
    return 'Day $day Reward';
  }

  @override
  String get legendaryStreak => 'Legendary Streak!';

  @override
  String get perfectPerformance => 'Perfect Performance! Bonus x2';

  @override
  String get milestoneLevel => 'Milestone Level! Special bonus';

  @override
  String get rewardsClaimed => 'Rewards Obtained';

  @override
  String comboBonus(int multiplier) {
    return 'Combo Bonus x$multiplier';
  }

  @override
  String get spectacularCombo => 'Spectacular Combo!';

  @override
  String megaMatch(int count) {
    return 'Mega Match of $count tiles!';
  }

  @override
  String get globalProgress => 'Global Progress';

  @override
  String collectTilesObjective(int count, String tileName) {
    return 'Collect $count $tileName';
  }

  @override
  String clearBlockersObjective(int count) {
    return 'Destroy $count blockers';
  }

  @override
  String reachScoreObjective(int count) {
    return 'Reach $count points';
  }

  @override
  String freeCreatureObjective(int count) {
    return 'Free $count creatures';
  }

  @override
  String clearJellyObjective(int count) {
    return 'Destroy $count jellies';
  }

  @override
  String get coinsBonus => 'Coins Bonus';

  @override
  String get gemsGratuits => 'Free Gems';

  @override
  String get watchAdForCoins => 'Watch an ad to get coins';

  @override
  String get watchAdForGems => 'Watch an ad to get gems';

  @override
  String get watchButton => 'WATCH';

  @override
  String get debugUnlockAllLevels => 'Unlock All Levels (DEBUG)';

  @override
  String get debugUnlockAllLevelsDescription =>
      'Test function to unlock all levels';

  @override
  String get shareScore => 'Share Score';

  @override
  String get shareScoreTitle => 'Share My Score';

  @override
  String shareScoreMessage(int score, int level) {
    return 'I got $score points on level $level in Mind Bloom! Can you do better? 🌱';
  }

  @override
  String get shareScoreSuccess => 'Score shared successfully!';

  @override
  String get shareScoreError => 'Error sharing score';

  @override
  String get quit => 'Quit';

  @override
  String get winterSolstice => 'Winter Solstice';

  @override
  String get winterSolsticeDescription =>
      'Light up the night with ice crystals';

  @override
  String get valentineDay => 'Valentine\'s Day';

  @override
  String get valentineDayDescription => 'Share love with romantic flowers';

  @override
  String get shareAchievements => 'Badge Sharer';

  @override
  String get shareAchievementsDescription =>
      'Share 5 achievements with your friends';

  @override
  String get socialButterfly => 'Social Butterfly';

  @override
  String get socialButterflyDescription =>
      'Share 10 achievements with your friends';

  @override
  String get shareThisBadge => 'Share this badge';

  @override
  String get shareMyAchievements => 'Share my achievements';

  @override
  String badgeShared(String badgeTitle) {
    return 'Badge \"$badgeTitle\" shared! 🎉';
  }

  @override
  String get achievementsShared => 'My achievements shared! 🎉';

  @override
  String get newWorldUnlocked => 'New World Unlocked';

  @override
  String get continueGame => 'Continue';

  @override
  String livesLimitedToMax(int actualAdded, int maxLives) {
    return 'Only $actualAdded lives added (limit: $maxLives lives)';
  }

  @override
  String get easterEvent => 'Magical Easter';

  @override
  String get easterEventDescription => 'Discover hidden magical eggs';

  @override
  String get halloweenEvent => 'Enchanted Halloween';

  @override
  String get halloweenEventDescription => 'Plant mysterious pumpkins';

  @override
  String get christmasEvent => 'Fairy Christmas';

  @override
  String get christmasEventDescription =>
      'Decorate your garden with Christmas stars';

  @override
  String get newYearEvent => 'Bright New Year';

  @override
  String get newYearEventDescription => 'Start the year with magical fireworks';

  @override
  String get thanksgivingEvent => 'Thanksgiving';

  @override
  String get thanksgivingEventDescription => 'Harvest abundance with gratitude';

  @override
  String get motherDayEvent => 'Mother\'s Day';

  @override
  String get motherDayEventDescription =>
      'Offer flowers as a tribute to mothers';

  @override
  String get fatherDayEvent => 'Father\'s Day';

  @override
  String get fatherDayEventDescription =>
      'Cultivate strength with robust plants';

  @override
  String get springCleaningEvent => 'Spring Cleaning';

  @override
  String get springCleaningEventDescription =>
      'Refresh your garden for a new season';

  @override
  String get summerFestivalEvent => 'Summer Festival';

  @override
  String get summerFestivalEventDescription =>
      'Grand summer festival with many rewards';

  @override
  String get harvestFestivalEvent => 'Harvest Festival';

  @override
  String get harvestFestivalEventDescription => 'Celebrate autumn\'s abundance';

  @override
  String get winterFestivalEvent => 'Winter Festival';

  @override
  String get winterFestivalEventDescription =>
      'Light up the dark season with crystals';

  @override
  String get specialUpdateEvent => 'Special Update';

  @override
  String get specialUpdateEventDescription => 'Discover new features';

  @override
  String get communityChallengeEvent => 'Community Challenge';

  @override
  String get communityChallengeEventDescription =>
      'Take on challenges with the whole community';

  @override
  String get limitedTimeEvent => 'Limited Time Event';

  @override
  String get limitedTimeEventDescription =>
      'Enjoy this unique event before it disappears';

  @override
  String get birthdayEvent => 'Mind Bloom Birthday';

  @override
  String get birthdayEventDescription =>
      'Celebrate one year of Mind Bloom with surprises';

  @override
  String get milestoneEvent => 'Milestone Event';

  @override
  String get milestoneEventDescription =>
      'Celebrate the game\'s major milestones';

  @override
  String get earthDayEvent => 'Earth Day';

  @override
  String get earthDayEventDescription =>
      'Protect nature with eco-friendly plants';

  @override
  String get independenceDayEvent => 'Independence Day';

  @override
  String get independenceDayEventDescription =>
      'Celebrate with patriotic plants';

  @override
  String completeActions(int target, String actionType) {
    return 'Complete $target $actionType actions';
  }

  @override
  String playConsecutiveDays(int target) {
    return 'Play for $target consecutive days';
  }

  @override
  String completeLevelsWithStars(int target, int stars) {
    return 'Complete $target levels with $stars stars';
  }

  @override
  String completeQuests(int target, String questType) {
    return 'Complete $target $questType quests';
  }

  @override
  String collectItems(int target, String itemType) {
    return 'Collect $target $itemType items';
  }

  @override
  String completeLevelsInDays(int target, int days) {
    return 'Complete $target levels in $days days';
  }

  @override
  String giveGifts(int target) {
    return 'Give $target gifts';
  }

  @override
  String get exploreNewFeatures => 'Explore the new features';

  @override
  String get loadingEvents => 'Loading events...';

  @override
  String get activeEvents => 'Active Events';

  @override
  String get thisMonth => 'This Month';

  @override
  String get upcomingEvents => 'Upcoming Events';

  @override
  String get lastDay => 'Last day';

  @override
  String daysLeft(int count) {
    return '$count days';
  }

  @override
  String inDays(int count) {
    return 'In $count days';
  }

  @override
  String get finished => 'Finished';

  @override
  String challengesCount(int count) {
    return 'Challenges ($count)';
  }

  @override
  String get eventStatistics => 'Event Statistics';

  @override
  String get filterEvents => 'Filter Events';

  @override
  String get filterFeatureComingSoon => 'Filter feature coming soon...';

  @override
  String participatingInEvent(String eventName) {
    return 'Participating in \"$eventName\"...';
  }

  @override
  String get fullLives => 'Full Lives';

  @override
  String get refillAllLives => 'Refills all your lives (5/5)';

  @override
  String get threeLives => '3 Lives';

  @override
  String get addThreeLives => 'Adds 3 lives (max 5 lives)';

  @override
  String get twoHundredCoins => '200 Coins';

  @override
  String get smallCoinBoost => 'A small coin boost';

  @override
  String get fiveHundredCoins => '500 Coins';

  @override
  String get goodCoinStock => 'A good coin stock';

  @override
  String get thousandCoins => '1000 Coins';

  @override
  String get bigCoinStock => 'A big coin stock';

  @override
  String get twentyFiveGems => '25 Gems';

  @override
  String get preciousGems => 'Precious gems for premium purchases';

  @override
  String get shuffleGrid => 'Shuffles the grid for new moves';

  @override
  String get revealWinningMove => 'Reveals a winning move';

  @override
  String get bonusMoves => 'Bonus moves';

  @override
  String get fiveExtraMoves => '+5 moves for the current level';

  @override
  String get doubleScoreThreeLevels => 'x2 score for 3 levels';

  @override
  String get experienceBoost => 'Experience boost';

  @override
  String get hundredXpBoost => '+100 XP to progress faster';

  @override
  String get skipLevel => 'Skip a level';

  @override
  String get unlockNextLevel => 'Unlocks the next level';

  @override
  String get unlockAllLevels => 'Unlock all levels';

  @override
  String get accessAllLevels => 'Access to all game levels';

  @override
  String get natureTheme => 'Nature Theme';

  @override
  String get natureThemeDescription => 'New visual theme with natural colors';

  @override
  String get oceanTheme => 'Ocean Theme';

  @override
  String get oceanThemeDescription => 'Aquatic theme with blue colors';

  @override
  String get goldFrame => 'Gold frame';

  @override
  String get goldFrameDescription => 'Gold frame for your avatar';

  @override
  String get playWithoutAds => 'Play without advertising interruption';

  @override
  String get premiumPack => 'Premium Pack';

  @override
  String get allPremiumBenefits => 'All premium benefits + 100 gems';

  @override
  String get cosmetics => 'Cosmetics';

  @override
  String get freeRewards => '🎁 Free Rewards';

  @override
  String get world_garden_beginnings => 'Garden of Beginnings';

  @override
  String get world_garden_beginnings_description =>
      'Begin your adventure in this peaceful garden where the first seeds of your journey come to life.';

  @override
  String get world_valley_flowers => 'Valley of Flowers';

  @override
  String get world_valley_flowers_description =>
      'Explore a colorful valley where nature\'s most beautiful creations bloom.';

  @override
  String get world_lunar_forest => 'Lunar Forest';

  @override
  String get world_lunar_forest_description =>
      'Dive into the mysterious darkness of this forest bathed in lunar light.';

  @override
  String get world_solar_meadow => 'Solar Meadow';

  @override
  String get world_solar_meadow_description =>
      'Bask in the benevolent warmth of this meadow gilded by the sun.';

  @override
  String get world_crystal_caverns => 'Crystal Caverns';

  @override
  String get world_crystal_caverns_description =>
      'Discover the hidden treasures in these sparkling caves of precious crystals.';

  @override
  String get world_mystic_swamps => 'Mystic Swamps';

  @override
  String get world_mystic_swamps_description =>
      'Navigate through the troubled waters of these swamps filled with ancient magic.';

  @override
  String get world_burning_lands => 'Burning Lands';

  @override
  String get world_burning_lands_description =>
      'Survive the intense heat of these volcanic lands in permanent eruption.';

  @override
  String get world_eternal_glacier => 'Eternal Glacier';

  @override
  String get world_eternal_glacier_description =>
      'Brave the glacial cold of these pristine white expanses.';

  @override
  String get world_lost_rainbow => 'Lost Rainbow';

  @override
  String get world_lost_rainbow_description =>
      'Find the lost colors of this legendary rainbow with magical hues.';

  @override
  String get world_celestial_garden => 'Celestial Garden';

  @override
  String get world_celestial_garden_description =>
      'Access the ultimate garden where stars bloom and dreams become reality.';

  @override
  String get worlds => 'Worlds';

  @override
  String get levels => 'Levels';

  @override
  String get enter => 'Enter';

  @override
  String get tutorial_welcome_title => 'Welcome to Mind Bloom!';

  @override
  String get tutorial_welcome_description =>
      'Discover the magical world of plants and puzzles';

  @override
  String get tutorial_matching_title => 'Make matches';

  @override
  String get tutorial_matching_description =>
      'Swap tiles to create lines of 3 or more of the same color';

  @override
  String get tutorial_objectives_title => 'Level objectives';

  @override
  String get tutorial_objectives_description =>
      'Each level has specific objectives to achieve to progress';

  @override
  String get tutorial_hint_title => 'Hint Button';

  @override
  String get tutorial_hint_description =>
      'Use the hint to reveal a winning move when you\'re stuck';

  @override
  String get tutorial_shuffle_title => 'Shuffle Button';

  @override
  String get tutorial_shuffle_description =>
      'Shuffle the grid to get new possible moves';

  @override
  String get tutorial_stars_title => 'Earn stars';

  @override
  String get tutorial_stars_description =>
      'The more objectives you achieve, the more stars you earn';

  @override
  String get tutorial_collection_title => 'Plant collection';

  @override
  String get tutorial_collection_description =>
      'Unlock new magical plants with special bonuses';

  @override
  String get tutorial_skip => 'Skip';

  @override
  String get tutorial_next => 'Next';

  @override
  String get tutorial_start => 'Start';

  @override
  String get tutorial_complete => 'Tutorial complete!';

  @override
  String get tutorial_complete_description =>
      'You are now ready to explore the world of Mind Bloom!';

  @override
  String get tutorial_skip_confirmation_title => 'Skip tutorial?';

  @override
  String get tutorial_skip_confirmation_message =>
      'Are you sure you want to skip the tutorial? You can review it later in the settings.';

  @override
  String get world_completed_title => 'World Completed & New World Unlocked!';

  @override
  String get world_completed_only_title => 'World Completed!';

  @override
  String get world_completed_message =>
      'Congratulations! You have completed this world and unlocked a new world!';

  @override
  String get world_completed_only_message =>
      'Congratulations! You have mastered all the challenges of this world with brilliance!';

  @override
  String new_world_unlocked(String worldName) {
    return 'New world unlocked: $worldName';
  }

  @override
  String get rare_items_unlocked => 'Rare Items Unlocked!';

  @override
  String get completion_rewards => 'Completion Rewards';

  @override
  String get unlock_bonus => 'Unlock bonus: +5 Gems';

  @override
  String get back_to_menu => 'Back to Menu';

  @override
  String get explore_new_world => 'Explore the New World';

  @override
  String get continue_text => 'Continue';

  @override
  String get new_world => 'New World';

  @override
  String get next_world => 'Next World';
}
