import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage();

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
              child: SizedBox(width:23,height:19,child: Image.asset('assets/images/message.png')),
            ),
          ],
        ),
        body:
        CustomScrollView(
          slivers: [
            SliverList(
              delegate:SliverChildBuilderDelegate(
                    (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [ profileBar(UserName: "Chandra",location: "Nalco",), imageBar(),likeBar()],
                    ),
                  );
                }, childCount: 5,
              ),
            ),
          ],
        )
    );
  }
}

class profileBar extends StatefulWidget{
  profileBar({required this.UserName, this.location});
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
          subtitle: widget.location!=null ?Text("${widget.location}"):Text(""),
          trailing: const Icon(Icons.more_horiz),
        ),
      ),
    );
  }
}

class imageBar extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 375,
        child: Image.asset("assets/images/post.jpg",fit: BoxFit.cover,),
      ),
    );
  }
}

class likeBar extends StatelessWidget{
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
                      const Icon(Icons.favorite_outline,size: 25,),
                      Text("100")
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
                  Icon(Icons.comment),
                  Text("")
                ],
              ),
              SizedBox(width: 17),
              Column(
                children: [
                  Image.asset("assets/images/send.png",height: 19,),
                  Text("")
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
