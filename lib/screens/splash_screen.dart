import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:mind_bloom/providers/user_provider.dart';
import 'package:mind_bloom/providers/audio_provider.dart';
import 'package:mind_bloom/providers/ad_provider.dart';
import 'package:mind_bloom/screens/home_screen.dart';
import 'package:mind_bloom/constants/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Initialiser les providers
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final audioProvider = Provider.of<AudioProvider>(context, listen: false);
    final adProvider = Provider.of<AdProvider>(context, listen: false);

    await Future.wait([
      userProvider.initializeUser(),
      audioProvider.initialize(),
      adProvider.initialize(),
    ]);

    // Attendre un peu pour l'animation
    await Future.delayed(const Duration(seconds: 3));

    // Naviguer vers l'écran principal
    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const HomeScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 500),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.background,
              AppColors.surfaceVariant,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo animé
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.eco,
                  size: 60,
                  color: Colors.white,
                ),
              )
                  .animate()
                  .scale(
                    begin: const Offset(0, 0),
                    end: const Offset(1, 1),
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.elasticOut,
                  )
                  .then()
                  .shimmer(
                    duration: const Duration(milliseconds: 1500),
                    color: Colors.white.withValues(alpha: 0.3),
                  ),

              const SizedBox(height: 40),

              // Titre du jeu
              Text(
                'Mind Bloom',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
              )
                  .animate()
                  .fadeIn(duration: const Duration(milliseconds: 600))
                  .slideY(begin: 0.3, end: 0),

              const SizedBox(height: 10),

              // Sous-titre
              Text(
                'Jardin Magique',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              )
                  .animate()
                  .fadeIn(
                      duration: const Duration(milliseconds: 600),
                      delay: const Duration(milliseconds: 200))
                  .slideY(begin: 0.3, end: 0),

              const SizedBox(height: 60),

              // Indicateur de chargement
              const SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              ).animate().fadeIn(
                  duration: const Duration(milliseconds: 400),
                  delay: const Duration(milliseconds: 400)),

              const SizedBox(height: 20),

              // Texte de chargement
              Text(
                'Chargement...',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ).animate().fadeIn(
                  duration: const Duration(milliseconds: 400),
                  delay: const Duration(milliseconds: 600)),
            ],
          ),
        ),
      ),
    );
  }
}
