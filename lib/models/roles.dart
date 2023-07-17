import 'package:cloud_firestore/cloud_firestore.dart';

class Role {
  final String id;
  final String name;
  final String clubId;
  final List<Right> rights;

  Role({
    required this.id,
    required this.name,
    required this.clubId,
    required this.rights,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'clubId': clubId,
      'rights': rights.map((right) => right.toJson()).toList(),
    };
  }

  static Role fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    final rightsList = (data['rights'] as List<dynamic>)
        .map((right) => Right.fromMap(right))
        .toList();
    return Role(
      id: snapshot.id,
      name: data['name'] as String,
      clubId: data['clubId'] as String,
      rights: rightsList,
    );
  }
}

class Right {
  final String id;
  final String name;

  Right({
    required this.id,
    required this.name,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  static Right fromMap(Map<String, dynamic> map) {
    return Right(
      id: map['id'] as String,
      name: map['name'] as String,
    );
  }
}
