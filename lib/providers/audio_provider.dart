import 'package:flutter/foundation.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AudioProvider extends ChangeNotifier {
  // Audio players
  AudioPlayer? _musicPlayer;
  AudioPlayer? _sfxPlayer;

  // État audio
  bool _isMusicEnabled = true;
  bool _isSfxEnabled = true;
  double _musicVolume = 0.7;
  double _sfxVolume = 1.0;
  String? _currentMusic;

  // Getters
  bool get isMusicEnabled => _isMusicEnabled;
  bool get isSfxEnabled => _isSfxEnabled;
  double get musicVolume => _musicVolume;
  double get sfxVolume => _sfxVolume;
  String? get currentMusic => _currentMusic;

  // Initialiser l'audio
  Future<void> initialize() async {
    _musicPlayer = AudioPlayer();
    _sfxPlayer = AudioPlayer();

    // Charger les préférences
    await _loadPreferences();

    // Configurer les volumes
    await _musicPlayer?.setVolume(_isMusicEnabled ? _musicVolume : 0.0);
    await _sfxPlayer?.setVolume(_isSfxEnabled ? _sfxVolume : 0.0);

    notifyListeners();
  }

  // Charger les préférences
  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();

    _isMusicEnabled = prefs.getBool('musicEnabled') ?? true;
    _isSfxEnabled = prefs.getBool('sfxEnabled') ?? true;
    _musicVolume = prefs.getDouble('musicVolume') ?? 0.7;
    _sfxVolume = prefs.getDouble('sfxVolume') ?? 1.0;
  }

  // Sauvegarder les préférences
  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool('musicEnabled', _isMusicEnabled);
    await prefs.setBool('sfxEnabled', _isSfxEnabled);
    await prefs.setDouble('musicVolume', _musicVolume);
    await prefs.setDouble('sfxVolume', _sfxVolume);
  }

  // Jouer de la musique
  Future<void> playMusic(String assetPath, {bool loop = true}) async {
    if (!_isMusicEnabled || _currentMusic == assetPath) return;

    try {
      await _musicPlayer?.stop();
      await _musicPlayer?.play(AssetSource(assetPath));

      if (loop) {
        await _musicPlayer?.setReleaseMode(ReleaseMode.loop);
      }

      _currentMusic = assetPath;
      notifyListeners();
    } catch (e) {
      debugPrint(
          'Erreur lors de la lecture de la musique: Unable to load asset: "$assetPath".');
      // Ne pas afficher l'erreur en production pour éviter le spam
    }
  }

  // Arrêter la musique
  Future<void> stopMusic() async {
    await _musicPlayer?.stop();
    _currentMusic = null;
    notifyListeners();
  }

  // Pause/Reprendre la musique
  Future<void> toggleMusic() async {
    if (_currentMusic != null) {
      await _musicPlayer?.pause();
    } else if (_isMusicEnabled) {
      await _musicPlayer?.resume();
    }
    notifyListeners();
  }

  // Jouer un effet sonore
  Future<void> playSfx(String assetPath) async {
    if (!_isSfxEnabled) return;

    try {
      await _sfxPlayer?.play(AssetSource(assetPath));
    } catch (e) {
      debugPrint(
          'Erreur lors de la lecture du SFX: Unable to load asset: "$assetPath".');
      // Ne pas afficher l'erreur en production pour éviter le spam
    }
  }

  // Activer/Désactiver la musique
  Future<void> toggleMusicEnabled() async {
    _isMusicEnabled = !_isMusicEnabled;

    if (_isMusicEnabled) {
      await _musicPlayer?.setVolume(_musicVolume);
      if (_currentMusic != null) {
        await _musicPlayer?.resume();
      }
    } else {
      await _musicPlayer?.setVolume(0.0);
      await _musicPlayer?.pause();
    }

    await _savePreferences();
    notifyListeners();
  }

  // Activer/Désactiver les effets sonores
  Future<void> toggleSfxEnabled() async {
    _isSfxEnabled = !_isSfxEnabled;

    if (_isSfxEnabled) {
      await _sfxPlayer?.setVolume(_sfxVolume);
    } else {
      await _sfxPlayer?.setVolume(0.0);
    }

    await _savePreferences();
    notifyListeners();
  }

  // Changer le volume de la musique
  Future<void> setMusicVolume(double volume) async {
    _musicVolume = volume.clamp(0.0, 1.0);

    if (_isMusicEnabled) {
      await _musicPlayer?.setVolume(_musicVolume);
    }

    await _savePreferences();
    notifyListeners();
  }

  // Changer le volume des effets sonores
  Future<void> setSfxVolume(double volume) async {
    _sfxVolume = volume.clamp(0.0, 1.0);

    if (_isSfxEnabled) {
      await _sfxPlayer?.setVolume(_sfxVolume);
    }

    await _savePreferences();
    notifyListeners();
  }

  // Effets sonores spécifiques au jeu
  Future<void> playTileSwap() async {
    await playSfx('audio/sfx/tile_swap.wav');
  }

  Future<void> playTileMatch() async {
    await playSfx('audio/sfx/tile_match.wav');
  }

  Future<void> playSpecialMatch() async {
    await playSfx('audio/sfx/special_match.wav');
  }

  Future<void> playLevelComplete() async {
    await playSfx('audio/sfx/level_complete.wav');
  }

  Future<void> playLevelFail() async {
    await playSfx('audio/sfx/level_fail.wav');
  }

  Future<void> playButtonClick() async {
    await playSfx('audio/sfx/button_click.wav');
  }

  Future<void> playCoinCollect() async {
    await playSfx('audio/sfx/coin_collect.wav');
  }

  // Nouveaux effets sonores
  Future<void> playCombo() async {
    await playSfx('audio/sfx/combo.mp3');
  }

  Future<void> playStarEarned() async {
    await playSfx('audio/sfx/star_earned.wav');
  }

  Future<void> playObjectiveComplete() async {
    await playSfx('audio/sfx/objective_complete.wav');
  }

  Future<void> playShuffle() async {
    await playSfx('audio/sfx/shuffle.wav');
  }

  Future<void> playHint() async {
    await playSfx('audio/sfx/hint.wav');
  }

  Future<void> playScore() async {
    await playSfx('audio/sfx/star_earned.wav');
  }

  Future<void> playGameOver() async {
    await playSfx('audio/sfx/level_failed.wav');
  }

  // Musiques spécifiques
  Future<void> playMainMenuMusic() async {
    await playMusic('audio/music/main_menu.mp3');
  }

  Future<void> playGameplayMusic() async {
    await playMusic('audio/music/gameplay.mp3');
  }

  Future<void> playVictoryMusic() async {
    await playMusic('audio/music/victory.wav', loop: false);
  }

  // Libérer les ressources
  @override
  void dispose() {
    _musicPlayer?.dispose();
    _sfxPlayer?.dispose();
    super.dispose();
  }
}
