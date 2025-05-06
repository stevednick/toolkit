import 'package:flutter/material.dart';
import 'package:toolkit/game_modes/simple_game/state_management/single_game_high_scores_manager.dart';

class GameOverPopup extends StatefulWidget {
  final int notesPlayed;
  final double difficultyLevel;
  final VoidCallback onPlayAgain;
  final VoidCallback onExit;

  const GameOverPopup({
    super.key,
    required this.notesPlayed,
    required this.difficultyLevel,
    required this.onPlayAgain,
    required this.onExit,
  });
  @override
  State<GameOverPopup> createState() => _GameOverPopupState();
}

class _GameOverPopupState extends State<GameOverPopup> {
  final SingleGameHighScoresManager highScoresManager = SingleGameHighScoresManager();
  bool isHighScore = false;
  bool isHighNotes = false;
  bool isLoading = true;
  double? overallHighScore;
  int? overallBestNotes;

  @override
  void initState() {
    super.initState();
    _loadHighScores();
  }
Future<void> _loadHighScores() async {
  try {
    await highScoresManager.init();
    
    setState(() {
      overallHighScore = highScoresManager.bestScore;
      overallBestNotes = highScoresManager.bestNotes;
    });

    double currentScore = widget.notesPlayed * widget.difficultyLevel;

    if (currentScore > (overallHighScore ?? 0)) {
      setState(() {
        isHighScore = true;
      });
      highScoresManager.bestScore = currentScore;
      await highScoresManager.saveHighScore(currentScore);
    }

    if (widget.notesPlayed > (overallBestNotes ?? 0)) {
      setState(() {
        isHighNotes = true;
      });
      highScoresManager.bestNotes = widget.notesPlayed;
      await highScoresManager.saveBestNotes(widget.notesPlayed);

    }
  } catch (e) {
    debugPrint('Error loading high scores: $e');
  } finally {
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  Widget contentBox(BuildContext context) {
    // Calculate current score
    double currentScore = widget.notesPlayed * widget.difficultyLevel;
    
    return Container(
      width: MediaQuery.of(context).size.width * 0.8, // Wider to accommodate side-by-side layout
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text(
            'Game Over',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          
          // Loading indicator
          if (isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: CircularProgressIndicator(),
              ),
            )
          else
            Column(
              children: [
                // Stats section with side-by-side layout
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Current game stats - Left column
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'This Game',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 6),
                              _buildInfoRow(
                                'Notes', 
                                widget.notesPlayed.toString(), 
                                isHighNotes
                              ),
                              const SizedBox(height: 4),
                              _buildInfoRow(
                                'Difficulty', 
                                widget.difficultyLevel.toStringAsFixed(1), 
                                false
                              ),
                              const SizedBox(height: 4),
                              _buildInfoRow(
                                'Score', 
                                currentScore.toStringAsFixed(0), 
                                isHighScore
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      const SizedBox(width: 10),
                      
                      // All-time best stats - Right column
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'All-Time Best',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 6),
                              _buildInfoRow(
                                'Best Notes', 
                                overallBestNotes != null ? overallBestNotes.toString() : '0',
                                false
                              ),
                              const SizedBox(height: 4),
                              _buildInfoRow(
                                'Best Score', 
                                overallHighScore != null ? overallHighScore!.toStringAsFixed(0) : '0',
                                false
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: widget.onPlayAgain,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      ),
                      child: const Text(
                        'Play Again',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: widget.onExit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      ),
                      child: const Text(
                        'Exit',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, bool isHighlight) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        Row(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (isHighlight)
              Container(
                margin: const EdgeInsets.only(left: 4),
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'New!',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

