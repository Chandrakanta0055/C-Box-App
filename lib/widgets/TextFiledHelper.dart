// import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UiHelper{

  //create for text field
  static CustomTextFiled(TextEditingController controller,String text, IconData iconData,bool Tohide)

  {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
      child: Card(
        elevation: 5
        ,
        child: TextField(

          controller: controller,//set the controller
          obscureText: Tohide,// hide the password data
          decoration: InputDecoration(// set decotation
            hintText: text,// set the hint text
            suffixIcon:Icon(iconData) ,// set the icon
            border: OutlineInputBorder(// set th radious
              borderRadius: BorderRadius.circular(10)
            )
          ),

        ),
      ),
    );

  }

  static CustomButton(VoidCallback voidCallback,String text)
  {
    return SizedBox(height: 50,width: 200,child: ElevatedButton(
      onPressed: (){
        voidCallback();
      },

      style: ElevatedButton.styleFrom(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Text(text,style: TextStyle(fontSize: 20),),
    ),);
  }

  static CustomAlatBox(BuildContext context,String text)

  {
    return showDialog(context: context, builder: (BuildContext contex){
      return AlertDialog(
        title: Text(text),
        actions: [//add ok button
          TextButton(onPressed: (){
            Navigator.pop(context);
          }, child: Text("ok"))
        ],
      );

    });


  }


}