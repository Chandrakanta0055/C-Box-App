import 'package:c_box/Modals/UserModel.dart';
import 'package:c_box/pages/ChatRoomPage.dart';
import 'package:c_box/pages/ChatSearchPage.dart';
import 'package:c_box/widgets/FirebaseHelper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

import '../Modals/ChatRoomModel.dart';

class ChatPage extends StatefulWidget {
  final UserModel userModel;
  const ChatPage({super.key, required this.userModel});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text("Chat ",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15),),
        centerTitle: true,
      ),
      body: Container(

        child: StreamBuilder(
          stream:FirebaseFirestore.instance.collection("CboxChatRoomModel").where("participants.${widget.userModel.uid}",isEqualTo: true).snapshots(),
          builder: (context,snapshot){
            if(snapshot.connectionState == ConnectionState.active)
            {
              if(snapshot.hasData)
              {
                QuerySnapshot querySnapshot = snapshot.data as QuerySnapshot;


                return ListView.builder(
                    itemCount: querySnapshot.docs.length,
                    itemBuilder: (context,index){
                      ChatRoomModel? chatRoomModel= ChatRoomModel.fromMap(querySnapshot.docs[index].data() as Map<String, dynamic>);

                      Map<String ,dynamic> participants= chatRoomModel!.participants!;

                      List<String> participantsKey= participants.keys.toList();

                      participantsKey.remove(widget.userModel.uid);


                      return FutureBuilder(
                          future: helper().getUserById(participantsKey[0]),
                          builder: (context,userData)
                          {
                            if(userData.connectionState == ConnectionState.done) {
                              if(userData.data != null) {
                                UserModel userModel = userData.data as UserModel;

                                return ListTile(
                                  onTap: ()
                                  {
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatRoomPage(chatRoomModel: chatRoomModel, userModel: widget.userModel, targetUser: userModel) ));
                                  },
                                  title: Text(userModel.userName.toString()),
                                  subtitle: (chatRoomModel.lastMessage.toString())!= ""? Text(
                                      chatRoomModel.lastMessage.toString()): Text("say hi to your new friend"),
                                  leading: CircleAvatar(
                                    child: Icon(Icons.person),
                                  ),
                                );
                              }
                              else{
                                return Container();
                              }
                            }
                            else{
                              return Container();
                            }
                          });


                    });

              }
              else if(snapshot.hasData)
              {
                return Text(snapshot.error.toString());

              }
              else
              {
                return Center(
                  child: Text("no chars"),
                );
              }
            }
            else
            {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=> ChatSearchPage(userModel: widget.userModel)));
        },
        child: Icon(Icons.search),
      )
      ,

    );
  }
}
