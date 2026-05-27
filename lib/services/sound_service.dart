import 'package:audioplayers/audioplayers.dart';

class SoundService {
  static final AudioPlayer _player = AudioPlayer();

  static void playClick() {
    _player.play(AssetSource('sounds/click.mp3'));
  }

  static void playFlag() {
    _player.play(AssetSource('sounds/flag.mp3'));
  }

  static void playBoom() {
    _player.play(AssetSource('sounds/boom.mp3'));
  }

  static void playWin() {
    _player.play(AssetSource('sounds/win.mp3'));
  }
}
