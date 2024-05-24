
import 'dart:typed_data';

import 'package:c_box/Modals/UserModel.dart';
import 'package:c_box/widgets/FirebaseHelper.dart';
import 'package:c_box/widgets/helper2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CameraPage extends StatefulWidget {
  final UserModel userModel;
  const CameraPage({super.key, required this.userModel});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  Uint8List? _file;
  TextEditingController description=TextEditingController();

  void checkValue()
  {
    if(description.text.trim() == "")
      {
        print("plesed filed the description");

      }
    else{
      helper().UploadImageData(widget.userModel, _file!, description.text.trim());
      // Helper().uploadImageData(widget.userModel, _file!, description.text.trim());
      setState(() {
        _file= null;
      });
    }
  }
  void ShowOption()
  {
    showDialog(context: context, builder: (contex){
      return AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text("Gallery"),
              leading: Icon(Icons.browse_gallery),
              onTap: () async{
                Navigator.pop(context);
                Uint8List file= await helper().PickImage(ImageSource.gallery);
                setState(() {
                  _file=file;
                });

              },
            ),

            ListTile(
              title: Text("Camera"),
              leading: Icon(Icons.camera_alt),
              onTap: () async{
                Navigator.pop(context);
                Uint8List file= await helper().PickImage(ImageSource.camera);
              },
            )
            ,
            ListTile(
              title: Text("Cancle"),
              leading: Icon(Icons.cancel),
              onTap: (){
                Navigator.pop(contex);
              },
            )
          ],
        ),

      );
    },);
  }
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      body: Center(
         child:  (_file!= null)?
       SingleChildScrollView(
         child: Container(
         
           child: Column(
         
             children: [
               Container(
                 height: MediaQuery.of(context).size.height *0.6,
                 decoration: BoxDecoration(
                   image: DecorationImage(
                     image: MemoryImage(_file!),
                     fit: BoxFit.cover
                   )
                 ),
         
               ),
               SizedBox(height: 10,),
         
               Padding(
                 padding: const EdgeInsets.all(15.0),
                 child: TextField(
                   controller: description,
                   maxLines: null,
                   decoration: InputDecoration(
                     hintText: "description....",
                     border: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(5)
                     )
                   ),
         
                 ),
               ),
               Card(
                 child: CupertinoButton(
                   
                     child: Text("Upload"), onPressed: (){

                   checkValue();
                          
                 }),
               )
               ,
               SizedBox(height: 50,)
         
         
             ],
         
           ),
         ),
       )
             : Container(
           child: InkWell(
               onTap: (){
                 ShowOption();
               },
               child: Card(
                   child: SizedBox(
                     height: 80,
                       width: 160,
                       child: Center(child: Text("Add Post",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)))))
         ),

      ),

    );
  }
}
