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