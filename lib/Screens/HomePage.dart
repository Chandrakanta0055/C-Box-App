import 'package:c_box/Modals/UserModel.dart';
import 'package:c_box/Modals/imageModel.dart';
import 'package:c_box/Screens/ChatHomePage.dart';
import 'package:c_box/pages/CommentScreen.dart';
import 'package:c_box/widgets/Videocontroller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  final UserModel userModel;
  const MyHomePage({ required this.userModel});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

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
                            (context, index) {

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
                                      UserName: model.userName!, location: model.discription!,),
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

// class MyHomePage extends StatefulWidget {
//   final UserModel userModel;
//   const MyHomePage({required this.userModel});
//
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           centerTitle: true,
//           elevation: 0,
//           backgroundColor: Colors.white,
//           leadingWidth: 100,
//           leading: Center(
//             child: Text(
//               "C Box",
//               style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black),
//             ),
//           ),
//           actions: [
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Icon(
//                 Icons.favorite_border_outlined,
//                 color: Colors.black,
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: SizedBox(width: 23, height: 19, child: Image.asset('assets/images/message.png')),
//             ),
//           ],
//         ),
//         body: StreamBuilder(
//           stream: FirebaseFirestore.instance.collection("images").snapshots(),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.active) {
//               if (snapshot.hasData) {
//                 QuerySnapshot querySnapshot = snapshot.data as QuerySnapshot;
//                 List<QueryDocumentSnapshot> docs = querySnapshot.docs;
//                 docs.shuffle(); // Shuffle the list to randomize the order
//
//                 return CustomScrollView(
//                   slivers: [
//                     SliverList(
//                       delegate: SliverChildBuilderDelegate(
//                             (context, index) {
//                           ImageModel model = ImageModel.fromMap(docs[index].data() as Map<String, dynamic>);
//                           return Padding(
//                             padding: const EdgeInsets.all(20),
//                             child: Column(
//                               children: [
//                             profileBar(
//                               UserName: model.userName!, location: model.discription!,),
//                                 imageBar(url: model.imageUrl!,),
//                                 likeBar(imagemodel: model,userModel: widget.userModel,)
//                               ],
//                             ),
//                           );
//                         },
//                         childCount: docs.length,
//                       ),
//                     ),
//                   ],
//                 );
//               } else if (snapshot.hasError) {
//                 return Text("Check internet");
//               } else {
//                 return Text("No data");
//               }
//             } else {
//               return Center(
//                 child: CircularProgressIndicator(),
//               );
//             }
//           },
//         ));
//   }
// }

class profileBar extends StatefulWidget{
  profileBar({required this.UserName, required this.location});
  final String? UserName;
  final String? location;

  @override
  State<profileBar> createState() => _profileBarState();
}

class _profileBarState extends State<profileBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 54,
      color: Colors.white,
      child: Center(
        child: ListTile(
          leading: ClipOval(
            child: SizedBox(
              width: 35,
              height: 35,
              child: Image.asset("assets/images/person.png"),
            ),
          ),
          title: Text('${widget.UserName}',style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold),
          ),
          subtitle:Text("${widget.location}"),
          trailing: const Icon(Icons.more_horiz),
        ),
      ),
    );
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
