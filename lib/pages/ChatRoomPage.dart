import 'dart:html';

import 'package:c_box/Modals/ChatRoomModel.dart';
import 'package:c_box/Modals/MessageModel.dart';
import 'package:c_box/Modals/UserModel.dart';
import 'package:c_box/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatRoomPage extends StatefulWidget {
  final ChatRoomModel chatRoomModel;
  final UserModel userModel;
  final UserModel targetUser;
  const ChatRoomPage({super.key, required this.chatRoomModel, required this.userModel, required this.targetUser});

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {

  TextEditingController textEditingController= TextEditingController();

  void sendMessage() async
  {
    String message= textEditingController.text.trim();
    if(message!="")
      {
        MessageModel messageModel= MessageModel(
          messageid: uuid.v1(),
          seen: false,
          text: message,
          sender: widget.userModel.uid,
          createdon: DateTime.now()
        );

        FirebaseFirestore.instance.collection("CboxChatRoomModel").doc(widget.chatRoomModel.chatroomid).collection("messages").doc(messageModel.messageid).set(messageModel.toMap());
        print("message send sucessfully");
        widget.chatRoomModel.lastMessage = message;

        FirebaseFirestore.instance.collection("CboxChatRoomModel").doc(widget.chatRoomModel.chatroomid).set(widget.chatRoomModel!.toMap());
      }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar
        (
        backgroundColor: Colors.blueAccent,
        title: Text(widget.targetUser.userName!,style: TextStyle(color: Colors.white),),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(child: Icon(Icons.person)),
        ),

      ),

      body: Column(
        children: [
          Expanded(
            child:Container(
              padding: EdgeInsets.all(10),
              child:StreamBuilder(
                  stream: FirebaseFirestore.instance.collection("CboxChatRoomModel").doc(widget.chatRoomModel!.chatroomid!).collection("messages").orderBy("createdon",descending: true).snapshots(),
                  builder: (context,snapshot)
              {
                if(snapshot.connectionState == ConnectionState.active)
                  {
                    if(snapshot.hasData)
                      {
                        QuerySnapshot data= snapshot.data as QuerySnapshot;

                        return ListView.builder(


                            reverse: true,
                            itemCount: data.docs.length,

                            itemBuilder: (context,index){

                              MessageModel model= MessageModel.fromMap(data.docs[index].data() as Map<String,dynamic>);
                              return Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: model.sender == widget.userModel.uid ? MainAxisAlignment.end : MainAxisAlignment.start ,
                                children: [
                                  Container(
                                    margin: EdgeInsets.all(10),
                                    // color:Colors.blueAccent,
                                    padding: EdgeInsets.all(10),
                             //        decoration:BoxDecoration(
                             // borderRadius: BorderRadius.circular(5)
                             //  ),
                                    child: Text(
                                      model.text.toString()
                                    ),
                                  ),
                                ],
                              );

                        });

                      }
                    else
                      {
                        return Center(child: Text("No data"));
                      }

                  }
                else
                  {
                    return Center(child: CircularProgressIndicator(),);
                  }

              })
              ,
            )
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    maxLines: null,
                    decoration: InputDecoration(
                      labelText: "Enter message",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    controller:textEditingController
                  ),
                ),
                IconButton(
                  onPressed: () {

                    sendMessage();
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
