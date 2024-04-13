import 'dart:async';

import 'package:c_box/pages/loginPages.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   Timer(Duration(seconds: 3),(){
     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginPages()));
   });
  }
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: CupertinoColors.white
      ),
      child: Center(
        child: Container(
          width: 300,
          height: 300,

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  image:  DecorationImage(
                    image: AssetImage("assets/C_Box_Image.png",),

                  )
                    ,
                  color: CupertinoColors.white
                ),
              ),
              // Text("C-Box",
              //   style: TextStyle(
              //     color: CupertinoColors.black,
              //     backgroundColor: Colors.white,
              //
              //
              //   ),
              // ),
            ],
          ),
        ),
      ),

    );
  }
}
