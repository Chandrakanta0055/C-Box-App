import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'Screens/AddPostPage.dart';
import 'Screens/CameraPage.dart';
import 'Screens/HomePage.dart';
import 'Screens/ProfilePage.dart';
import 'Screens/SearchPage.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  late int index=0;

  final pages=[
    MyHomePage(),
    SearchPage(),
    AddPostPage(),
    CameraPage(),
    ProfilePage()

  ];

  final items= <Widget> [
    Icon(Icons.home,size: 30,color: Colors.blueGrey,),
    Icon(Icons.search,size: 30,color: Colors.blueGrey,),
    Icon(Icons.add_circle_rounded,size: 30,color: Colors.blueAccent,),
   Icon(Icons.camera_alt,size: 30,color: Colors.blueGrey,),
    Icon(Icons.person,size: 30,color: Colors.blueGrey,),
  ];

  @override
  Widget build(BuildContext context) {

    return Container(
      child: SafeArea(
        top: false,

          child: Scaffold(
            extendBody: true,
            backgroundColor: Colors.blue,
            bottomNavigationBar: CurvedNavigationBar(
              color:Colors.cyanAccent,
              height: 60,
              items: items,
              index: index,
              // buttonBackgroundColor: Colors.blueAccent,
              backgroundColor: Colors.transparent,
              animationCurve: Curves.easeOut,
              animationDuration: Duration(milliseconds: 300),

              onTap: (index){
                setState(() {
                  this.index=index;
                });

              },

            ),
            body: Container(
              child : pages[index],


            ),
          ),

      ),
    );
  }
}
