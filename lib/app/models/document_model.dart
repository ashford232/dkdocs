import 'dart:convert';

class DocumentModel {
  final String id;
  final String uid;
  final String title;
  final List<Map<String, dynamic>> content;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  DocumentModel({
    required this.id,
    required this.uid,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'uid': uid,
      'title': title,
      'content': content,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory DocumentModel.fromMap(Map<String, dynamic> map) {
    return DocumentModel(
      id: map['_id'] ?? "",
      uid: map['uid'] ?? "",
      title: map['title'] ?? "",
      content: map['content'] == null
          ? <Map<String, dynamic>>[]
          : List<Map<String, dynamic>>.from(
              (map['content'] as List).map((e) => Map<String, dynamic>.from(e)),
            ),
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : null,
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'])
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory DocumentModel.fromJson(String source) =>
      DocumentModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
