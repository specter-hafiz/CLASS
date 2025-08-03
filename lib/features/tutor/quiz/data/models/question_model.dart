class Question {
  final String id;
  final String question;
  final List<String> options;
  final String answer;

  Question({
    required this.id,
    required this.question,
    required this.options,
    required this.answer,
  });
  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['_id']?.toString() ?? '',
      question: json['question']?.toString() ?? '',
      options:
          (json['options'] as List?)?.map((o) => o.toString()).toList() ?? [],
      answer: json['answer']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'question': question,
      'options': options,
      'answer': answer,
    };
  }

  Question copyWith({String? question, List<String>? options, String? answer}) {
    return Question(
      id: id,
      question: question ?? this.question,
      options: options ?? this.options,
      answer: answer ?? this.answer,
    );
  }
}
