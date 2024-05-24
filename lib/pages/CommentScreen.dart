import 'package:c_box/Modals/CommentModel.dart';
import 'package:c_box/Modals/UserModel.dart';
import 'package:c_box/Modals/imageModel.dart';
import 'package:c_box/widgets/CommentController.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CommentScreen extends StatefulWidget {
  final ImageModel imageModel;
  final UserModel userModel;

  const CommentScreen({super.key, required this.imageModel, required this.userModel});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  TextEditingController commentC = TextEditingController();

  void CommentData() {
    String comment = commentC.text.trim();
    if (comment.isEmpty) {
      print("Please write a comment");
    } else {
      CommentController().postComment(widget.userModel, comment, widget.imageModel.id!);
      commentC.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(
          widget.imageModel.userName!,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection("images").doc(widget.imageModel.id).collection("Comments").snapshots(),
              builder: (context, snapshot) {
                if(snapshot.connectionState == ConnectionState.active) {
                  if(snapshot.hasData) {
                    QuerySnapshot data= snapshot.data as QuerySnapshot;


                    return ListView.builder(
                      itemCount: data.docs.length,
                        itemBuilder: (context, index) {
                          Map<String,dynamic> map= data.docs[index].data() as Map<String,dynamic>;
                          // Comment comment = Comment(userName: map["userName"], uid: uid, id: id, comment: comment, profilePic: profilePic, likes: likes, datePublished: datePublished)
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SingleChildScrollView(
                              child: Container(
                                child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CircleAvatar(child: Icon(Icons.person)),
                                      SizedBox(width: 10,),
                                      SingleChildScrollView(
                                        child: Row(
                                          children: [
                                            Text(map["userName"], style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.red),),
                                            SizedBox(width: 8,),
                                            SingleChildScrollView(child: Text(
                                              map["comment"],
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 15),))
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 15,),
                                      InkWell(
                                          onTap: () {
                                            CommentController().likeComment(CommentId: map["id"], imageid: widget.imageModel!.id!,uid: widget.userModel!.uid!);
                                          },
                                          child: Column(
                                            children: [
                                              Icon(Icons.favorite),
                                              SizedBox(height: 5,),
                                              Text(map["likes"].length.toString())
                                            ],
                                          ))
                                    ]
                                ),
                              ),
                            ),
                          );
                        });
                  }
                  else if(snapshot.hasError)
                  {
                    return Text("error");
                  }
                  else
                    {
                      return Text("No data");
                    }
                }
                else{
                  return Center(child: CircularProgressIndicator());
                }

              }
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: "Comments",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    controller: commentC,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    CommentData();
                  },
                  icon: Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
