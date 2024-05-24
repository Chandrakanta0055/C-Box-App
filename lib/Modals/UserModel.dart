class UserModel{
  String? email;
  String? userName;
  String? uid;
  String? password;
  List? followers;
  List? follow;


  UserModel({this.email, this.userName, this.uid, this.password, this.followers,
      this.follow});

  UserModel.fromUser(Map<String ,dynamic> map)
  {
    email= map["email"];
    userName= map["userName"];
    uid= map["uid"];
    password=map["password"];
    followers= map["followers"];
    follow=map["follow"];

  }
  Map<String ,dynamic> toMap()
  {
    return {
      "email": email,
      "userName": userName,
      "uid":uid,
      "password": password,
      "followers": followers,
      "follow": follow
    };
  }
}