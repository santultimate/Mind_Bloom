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

  /// Lives name
  ///
  /// In en, this message translates to:
  /// **'Lives'**
  String get lives;

  /// Currency coins name
  ///
  /// In en, this message translates to:
  /// **'Coins'**
  String get coins;

  /// Gems name
  ///
  /// In en, this message translates to:
  /// **'Gems'**
  String get gems;

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

  /// Title for hint booster
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

  /// Cancel button
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

  /// Delete button
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Edit button text
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// Button to close a dialog
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// Confirmation button
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

  /// Error title
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

  /// Free life button text
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

  /// Current streak title
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

  /// Word events
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

  /// Text for a locked world
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

  /// Indicates active events
  ///
  /// In en, this message translates to:
  /// **'Active'**
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

  /// Button to participate in an event
  ///
  /// In en, this message translates to:
  /// **'Participate'**
  String get participate;

  /// Word rewards
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

  /// Experience text
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

  /// Number of days remaining for an event
  ///
  /// In en, this message translates to:
  /// **'{count} days remaining'**
  String daysRemaining(int count);

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

  /// Generic plant name
  ///
  /// In en, this message translates to:
  /// **'Plant'**
  String get plant;

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

  /// Word challenges
  ///
  /// In en, this message translates to:
  /// **'Challenges'**
  String get challenges;

  /// Indicates that an event will be available soon
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

  /// Title for shuffler booster
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

  /// Title for remove ads
  ///
  /// In en, this message translates to:
  /// **'Remove ads'**
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

  /// Title for score multiplier booster
  ///
  /// In en, this message translates to:
  /// **'Score multiplier'**
  String get scoreMultiplier;

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

  /// Name of progression category
  ///
  /// In en, this message translates to:
  /// **'Progression'**
  String get progression;

  /// Social category filter
  ///
  /// In en, this message translates to:
  /// **'Social'**
  String get social;

  /// Generic reward name
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

  /// Life earned success message
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

  /// Time remaining label
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get timeRemaining;

  /// Next life regeneration label
  ///
  /// In en, this message translates to:
  /// **'Next life'**
  String get nextLife;

  /// Watch ad for free life message
  ///
  /// In en, this message translates to:
  /// **'Watch an ad to get a free life!'**
  String get watchAdForFreeLife;

  /// Daily rewards screen title
  ///
  /// In en, this message translates to:
  /// **'Daily Rewards'**
  String get dailyRewards;

  /// Claim reward button
  ///
  /// In en, this message translates to:
  /// **'Claim!'**
  String get claimReward;

  /// Reward already claimed message
  ///
  /// In en, this message translates to:
  /// **'Reward already claimed'**
  String get rewardAlreadyClaimed;

  /// Next reward in text
  ///
  /// In en, this message translates to:
  /// **'Next reward in:'**
  String get nextRewardIn;

  /// How it works title
  ///
  /// In en, this message translates to:
  /// **'How it works?'**
  String get howItWorks;

  /// Daily reward info 1
  ///
  /// In en, this message translates to:
  /// **'Log in every day to claim your reward'**
  String get dailyRewardInfo1;

  /// Daily reward info 2
  ///
  /// In en, this message translates to:
  /// **'The longer your streak, the better the rewards'**
  String get dailyRewardInfo2;

  /// Daily reward info 3
  ///
  /// In en, this message translates to:
  /// **'The 7th day offers a legendary reward'**
  String get dailyRewardInfo3;

  /// Daily reward info 4
  ///
  /// In en, this message translates to:
  /// **'Rewards reset at midnight'**
  String get dailyRewardInfo4;

  /// Day reward title
  ///
  /// In en, this message translates to:
  /// **'Day {day} Reward'**
  String rewardOfDay(int day);

  /// Legendary streak text
  ///
  /// In en, this message translates to:
  /// **'Legendary Streak!'**
  String get legendaryStreak;

  /// Perfect performance text
  ///
  /// In en, this message translates to:
  /// **'Perfect Performance! Bonus x2'**
  String get perfectPerformance;

  /// Milestone level text
  ///
  /// In en, this message translates to:
  /// **'Milestone Level! Special bonus'**
  String get milestoneLevel;

  /// Rewards obtained title
  ///
  /// In en, this message translates to:
  /// **'Rewards Obtained'**
  String get rewardsClaimed;

  /// Combo bonus text
  ///
  /// In en, this message translates to:
  /// **'Combo Bonus x{multiplier}'**
  String comboBonus(int multiplier);

  /// Spectacular combo text
  ///
  /// In en, this message translates to:
  /// **'Spectacular Combo!'**
  String get spectacularCombo;

  /// Mega match text
  ///
  /// In en, this message translates to:
  /// **'Mega Match of {count} tiles!'**
  String megaMatch(int count);

  /// Global progress text
  ///
  /// In en, this message translates to:
  /// **'Global Progress'**
  String get globalProgress;

  /// Collect tiles objective
  ///
  /// In en, this message translates to:
  /// **'Collect {count} {tileName}'**
  String collectTilesObjective(int count, String tileName);

  /// Clear blockers objective
  ///
  /// In en, this message translates to:
  /// **'Destroy {count} blockers'**
  String clearBlockersObjective(int count);

  /// Reach score objective
  ///
  /// In en, this message translates to:
  /// **'Reach {count} points'**
  String reachScoreObjective(int count);

  /// Free creature objective
  ///
  /// In en, this message translates to:
  /// **'Free {count} creatures'**
  String freeCreatureObjective(int count);

  /// Clear jelly objective
  ///
  /// In en, this message translates to:
  /// **'Destroy {count} jellies'**
  String clearJellyObjective(int count);

  /// Coins bonus title
  ///
  /// In en, this message translates to:
  /// **'Coins Bonus'**
  String get coinsBonus;

  /// Free gems title
  ///
  /// In en, this message translates to:
  /// **'Free Gems'**
  String get gemsGratuits;

  /// Watch ad for coins description
  ///
  /// In en, this message translates to:
  /// **'Watch an ad to get coins'**
  String get watchAdForCoins;

  /// Watch ad for gems description
  ///
  /// In en, this message translates to:
  /// **'Watch an ad to get gems'**
  String get watchAdForGems;

  /// Watch button
  ///
  /// In en, this message translates to:
  /// **'WATCH'**
  String get watchButton;

  /// No description provided for @debugUnlockAllLevels.
  ///
  /// In en, this message translates to:
  /// **'Unlock All Levels (DEBUG)'**
  String get debugUnlockAllLevels;

  /// No description provided for @debugUnlockAllLevelsDescription.
  ///
  /// In en, this message translates to:
  /// **'Test function to unlock all levels'**
  String get debugUnlockAllLevelsDescription;

  /// No description provided for @shareScore.
  ///
  /// In en, this message translates to:
  /// **'Share Score'**
  String get shareScore;

  /// No description provided for @shareScoreTitle.
  ///
  /// In en, this message translates to:
  /// **'Share My Score'**
  String get shareScoreTitle;

  /// Score sharing message
  ///
  /// In en, this message translates to:
  /// **'I got {score} points on level {level} in Mind Bloom! Can you do better? 🌱'**
  String shareScoreMessage(int score, int level);

  /// No description provided for @shareScoreSuccess.
  ///
  /// In en, this message translates to:
  /// **'Score shared successfully!'**
  String get shareScoreSuccess;

  /// No description provided for @shareScoreError.
  ///
  /// In en, this message translates to:
  /// **'Error sharing score'**
  String get shareScoreError;

  /// Quit button text
  ///
  /// In en, this message translates to:
  /// **'Quit'**
  String get quit;

  /// Winter event name
  ///
  /// In en, this message translates to:
  /// **'Winter Solstice'**
  String get winterSolstice;

  /// Winter event description
  ///
  /// In en, this message translates to:
  /// **'Light up the night with ice crystals'**
  String get winterSolsticeDescription;

  /// Valentine's Day event name
  ///
  /// In en, this message translates to:
  /// **'Valentine\'s Day'**
  String get valentineDay;

  /// Valentine's Day event description
  ///
  /// In en, this message translates to:
  /// **'Share love with romantic flowers'**
  String get valentineDayDescription;

  /// Achievement title for sharing badges
  ///
  /// In en, this message translates to:
  /// **'Badge Sharer'**
  String get shareAchievements;

  /// Achievement description for sharing badges
  ///
  /// In en, this message translates to:
  /// **'Share 5 achievements with your friends'**
  String get shareAchievementsDescription;

  /// Social butterfly achievement title
  ///
  /// In en, this message translates to:
  /// **'Social Butterfly'**
  String get socialButterfly;

  /// Social butterfly achievement description
  ///
  /// In en, this message translates to:
  /// **'Share 10 achievements with your friends'**
  String get socialButterflyDescription;

  /// Tooltip for sharing an individual badge
  ///
  /// In en, this message translates to:
  /// **'Share this badge'**
  String get shareThisBadge;

  /// Button to share all achievements
  ///
  /// In en, this message translates to:
  /// **'Share my achievements'**
  String get shareMyAchievements;

  /// Confirmation message for sharing a badge
  ///
  /// In en, this message translates to:
  /// **'Badge \"{badgeTitle}\" shared! 🎉'**
  String badgeShared(String badgeTitle);

  /// Confirmation message for sharing all achievements
  ///
  /// In en, this message translates to:
  /// **'My achievements shared! 🎉'**
  String get achievementsShared;

  /// Notification title for a new unlocked world
  ///
  /// In en, this message translates to:
  /// **'New World Unlocked'**
  String get newWorldUnlocked;

  /// Button to continue the game
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueGame;

  /// Message when life purchase is limited by maximum
  ///
  /// In en, this message translates to:
  /// **'Only {actualAdded} lives added (limit: {maxLives} lives)'**
  String livesLimitedToMax(int actualAdded, int maxLives);

  /// Easter event name
  ///
  /// In en, this message translates to:
  /// **'Magical Easter'**
  String get easterEvent;

  /// Easter event description
  ///
  /// In en, this message translates to:
  /// **'Discover hidden magical eggs'**
  String get easterEventDescription;

  /// Halloween event name
  ///
  /// In en, this message translates to:
  /// **'Enchanted Halloween'**
  String get halloweenEvent;

  /// Halloween event description
  ///
  /// In en, this message translates to:
  /// **'Plant mysterious pumpkins'**
  String get halloweenEventDescription;

  /// Christmas event name
  ///
  /// In en, this message translates to:
  /// **'Fairy Christmas'**
  String get christmasEvent;

  /// Christmas event description
  ///
  /// In en, this message translates to:
  /// **'Decorate your garden with Christmas stars'**
  String get christmasEventDescription;

  /// New Year event name
  ///
  /// In en, this message translates to:
  /// **'Bright New Year'**
  String get newYearEvent;

  /// New Year event description
  ///
  /// In en, this message translates to:
  /// **'Start the year with magical fireworks'**
  String get newYearEventDescription;

  /// Thanksgiving event name
  ///
  /// In en, this message translates to:
  /// **'Thanksgiving'**
  String get thanksgivingEvent;

  /// Thanksgiving event description
  ///
  /// In en, this message translates to:
  /// **'Harvest abundance with gratitude'**
  String get thanksgivingEventDescription;

  /// Mother's Day event name
  ///
  /// In en, this message translates to:
  /// **'Mother\'s Day'**
  String get motherDayEvent;

  /// Mother's Day event description
  ///
  /// In en, this message translates to:
  /// **'Offer flowers as a tribute to mothers'**
  String get motherDayEventDescription;

  /// Father's Day event name
  ///
  /// In en, this message translates to:
  /// **'Father\'s Day'**
  String get fatherDayEvent;

  /// Father's Day event description
  ///
  /// In en, this message translates to:
  /// **'Cultivate strength with robust plants'**
  String get fatherDayEventDescription;

  /// Spring Cleaning event name
  ///
  /// In en, this message translates to:
  /// **'Spring Cleaning'**
  String get springCleaningEvent;

  /// Spring Cleaning event description
  ///
  /// In en, this message translates to:
  /// **'Refresh your garden for a new season'**
  String get springCleaningEventDescription;

  /// Summer Festival event name
  ///
  /// In en, this message translates to:
  /// **'Summer Festival'**
  String get summerFestivalEvent;

  /// Summer Festival event description
  ///
  /// In en, this message translates to:
  /// **'Grand summer festival with many rewards'**
  String get summerFestivalEventDescription;

  /// Harvest Festival event name
  ///
  /// In en, this message translates to:
  /// **'Harvest Festival'**
  String get harvestFestivalEvent;

  /// Harvest Festival event description
  ///
  /// In en, this message translates to:
  /// **'Celebrate autumn\'s abundance'**
  String get harvestFestivalEventDescription;

  /// Winter Festival event name
  ///
  /// In en, this message translates to:
  /// **'Winter Festival'**
  String get winterFestivalEvent;

  /// Winter Festival event description
  ///
  /// In en, this message translates to:
  /// **'Light up the dark season with crystals'**
  String get winterFestivalEventDescription;

  /// Special Update event name
  ///
  /// In en, this message translates to:
  /// **'Special Update'**
  String get specialUpdateEvent;

  /// Special Update event description
  ///
  /// In en, this message translates to:
  /// **'Discover new features'**
  String get specialUpdateEventDescription;

  /// Community Challenge event name
  ///
  /// In en, this message translates to:
  /// **'Community Challenge'**
  String get communityChallengeEvent;

  /// Community Challenge event description
  ///
  /// In en, this message translates to:
  /// **'Take on challenges with the whole community'**
  String get communityChallengeEventDescription;

  /// Limited Time Event name
  ///
  /// In en, this message translates to:
  /// **'Limited Time Event'**
  String get limitedTimeEvent;

  /// Limited Time Event description
  ///
  /// In en, this message translates to:
  /// **'Enjoy this unique event before it disappears'**
  String get limitedTimeEventDescription;

  /// Birthday event name
  ///
  /// In en, this message translates to:
  /// **'Mind Bloom Birthday'**
  String get birthdayEvent;

  /// Birthday event description
  ///
  /// In en, this message translates to:
  /// **'Celebrate one year of Mind Bloom with surprises'**
  String get birthdayEventDescription;

  /// Milestone event name
  ///
  /// In en, this message translates to:
  /// **'Milestone Event'**
  String get milestoneEvent;

  /// Milestone event description
  ///
  /// In en, this message translates to:
  /// **'Celebrate the game\'s major milestones'**
  String get milestoneEventDescription;

  /// Earth Day event name
  ///
  /// In en, this message translates to:
  /// **'Earth Day'**
  String get earthDayEvent;

  /// Earth Day event description
  ///
  /// In en, this message translates to:
  /// **'Protect nature with eco-friendly plants'**
  String get earthDayEventDescription;

  /// Independence Day event name
  ///
  /// In en, this message translates to:
  /// **'Independence Day'**
  String get independenceDayEvent;

  /// Independence Day event description
  ///
  /// In en, this message translates to:
  /// **'Celebrate with patriotic plants'**
  String get independenceDayEventDescription;

  /// Description for completing actions
  ///
  /// In en, this message translates to:
  /// **'Complete {target} {actionType} actions'**
  String completeActions(int target, String actionType);

  /// Description for playing consecutive days
  ///
  /// In en, this message translates to:
  /// **'Play for {target} consecutive days'**
  String playConsecutiveDays(int target);

  /// Description for completing levels with stars
  ///
  /// In en, this message translates to:
  /// **'Complete {target} levels with {stars} stars'**
  String completeLevelsWithStars(int target, int stars);

  /// Description for completing quests
  ///
  /// In en, this message translates to:
  /// **'Complete {target} {questType} quests'**
  String completeQuests(int target, String questType);

  /// Description for collecting items
  ///
  /// In en, this message translates to:
  /// **'Collect {target} {itemType} items'**
  String collectItems(int target, String itemType);

  /// Description for completing levels in X days
  ///
  /// In en, this message translates to:
  /// **'Complete {target} levels in {days} days'**
  String completeLevelsInDays(int target, int days);

  /// Description for giving gifts
  ///
  /// In en, this message translates to:
  /// **'Give {target} gifts'**
  String giveGifts(int target);

  /// Description for exploring new features
  ///
  /// In en, this message translates to:
  /// **'Explore the new features'**
  String get exploreNewFeatures;

  /// Message for loading events
  ///
  /// In en, this message translates to:
  /// **'Loading events...'**
  String get loadingEvents;

  /// Title for active events section
  ///
  /// In en, this message translates to:
  /// **'Active Events'**
  String get activeEvents;

  /// Title for this month's events section
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get thisMonth;

  /// Title for upcoming events section
  ///
  /// In en, this message translates to:
  /// **'Upcoming Events'**
  String get upcomingEvents;

  /// Indicates the last day of an event
  ///
  /// In en, this message translates to:
  /// **'Last day'**
  String get lastDay;

  /// Number of days left
  ///
  /// In en, this message translates to:
  /// **'{count} days'**
  String daysLeft(int count);

  /// Number of days before an event starts
  ///
  /// In en, this message translates to:
  /// **'In {count} days'**
  String inDays(int count);

  /// Indicates that an event is finished
  ///
  /// In en, this message translates to:
  /// **'Finished'**
  String get finished;

  /// Number of challenges in an event
  ///
  /// In en, this message translates to:
  /// **'Challenges ({count})'**
  String challengesCount(int count);

  /// Title for event statistics section
  ///
  /// In en, this message translates to:
  /// **'Event Statistics'**
  String get eventStatistics;

  /// Title for event filter dialog
  ///
  /// In en, this message translates to:
  /// **'Filter Events'**
  String get filterEvents;

  /// Message indicating that the filter feature is coming soon
  ///
  /// In en, this message translates to:
  /// **'Filter feature coming soon...'**
  String get filterFeatureComingSoon;

  /// Message indicating participation in an event
  ///
  /// In en, this message translates to:
  /// **'Participating in \"{eventName}\"...'**
  String participatingInEvent(String eventName);

  /// Title for full lives item
  ///
  /// In en, this message translates to:
  /// **'Full Lives'**
  String get fullLives;

  /// Description for full lives item
  ///
  /// In en, this message translates to:
  /// **'Refills all your lives (5/5)'**
  String get refillAllLives;

  /// Title for 3 lives item
  ///
  /// In en, this message translates to:
  /// **'3 Lives'**
  String get threeLives;

  /// Description for 3 lives item with limitation
  ///
  /// In en, this message translates to:
  /// **'Adds 3 lives (max 5 lives)'**
  String get addThreeLives;

  /// Title for 200 coins item
  ///
  /// In en, this message translates to:
  /// **'200 Coins'**
  String get twoHundredCoins;

  /// Description for 200 coins item
  ///
  /// In en, this message translates to:
  /// **'A small coin boost'**
  String get smallCoinBoost;

  /// Title for 500 coins item
  ///
  /// In en, this message translates to:
  /// **'500 Coins'**
  String get fiveHundredCoins;

  /// Description for 500 coins item
  ///
  /// In en, this message translates to:
  /// **'A good coin stock'**
  String get goodCoinStock;

  /// Title for 1000 coins item
  ///
  /// In en, this message translates to:
  /// **'1000 Coins'**
  String get thousandCoins;

  /// Description for 1000 coins item
  ///
  /// In en, this message translates to:
  /// **'A big coin stock'**
  String get bigCoinStock;

  /// Title for 25 gems item
  ///
  /// In en, this message translates to:
  /// **'25 Gems'**
  String get twentyFiveGems;

  /// Description for 25 gems item
  ///
  /// In en, this message translates to:
  /// **'Precious gems for premium purchases'**
  String get preciousGems;

  /// Description for shuffler booster
  ///
  /// In en, this message translates to:
  /// **'Shuffles the grid for new moves'**
  String get shuffleGrid;

  /// Description for hint booster
  ///
  /// In en, this message translates to:
  /// **'Reveals a winning move'**
  String get revealWinningMove;

  /// Title for bonus moves booster
  ///
  /// In en, this message translates to:
  /// **'Bonus moves'**
  String get bonusMoves;

  /// Description for bonus moves booster
  ///
  /// In en, this message translates to:
  /// **'+5 moves for the current level'**
  String get fiveExtraMoves;

  /// Description for score multiplier booster
  ///
  /// In en, this message translates to:
  /// **'x2 score for 3 levels'**
  String get doubleScoreThreeLevels;

  /// Title for experience booster
  ///
  /// In en, this message translates to:
  /// **'Experience boost'**
  String get experienceBoost;

  /// Description for experience booster
  ///
  /// In en, this message translates to:
  /// **'+100 XP to progress faster'**
  String get hundredXpBoost;

  /// Title for skip level
  ///
  /// In en, this message translates to:
  /// **'Skip a level'**
  String get skipLevel;

  /// Description for skip level
  ///
  /// In en, this message translates to:
  /// **'Unlocks the next level'**
  String get unlockNextLevel;

  /// Title for unlock all levels
  ///
  /// In en, this message translates to:
  /// **'Unlock all levels'**
  String get unlockAllLevels;

  /// Description for unlock all levels
  ///
  /// In en, this message translates to:
  /// **'Access to all game levels'**
  String get accessAllLevels;

  /// Title for nature theme
  ///
  /// In en, this message translates to:
  /// **'Nature Theme'**
  String get natureTheme;

  /// Description for nature theme
  ///
  /// In en, this message translates to:
  /// **'New visual theme with natural colors'**
  String get natureThemeDescription;

  /// Title for ocean theme
  ///
  /// In en, this message translates to:
  /// **'Ocean Theme'**
  String get oceanTheme;

  /// Description for ocean theme
  ///
  /// In en, this message translates to:
  /// **'Aquatic theme with blue colors'**
  String get oceanThemeDescription;

  /// Title for gold frame
  ///
  /// In en, this message translates to:
  /// **'Gold frame'**
  String get goldFrame;

  /// Description for gold frame
  ///
  /// In en, this message translates to:
  /// **'Gold frame for your avatar'**
  String get goldFrameDescription;

  /// Description for remove ads
  ///
  /// In en, this message translates to:
  /// **'Play without advertising interruption'**
  String get playWithoutAds;

  /// Title for premium pack
  ///
  /// In en, this message translates to:
  /// **'Premium Pack'**
  String get premiumPack;

  /// Description for premium pack
  ///
  /// In en, this message translates to:
  /// **'All premium benefits + 100 gems'**
  String get allPremiumBenefits;

  /// Name of cosmetics category
  ///
  /// In en, this message translates to:
  /// **'Cosmetics'**
  String get cosmetics;

  /// Title for free rewards
  ///
  /// In en, this message translates to:
  /// **'🎁 Free Rewards'**
  String get freeRewards;

  /// Name of world 1 - Garden of Beginnings
  ///
  /// In en, this message translates to:
  /// **'Garden of Beginnings'**
  String get world_garden_beginnings;

  /// Description of world 1
  ///
  /// In en, this message translates to:
  /// **'Begin your adventure in this peaceful garden where the first seeds of your journey come to life.'**
  String get world_garden_beginnings_description;

  /// Name of world 2 - Valley of Flowers
  ///
  /// In en, this message translates to:
  /// **'Valley of Flowers'**
  String get world_valley_flowers;

  /// Description of world 2
  ///
  /// In en, this message translates to:
  /// **'Explore a colorful valley where nature\'s most beautiful creations bloom.'**
  String get world_valley_flowers_description;

  /// Name of world 3 - Lunar Forest
  ///
  /// In en, this message translates to:
  /// **'Lunar Forest'**
  String get world_lunar_forest;

  /// Description of world 3
  ///
  /// In en, this message translates to:
  /// **'Dive into the mysterious darkness of this forest bathed in lunar light.'**
  String get world_lunar_forest_description;

  /// Name of world 4 - Solar Meadow
  ///
  /// In en, this message translates to:
  /// **'Solar Meadow'**
  String get world_solar_meadow;

  /// Description of world 4
  ///
  /// In en, this message translates to:
  /// **'Bask in the benevolent warmth of this meadow gilded by the sun.'**
  String get world_solar_meadow_description;

  /// Name of world 5 - Crystal Caverns
  ///
  /// In en, this message translates to:
  /// **'Crystal Caverns'**
  String get world_crystal_caverns;

  /// Description of world 5
  ///
  /// In en, this message translates to:
  /// **'Discover the hidden treasures in these sparkling caves of precious crystals.'**
  String get world_crystal_caverns_description;

  /// Name of world 6 - Mystic Swamps
  ///
  /// In en, this message translates to:
  /// **'Mystic Swamps'**
  String get world_mystic_swamps;

  /// Description of world 6
  ///
  /// In en, this message translates to:
  /// **'Navigate through the troubled waters of these swamps filled with ancient magic.'**
  String get world_mystic_swamps_description;

  /// Name of world 7 - Burning Lands
  ///
  /// In en, this message translates to:
  /// **'Burning Lands'**
  String get world_burning_lands;

  /// Description of world 7
  ///
  /// In en, this message translates to:
  /// **'Survive the intense heat of these volcanic lands in permanent eruption.'**
  String get world_burning_lands_description;

  /// Name of world 8 - Eternal Glacier
  ///
  /// In en, this message translates to:
  /// **'Eternal Glacier'**
  String get world_eternal_glacier;

  /// Description of world 8
  ///
  /// In en, this message translates to:
  /// **'Brave the glacial cold of these pristine white expanses.'**
  String get world_eternal_glacier_description;

  /// Name of world 9 - Lost Rainbow
  ///
  /// In en, this message translates to:
  /// **'Lost Rainbow'**
  String get world_lost_rainbow;

  /// Description of world 9
  ///
  /// In en, this message translates to:
  /// **'Find the lost colors of this legendary rainbow with magical hues.'**
  String get world_lost_rainbow_description;

  /// Name of world 10 - Celestial Garden
  ///
  /// In en, this message translates to:
  /// **'Celestial Garden'**
  String get world_celestial_garden;

  /// Description of world 10
  ///
  /// In en, this message translates to:
  /// **'Access the ultimate garden where stars bloom and dreams become reality.'**
  String get world_celestial_garden_description;

  /// Title for worlds screen
  ///
  /// In en, this message translates to:
  /// **'Worlds'**
  String get worlds;

  /// Name of levels
  ///
  /// In en, this message translates to:
  /// **'Levels'**
  String get levels;

  /// Button to enter a world
  ///
  /// In en, this message translates to:
  /// **'Enter'**
  String get enter;

  /// Tutorial welcome title
  ///
  /// In en, this message translates to:
  /// **'Welcome to Mind Bloom!'**
  String get tutorial_welcome_title;

  /// Tutorial welcome description
  ///
  /// In en, this message translates to:
  /// **'Discover the magical world of plants and puzzles'**
  String get tutorial_welcome_description;

  /// Tutorial matching section title
  ///
  /// In en, this message translates to:
  /// **'Make matches'**
  String get tutorial_matching_title;

  /// Tutorial matching section description
  ///
  /// In en, this message translates to:
  /// **'Swap tiles to create lines of 3 or more of the same color'**
  String get tutorial_matching_description;

  /// Tutorial objectives section title
  ///
  /// In en, this message translates to:
  /// **'Level objectives'**
  String get tutorial_objectives_title;

  /// Tutorial objectives section description
  ///
  /// In en, this message translates to:
  /// **'Each level has specific objectives to achieve to progress'**
  String get tutorial_objectives_description;

  /// Tutorial hint section title
  ///
  /// In en, this message translates to:
  /// **'Hint Button'**
  String get tutorial_hint_title;

  /// Tutorial hint section description
  ///
  /// In en, this message translates to:
  /// **'Use the hint to reveal a winning move when you\'re stuck'**
  String get tutorial_hint_description;

  /// Tutorial shuffle section title
  ///
  /// In en, this message translates to:
  /// **'Shuffle Button'**
  String get tutorial_shuffle_title;

  /// Tutorial shuffle section description
  ///
  /// In en, this message translates to:
  /// **'Shuffle the grid to get new possible moves'**
  String get tutorial_shuffle_description;

  /// Tutorial stars section title
  ///
  /// In en, this message translates to:
  /// **'Earn stars'**
  String get tutorial_stars_title;

  /// Tutorial stars section description
  ///
  /// In en, this message translates to:
  /// **'The more objectives you achieve, the more stars you earn'**
  String get tutorial_stars_description;

  /// Tutorial collection section title
  ///
  /// In en, this message translates to:
  /// **'Plant collection'**
  String get tutorial_collection_title;

  /// Tutorial collection section description
  ///
  /// In en, this message translates to:
  /// **'Unlock new magical plants with special bonuses'**
  String get tutorial_collection_description;

  /// Button to skip tutorial
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get tutorial_skip;

  /// Tutorial next button
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get tutorial_next;

  /// Button to start the game after tutorial
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get tutorial_start;

  /// Tutorial completion message
  ///
  /// In en, this message translates to:
  /// **'Tutorial complete!'**
  String get tutorial_complete;

  /// Tutorial completion description
  ///
  /// In en, this message translates to:
  /// **'You are now ready to explore the world of Mind Bloom!'**
  String get tutorial_complete_description;

  /// Skip tutorial confirmation dialog title
  ///
  /// In en, this message translates to:
  /// **'Skip tutorial?'**
  String get tutorial_skip_confirmation_title;

  /// Skip tutorial confirmation dialog message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to skip the tutorial? You can review it later in the settings.'**
  String get tutorial_skip_confirmation_message;

  /// Title for world completion dialog
  ///
  /// In en, this message translates to:
  /// **'World Completed & New World Unlocked!'**
  String get world_completed_title;

  /// Title for world completion dialog when no new world is unlocked
  ///
  /// In en, this message translates to:
  /// **'World Completed!'**
  String get world_completed_only_title;

  /// Message for world completion dialog with new world
  ///
  /// In en, this message translates to:
  /// **'Congratulations! You have completed this world and unlocked a new world!'**
  String get world_completed_message;

  /// Message for world completion dialog without new world
  ///
  /// In en, this message translates to:
  /// **'Congratulations! You have mastered all the challenges of this world with brilliance!'**
  String get world_completed_only_message;

  /// Message showing newly unlocked world
  ///
  /// In en, this message translates to:
  /// **'New world unlocked: {worldName}'**
  String new_world_unlocked(String worldName);

  /// Title for rare items unlocked section
  ///
  /// In en, this message translates to:
  /// **'Rare Items Unlocked!'**
  String get rare_items_unlocked;

  /// Title for completion rewards section
  ///
  /// In en, this message translates to:
  /// **'Completion Rewards'**
  String get completion_rewards;

  /// Unlock bonus text
  ///
  /// In en, this message translates to:
  /// **'Unlock bonus: +5 Gems'**
  String get unlock_bonus;

  /// Back to menu button text
  ///
  /// In en, this message translates to:
  /// **'Back to Menu'**
  String get back_to_menu;

  /// Explore new world button text
  ///
  /// In en, this message translates to:
  /// **'Explore the New World'**
  String get explore_new_world;

  /// Continue button text
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continue_text;

  /// Default name for new world
  ///
  /// In en, this message translates to:
  /// **'New World'**
  String get new_world;

  /// Button text to go to next world
  ///
  /// In en, this message translates to:
  /// **'Next World'**
  String get next_world;

  /// Button to claim event rewards
  ///
  /// In en, this message translates to:
  /// **'Claim Rewards'**
  String get claim_rewards;

  /// Error message when not all challenges are completed
  ///
  /// In en, this message translates to:
  /// **'Complete all challenges to claim rewards!'**
  String get complete_all_challenges;

  /// Error message when rewards have already been claimed
  ///
  /// In en, this message translates to:
  /// **'Rewards already claimed for this event!'**
  String get rewards_already_claimed;

  /// Congratulations title
  ///
  /// In en, this message translates to:
  /// **'Congratulations!'**
  String get congratulations;

  /// Message indicating what the player earned
  ///
  /// In en, this message translates to:
  /// **'You earned:'**
  String get you_earned;

  /// Positive confirmation button
  ///
  /// In en, this message translates to:
  /// **'Awesome!'**
  String get awesome;

  /// Message to encourage checking the collection
  ///
  /// In en, this message translates to:
  /// **'Check your collection to see your new plants!'**
  String get check_your_collection;

  /// Button to view something
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get view;

  /// Uncommon rarity
  ///
  /// In en, this message translates to:
  /// **'Uncommon'**
  String get uncommon;

  /// Button to see worlds list
  ///
  /// In en, this message translates to:
  /// **'See Worlds'**
  String get see_worlds;

  /// Continue button
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// Title when a reward is obtained
  ///
  /// In en, this message translates to:
  /// **'Reward Obtained!'**
  String get reward_obtained;

  /// Free lives screen title
  ///
  /// In en, this message translates to:
  /// **'Free Lives'**
  String get free_lives;

  /// Button to reset data
  ///
  /// In en, this message translates to:
  /// **'Reset Data'**
  String get reset_data;

  /// Button to share and continue
  ///
  /// In en, this message translates to:
  /// **'Share & Continue'**
  String get share_continue;

  /// Message when achievement is copied
  ///
  /// In en, this message translates to:
  /// **'🎉 Achievement copied! Share your success!'**
  String get achievement_copied;

  /// Error message during sharing
  ///
  /// In en, this message translates to:
  /// **'Error during sharing'**
  String get sharing_error;

  /// Error message during claim
  ///
  /// In en, this message translates to:
  /// **'Error during claim'**
  String get claim_error;
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
