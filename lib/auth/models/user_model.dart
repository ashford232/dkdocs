import 'dart:convert';

class UserModel {
  final String uid;
  final String email;
  final String name;

  final String photoUrl;
  final DateTime? dob;
  final DateTime? createdAt;
  final String token;

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.photoUrl,
    this.dob,
    this.createdAt,
    required this.token,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'email': email,
      'name': name,
      'photoUrl': photoUrl,
      'dob': dob?.millisecondsSinceEpoch,
      'createdAt': createdAt?.millisecondsSinceEpoch,
      'token': token,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? "",
      email: map['email'] ?? "",
      name: map['name'] ?? "",
      photoUrl: map['photoUrl'] ?? "",
      dob: map["dob"] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(map['dob'] as int),
      createdAt: map["createdAt"] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      token: map['token'] ?? "",
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  UserModel copyWith({
    String? uid,
    String? email,
    String? name,
    String? photoUrl,
    DateTime? dob,
    DateTime? createdAt,
    String? token,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      dob: dob ?? this.dob,
      createdAt: createdAt ?? this.createdAt,
      token: token ?? this.token,
    );
  }
}
