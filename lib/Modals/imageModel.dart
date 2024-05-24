import 'package:cloud_firestore/cloud_firestore.dart';

class ImageModel{
  String? userName;
  String? uid;
  String? id;
  String? imageUrl;
  String? discription;
  String? profilePic;
  List?likes;
  int? commentCount;
  int? shareCount;

  ImageModel({ this.userName,
     this.uid,
    this.id,
    this.imageUrl,
    this.discription,
    this.profilePic,
    this.likes,
    this.commentCount,
    this.shareCount });

  ImageModel.fromMap(Map <String,dynamic> map )
  {
        userName = map["userName"];
        uid = map["uid"];
        id = map["id"];
        imageUrl = map["imageUrl"];
        discription = map["discription"];
        profilePic= map["profilePic"];
        likes = map["likes"];
        commentCount = map["commentCount"];
        shareCount = map["shareCount"];

  }
  Map<String,dynamic> toJson()
  {
    return{
      "userName":userName,
      "uid":uid,
      "id":id,
      "imageUrl":imageUrl,
      "discription": discription,
      "likes": likes,
      "commentCount":commentCount,
      "shareCount":shareCount
    };
  }


}