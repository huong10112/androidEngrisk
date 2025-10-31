import 'package:audioplayers/audioplayers.dart';

class AudioService {
  static final AudioPlayer _audioPlayer = AudioPlayer();

  static Future<void> playSound(String audioPath) async {
    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource(audioPath));
    } catch (e) {
      print('Lỗi phát âm thanh: $e');
    }
  }

  static Future<void> stopSound() async {
    await _audioPlayer.stop();
  }

  static void dispose() {
    _audioPlayer.dispose();
  }
}