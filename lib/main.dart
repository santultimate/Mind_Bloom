import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:mind_bloom/providers/game_provider.dart';
import 'package:mind_bloom/providers/audio_provider.dart';
import 'package:mind_bloom/providers/user_provider.dart';
import 'package:mind_bloom/providers/ad_provider.dart';
import 'package:mind_bloom/providers/collection_provider.dart';
import 'package:mind_bloom/screens/splash_screen.dart';
import 'package:mind_bloom/constants/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase - Commenté pour l'instant
  // await Firebase.initializeApp();

  // ✅ Initialiser AdMob correctement
  try {
    await MobileAds.instance.initialize();
  } catch (e) {
    print('Error initializing AdMob: $e');
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
      ],
      child: MaterialApp(
        title: 'Mind Bloom',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const SplashScreen(),
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(1.0)),
            child: child!,
          );
        },
      ),
    );
  }
}
