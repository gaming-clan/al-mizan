import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../modules/data/models/fiqh_models.dart';

class QuizState {
  final int currentIndex;
  final int? selectedOption;
  final bool answered;
  final int correctCount;
  final List<QuizQuestion> questions;

  const QuizState({
    this.currentIndex = 0,
    this.selectedOption,
    this.answered = false,
    this.correctCount = 0,
    this.questions = const [],
  });

  QuizState copyWith({
    int? currentIndex,
    int? selectedOption,
    bool? answered,
    int? correctCount,
    List<QuizQuestion>? questions,
  }) {
    return QuizState(
      currentIndex: currentIndex ?? this.currentIndex,
      selectedOption: selectedOption,
      answered: answered ?? this.answered,
      correctCount: correctCount ?? this.correctCount,
      questions: questions ?? this.questions,
    );
  }
}

class QuizNotifier extends StateNotifier<QuizState> {
  QuizNotifier() : super(const QuizState());

  /// Shuffles both question order and each question's option order.
  void initialize(List<QuizQuestion> originalQuestions) {
    if (state.questions.isNotEmpty) return;
    final rng = Random();
    final shuffled = List<QuizQuestion>.from(originalQuestions);
    shuffled.shuffle(rng);
    final randomized = shuffled.map((q) {
      final correctAnswer = q.options[q.correctIndex];
      final shuffledOptions = List<String>.from(q.options);
      shuffledOptions.shuffle(rng);
      final newCorrectIndex = shuffledOptions.indexOf(correctAnswer);
      return QuizQuestion(
        question: q.question,
        options: shuffledOptions,
        correctIndex: newCorrectIndex,
        explanation: q.explanation,
      );
    }).toList();
    state = QuizState(questions: randomized);
  }

  void selectOption(int index, int correctIndex) {
    if (state.answered) return;
    state = state.copyWith(
      selectedOption: index,
      answered: true,
      correctCount:
          index == correctIndex ? state.correctCount + 1 : state.correctCount,
    );
  }

  void nextQuestion() {
    state = QuizState(
      currentIndex: state.currentIndex + 1,
      correctCount: state.correctCount,
      questions: state.questions,
    );
  }

  void reset() {
    state = const QuizState();
  }
}

final quizProvider =
    StateNotifierProvider.autoDispose<QuizNotifier, QuizState>((ref) {
  return QuizNotifier();
});
