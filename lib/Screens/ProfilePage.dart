import 'package:c_box/Modals/UserModel.dart';
import 'package:c_box/Modals/imageModel.dart';
import 'package:c_box/pages/loginPages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  final UserModel userModel;
  const ProfilePage({super.key, required this.userModel});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(bottom: 50),
          // padding: EdgeInsets.all(15),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(width: 10,),
                  Text(widget.userModel!.userName!,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700),),
                  SizedBox(width:MediaQuery.of(context).size.width *0.7 ,),

                  IconButton(
                    onPressed: () {
                      Navigator.popUntil(context, (route) => route.isFirst);
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPages()));
                    },
                    icon: Icon(
                      color: Colors.black,
                      Icons.exit_to_app_outlined,
                    ),
                  ),
                  SizedBox(width: 10,)

                ],
              ),
              Divider(
                color: Colors.grey,
                thickness: 2,
              )
              ,
              SizedBox(height: 30,),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 40,
                    child: Icon(Icons.person),
                  ),
                ],
              ),
              Text(widget.userModel.userName!,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
              SizedBox(height: 25),
              // Divider(
              //   color: Colors.grey,
              //   thickness: 1,
              // )
              // ,
              Container(
                padding: EdgeInsets.all(5),
                child: Card(
                  
                  elevation: 4,
                  child: Center(
                    child: SizedBox(
                      height: 65,
                      child: Container(
                        margin: EdgeInsets.only(top: 6),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(width: 20),
                            Column(
                              children: [
                
                                Text(widget.userModel.follow!.length!.toString(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                                SizedBox(height: 4),
                                Text("Following",style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                              ],
                            ),
                            SizedBox(width: 20),
                            Column(
                              children: [
                                Text(widget.userModel.followers!.length.toString(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                                SizedBox(height: 4),
                                Text("Followers",style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Divider(
              //   color: Colors.grey,
              //   thickness: 1,
              // )
              // ,
              SizedBox(height: 30),
              StreamBuilder(
                stream: FirebaseFirestore.instance.collection("images").where("uid",isEqualTo: widget.userModel.uid).snapshots(),
                builder: (context, snapshot) {
                  if(snapshot.connectionState == ConnectionState.active) {
                    if(snapshot.hasData) {
                      QuerySnapshot data= snapshot.data as QuerySnapshot;

                      return Container(
                        height: 400, // Specify a height for the GridView
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 3 / 2,
                            crossAxisSpacing: 7,
                            mainAxisSpacing: 7,
                          ),
                          itemBuilder: (context, index) {

                            ImageModel model= ImageModel.fromMap(data.docs[index].data() as Map<String,dynamic>);
                            return Card(

                              elevation: 4,
                              child: Container(
                                // color: Colors.blueAccent,
                                child: Column(
                                  children: [
                                    Container(),
                                  ],
                                ),
                              ),
                            );
                          },
                          itemCount: data.docs.length,
                        ),
                      );
                    }
                    else{
                      return Text("No post");
                    }
                  }
                  else
                    {
                      return Container(child: CircularProgressIndicator());
                    }
                }
              ),
            ],
          ),
        ),
      ),
    );
  }
}
