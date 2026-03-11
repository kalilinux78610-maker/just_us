class QuizItem {
  final String id;
  final String question;
  final List<String> options;
  // Index of the right answer or can it be varied depending on who plays?
  // Let's assume it's "who knows the other better", so we need 1 correct answer
  // OR the current player has to guess what the OTHER player would choose.
  // For simplicity, let's say partners take turns: one partner answers secretly,
  // then the other guesses. But the proposal says "score tracker - see who knows the other better".
  // This means the quiz asks things like "What is my favorite color?".
  // Instead of a multiplayer socket, we can just say "Player A asking Player B".
  // For now, let's keep it simple: predefined questions that the user answers.

  final String?
  correctAnswer; // The correct answer text, optional if open ended
  final String? hindiQuestion;
  final List<String>? hindiOptions;

  const QuizItem({
    required this.id,
    required this.question,
    required this.options,
    this.correctAnswer,
    this.hindiQuestion,
    this.hindiOptions,
  });
}
