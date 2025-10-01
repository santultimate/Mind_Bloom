import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:mind_bloom/providers/game_provider.dart';
import 'package:mind_bloom/providers/audio_provider.dart';
import 'package:mind_bloom/providers/user_provider.dart';
import 'package:mind_bloom/providers/ad_provider.dart';
import 'package:mind_bloom/providers/collection_provider.dart';
import 'package:mind_bloom/providers/language_provider.dart';
import 'package:mind_bloom/providers/theme_provider.dart';
import 'package:mind_bloom/providers/daily_rewards_provider.dart';
import 'package:mind_bloom/providers/quest_provider.dart';
import 'package:mind_bloom/providers/event_provider.dart';
import 'package:mind_bloom/providers/world_provider.dart';
import 'package:mind_bloom/providers/level_provider.dart';
import 'package:mind_bloom/screens/splash_screen.dart';
import 'package:mind_bloom/constants/app_theme.dart';
import 'package:mind_bloom/generated/l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase - Commenté pour l'instant
  // await Firebase.initializeApp();

  // ✅ Initialiser AdMob correctement
  try {
    await MobileAds.instance.initialize();
  } catch (e) {
    // Commenté pour la version de production
    // print('Error initializing AdMob: $e');
  }

  runApp(const MindBloomApp());
}

class MindBloomApp extends StatelessWidget {
  const MindBloomApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GameProvider()),
        ChangeNotifierProvider(create: (_) => AudioProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => AdProvider()),
        ChangeNotifierProvider(create: (_) => CollectionProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => DailyRewardsProvider()),
        ChangeNotifierProvider(create: (_) => QuestProvider()),
        ChangeNotifierProvider(create: (_) => EventProvider()),
        ChangeNotifierProvider(create: (_) => WorldProvider()),
        ChangeNotifierProvider(create: (_) => LevelProvider()),
      ],
      child: Consumer2<LanguageProvider, ThemeProvider>(
        builder: (context, languageProvider, themeProvider, child) {
          return MaterialApp(
            title: 'Mind Bloom',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            locale: languageProvider.currentLocale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'), // English
              Locale('fr'), // French
            ],
            home: const AppLifecycleWrapper(child: SplashScreen()),
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(textScaler: const TextScaler.linear(1.0)),
                child: child!,
              );
            },
          );
        },
      ),
    );
  }
}

class AppLifecycleWrapper extends StatefulWidget {
  final Widget child;

  const AppLifecycleWrapper({super.key, required this.child});

  @override
  State<AppLifecycleWrapper> createState() => _AppLifecycleWrapperState();
}

class _AppLifecycleWrapperState extends State<AppLifecycleWrapper>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    // 🔧 CORRECTION: Vérification de vie optimisée
    if (state == AppLifecycleState.resumed) {
      // L'application est revenue au premier plan
      try {
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.checkLifeRegeneration();
      } catch (e) {
        // Éviter les erreurs si le context n'est pas disponible
        if (kDebugMode) {
          print('Erreur lors de la vérification des vies: $e');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
