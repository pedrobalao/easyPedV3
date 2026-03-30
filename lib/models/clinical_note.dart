/// A temporary clinical note stored locally with auto-delete after 24 hours.
final class ClinicalNote {
  ClinicalNote({this.id, this.text, this.createdAt});

  ClinicalNote.fromJson(Map<String, dynamic> json) {
    id = json['id'] as String?;
    text = json['text'] as String?;
    createdAt = json['createdAt'] != null
        ? DateTime.parse(json['createdAt'] as String)
        : null;
  }

  String? id;
  String? text;
  DateTime? createdAt;

  /// Whether the note has exceeded its 24-hour lifetime.
  bool get isExpired =>
      createdAt != null &&
      DateTime.now().difference(createdAt!) > const Duration(hours: 24);

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['text'] = text;
    data['createdAt'] = createdAt?.toIso8601String();
    return data;
  }
}
