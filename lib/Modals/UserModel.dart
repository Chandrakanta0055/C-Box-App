class UserModel {
  String? email;
  String? userName;
  String? uid;
  String? password;
  List<String>? followers;
  List<String>? follow;

  UserModel({this.email, this.userName, this.uid, this.password, this.followers, this.follow});

  UserModel.fromMap(Map<String, dynamic> map) {
    email = map["email"];
    userName = map["userName"];
    uid = map["uid"];
    password = map["password"];
    followers = List<String>.from(map["followers"] ?? []);
    follow = List<String>.from(map["follow"] ?? []);
  }

  Map<String, dynamic> toMap() {
    return {
      "email": email,
      "userName": userName,
      "uid": uid,
      "password": password,
      "followers": followers,
      "follow": follow,
    };
  }
}
