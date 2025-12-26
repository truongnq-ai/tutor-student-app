import '../../domain/entities/tutor_entity.dart';

class SolveResponseModel extends SolveResponseEntity {
  SolveResponseModel({
    required super.solveId,
    required super.problemText,
    required super.solution,
    required super.relatedSkills,
  });

  factory SolveResponseModel.fromJson(Map<String, dynamic> json) {
    return SolveResponseModel(
      solveId: json['solveId'] as String,
      problemText: json['problemText'] as String,
      solution: SolutionDataModel.fromJson(json['solution'] as Map<String, dynamic>),
      relatedSkills: (json['relatedSkills'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'solveId': solveId,
      'problemText': problemText,
      'solution': (solution as SolutionDataModel).toJson(),
      'relatedSkills': relatedSkills,
    };
  }
}

class SolutionDataModel extends SolutionDataEntity {
  SolutionDataModel({
    required super.steps,
    required super.finalAnswer,
    required super.commonMistakes,
  });

  factory SolutionDataModel.fromJson(Map<String, dynamic> json) {
    return SolutionDataModel(
      steps: (json['steps'] as List<dynamic>)
          .map((e) => SolutionStepModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      finalAnswer: json['finalAnswer'] as String,
      commonMistakes: (json['commonMistakes'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'steps': steps.map((e) => (e as SolutionStepModel).toJson()).toList(),
      'finalAnswer': finalAnswer,
      'commonMistakes': commonMistakes,
    };
  }
}

class SolutionStepModel extends SolutionStepEntity {
  SolutionStepModel({
    required super.stepNumber,
    required super.description,
    required super.content,
    required super.explanation,
    super.hint,
  });

  factory SolutionStepModel.fromJson(Map<String, dynamic> json) {
    return SolutionStepModel(
      stepNumber: json['stepNumber'] as int,
      description: json['description'] as String,
      content: json['content'] as String,
      explanation: json['explanation'] as String,
      hint: json['hint'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stepNumber': stepNumber,
      'description': description,
      'content': content,
      'explanation': explanation,
      if (hint != null) 'hint': hint,
    };
  }
}

class RecentProblemModel extends RecentProblemEntity {
  RecentProblemModel({
    required super.id,
    required super.problemText,
    super.imageUrl,
    super.finalAnswer,
    required super.relatedSkills,
    required super.solvedAt,
  });

  factory RecentProblemModel.fromJson(Map<String, dynamic> json) {
    return RecentProblemModel(
      id: json['id'] as String,
      problemText: json['problemText'] as String,
      imageUrl: json['imageUrl'] as String?,
      finalAnswer: json['finalAnswer'] as String?,
      relatedSkills: (json['relatedSkills'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      solvedAt: DateTime.parse(json['solvedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'problemText': problemText,
      if (imageUrl != null) 'imageUrl': imageUrl,
      if (finalAnswer != null) 'finalAnswer': finalAnswer,
      'relatedSkills': relatedSkills,
      'solvedAt': solvedAt.toIso8601String(),
    };
  }
}

