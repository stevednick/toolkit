import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameModeIntroPopup extends StatefulWidget {
  const GameModeIntroPopup({super.key, required this.introSeenKey});

  final String introSeenKey;
  

  @override
  State<GameModeIntroPopup> createState() => GameModeIntroPopupState();
}

class GameModeIntroPopupState extends State<GameModeIntroPopup> {
  bool _hasCheckedFirstTime = false;
  bool _showPopup = false;



  @override
  void initState() {
    super.initState();
    _checkFirstTime();
  }

  Future<void> _checkFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    final hasSeenIntro = prefs.getBool('hasSeenIntro') ?? false;

    if (!hasSeenIntro) {
      setState(() {
        _showPopup = true;
        _hasCheckedFirstTime = true;
      });
      await prefs.setBool('hasSeenIntro', true);
    } else {
      setState(() {
        _hasCheckedFirstTime = true;
      });
    }
  }

  void _closePopup() {
    setState(() {
      _showPopup = false;
    });
  }

  void openPopup(){
    setState(() {
      _showPopup = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    // If we haven't checked yet or popup shouldn't be shown, return empty container
    if (!_hasCheckedFirstTime || !_showPopup) {
      return Container();
    }

    return Container(
      color: Colors.black.withOpacity(0.7),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          margin: const EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF334155)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header row with icon, title and close button
                Row(
                  children: [
                    // Clock icon
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Color(0xFF4F46E5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.timer,
                        size: 24,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 12),
                    
                    // Title
                    const Expanded(
                      child: Text(
                        'Time Trial Mode',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    
                    // Close button
                    IconButton(
                      constraints: const BoxConstraints(),
                      padding: EdgeInsets.zero,
                      icon: const Icon(Icons.close, color: Color(0xFF94A3B8)),
                      onPressed: _closePopup,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                
                // Make the content scrollable if needed
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Description
                        const Text(
                          'You start with 20 seconds, and each correct note adds more time. '
                          'Your final score is multiplied based on the challenge you set for yourself.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            color: Color(0xFFCBD5E1),
                          ),
                        ),
                        const SizedBox(height: 12),
                        
                        // Tips box
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E293B),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFF334155)),
                          ),
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.music_note,
                                    size: 18,
                                    color: Color(0xFFA5B4FC),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: RichText(
                                      text: const TextSpan(
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFFCBD5E1),
                                        ),
                                        children: [
                                          TextSpan(
                                            text: 'Wider ranges',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          TextSpan(text: ', '),
                                          TextSpan(
                                            text: 'more accidentals',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          TextSpan(text: ', and '),
                                          TextSpan(
                                            text: 'greater clef overlap',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          TextSpan(
                                            text: ' increase your difficulty—and your potential score.',
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Experiment with different settings to find the best combination and maximize your results.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontStyle: FontStyle.italic,
                                  color: Color(0xFFCBD5E1),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Button
                ElevatedButton(
                  onPressed: _closePopup,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4F46E5),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    minimumSize: const Size(120, 36),
                  ),
                  child: const Text(
                    "Let's Go!",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

