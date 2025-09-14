import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr')
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'Mind Bloom'**
  String get appTitle;

  /// Home button
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// Profile screen title
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// Collection category filter
  ///
  /// In en, this message translates to:
  /// **'Collection'**
  String get collection;

  /// Shop screen title
  ///
  /// In en, this message translates to:
  /// **'Shop'**
  String get shop;

  /// Settings screen title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// About text
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// Level statistic label
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get level;

  /// Score category filter
  ///
  /// In en, this message translates to:
  /// **'Score'**
  String get score;

  /// Moves text
  ///
  /// In en, this message translates to:
  /// **'Moves'**
  String get moves;

  /// Lives statistic
  ///
  /// In en, this message translates to:
  /// **'Lives'**
  String get lives;

  /// Coins reward text
  ///
  /// In en, this message translates to:
  /// **'{quantity} coins'**
  String coins(int quantity);

  /// Gems count text
  ///
  /// In en, this message translates to:
  /// **'{count} gems'**
  String gems(int count);

  /// Play button text
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get play;

  /// Pause button text
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pause;

  /// Resume button text
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get resume;

  /// Restart button text
  ///
  /// In en, this message translates to:
  /// **'Restart'**
  String get restart;

  /// Menu button text
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menu;

  /// Hint booster title
  ///
  /// In en, this message translates to:
  /// **'Hint'**
  String get hint;

  /// Shuffle text
  ///
  /// In en, this message translates to:
  /// **'Shuffle'**
  String get shuffle;

  /// Next button text
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// Back button text
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// Cancel button text
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Confirm button text
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// Save button text
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Load button text
  ///
  /// In en, this message translates to:
  /// **'Load'**
  String get load;

  /// Reset button text
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// Delete button text
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Edit button text
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// Close button text
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// OK button text
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// Yes button text
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No button text
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// Loading text
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// Error text
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// Achievements screen title
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get success;

  /// Warning text
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get warning;

  /// Information text
  ///
  /// In en, this message translates to:
  /// **'Information'**
  String get info;

  /// No moves available message
  ///
  /// In en, this message translates to:
  /// **'No moves available. Use the shuffle button!'**
  String get noMovesAvailable;

  /// Level complete message
  ///
  /// In en, this message translates to:
  /// **'Level Complete!'**
  String get levelComplete;

  /// Level failed message
  ///
  /// In en, this message translates to:
  /// **'Level {id} Failed'**
  String levelFailed(int id);

  /// Game paused message
  ///
  /// In en, this message translates to:
  /// **'Game paused'**
  String get gamePaused;

  /// What would you like to do message
  ///
  /// In en, this message translates to:
  /// **'What would you like to do?'**
  String get whatWouldYouLikeToDo;

  /// Free life text
  ///
  /// In en, this message translates to:
  /// **'Free Life'**
  String get freeLife;

  /// Title for watch ad dialog
  ///
  /// In en, this message translates to:
  /// **'Watch Ad for Life'**
  String get watchAdForLife;

  /// Button text to watch ad
  ///
  /// In en, this message translates to:
  /// **'Watch Ad'**
  String get watchAd;

  /// Ad in progress message
  ///
  /// In en, this message translates to:
  /// **'Ad in progress...'**
  String get adInProgress;

  /// Life obtained message
  ///
  /// In en, this message translates to:
  /// **'Life obtained! You can continue playing.'**
  String get lifeObtained;

  /// Music text
  ///
  /// In en, this message translates to:
  /// **'Music'**
  String get music;

  /// Sound effects text
  ///
  /// In en, this message translates to:
  /// **'Sound Effects'**
  String get soundEffects;

  /// Animations text
  ///
  /// In en, this message translates to:
  /// **'Animations'**
  String get animations;

  /// Vibrations text
  ///
  /// In en, this message translates to:
  /// **'Vibrations'**
  String get vibrations;

  /// Auto hints setting
  ///
  /// In en, this message translates to:
  /// **'Auto Hints'**
  String get autoHints;

  /// Language setting
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// English language
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// French language
  ///
  /// In en, this message translates to:
  /// **'Français'**
  String get french;

  /// Version text
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// Developer text
  ///
  /// In en, this message translates to:
  /// **'Developer'**
  String get developer;

  /// Terms of service screen title
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// Privacy policy text
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// Read terms of service text
  ///
  /// In en, this message translates to:
  /// **'Read the terms of service'**
  String get readTermsOfService;

  /// Read privacy policy text
  ///
  /// In en, this message translates to:
  /// **'Read the privacy policy'**
  String get readPrivacyPolicy;

  /// About game text
  ///
  /// In en, this message translates to:
  /// **'About the game'**
  String get aboutGame;

  /// Game description
  ///
  /// In en, this message translates to:
  /// **'Mind Bloom is a magical puzzle game that combines classic match-3 mechanics with RPG elements. Cultivate your enchanted garden by aligning colored tiles and discover a unique universe of progression and collection.'**
  String get gameDescription;

  /// Technologies text
  ///
  /// In en, this message translates to:
  /// **'Technologies'**
  String get technologies;

  /// Legal information text
  ///
  /// In en, this message translates to:
  /// **'Legal information'**
  String get legalInformation;

  /// License text
  ///
  /// In en, this message translates to:
  /// **'License'**
  String get license;

  /// License text
  ///
  /// In en, this message translates to:
  /// **'This project is under MIT license. You are free to use, modify and distribute it according to the terms of this license.'**
  String get licenseText;

  /// Acknowledgments text
  ///
  /// In en, this message translates to:
  /// **'Acknowledgments'**
  String get acknowledgments;

  /// Acknowledgments text
  ///
  /// In en, this message translates to:
  /// **'A big thank you to the Flutter community, the contributors of the packages used, and everyone who supported this project.'**
  String get acknowledgmentsText;

  /// Developer signature text
  ///
  /// In en, this message translates to:
  /// **'Developed with ❤️ by'**
  String get developedWithLove;

  /// Developer quote
  ///
  /// In en, this message translates to:
  /// **'\"Cultivate your inner garden, one match at a time\"'**
  String get quote;

  /// Username label
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// Edit username dialog title
  ///
  /// In en, this message translates to:
  /// **'Edit Username'**
  String get editUsername;

  /// Current streak label
  ///
  /// In en, this message translates to:
  /// **'Current Streak'**
  String get currentStreak;

  /// Best streak statistic
  ///
  /// In en, this message translates to:
  /// **'Best Streak'**
  String get bestStreak;

  /// Days text
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get days;

  /// Save data text
  ///
  /// In en, this message translates to:
  /// **'Save data'**
  String get saveData;

  /// Restore data text
  ///
  /// In en, this message translates to:
  /// **'Restore data'**
  String get restoreData;

  /// Reset data action
  ///
  /// In en, this message translates to:
  /// **'Reset Data'**
  String get resetData;

  /// Save progress text
  ///
  /// In en, this message translates to:
  /// **'Save your progress'**
  String get saveProgress;

  /// Restore progress text
  ///
  /// In en, this message translates to:
  /// **'Restore your progress'**
  String get restoreProgress;

  /// Delete all data text
  ///
  /// In en, this message translates to:
  /// **'Delete all data (irreversible)'**
  String get deleteAllData;

  /// Reset data confirmation
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete all your data? This action is irreversible.'**
  String get resetDataConfirmation;

  /// Data reset success message
  ///
  /// In en, this message translates to:
  /// **'Data reset'**
  String get dataReset;

  /// Data saved message
  ///
  /// In en, this message translates to:
  /// **'Data saved successfully'**
  String get dataSaved;

  /// Data restored message
  ///
  /// In en, this message translates to:
  /// **'Data restored successfully'**
  String get dataRestored;

  /// Save error message
  ///
  /// In en, this message translates to:
  /// **'Error saving data'**
  String get saveError;

  /// Restore error message
  ///
  /// In en, this message translates to:
  /// **'Error restoring data'**
  String get restoreError;

  /// Username updated success message
  ///
  /// In en, this message translates to:
  /// **'Username updated successfully'**
  String get usernameUpdated;

  /// World text
  ///
  /// In en, this message translates to:
  /// **'World'**
  String get world;

  /// Level completed message
  ///
  /// In en, this message translates to:
  /// **'Level {id} Completed!'**
  String levelCompleted(int id);

  /// Stars text
  ///
  /// In en, this message translates to:
  /// **'Stars'**
  String get stars;

  /// Moves used text
  ///
  /// In en, this message translates to:
  /// **'Moves used'**
  String get movesUsed;

  /// Next level button text
  ///
  /// In en, this message translates to:
  /// **'Next level'**
  String get nextLevel;

  /// Retry button
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// Objectives text
  ///
  /// In en, this message translates to:
  /// **'Objectives'**
  String get objectives;

  /// Collect tiles objective
  ///
  /// In en, this message translates to:
  /// **'Collect {count} {type}'**
  String collectTiles(int count, String type);

  /// Reach score objective
  ///
  /// In en, this message translates to:
  /// **'Reach {score} points'**
  String reachScore(int score);

  /// Complete in moves objective
  ///
  /// In en, this message translates to:
  /// **'Complete in {moves} moves'**
  String completeInMoves(int moves);

  /// Flower tile type
  ///
  /// In en, this message translates to:
  /// **'Flower'**
  String get tileTypeFlower;

  /// Leaf tile type
  ///
  /// In en, this message translates to:
  /// **'Leaf'**
  String get tileTypeLeaf;

  /// Crystal tile type
  ///
  /// In en, this message translates to:
  /// **'Crystal'**
  String get tileTypeCrystal;

  /// Seed tile type
  ///
  /// In en, this message translates to:
  /// **'Seed'**
  String get tileTypeSeed;

  /// Dew tile type
  ///
  /// In en, this message translates to:
  /// **'Dew'**
  String get tileTypeDew;

  /// Sun tile type
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get tileTypeSun;

  /// Moon tile type
  ///
  /// In en, this message translates to:
  /// **'Moon'**
  String get tileTypeMoon;

  /// Gem tile type
  ///
  /// In en, this message translates to:
  /// **'Gem'**
  String get tileTypeGem;

  /// Achievements text
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get achievements;

  /// Events screen title
  ///
  /// In en, this message translates to:
  /// **'Events'**
  String get events;

  /// Tutorial text
  ///
  /// In en, this message translates to:
  /// **'Tutorial'**
  String get tutorial;

  /// Buy button text
  ///
  /// In en, this message translates to:
  /// **'Buy'**
  String get buy;

  /// Price text
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// Owned text
  ///
  /// In en, this message translates to:
  /// **'Owned'**
  String get owned;

  /// Plants statistic label
  ///
  /// In en, this message translates to:
  /// **'Plants'**
  String get plants;

  /// Unlocked text
  ///
  /// In en, this message translates to:
  /// **'Unlocked'**
  String get unlocked;

  /// Locked button text
  ///
  /// In en, this message translates to:
  /// **'Locked'**
  String get locked;

  /// Upgrade button text
  ///
  /// In en, this message translates to:
  /// **'Upgrade'**
  String get upgrade;

  /// Bonus count text
  ///
  /// In en, this message translates to:
  /// **'+{count} bonus'**
  String bonus(int count);

  /// Active status badge
  ///
  /// In en, this message translates to:
  /// **'ACTIVE'**
  String get active;

  /// Inactive text
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get inactive;

  /// Filter text
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// All category filter
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// Unlocked only text
  ///
  /// In en, this message translates to:
  /// **'Unlocked Only'**
  String get unlockedOnly;

  /// Locked only text
  ///
  /// In en, this message translates to:
  /// **'Locked Only'**
  String get lockedOnly;

  /// No plants found message
  ///
  /// In en, this message translates to:
  /// **'No plants found'**
  String get noPlantsFound;

  /// Plant details title
  ///
  /// In en, this message translates to:
  /// **'Plant Details'**
  String get plantDetails;

  /// Description section title
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// Rarity statistic label
  ///
  /// In en, this message translates to:
  /// **'Rarity'**
  String get rarity;

  /// Common rarity
  ///
  /// In en, this message translates to:
  /// **'Common'**
  String get common;

  /// Rare rarity
  ///
  /// In en, this message translates to:
  /// **'Rare'**
  String get rare;

  /// Epic rarity
  ///
  /// In en, this message translates to:
  /// **'Epic'**
  String get epic;

  /// Legendary rarity
  ///
  /// In en, this message translates to:
  /// **'Legendary'**
  String get legendary;

  /// Upgrade cost text
  ///
  /// In en, this message translates to:
  /// **'Upgrade Cost'**
  String get upgradeCost;

  /// Insufficient coins message
  ///
  /// In en, this message translates to:
  /// **'Insufficient coins'**
  String get insufficientCoins;

  /// Upgrade success message
  ///
  /// In en, this message translates to:
  /// **'Upgrade successful!'**
  String get upgradeSuccess;

  /// No lives message
  ///
  /// In en, this message translates to:
  /// **'No Lives'**
  String get noLives;

  /// No lives message content
  ///
  /// In en, this message translates to:
  /// **'You don\'t have any lives left. Watch an ad to get a free life or wait for lives to regenerate.'**
  String get noLivesMessage;

  /// Level locked message
  ///
  /// In en, this message translates to:
  /// **'Level locked'**
  String get levelLocked;

  /// Level locked detailed message
  ///
  /// In en, this message translates to:
  /// **'You must complete the previous level to unlock this one.'**
  String get levelLockedMessage;

  /// First steps achievement title
  ///
  /// In en, this message translates to:
  /// **'First Steps'**
  String get firstSteps;

  /// First steps achievement description
  ///
  /// In en, this message translates to:
  /// **'Complete your first level'**
  String get firstStepsDescription;

  /// Level master achievement
  ///
  /// In en, this message translates to:
  /// **'Level Master'**
  String get levelMaster;

  /// Level master achievement description
  ///
  /// In en, this message translates to:
  /// **'Complete 10 levels'**
  String get levelMasterDescription;

  /// Score hunter achievement
  ///
  /// In en, this message translates to:
  /// **'Score Hunter'**
  String get scoreHunter;

  /// Score hunter achievement description
  ///
  /// In en, this message translates to:
  /// **'Reach 10,000 points in a single level'**
  String get scoreHunterDescription;

  /// Combo king achievement
  ///
  /// In en, this message translates to:
  /// **'Combo King'**
  String get comboKing;

  /// Combo king achievement description
  ///
  /// In en, this message translates to:
  /// **'Make a 5-combo match'**
  String get comboKingDescription;

  /// Plant collector achievement
  ///
  /// In en, this message translates to:
  /// **'Plant Collector'**
  String get plantCollector;

  /// Plant collector achievement description
  ///
  /// In en, this message translates to:
  /// **'Unlock 5 plants'**
  String get plantCollectorDescription;

  /// Perfect player achievement
  ///
  /// In en, this message translates to:
  /// **'Perfect Player'**
  String get perfectPlayer;

  /// Perfect player achievement description
  ///
  /// In en, this message translates to:
  /// **'Complete a level with 3 stars'**
  String get perfectPlayerDescription;

  /// Daily challenge text
  ///
  /// In en, this message translates to:
  /// **'Daily Challenge'**
  String get dailyChallenge;

  /// Weekly event text
  ///
  /// In en, this message translates to:
  /// **'Weekly Event'**
  String get weeklyEvent;

  /// Special offer text
  ///
  /// In en, this message translates to:
  /// **'Special Offer'**
  String get specialOffer;

  /// Limited time text
  ///
  /// In en, this message translates to:
  /// **'Limited Time'**
  String get limitedTime;

  /// New event text
  ///
  /// In en, this message translates to:
  /// **'New Event'**
  String get newEvent;

  /// Event description text
  ///
  /// In en, this message translates to:
  /// **'Complete special objectives to earn exclusive rewards!'**
  String get eventDescription;

  /// Participate button text
  ///
  /// In en, this message translates to:
  /// **'Participate'**
  String get participate;

  /// Rewards statistic label
  ///
  /// In en, this message translates to:
  /// **'Rewards'**
  String get rewards;

  /// Power-ups text
  ///
  /// In en, this message translates to:
  /// **'Power-ups'**
  String get powerUps;

  /// Bomb power-up
  ///
  /// In en, this message translates to:
  /// **'Bomb'**
  String get bomb;

  /// Lightning power-up
  ///
  /// In en, this message translates to:
  /// **'Lightning'**
  String get lightning;

  /// Rainbow power-up
  ///
  /// In en, this message translates to:
  /// **'Rainbow'**
  String get rainbow;

  /// Hammer power-up
  ///
  /// In en, this message translates to:
  /// **'Hammer'**
  String get hammer;

  /// Gameplay text
  ///
  /// In en, this message translates to:
  /// **'Gameplay'**
  String get gameplay;

  /// Match three instruction
  ///
  /// In en, this message translates to:
  /// **'Match 3 or more tiles of the same type to clear them'**
  String get matchThree;

  /// Combos instruction
  ///
  /// In en, this message translates to:
  /// **'Create combos for bonus points'**
  String get combos;

  /// Power-ups usage instruction
  ///
  /// In en, this message translates to:
  /// **'Use power-ups to help you in difficult situations'**
  String get powerUpsUsage;

  /// Lives system instruction
  ///
  /// In en, this message translates to:
  /// **'You have limited lives. Watch ads to get more!'**
  String get livesSystem;

  /// Read terms of use text
  ///
  /// In en, this message translates to:
  /// **'Read the terms of use'**
  String get readTermsOfUse;

  /// Last updated date text
  ///
  /// In en, this message translates to:
  /// **'Last updated: {date}'**
  String lastUpdated(String date);

  /// Privacy policy introduction
  ///
  /// In en, this message translates to:
  /// **'This privacy policy describes how Mind Bloom collects, uses, and protects your personal information when you use our mobile application. We are committed to protecting your privacy and treating your data with the utmost respect.'**
  String get privacyPolicyIntroduction;

  /// Information we collect heading
  ///
  /// In en, this message translates to:
  /// **'Information we collect'**
  String get informationWeCollect;

  /// We collect following information text
  ///
  /// In en, this message translates to:
  /// **'We collect the following information:'**
  String get weCollectFollowing;

  /// Game data text
  ///
  /// In en, this message translates to:
  /// **'Game Data'**
  String get gameData;

  /// Game data description
  ///
  /// In en, this message translates to:
  /// **'Progress, scores, game preferences'**
  String get gameDataDescription;

  /// Technical data text
  ///
  /// In en, this message translates to:
  /// **'Technical Data'**
  String get technicalData;

  /// Technical data description
  ///
  /// In en, this message translates to:
  /// **'Application version, device type, operating system'**
  String get technicalDataDescription;

  /// Usage data text
  ///
  /// In en, this message translates to:
  /// **'Usage Data'**
  String get usageData;

  /// Usage data description
  ///
  /// In en, this message translates to:
  /// **'Playtime, features used, performance metrics'**
  String get usageDataDescription;

  /// How we use data heading
  ///
  /// In en, this message translates to:
  /// **'How we use your data'**
  String get howWeUseData;

  /// Data usage description
  ///
  /// In en, this message translates to:
  /// **'We use your data to:'**
  String get dataUsageDescription;

  /// Improve gameplay text
  ///
  /// In en, this message translates to:
  /// **'Improve gameplay experience'**
  String get improveGameplay;

  /// Provide support text
  ///
  /// In en, this message translates to:
  /// **'Provide customer support'**
  String get provideSupport;

  /// Analyze usage text
  ///
  /// In en, this message translates to:
  /// **'Analyze application usage'**
  String get analyzeUsage;

  /// Data protection heading
  ///
  /// In en, this message translates to:
  /// **'Data Protection'**
  String get dataProtection;

  /// Data protection description
  ///
  /// In en, this message translates to:
  /// **'We implement appropriate security measures to protect your personal information against unauthorized access, alteration, disclosure, or destruction.'**
  String get dataProtectionDescription;

  /// Contact us heading
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contactUs;

  /// Contact us description
  ///
  /// In en, this message translates to:
  /// **'If you have any questions about this privacy policy, please contact us at:'**
  String get contactUsDescription;

  /// Email text
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// Email address
  ///
  /// In en, this message translates to:
  /// **'privacy@mindbloom.com'**
  String get emailAddress;

  /// How we use information heading
  ///
  /// In en, this message translates to:
  /// **'How we use your information'**
  String get howWeUseInformation;

  /// We use information for text
  ///
  /// In en, this message translates to:
  /// **'We use your information for:'**
  String get weUseInformationFor;

  /// Provide service text
  ///
  /// In en, this message translates to:
  /// **'Provide and improve the game service'**
  String get provideService;

  /// Personalize experience text
  ///
  /// In en, this message translates to:
  /// **'Personalize your game experience'**
  String get personalizeExperience;

  /// Display ads text
  ///
  /// In en, this message translates to:
  /// **'Display personalized advertisements (with your consent)'**
  String get displayAds;

  /// Ensure security text
  ///
  /// In en, this message translates to:
  /// **'Ensure security and prevent fraud'**
  String get ensureSecurity;

  /// Communicate service text
  ///
  /// In en, this message translates to:
  /// **'Communicate with you regarding the service'**
  String get communicateService;

  /// Data sharing heading
  ///
  /// In en, this message translates to:
  /// **'Data sharing'**
  String get dataSharing;

  /// Data sharing description
  ///
  /// In en, this message translates to:
  /// **'We do not sell, trade, or otherwise transfer your personal information to third parties without your consent, except as described in this policy.'**
  String get dataSharingDescription;

  /// Your rights heading
  ///
  /// In en, this message translates to:
  /// **'Your rights'**
  String get yourRights;

  /// Your rights description
  ///
  /// In en, this message translates to:
  /// **'You have the right to:'**
  String get yourRightsDescription;

  /// Access data text
  ///
  /// In en, this message translates to:
  /// **'Access your personal data'**
  String get accessData;

  /// Correct data text
  ///
  /// In en, this message translates to:
  /// **'Correct inaccurate data'**
  String get correctData;

  /// Delete data text
  ///
  /// In en, this message translates to:
  /// **'Delete your data'**
  String get deleteData;

  /// Withdraw consent text
  ///
  /// In en, this message translates to:
  /// **'Withdraw consent for data processing'**
  String get withdrawConsent;

  /// Data text
  ///
  /// In en, this message translates to:
  /// **'Data'**
  String get data;

  /// Audio text
  ///
  /// In en, this message translates to:
  /// **'Audio'**
  String get audio;

  /// Enable disable music text
  ///
  /// In en, this message translates to:
  /// **'Enable/disable background music'**
  String get enableDisableMusic;

  /// Enable disable sound effects text
  ///
  /// In en, this message translates to:
  /// **'Enable/disable sound effects'**
  String get enableDisableSfx;

  /// Game category filter
  ///
  /// In en, this message translates to:
  /// **'Game'**
  String get game;

  /// Enable disable animations text
  ///
  /// In en, this message translates to:
  /// **'Enable/disable animations'**
  String get enableDisableAnimations;

  /// Enable disable vibrations text
  ///
  /// In en, this message translates to:
  /// **'Enable/disable vibrations'**
  String get enableDisableVibrations;

  /// Music volume text
  ///
  /// In en, this message translates to:
  /// **'Music volume'**
  String get musicVolume;

  /// Effects volume text
  ///
  /// In en, this message translates to:
  /// **'Effects volume'**
  String get effectsVolume;

  /// Experience label
  ///
  /// In en, this message translates to:
  /// **'Experience'**
  String get experience;

  /// No more lives message
  ///
  /// In en, this message translates to:
  /// **'No more lives!'**
  String get noMoreLives;

  /// No more lives detailed message
  ///
  /// In en, this message translates to:
  /// **'You have no more lives. Watch an ad to get a free life, wait for them to recharge or buy more.'**
  String get noMoreLivesMessage;

  /// Wait button text
  ///
  /// In en, this message translates to:
  /// **'Wait'**
  String get wait;

  /// No level loaded message
  ///
  /// In en, this message translates to:
  /// **'No level loaded'**
  String get noLevelLoaded;

  /// Back to menu button text
  ///
  /// In en, this message translates to:
  /// **'Back to menu'**
  String get backToMenu;

  /// You have used all moves message
  ///
  /// In en, this message translates to:
  /// **'You have used all your moves!'**
  String get youHaveUsedAllMoves;

  /// About the game text
  ///
  /// In en, this message translates to:
  /// **'About the game'**
  String get aboutTheGame;

  /// Flutter Developer text
  ///
  /// In en, this message translates to:
  /// **'Flutter Developer'**
  String get flutterDeveloper;

  /// Read our terms of service text
  ///
  /// In en, this message translates to:
  /// **'Read our terms of service'**
  String get readOurTermsOfService;

  /// Discover how we protect your data text
  ///
  /// In en, this message translates to:
  /// **'Discover how we protect your data'**
  String get discoverHowWeProtectYourData;

  /// Moves remaining text
  ///
  /// In en, this message translates to:
  /// **'Moves remaining'**
  String get movesRemaining;

  /// No moves possible text
  ///
  /// In en, this message translates to:
  /// **'No moves possible. Use the shuffle button!'**
  String get noMovesPossible;

  /// Active event banner title
  ///
  /// In en, this message translates to:
  /// **'ACTIVE EVENT'**
  String get activeEvent;

  /// Days remaining for event
  ///
  /// In en, this message translates to:
  /// **'{days} days remaining'**
  String daysRemaining(int days);

  /// Event starts in X days
  ///
  /// In en, this message translates to:
  /// **'Starts in {days} days'**
  String startsIn(int days);

  /// Additional items count
  ///
  /// In en, this message translates to:
  /// **'+{count} others'**
  String others(int count);

  /// Progress section title
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get progress;

  /// Plant reward text
  ///
  /// In en, this message translates to:
  /// **'{rarity}★ Plant'**
  String plant(int rarity);

  /// Boosters count text
  ///
  /// In en, this message translates to:
  /// **'{count} boosters'**
  String boosters(int count);

  /// Completed achievement badge
  ///
  /// In en, this message translates to:
  /// **'COMPLETED'**
  String get completed;

  /// Challenges section title
  ///
  /// In en, this message translates to:
  /// **'Challenges'**
  String get challenges;

  /// Coming soon button text
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get comingSoon;

  /// Rare plant description
  ///
  /// In en, this message translates to:
  /// **'Rare {rarity} star plant'**
  String rarePlant(int rarity);

  /// Participation message
  ///
  /// In en, this message translates to:
  /// **'Participation in {eventName} in progress...'**
  String participationInProgress(String eventName);

  /// Spring event name
  ///
  /// In en, this message translates to:
  /// **'Spring Bloom'**
  String get springBloom;

  /// Spring event description
  ///
  /// In en, this message translates to:
  /// **'Celebrate renewal with magical flowers'**
  String get springBloomDescription;

  /// Summer event name
  ///
  /// In en, this message translates to:
  /// **'Summer Solstice'**
  String get summerSolstice;

  /// Summer event description
  ///
  /// In en, this message translates to:
  /// **'Enjoy the sun with sunny plants'**
  String get summerSolsticeDescription;

  /// Autumn event name
  ///
  /// In en, this message translates to:
  /// **'Autumn Harvest'**
  String get autumnHarvest;

  /// Autumn event description
  ///
  /// In en, this message translates to:
  /// **'Harvest the fruits of your efforts'**
  String get autumnHarvestDescription;

  /// Complete levels challenge
  ///
  /// In en, this message translates to:
  /// **'Complete {target} levels'**
  String completeLevels(int target);

  /// Earn stars challenge
  ///
  /// In en, this message translates to:
  /// **'Earn {target} stars'**
  String earnStars(int target);

  /// Use boosters challenge
  ///
  /// In en, this message translates to:
  /// **'Use {target} boosters'**
  String useBoosters(int target);

  /// Score points challenge
  ///
  /// In en, this message translates to:
  /// **'Score {target} points'**
  String scorePoints(int target);

  /// Popular items section title
  ///
  /// In en, this message translates to:
  /// **'Popular Items'**
  String get popularItems;

  /// Currency category filter
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currency;

  /// Premium category filter
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get premium;

  /// Popular badge text
  ///
  /// In en, this message translates to:
  /// **'POP'**
  String get pop;

  /// Not enough currency message
  ///
  /// In en, this message translates to:
  /// **'You don\'t have enough {currency}'**
  String notEnoughCurrency(String currency);

  /// Purchase success message
  ///
  /// In en, this message translates to:
  /// **'{item} purchased successfully!'**
  String purchaseSuccess(String item);

  /// 5 lives item title
  ///
  /// In en, this message translates to:
  /// **'5 Lives'**
  String get lives5;

  /// 5 lives item description
  ///
  /// In en, this message translates to:
  /// **'Recharge your lives to keep playing'**
  String get lives5Description;

  /// 10 lives item title
  ///
  /// In en, this message translates to:
  /// **'10 Lives'**
  String get lives10;

  /// 10 lives item description
  ///
  /// In en, this message translates to:
  /// **'Larger life pack'**
  String get lives10Description;

  /// 100 coins item title
  ///
  /// In en, this message translates to:
  /// **'100 Coins'**
  String get coins100;

  /// 100 coins item description
  ///
  /// In en, this message translates to:
  /// **'Small coin pack'**
  String get coins100Description;

  /// 500 coins item title
  ///
  /// In en, this message translates to:
  /// **'500 Coins'**
  String get coins500;

  /// 500 coins item description
  ///
  /// In en, this message translates to:
  /// **'Medium coin pack'**
  String get coins500Description;

  /// 1000 coins item title
  ///
  /// In en, this message translates to:
  /// **'1000 Coins'**
  String get coins1000;

  /// 1000 coins item description
  ///
  /// In en, this message translates to:
  /// **'Large coin pack'**
  String get coins1000Description;

  /// 50 gems item title
  ///
  /// In en, this message translates to:
  /// **'50 Gems'**
  String get gems50;

  /// 50 gems item description
  ///
  /// In en, this message translates to:
  /// **'Premium gem pack'**
  String get gems50Description;

  /// Shuffler booster title
  ///
  /// In en, this message translates to:
  /// **'Shuffler'**
  String get shuffler;

  /// Shuffler booster description
  ///
  /// In en, this message translates to:
  /// **'Automatically shuffles the board'**
  String get shufflerDescription;

  /// Hint booster description
  ///
  /// In en, this message translates to:
  /// **'Shows a possible move'**
  String get hintDescription;

  /// Remove ads item title
  ///
  /// In en, this message translates to:
  /// **'No Ads'**
  String get removeAds;

  /// Remove ads item description
  ///
  /// In en, this message translates to:
  /// **'Removes all advertisements'**
  String get removeAdsDescription;

  /// Plant level text
  ///
  /// In en, this message translates to:
  /// **'Level {level}'**
  String plantLevel(int level);

  /// Unlock condition section title
  ///
  /// In en, this message translates to:
  /// **'Unlock Condition'**
  String get unlockCondition;

  /// Bonuses section title
  ///
  /// In en, this message translates to:
  /// **'Bonuses'**
  String get bonuses;

  /// Extra moves bonus description
  ///
  /// In en, this message translates to:
  /// **'+{value} extra moves'**
  String extraMoves(int value);

  /// Score multiplier bonus description
  ///
  /// In en, this message translates to:
  /// **'Score x{value}'**
  String scoreMultiplier(int value);

  /// Coin multiplier bonus description
  ///
  /// In en, this message translates to:
  /// **'Coins x{value}'**
  String coinMultiplier(int value);

  /// Extra lives bonus description
  ///
  /// In en, this message translates to:
  /// **'+{value} life(s)'**
  String extraLives(int value);

  /// Plant upgrade success message
  ///
  /// In en, this message translates to:
  /// **'{plantName} upgraded to level {level}!'**
  String plantUpgraded(String plantName, int level);

  /// Progression category filter
  ///
  /// In en, this message translates to:
  /// **'Progression'**
  String get progression;

  /// Social category filter
  ///
  /// In en, this message translates to:
  /// **'Social'**
  String get social;

  /// Reward section title
  ///
  /// In en, this message translates to:
  /// **'Reward'**
  String get reward;

  /// Reward claimed button text
  ///
  /// In en, this message translates to:
  /// **'Reward claimed'**
  String get rewardClaimed;

  /// In progress button text
  ///
  /// In en, this message translates to:
  /// **'In progress...'**
  String get inProgress;

  /// Reward claimed success message
  ///
  /// In en, this message translates to:
  /// **'Reward for {achievementTitle} claimed!'**
  String rewardClaimedMessage(String achievementTitle);

  /// Confirmed beginner achievement title
  ///
  /// In en, this message translates to:
  /// **'Confirmed Beginner'**
  String get confirmedBeginner;

  /// Confirmed beginner achievement description
  ///
  /// In en, this message translates to:
  /// **'Complete 10 levels'**
  String get confirmedBeginnerDescription;

  /// Expert in the making achievement title
  ///
  /// In en, this message translates to:
  /// **'Expert in the Making'**
  String get expertInTheMaking;

  /// Expert in the making achievement description
  ///
  /// In en, this message translates to:
  /// **'Complete 50 levels'**
  String get expertInTheMakingDescription;

  /// Perfectionist achievement title
  ///
  /// In en, this message translates to:
  /// **'Perfectionist'**
  String get perfectionist;

  /// Perfectionist achievement description
  ///
  /// In en, this message translates to:
  /// **'Get 3 stars on a level'**
  String get perfectionistDescription;

  /// Scorer achievement title
  ///
  /// In en, this message translates to:
  /// **'Scorer'**
  String get scorer;

  /// Scorer achievement description
  ///
  /// In en, this message translates to:
  /// **'Score 1,000 points in one level'**
  String get scorerDescription;

  /// Score master achievement title
  ///
  /// In en, this message translates to:
  /// **'Score Master'**
  String get scoreMaster;

  /// Score master achievement description
  ///
  /// In en, this message translates to:
  /// **'Score 5,000 points in one level'**
  String get scoreMasterDescription;

  /// Accumulator achievement title
  ///
  /// In en, this message translates to:
  /// **'Accumulator'**
  String get accumulator;

  /// Accumulator achievement description
  ///
  /// In en, this message translates to:
  /// **'Score a total of 100,000 points'**
  String get accumulatorDescription;

  /// Beginner botanist achievement title
  ///
  /// In en, this message translates to:
  /// **'Beginner Botanist'**
  String get beginnerBotanist;

  /// Beginner botanist achievement description
  ///
  /// In en, this message translates to:
  /// **'Unlock your first plant'**
  String get beginnerBotanistDescription;

  /// Collector achievement title
  ///
  /// In en, this message translates to:
  /// **'Collector'**
  String get collector;

  /// Collector achievement description
  ///
  /// In en, this message translates to:
  /// **'Unlock 5 plants'**
  String get collectorDescription;

  /// Rarity hunter achievement title
  ///
  /// In en, this message translates to:
  /// **'Rarity Hunter'**
  String get rarityHunter;

  /// Rarity hunter achievement description
  ///
  /// In en, this message translates to:
  /// **'Unlock a 4-star or higher plant'**
  String get rarityHunterDescription;

  /// Combo master achievement title
  ///
  /// In en, this message translates to:
  /// **'Combo Master'**
  String get comboMaster;

  /// Combo master achievement description
  ///
  /// In en, this message translates to:
  /// **'Make a 5-tile combo'**
  String get comboMasterDescription;

  /// Legendary combo achievement title
  ///
  /// In en, this message translates to:
  /// **'Legendary Combo'**
  String get legendaryCombo;

  /// Legendary combo achievement description
  ///
  /// In en, this message translates to:
  /// **'Make a 10-tile combo'**
  String get legendaryComboDescription;

  /// Saver achievement title
  ///
  /// In en, this message translates to:
  /// **'Saver'**
  String get saver;

  /// Saver achievement description
  ///
  /// In en, this message translates to:
  /// **'Complete a level with more than 5 moves remaining'**
  String get saverDescription;

  /// Loyal achievement title
  ///
  /// In en, this message translates to:
  /// **'Loyal'**
  String get loyal;

  /// Loyal achievement description
  ///
  /// In en, this message translates to:
  /// **'Log in 7 days in a row'**
  String get loyalDescription;

  /// Sharer achievement title
  ///
  /// In en, this message translates to:
  /// **'Sharer'**
  String get sharer;

  /// Sharer achievement description
  ///
  /// In en, this message translates to:
  /// **'Share your score 3 times'**
  String get sharerDescription;

  /// User level text
  ///
  /// In en, this message translates to:
  /// **'Level {level}'**
  String userLevel(int level);

  /// Completed levels statistic
  ///
  /// In en, this message translates to:
  /// **'Completed Levels'**
  String get completedLevels;

  /// Detailed statistics section title
  ///
  /// In en, this message translates to:
  /// **'Detailed Statistics'**
  String get detailedStats;

  /// Total coins statistic
  ///
  /// In en, this message translates to:
  /// **'Total Coins'**
  String get totalCoins;

  /// Stars earned statistic
  ///
  /// In en, this message translates to:
  /// **'Stars Earned'**
  String get starsEarned;

  /// Highest level statistic
  ///
  /// In en, this message translates to:
  /// **'Highest Level'**
  String get highestLevel;

  /// Quick actions section title
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// Review tutorial action
  ///
  /// In en, this message translates to:
  /// **'Review Tutorial'**
  String get reviewTutorial;

  /// Share profile action
  ///
  /// In en, this message translates to:
  /// **'Share Profile'**
  String get shareProfile;

  /// Recent achievements section title
  ///
  /// In en, this message translates to:
  /// **'Recent Achievements'**
  String get recentAchievements;

  /// First level completed achievement
  ///
  /// In en, this message translates to:
  /// **'First level completed'**
  String get firstLevelCompleted;

  /// Three stars obtained achievement
  ///
  /// In en, this message translates to:
  /// **'3 stars obtained'**
  String get threeStarsObtained;

  /// Streak of five levels achievement
  ///
  /// In en, this message translates to:
  /// **'Streak of 5 levels'**
  String get streakOfFive;

  /// Days ago text
  ///
  /// In en, this message translates to:
  /// **'{days} days ago'**
  String daysAgo(int days);

  /// One day ago text
  ///
  /// In en, this message translates to:
  /// **'1 day ago'**
  String get dayAgo;

  /// Today text
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// Reset data dialog title
  ///
  /// In en, this message translates to:
  /// **'Reset data?'**
  String get resetDataTitle;

  /// Reset data dialog message
  ///
  /// In en, this message translates to:
  /// **'This action will delete all your progress data. This action is irreversible.'**
  String get resetDataMessage;

  /// Share coming soon message
  ///
  /// In en, this message translates to:
  /// **'Sharing coming soon...'**
  String get shareComingSoon;

  /// Acceptance of terms section title
  ///
  /// In en, this message translates to:
  /// **'1. Acceptance of Terms'**
  String get acceptanceOfTerms;

  /// Acceptance of terms section content
  ///
  /// In en, this message translates to:
  /// **'By using the Mind Bloom application, you agree to be bound by these terms of use. If you do not accept these terms, please do not use our application.'**
  String get acceptanceOfTermsContent;

  /// Service description section title
  ///
  /// In en, this message translates to:
  /// **'2. Service Description'**
  String get serviceDescription;

  /// Service description section content
  ///
  /// In en, this message translates to:
  /// **'Mind Bloom is a mobile puzzle game developed by YACOUBA SANTARA. The application offers match-3 mechanics with RPG progression elements in a magical garden universe.'**
  String get serviceDescriptionContent;

  /// Authorized use section title
  ///
  /// In en, this message translates to:
  /// **'3. Authorized Use'**
  String get authorizedUse;

  /// Authorized use section content
  ///
  /// In en, this message translates to:
  /// **'You may use Mind Bloom for personal and non-commercial purposes only. It is prohibited to:\n\n• Copy, modify or distribute the application\n• Use the application for commercial purposes without authorization\n• Attempt to bypass security measures\n• Use the application in a way that harms other users'**
  String get authorizedUseContent;

  /// Intellectual property section title
  ///
  /// In en, this message translates to:
  /// **'4. Content and Intellectual Property'**
  String get intellectualProperty;

  /// Intellectual property section content
  ///
  /// In en, this message translates to:
  /// **'All elements of Mind Bloom, including but not limited to graphics, sounds, source code, and design, are the exclusive property of YACOUBA SANTARA and are protected by copyright laws.'**
  String get intellectualPropertyContent;

  /// In-app purchases section title
  ///
  /// In en, this message translates to:
  /// **'5. In-App Purchases'**
  String get inAppPurchases;

  /// In-app purchases section content
  ///
  /// In en, this message translates to:
  /// **'The application may contain in-app purchases for additional lives, boosters, or other game elements. All purchases are final and non-refundable, except as required by applicable law.'**
  String get inAppPurchasesContent;

  /// Advertisements section title
  ///
  /// In en, this message translates to:
  /// **'6. Advertisements'**
  String get advertisements;

  /// Advertisements section content
  ///
  /// In en, this message translates to:
  /// **'Mind Bloom may display third-party advertisements. These advertisements are managed by advertising partners and we are not responsible for the content of these advertisements.'**
  String get advertisementsContent;

  /// Liability limitation section title
  ///
  /// In en, this message translates to:
  /// **'7. Limitation of Liability'**
  String get liabilityLimitation;

  /// Liability limitation section content
  ///
  /// In en, this message translates to:
  /// **'The application is provided \'as is\' without warranty of any kind. We will not be liable for direct, indirect, incidental or consequential damages resulting from the use of the application.'**
  String get liabilityLimitationContent;

  /// Terms modifications section title
  ///
  /// In en, this message translates to:
  /// **'8. Terms Modifications'**
  String get termsModifications;

  /// Terms modifications section content
  ///
  /// In en, this message translates to:
  /// **'We reserve the right to modify these terms of use at any time. Modifications will take effect upon their publication in the application. Your continued use of the application constitutes your acceptance of the modified terms.'**
  String get termsModificationsContent;

  /// Termination section title
  ///
  /// In en, this message translates to:
  /// **'9. Termination'**
  String get termination;

  /// Termination section content
  ///
  /// In en, this message translates to:
  /// **'We reserve the right to suspend or terminate your access to the application at any time, without notice, for violation of these terms of use.'**
  String get terminationContent;

  /// Applicable law section title
  ///
  /// In en, this message translates to:
  /// **'10. Applicable Law'**
  String get applicableLaw;

  /// Applicable law section content
  ///
  /// In en, this message translates to:
  /// **'These terms of use are governed by French law. Any dispute will be subject to the exclusive jurisdiction of French courts.'**
  String get applicableLawContent;

  /// Contact section title
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get contact;

  /// Contact section content
  ///
  /// In en, this message translates to:
  /// **'For any questions regarding these terms of use, you can contact us at:'**
  String get contactContent;

  /// Data storage section title
  ///
  /// In en, this message translates to:
  /// **'4. Data Storage and Security'**
  String get dataStorage;

  /// Data storage section content
  ///
  /// In en, this message translates to:
  /// **'Your data is stored securely:\n\n• **Encryption**: Sensitive data is encrypted\n• **Limited Access**: Only authorized personnel can access data\n• **Backup**: Regular backups are performed\n• **Duration**: Data is kept only as long as necessary'**
  String get dataStorageContent;

  /// Cookies section title
  ///
  /// In en, this message translates to:
  /// **'5. Cookies and Similar Technologies'**
  String get cookies;

  /// Cookies section content
  ///
  /// In en, this message translates to:
  /// **'The application may use:\n\n• **Local Cookies**: To save your game preferences\n• **Advertising Identifiers**: To personalize advertisements\n• **Analytics**: To understand application usage\n\nYou can disable these features in your device settings.'**
  String get cookiesContent;

  /// Third-party ads section title
  ///
  /// In en, this message translates to:
  /// **'7. Third-Party Advertisements and Partners'**
  String get thirdPartyAds;

  /// Third-party ads section content
  ///
  /// In en, this message translates to:
  /// **'The application may display advertisements through third-party partners like Google AdMob. These partners may collect information to personalize advertisements. You can:\n\n• Disable ad personalization in settings\n• Use your device\'s privacy settings\n• Contact advertising partners directly'**
  String get thirdPartyAdsContent;

  /// Minors data section title
  ///
  /// In en, this message translates to:
  /// **'8. Minors\' Data'**
  String get minorsData;

  /// Minors data section content
  ///
  /// In en, this message translates to:
  /// **'Mind Bloom does not knowingly collect personal information from children under 13. If we discover that a child under 13 has provided us with personal information, we will delete it immediately.'**
  String get minorsDataContent;

  /// Policy changes section title
  ///
  /// In en, this message translates to:
  /// **'9. Changes to This Policy'**
  String get policyChanges;

  /// Policy changes section content
  ///
  /// In en, this message translates to:
  /// **'We may modify this privacy policy at any time. Important changes will be communicated via the application or by email. We encourage you to regularly review this policy.'**
  String get policyChangesContent;

  /// Legal basis section title
  ///
  /// In en, this message translates to:
  /// **'10. Legal Basis for Processing'**
  String get legalBasis;

  /// Legal basis section content
  ///
  /// In en, this message translates to:
  /// **'We process your personal data on the basis of:\n\n• **Contract Performance**: To provide the gaming service\n• **Legitimate Interest**: To improve the application and prevent fraud\n• **Consent**: For personalized advertisements and marketing communications'**
  String get legalBasisContent;

  /// Contact and DPO section title
  ///
  /// In en, this message translates to:
  /// **'Contact and DPO'**
  String get contactDPO;

  /// Contact and DPO section content
  ///
  /// In en, this message translates to:
  /// **'For any questions regarding this privacy policy or to exercise your rights, contact us:'**
  String get contactDPOContent;

  /// Response time commitment text
  ///
  /// In en, this message translates to:
  /// **'We commit to responding to your request within 30 days.'**
  String get responseTime;

  /// Introduction section title
  ///
  /// In en, this message translates to:
  /// **'Introduction'**
  String get introduction;

  /// Account section title
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// Enter new username hint
  ///
  /// In en, this message translates to:
  /// **'Enter new username'**
  String get enterNewUsername;

  /// Theme section title
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// Light theme option
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get lightTheme;

  /// Dark theme option
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get darkTheme;

  /// System theme option
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get systemTheme;

  /// Theme section description
  ///
  /// In en, this message translates to:
  /// **'Choose your preferred theme'**
  String get themeDescription;

  /// Message shown when sharing profile
  ///
  /// In en, this message translates to:
  /// **'Check out my progress in Mind Bloom! Can you beat my score?'**
  String get shareProfileMessage;

  /// Label for completed levels count
  ///
  /// In en, this message translates to:
  /// **'Levels Completed'**
  String get levelsCompleted;

  /// Description for watch ad dialog
  ///
  /// In en, this message translates to:
  /// **'Watch a short video to earn one life and continue playing!'**
  String get watchAdForLifeDescription;

  /// Text showing what user will earn
  ///
  /// In en, this message translates to:
  /// **'Earn 1 Life'**
  String get earnOneLife;

  /// Message when life is earned
  ///
  /// In en, this message translates to:
  /// **'Life earned! You can continue playing.'**
  String get lifeEarned;

  /// Message when no ad is available
  ///
  /// In en, this message translates to:
  /// **'No ad available at the moment. Please try again later.'**
  String get noAdAvailable;

  /// Message when ad fails to load
  ///
  /// In en, this message translates to:
  /// **'Error loading ad. Please try again.'**
  String get adError;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
