import 'package:c_box/Modals/UserModel.dart';
import 'package:c_box/widgets/statusController.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Statuspage extends StatefulWidget {
   final Uint8List file;
    final UserModel userModel;
  const Statuspage({super.key, required this.file, required this.userModel});

  @override
  State<Statuspage> createState() => _StatuspageState();
}

class _StatuspageState extends State<Statuspage> {


  void UploadImage() async
  {

    showDialog(context: context, builder: (context){
      return Center(child: CircularProgressIndicator());
    });

   String res= await  uploadStatus(userMode: widget.userModel!, file: widget.file);

   if(res =="success")
     {
       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Status Uploaded successfully")));

     }
   else{
     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res)));

   }
   Navigator.pop(context);
   Navigator.pop(context);

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          UploadImage();

        },
        child: CircleAvatar(
          child: Icon(Icons.check),
        ),
      ),
      body: Center(
        child: kIsWeb ? AspectRatio(
          aspectRatio: 9/16,
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: MemoryImage(widget.file),
                    fit: BoxFit.cover
                )
            ),

          ),
        ): CircularProgressIndicator(),
      ),
    );
  }
}
