class Comment {
  String userName;
  String uid;
  String id;
  String comment;
  String profilePic;
  List likes;
  late final datePublished;

  Comment({ required this.userName, required this.uid,required this.id,required this.comment,required this.profilePic,
    required this.likes,required this.datePublished});

  Map<String, dynamic> toMap() {
    return {
      "userName": userName,
      "uid": uid,
      "id": id,
      "comment": comment,
      "profilePic": profilePic,
      "likes": likes,
      "datePublished": DateTime.now()
    };
  }
  Comment fromMap(Map<String,dynamic> map)
  {
    return Comment(userName: map["userName"], uid: map["uid"] , id: map["id"], comment: map["comment"], profilePic: map["profilePic"], likes:  map["likes"], datePublished: map["datePublished"]) ;
    // userName = map["userName"];
    //   uid = map["uid"];
    //   id = map["id"];
    //   datePublished = map["datePublished"];
    //   comment = map["comment"];
    //   profilePic =map["profilePic"];
    //   likes = map["likes"];





  }


}




