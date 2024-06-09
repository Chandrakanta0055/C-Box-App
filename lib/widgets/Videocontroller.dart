import 'dart:developer';

import 'package:c_box/Modals/UserModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VideoController{
  VideoLikes(String id) async
  {
    DocumentSnapshot doc= await FirebaseFirestore.instance.collection("images").doc(id).get();

    var uid= FirebaseAuth.instance.currentUser!.uid!;
    Map<String,dynamic> map= doc.data() as Map<String,dynamic>;

    if((doc.data()! as dynamic)["likes"].contains(uid))
      {
        await FirebaseFirestore.instance.collection("images").doc(id).update({
          'likes':FieldValue.arrayRemove([uid]),
        });

      }
    else
      {
        await FirebaseFirestore.instance.collection("images").doc(id).update({
        'likes':FieldValue.arrayUnion([uid]),
        });

      }

  }
  
}
FollowUser(UserModel model) async
{
  
  String id= FirebaseAuth.instance.currentUser!.uid!;
  
  if(model.followers!.contains(id))
    {
      model.followers!.remove(id);
      await FirebaseFirestore.instance.collection("users").doc(model!.uid).update(model.toMap());
      log("unfollow");

      await FirebaseFirestore.instance.collection("users").doc(id).update({
        "follow": FieldValue.arrayRemove([model.uid])
      });
      print("update value");
      return "unfollow";
      
    }
  else{
    model.followers!.add(id);
    await FirebaseFirestore.instance.collection("users").doc(model!.uid).update(model.toMap());
    log("follow");


    await FirebaseFirestore.instance.collection("users").doc(id).update({
      "follow": FieldValue.arrayUnion([model.uid])
    });
    print("update value");





    return "follow";
  }

}



