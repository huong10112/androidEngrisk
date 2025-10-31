import 'package:audioplayers/audioplayers.dart';

class AudioPlayerUtil {
  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> playAudio(String url) async {
    try {
      await _audioPlayer.play(UrlSource(url));
    } catch (e) {
      print('Error playing audio: $e');
    }
  }

  void dispose() {
    _audioPlayer.dispose();
  }
}