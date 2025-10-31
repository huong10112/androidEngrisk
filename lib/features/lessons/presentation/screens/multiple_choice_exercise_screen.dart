import 'package:flutter/material.dart';
import 'package:engrisk/core/widgets/custom_bottom_navigation.dart';
import 'package:audioplayers/audioplayers.dart';

class MultipleChoiceExerciseScreen extends StatefulWidget {
  final List<String> options;
  final String correctAnswer;

  const MultipleChoiceExerciseScreen({
    super.key,
    required this.options,
    required this.correctAnswer,
  });

  @override
  State<MultipleChoiceExerciseScreen> createState() => _MultipleChoiceExerciseScreenState();
}

class _MultipleChoiceExerciseScreenState extends State<MultipleChoiceExerciseScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  String? _selectedAnswer;
  bool _showResult = false;
  bool _isCorrect = false;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _setupAudio();
  }

  void _setupAudio() async {
    // Trên web, cần preload audio trước khi play
    try {
      await _audioPlayer.setSource(AssetSource('audios/filetest1.mp3'));
    } catch (e) {
      print('Error setting up audio: $e');
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _checkAnswer() {
    if (_selectedAnswer != null) {
      setState(() {
        _isCorrect = _selectedAnswer == widget.correctAnswer;
        _showResult = true;
      });
    }
  }

  void _continueNext() {
    Navigator.pop(context);
  }

  void _playAudio() async {
    if (_isPlaying) return;

    try {
      setState(() {
        _isPlaying = true;
      });

      // Cách 1: Dùng AssetSource (cho mobile và web)
      await _audioPlayer.play(AssetSource('audios/filetest1.mp3'));

      // Hoặc Cách 2: Dùng UrlSource với audio online (tạm thời cho web)
      // await _audioPlayer.play(UrlSource('https://assets.mixkit.co/music/preview/mixkit-tech-house-vibes-130.mp3'));

      // Lắng nghe khi audio kết thúc
      _audioPlayer.onPlayerComplete.listen((event) {
        setState(() {
          _isPlaying = false;
        });
      });

    } catch (e) {
      print('Error playing audio: $e');
      setState(() {
        _isPlaying = false;
      });
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
              width: 200,
              decoration: BoxDecoration(
                color: const Color(0xFF4CAF50),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            const SizedBox(height: 32),

            // Instruction
            const Text(
              'Nghe và chọn đáp án đúng:',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 16),

            // Audio player
            Center(
              child: GestureDetector(
                onTap: _isPlaying ? null : _playAudio,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: _isPlaying
                        ? Colors.grey[300]
                        : const Color(0xFF4CAF50).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Icon(
                    _isPlaying ? Icons.volume_off : Icons.volume_up,
                    color: _isPlaying ? Colors.grey : const Color(0xFF4CAF50),
                    size: 40,
                  ),
                ),
              ),
            ),

            if (_isPlaying) ...[
              const SizedBox(height: 16),
              const Center(
                child: Text(
                  'Đang phát audio...',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],

            const SizedBox(height: 32),

            // Options
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: widget.options.map((option) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: GestureDetector(
                        onTap: _showResult ? null : () {
                          setState(() {
                            _selectedAnswer = option;
                          });
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: _getOptionColor(option),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _getOptionBorderColor(option),
                            ),
                          ),
                          child: Text(
                            option,
                            style: TextStyle(
                              fontSize: 16,
                              color: _getOptionTextColor(option),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            const SizedBox(height: 16),

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
                onPressed: _selectedAnswer != null && !_showResult
                    ? _checkAnswer
                    : _showResult ? _continueNext : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _selectedAnswer != null && !_showResult || _showResult
                      ? const Color(0xFF4CAF50)
                      : Colors.grey[400],
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

  Color _getOptionColor(String option) {
    if (!_showResult) {
      return _selectedAnswer == option ? const Color(0xFF4CAF50).withOpacity(0.1) : Colors.white;
    } else {
      if (option == widget.correctAnswer) {
        return Colors.green.withOpacity(0.1);
      } else if (option == _selectedAnswer && option != widget.correctAnswer) {
        return Colors.red.withOpacity(0.1);
      }
      return Colors.white;
    }
  }

  Color _getOptionBorderColor(String option) {
    if (!_showResult) {
      return _selectedAnswer == option ? const Color(0xFF4CAF50) : Colors.grey[300]!;
    } else {
      if (option == widget.correctAnswer) {
        return Colors.green;
      } else if (option == _selectedAnswer && option != widget.correctAnswer) {
        return Colors.red;
      }
      return Colors.grey[300]!;
    }
  }

  Color _getOptionTextColor(String option) {
    if (!_showResult) {
      return _selectedAnswer == option ? const Color(0xFF4CAF50) : Colors.black;
    } else {
      if (option == widget.correctAnswer) {
        return Colors.green;
      } else if (option == _selectedAnswer && option != widget.correctAnswer) {
        return Colors.red;
      }
      return Colors.black;
    }
  }
}