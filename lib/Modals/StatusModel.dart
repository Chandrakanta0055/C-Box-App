import 'package:cloud_firestore/cloud_firestore.dart';

class StatusModel {
  String uid;
  String userName;
  String statusId;
  String profilePic;
  List<String> photoUrl;
  DateTime createAt;
  List<String> whoCanSee;

  StatusModel({
    required this.uid,
    required this.userName,
    required this.statusId,
    required this.profilePic,
    required this.photoUrl,
    required this.createAt,
    required this.whoCanSee,
  });

  factory StatusModel.fromMap(Map<String, dynamic> map) {
    return StatusModel(
      uid: map['uid'],
      userName: map['userName'],
      statusId: map['statusId'],
      profilePic: map['profilePic'],
      photoUrl: List<String>.from(map['photoUrl']),
      createAt: map['createAt'] != null ? (map['createAt'] as Timestamp).toDate() : DateTime.now(),
      whoCanSee: List<String>.from(map['whoCanSee']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'userName': userName,
      'statusId': statusId,
      'profilePic': profilePic,
      'photoUrl': photoUrl,
      'createAt': createAt,
      'whoCanSee': whoCanSee,
    };
  }
}
