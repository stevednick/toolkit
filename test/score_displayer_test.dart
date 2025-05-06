import 'package:toolkit/game_modes/simple_game/scoring/score_displayer.dart';
import 'package:test/test.dart';

void main(){
  test('1 should show when no decimal point', () {
    final scoreDisplayer = ScoreDisplayer();
    String result = scoreDisplayer.formatScore(1.00);
    expect(result, '1');
  });

  test('2.2023 should show 2.2', () {
    final scoreDisplayer = ScoreDisplayer();
    String result = scoreDisplayer.formatScore(2.2023);
    expect(result, '2.2');
  });

  test('2.259 should show 2.6', () {
    final scoreDisplayer = ScoreDisplayer();
    String result = scoreDisplayer.formatScore(2.259);
    expect(result, '2.26');
  });
}


