class Transcript {
  final String id;
  final String audioUrl;
  final String transcript;
  final String userId;
  final DateTime createdAt;

  Transcript({
    required this.id,
    required this.audioUrl,
    required this.transcript,
    required this.userId,
    required this.createdAt,
  });

  factory Transcript.fromJson(Map<String, dynamic> json) {
    return Transcript(
      id: json['_id'] as String,
      audioUrl: json['audioUrl'] as String,
      transcript: json['transcript'] as String,
      userId: json['userId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Transcript copyWith({
    String? id,
    String? transcript,
    String? audioUrl,
    String? title,
    DateTime? createdAt,
  }) {
    return Transcript(
      id: id ?? this.id,
      transcript: transcript ?? this.transcript,
      audioUrl: audioUrl ?? this.audioUrl,
      userId: userId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'audioUrl': audioUrl,
      'transcript': transcript,
      'userId': userId,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
