import 'package:flutter/material.dart';
import 'package:engrisk/core/widgets/custom_bottom_navigation.dart';
import 'package:engrisk/core/utils/audio_player_util.dart';

class TranslationExerciseScreen extends StatefulWidget {
  final String sentence;
  final String correctAnswer;

  const TranslationExerciseScreen({
    super.key,
    required this.sentence,
    required this.correctAnswer,
  });

  @override
  State<TranslationExerciseScreen> createState() => _TranslationExerciseScreenState();
}

class _TranslationExerciseScreenState extends State<TranslationExerciseScreen> {
  final TextEditingController _answerController = TextEditingController();
  final AudioPlayerUtil _audioPlayerUtil = AudioPlayerUtil();
  bool _showResult = false;
  bool _isCorrect = false;

  @override
  void dispose() {
    _answerController.dispose();
    _audioPlayerUtil.dispose();
    super.dispose();
  }

  void _checkAnswer() {
    final userAnswer = _answerController.text.trim();
    setState(() {
      _isCorrect = userAnswer.toLowerCase() == widget.correctAnswer.toLowerCase();
      _showResult = true;
    });
  }

  void _continueNext() {
    Navigator.pop(context);
  }

  void _playAudio() async {
    try {
      await _audioPlayerUtil.playAudio('https://www.soundjay.com/button/beep-07.mp3');
    } catch (e) {
      print('Error playing audio: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Bài học',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress bar
            Container(
              height: 4,
              width: 100,
              decoration: BoxDecoration(
                color: const Color(0xFF4CAF50),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            const SizedBox(height: 32),

            // Instruction
            const Text(
              'Dịch sang tiếng Việt',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 16),

            // English sentence
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: _playAudio,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFF4CAF50).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.volume_up,
                        color: Color(0xFF4CAF50),
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      widget.sentence,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Answer input
            const Text(
              'Nhập câu trả lời của bạn',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: _answerController,
              decoration: InputDecoration(
                hintText: 'Nhập bản dịch...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF4CAF50)),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
              style: const TextStyle(fontSize: 16),
            ),

            const Spacer(),

            if (_showResult) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _isCorrect ? Colors.green[50] : Colors.red[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _isCorrect ? Colors.green : Colors.red,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _isCorrect ? 'Chính xác!' : 'Chưa chính xác!',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: _isCorrect ? Colors.green : Colors.red,
                      ),
                    ),
                    if (!_isCorrect) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Đáp án đúng: ${widget.correctAnswer}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Check button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _showResult ? _continueNext : _checkAnswer,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  _showResult ? 'Tiếp tục' : 'Kiểm tra',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigation(
        currentIndex: 0,
        onTap: (index) {
          if (index == 0) {
            Navigator.popUntil(context, (route) => route.isFirst);
          }
        },
      ),
    );
  }
}