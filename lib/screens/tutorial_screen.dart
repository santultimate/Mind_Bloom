import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mind_bloom/constants/app_colors.dart';
import 'package:mind_bloom/providers/user_provider.dart';
import 'package:mind_bloom/providers/audio_provider.dart';
import 'package:mind_bloom/screens/home_screen.dart';

class TutorialScreen extends StatefulWidget {
  const TutorialScreen({super.key});

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  int _currentStep = 0;

  final List<TutorialStep> _steps = [
    TutorialStep(
      id: 'welcome',
      title: 'Bienvenue dans Mind Bloom !',
      description: 'Découvrez le monde magique des plantes et des puzzles',
      icon: Icons.eco,
      color: AppColors.primary,
      showSkip: false,
    ),
    TutorialStep(
      id: 'matching',
      title: 'Faites des correspondances',
      description:
          'Échangez les tuiles pour créer des lignes de 3 ou plus de la même couleur',
      icon: Icons.grid_3x3,
      color: AppColors.success,
      showSkip: true,
    ),
    TutorialStep(
      id: 'objectives',
      title: 'Objectifs du niveau',
      description:
          'Chaque niveau a des objectifs spécifiques à atteindre pour progresser',
      icon: Icons.flag,
      color: AppColors.accent,
      showSkip: true,
    ),
    TutorialStep(
      id: 'stars',
      title: 'Gagnez des étoiles',
      description:
          'Plus vous atteignez d\'objectifs, plus vous gagnez d\'étoiles',
      icon: Icons.star,
      color: AppColors.gold,
      showSkip: true,
    ),
    TutorialStep(
      id: 'collection',
      title: 'Collectionnez des plantes',
      description:
          'Débloquez de nouvelles plantes magiques avec des bonus spéciaux',
      icon: Icons.collections,
      color: AppColors.primary,
      showSkip: true,
    ),
    TutorialStep(
      id: 'shop',
      title: 'Boutique',
      description:
          'Achetez des vies, des boosters et des récompenses avec vos pièces',
      icon: Icons.shopping_cart,
      color: AppColors.coins,
      showSkip: true,
    ),
    TutorialStep(
      id: 'events',
      title: 'Événements spéciaux',
      description:
          'Participez aux événements saisonniers pour des récompenses exclusives',
      icon: Icons.event,
      color: AppColors.accent,
      showSkip: true,
    ),
    TutorialStep(
      id: 'ready',
      title: 'Vous êtes prêt !',
      description: 'Commencez votre aventure et cultivez votre jardin magique',
      icon: Icons.play_arrow,
      color: AppColors.success,
      showSkip: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Barre de progression
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  IconButton(
                    onPressed: _currentStep > 0 ? _previousStep : null,
                    icon: Icon(
                      Icons.arrow_back,
                      color: _currentStep > 0
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                    ),
                  ),
                  Expanded(
                    child: LinearProgressIndicator(
                      value: (_currentStep + 1) / _steps.length,
                      backgroundColor:
                          AppColors.textSecondary.withValues(alpha: 0.2),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.primary),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    '${_currentStep + 1}/${_steps.length}',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            // Contenu principal
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: _steps.length,
                itemBuilder: (context, index) {
                  return _buildStepContent(_steps[index]);
                },
              ),
            ),

            // Boutons de navigation
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  if (_steps[_currentStep].showSkip)
                    TextButton(
                      onPressed: _skipTutorial,
                      child: Text(
                        'Passer',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  const Spacer(),
                  if (_currentStep < _steps.length - 1)
                    ElevatedButton(
                      onPressed: _nextStep,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        'Suivant',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  else
                    ElevatedButton(
                      onPressed: _finishTutorial,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.success,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        'Commencer',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepContent(TutorialStep step) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icône principale
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: step.color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: step.color.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Icon(
                  step.icon,
                  color: step.color,
                  size: 60,
                ),
              ),

              const SizedBox(height: 40),

              // Titre
              Text(
                step.title,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 16),

              // Description
              Text(
                step.description,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 40),

              // Contenu spécifique à l'étape
              _buildStepSpecificContent(step),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepSpecificContent(TutorialStep step) {
    switch (step.id) {
      case 'matching':
        return _buildMatchingDemo();
      case 'objectives':
        return _buildObjectivesDemo();
      case 'stars':
        return _buildStarsDemo();
      case 'collection':
        return _buildCollectionDemo();
      case 'shop':
        return _buildShopDemo();
      case 'events':
        return _buildEventsDemo();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildMatchingDemo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.success.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          Text(
            'Exemple de correspondance',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildDemoTile(AppColors.tileFlower),
              _buildDemoTile(AppColors.tileFlower),
              _buildDemoTile(AppColors.tileFlower),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '3 tuiles de la même couleur = Match !',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildObjectivesDemo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.accent.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          Text(
            'Objectifs du niveau',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildObjectiveItem('Collecter 20 fleurs', 15, 20),
              _buildObjectiveItem('Marquer 1000 points', 800, 1000),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStarsDemo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.gold.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          Text(
            'Système d\'étoiles',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Icon(
                  index < 2 ? Icons.star : Icons.star_border,
                  color: AppColors.gold,
                  size: 32,
                ),
              );
            }),
          ),
          const SizedBox(height: 8),
          Text(
            '2/3 objectifs atteints = 2 étoiles',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCollectionDemo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          Text(
            'Collection de plantes',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildPlantItem('Rose Magique', 5, true),
              _buildPlantItem('Lotus Cristal', 4, true),
              _buildPlantItem('Orchidée Lune', 4, false),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShopDemo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.coins.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          Text(
            'Boutique',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildShopItem('5 Vies', 50, Icons.favorite),
              _buildShopItem('Booster', 30, Icons.rocket_launch),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEventsDemo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.accent.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          Text(
            'Événements saisonniers',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary,
                  AppColors.accent,
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.event,
                  color: Colors.white,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Floraison de Printemps',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '5 jours restants',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDemoTile(Color color) {
    return Container(
      width: 40,
      height: 40,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
    );
  }

  Widget _buildObjectiveItem(String description, int current, int target) {
    return Column(
      children: [
        Text(
          description,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          '$current/$target',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildPlantItem(String name, int rarity, bool isUnlocked) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isUnlocked
                ? AppColors.primary.withValues(alpha: 0.2)
                : AppColors.textSecondary.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            isUnlocked ? Icons.eco : Icons.lock,
            color: isUnlocked ? AppColors.primary : AppColors.textSecondary,
            size: 20,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          name,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 10,
          ),
          textAlign: TextAlign.center,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            return Icon(
              index < rarity ? Icons.star : Icons.star_border,
              color: AppColors.gold,
              size: 8,
            );
          }),
        ),
      ],
    );
  }

  Widget _buildShopItem(String name, int price, IconData icon) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: AppColors.coins.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: AppColors.coins,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
          ),
        ),
        Row(
          children: [
            Icon(
              Icons.monetization_on,
              color: AppColors.coins,
              size: 12,
            ),
            const SizedBox(width: 2),
            Text(
              price.toString(),
              style: TextStyle(
                color: AppColors.coins,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentStep = page;
    });
    _animationController.reset();
    _animationController.forward();
  }

  void _nextStep() {
    final audioProvider = Provider.of<AudioProvider>(context, listen: false);
    audioProvider.playSfx('audio/sfx/button_click.wav');

    if (_currentStep < _steps.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousStep() {
    final audioProvider = Provider.of<AudioProvider>(context, listen: false);
    audioProvider.playSfx('audio/sfx/button_click.wav');

    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _skipTutorial() {
    final audioProvider = Provider.of<AudioProvider>(context, listen: false);
    audioProvider.playSfx('audio/sfx/button_click.wav');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Passer le tutoriel ?'),
        content: const Text(
          'Êtes-vous sûr de vouloir passer le tutoriel ? Vous pourrez le revoir plus tard dans les paramètres.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _finishTutorial();
            },
            child: const Text('Passer'),
          ),
        ],
      ),
    );
  }

  void _finishTutorial() {
    final audioProvider = Provider.of<AudioProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    audioProvider.playSfx('audio/sfx/button_click.wav');

    // Marquer le tutoriel comme terminé
    userProvider.completeTutorial();

    // Aller à l'écran d'accueil
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ),
      (route) => false,
    );
  }
}

class TutorialStep {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final bool showSkip;

  TutorialStep({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.showSkip,
  });
}

