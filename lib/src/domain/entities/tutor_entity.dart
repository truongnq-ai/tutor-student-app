class SolveResponseEntity {
  final String solveId;
  final String problemText;
  final SolutionDataEntity solution;
  final List<String> relatedSkills;

  SolveResponseEntity({
    required this.solveId,
    required this.problemText,
    required this.solution,
    required this.relatedSkills,
  });
}

class SolutionDataEntity {
  final List<SolutionStepEntity> steps;
  final String finalAnswer;
  final List<String> commonMistakes;

  SolutionDataEntity({
    required this.steps,
    required this.finalAnswer,
    required this.commonMistakes,
  });
}

class SolutionStepEntity {
  final int stepNumber;
  final String description;
  final String content;
  final String explanation;
  final String? hint;

  SolutionStepEntity({
    required this.stepNumber,
    required this.description,
    required this.content,
    required this.explanation,
    this.hint,
  });
}

class RecentProblemEntity {
  final String id;
  final String problemText;
  final String? imageUrl;
  final String? finalAnswer;
  final List<String> relatedSkills;
  final DateTime solvedAt;

  RecentProblemEntity({
    required this.id,
    required this.problemText,
    this.imageUrl,
    this.finalAnswer,
    required this.relatedSkills,
    required this.solvedAt,
  });
}

