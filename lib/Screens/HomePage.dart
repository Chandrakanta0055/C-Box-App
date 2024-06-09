import 'dart:developer';

import 'dart:typed_data';

import 'package:c_box/Modals/StatusModel.dart';
import 'package:c_box/Modals/UserModel.dart';
import 'package:c_box/Modals/imageModel.dart';
import 'package:c_box/Screens/ChatHomePage.dart';
import 'package:c_box/Screens/ProfilePage.dart';
import 'package:c_box/Screens/statusScreens.dart';
import 'package:c_box/pages/CommentScreen.dart';
import 'package:c_box/widgets/FirebaseHelper.dart';
import 'package:c_box/widgets/Videocontroller.dart';
import 'package:c_box/widgets/helper2.dart';
import 'package:c_box/widgets/statusController.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import 'StatusPage.dart';

class MyHomePage extends StatefulWidget {
  final UserModel userModel;
  const MyHomePage({ required this.userModel});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Uint8List? file;

  final List<Map<String, dynamic>> searchUsers = [
    {
      'profileImageUrl': 'https://cdn.pixabay.com/photo/2016/03/15/17/07/girl-1258727_640.jpg',
      'username': 'johndoe',
      'fullName': 'John Doe',
    },
    {
      'profileImageUrl': 'https://cdn.pixabay.com/photo/2017/09/26/17/34/ballet-2789416_640.jpg',
      'username': 'janedoe',
      'fullName': 'Jane Doe',
    },
    {
      'profileImageUrl': 'https://cdn.pixabay.com/photo/2019/05/28/05/06/female-4234344_640.jpg',
      'username': 'mikebrown',
      'fullName': 'Mike Brown',
    },
    {
      'profileImageUrl': 'https://cdn.pixabay.com/photo/2016/10/20/08/36/woman-1754895_640.jpg',
      'username': 'emilyjones',
      'fullName': 'Emily Jones',
    },
    {
      'profileImageUrl': 'https://cdn.pixabay.com/photo/2019/07/25/10/43/ballerina-4362282_640.jpg',
      'username': 'alexsmith',
      'fullName': 'Alex Smith',
    },
    {
      'profileImageUrl': 'https://cdn.pixabay.com/photo/2016/03/15/17/07/girl-1258727_640.jpg',
      'username': 'sarahwilliams',
      'fullName': 'Sarah Williams',
    },
    {
      'profileImageUrl': 'https://cdn.pixabay.com/photo/2016/07/08/23/17/girl-1505407_640.jpg',
      'username': 'davidlee',
      'fullName': 'David Lee',
    },
    {
      'profileImageUrl': 'https://cdn.pixabay.com/photo/2023/01/01/16/35/street-7690347_640.jpg',
      'username': 'laurajohnson',
      'fullName': 'Laura Johnson',
    },
    {
      'profileImageUrl': 'https://cdn.pixabay.com/photo/2016/10/20/08/36/woman-1754895_640.jpg',
      'username': 'emilyjones',
      'fullName': 'Emily Jones',
    },
    {
      'profileImageUrl': 'https://cdn.pixabay.com/photo/2019/07/25/10/43/ballerina-4362282_640.jpg',
      'username': 'alexsmith',
      'fullName': 'Alex Smith',
    },
    {
      'profileImageUrl': 'https://cdn.pixabay.com/photo/2016/03/15/17/07/girl-1258727_640.jpg',
      'username': 'sarahwilliams',
      'fullName': 'Sarah Williams',
    },
    {
      'profileImageUrl': 'https://cdn.pixabay.com/photo/2016/07/08/23/17/girl-1505407_640.jpg',
      'username': 'davidlee',
      'fullName': 'David Lee',
    },
    {
      'profileImageUrl': 'https://cdn.pixabay.com/photo/2023/01/01/16/35/street-7690347_640.jpg',
      'username': 'laurajohnson',
      'fullName': 'Laura Johnson',
    },
    {
      'profileImageUrl': 'https://cdn.pixabay.com/photo/2016/10/20/08/36/woman-1754895_640.jpg',
      'username': 'emilyjones',
      'fullName': 'Emily Jones',
    },
    {
      'profileImageUrl': 'https://cdn.pixabay.com/photo/2019/07/25/10/43/ballerina-4362282_640.jpg',
      'username': 'alexsmith',
      'fullName': 'Alex Smith',
    },
    {
      'profileImageUrl': 'https://cdn.pixabay.com/photo/2016/03/15/17/07/girl-1258727_640.jpg',
      'username': 'sarahwilliams',
      'fullName': 'Sarah Williams',
    },
    {
      'profileImageUrl': 'https://cdn.pixabay.com/photo/2016/07/08/23/17/girl-1505407_640.jpg',
      'username': 'davidlee',
      'fullName': 'David Lee',
    },
    {
      'profileImageUrl': 'https://cdn.pixabay.com/photo/2023/01/01/16/35/street-7690347_640.jpg',
      'username': 'laurajohnson',
      'fullName': 'Laura Johnson',
    },
  ];

  PreferredSize _buildStatusBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(100),
      child: Container(
        color: Colors.lightBlue[50],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 10),
            Stack(
              children: [
                InkWell(
                  onTap: pickFile,
                  child: CircleAvatar(
                    radius: 25,
                    child: Icon(Icons.person),
                  ),
                ),
                Center(child: Icon(Icons.add)),
              ],
            ),
            SizedBox(width: 10),
            Expanded(
              child: Container(
                height: 100,
                child: FutureBuilder<List<StatusModel>>(
                  future: getStatusData(widget.userModel),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasData) {
                      print("hasData");
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {

                          var statusData = snapshot.data![index];
                          return _buildStatusTile(statusData);
                        },
                      );
                    } else {
                      print("no data ");
                      return Center(child: Text("No status available"));
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusTile(StatusModel statusData) {
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> Statuscreens(status: statusData) ));
      },
      child: Container(
        width: 70,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 25,
                // backgroundImage: NetworkImage(statusData.profileImageUrl),
                child: Icon(Icons.person),
              ),
              SizedBox(height: 4),
              Text(
                statusData.userName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> pickFile() async {
    try {
      file = await Helper().pickImage(ImageSource.gallery);
      if (file != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Statuspage(file: file!, userModel: widget.userModel),
          ),
        );
      }
    } catch (e) {
      log('Error picking file: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(


        appBar: AppBar(

          centerTitle: true,
          elevation: 0,
          // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          backgroundColor: Colors.white,
          leadingWidth: 100,
          leading:  Center(child: Text("C Box",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.black),)),
          // title: Text("C Box",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.white),),
          //leading: SizedBox(width:23,height:19,child: Image.asset('assets/images/camera.jpg')),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: const Icon(
                Icons.favorite_border_outlined,
                color: Colors.black,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: ()
                  {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> ChatPage(userModel: widget.userModel)));

                  },
                  child: SizedBox(width:23,height:19,child: Image.asset('assets/images/message.png'))),
            ),
          ],
          bottom: _buildStatusBar(),
        ),
        body:
        StreamBuilder(
          stream: FirebaseFirestore.instance.collection("images").snapshots(),
          builder: (context, snapshot) {

            if(snapshot.connectionState == ConnectionState.active) {
              if(snapshot.hasData) {
                QuerySnapshot querySnapshot = snapshot.data as QuerySnapshot;


                return CustomScrollView(
                  slivers: [
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                            (context, index){

                              ImageModel model = ImageModel.fromMap(querySnapshot.docs[index].data() as Map<String ,dynamic>);

                          return Padding(
                            padding: const EdgeInsets.all(20),
                            child: Card(
                              elevation: 5,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Column(
                                  children: [
                                    profileBar(
                                      UserName: model.userName!, location: model.discription!, uid: model!.uid!),
                                    imageBar(url: model.imageUrl!,),
                                    likeBar(imagemodel: model,userModel: widget.userModel,)
                                  ],
                                ),
                              ),
                            ),
                          );
                        }, childCount: querySnapshot.docs.length,
                      ),
                    ),
                  ],
                );
              }
              else if(snapshot.hasError)
                {
                  return Text("check internet");

                }
              else{
                return Text("No data");
              }
            }
            else
              {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
          }
        )
    );
  }
}



class profileBar extends StatefulWidget{
  profileBar({required this.UserName, required this.location, required this.uid});
  final String? UserName;
  final String? location;
  final String? uid;

  @override
  State<profileBar> createState() => _profileBarState();
}

class _profileBarState extends State<profileBar> {
  UserModel? model;


  getUserModel() async
  {
    model = await helper().getUserById(widget!.uid!);
    log(model!.uid!);
    log(model!.userName!);
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserModel();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 54,
      color: Colors.white,
      child: Center(
        child: ListTile(
          leading: ClipOval(
            child: InkWell(
              onTap: (){
               Navigator.push(context, MaterialPageRoute(builder: (context)=>  ProfilePage(userModel: model!,)));
              },
              child: SizedBox(
                width: 35,
                height: 35,
                child: Image.asset("assets/images/person.png"),
              ),
            ),
          ),
          title: Text('${widget.UserName}',style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold),
          ),
          subtitle:Text("${widget.location}"),
          trailing: const Icon(Icons.more_horiz),
        ),
      ),
    ) ;
  }
}

class imageBar extends StatelessWidget{
  final String? url;
   imageBar({ this.url});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 375,
        decoration: BoxDecoration(
          image:DecorationImage(
            image:  NetworkImage(url!)
          )
        ),
      ),
    );
  }
}

class likeBar extends StatelessWidget{
  // final List likes;
  // final int commentCount;
  // final int shareCount;
  // final String id;
  // final String uid;
  final ImageModel imagemodel;
  final UserModel userModel;

  likeBar({ required this.imagemodel, required this.userModel});
  // likeBar({ required this.likes, required this.commentCount,required this.shareCount, required this.id, required this.uid});
  @override

  Widget build(BuildContext context) {
    return Container(
      width:MediaQuery.of(context).size.width,
      color: Colors.white,
      child: Column(
        children: [
          SizedBox(height: 14),
          Row(
            children: [
              SizedBox(width: 14),
              Column(
                children: [
                  Column(
                    children: [
                      InkWell(
                        onTap: ()
                          {
                            VideoController().VideoLikes(imagemodel.id.toString());
                          },
                          child: Icon(imagemodel.likes!.contains(userModel.uid) ? Icons.favorite:Icons.favorite_outline,size: 25,color: imagemodel.likes!.contains(userModel.uid) ? Colors.red : Colors.black ,)),
                      Text(imagemodel.likes!.length.toString())
                    ],
                  ),
                  SizedBox(height: 3,),
                  // Text("100"),
                ],
              ),
              SizedBox(width: 17),
              // Image.asset("assets/images/comment.png",
              //   height: 19,
              // ),
              Column(
                children: [
                  InkWell(
                    onTap: ()
                      {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>CommentScreen(imageModel: imagemodel, userModel: userModel)));
                      },
                      child: Icon(Icons.comment)),
                  Text(imagemodel.commentCount!.toString())
                ],
              ),
              SizedBox(width: 17),
              Column(
                children: [
                  Image.asset("assets/images/send.png",height: 19,),
                  Text(imagemodel.shareCount.toString())
                ],
              ),

              const Spacer(),
              Padding(padding: EdgeInsets.only(right: 15),
                  child: Image.asset("assets/images/save.png", height: 20,)
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 19,top: 8),
            child: Row(
              children: [
                Text('username'+' ',
                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 13),),
                Text('caption'+'',
                  style: TextStyle(fontSize: 13),),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
