
import 'package:c_box/Modals/CommentModel.dart';
import 'package:c_box/Modals/UserModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CommentController{

  void postComment(UserModel userModel, String comment,String imageId) async

  {
    try {
      var data = await FirebaseFirestore.instance.collection("images").doc(
          imageId).collection("Comments").get();
      int len = data.docs.length;

      Comment Postcomment = Comment(userName: userModel.userName!,
          uid: userModel.uid!,
          id: "comment $len",
          comment: comment!,
          profilePic: "",
          likes: [],
          datePublished: DateTime.now());

      await FirebaseFirestore.instance.collection("images").doc(imageId)
          .collection("Comments").doc("comment $len")
          .set(Postcomment.toMap());
      print("sucessfull comment");
      DocumentSnapshot snapshot= await FirebaseFirestore.instance.collection("images").doc(imageId).get();
      await FirebaseFirestore.instance.collection("images").doc(imageId).update({
        "commentCount": (snapshot.data()! as dynamic)["commentCount"] + 1
        // "commentCount": len

      });

    }
    catch(ex)
    {
      print(ex.toString());
    }
  }
  
  
  void likeComment({required String CommentId,required String imageid,required String uid}) async
  {
    
    DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection("images").doc(imageid).collection("Comments").doc(CommentId).get();

    Map<String, dynamic> map = snapshot.data() as Map<String,dynamic>;

    if(map["likes"].contains(uid))
      {
        await FirebaseFirestore.instance.collection("images").doc(imageid).collection("Comments").doc(CommentId).update({
          "likes":FieldValue.arrayRemove([uid])
        });

      }
    else{
      await FirebaseFirestore.instance.collection("images").doc(imageid).collection("Comments").doc(CommentId).update({
        "likes":FieldValue.arrayUnion([uid])
      });

    }
  }
}