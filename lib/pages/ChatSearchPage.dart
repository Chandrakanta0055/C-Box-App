import 'dart:developer';

import 'package:c_box/Modals/UserModel.dart';
import 'package:c_box/pages/ChatRoomPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Modals/ChatRoomModel.dart';
import '../main.dart';

class ChatSearchPage extends StatefulWidget {
  final UserModel userModel;
  const ChatSearchPage({super.key, required this.userModel});

  @override
  State<ChatSearchPage> createState() => _ChatSearchPageState();
}

class _ChatSearchPageState extends State<ChatSearchPage> {
  TextEditingController searchController= TextEditingController();


  Future<ChatRoomModel> getChatRoom(UserModel targetUser) async
  {
    ChatRoomModel? chatRoomModel;
    QuerySnapshot querySnapshot= await FirebaseFirestore.instance.collection("CboxChatRoomModel").
    where("participants.${widget.userModel.uid}",isEqualTo: true).
    where("participants.${targetUser.uid}",isEqualTo: true).get();
    if(querySnapshot.docs.length >0)
      {
        log("userModel Exist");
        Map<String,dynamic> map = querySnapshot.docs[0].data() as Map<String,dynamic>;

        ChatRoomModel exitChatRoom= ChatRoomModel.fromMap(map);
        chatRoomModel =exitChatRoom;
      }
    else
      {
        print("new chat room created");

        ChatRoomModel newChatRoom = ChatRoomModel(
          chatroomid: uuid.v1(),
          lastMessage: "",
          participants: {
            widget.userModel.uid!:true,
            targetUser.uid!:true
          }


        );


        chatRoomModel= newChatRoom;
        await FirebaseFirestore.instance.collection("CboxChatRoomModel").doc(chatRoomModel.chatroomid).set(chatRoomModel.toMap());
        print("sucessfully store data");
      }

    return chatRoomModel!;
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search Page"),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: "email",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5)
                )
              ),
            ),
            SizedBox(
              height: 20,
            ),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)
                )
              ),
              onPressed: (){
              setState(() {
                
              });
            }, child: Text("search"),

            )
            ,
            SizedBox(height: 10,),
            StreamBuilder(stream: FirebaseFirestore.instance.collection("users").where("email",isEqualTo: searchController.text.trim()).snapshots(),
                builder: (context,snapshot)
            {
              if(snapshot.connectionState == ConnectionState.active)
                {
                  if(snapshot.hasData )
                    {
                      QuerySnapshot querySnap= snapshot.data as QuerySnapshot;
                      if(querySnap.docs.length > 0) {
                        UserModel targetUser = UserModel.fromMap(
                            querySnap.docs[0].data() as Map<String, dynamic>);
                        return ListTile(
                          onTap: ()async
                          {
                            ChatRoomModel chatroomModel= await  getChatRoom(targetUser);

                            Navigator.pop(context);

                            Navigator.push(context, MaterialPageRoute(builder: (context)=> ChatRoomPage(chatRoomModel: chatroomModel, userModel: widget.userModel, targetUser: targetUser)));
                          },
                          title: Text(targetUser.userName!),
                          subtitle: Text(targetUser.email!),
                          leading: Icon(Icons.person),


                        );
                      }
                      else{
                        return Text("no data");
                      }

                    }
                  else if(snapshot.hasError)
                    {
                      return Text("error ");

                    }
                  else
                    {
                      return Center(child: Text("No User"),);
                    }

                }
              else
                {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }


            })

          ],
        ),

      ),

    );
  }
}

