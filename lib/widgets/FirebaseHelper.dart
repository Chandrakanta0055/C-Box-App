
import 'dart:developer';
import 'dart:typed_data';

import 'package:c_box/Modals/UserModel.dart';
import 'package:c_box/Modals/imageModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class helper{

  FirebaseAuth _auth= FirebaseAuth.instance;
  FirebaseStorage _storage= FirebaseStorage.instance;
  FirebaseFirestore _firestore= FirebaseFirestore.instance;


  // upload data into firebase firestore

  void UploadImageData(UserModel userModel,Uint8List file,String discription) async
  {

    String? uid=  userModel.uid;
    String? userName= userModel.userName;

    try {
      var allDocs = await _firestore.collection("images").get();

      int len = allDocs.docs.length;

      String? imageUrl = await uploadImageToStorage(file, "image $len");
      ImageModel imageModel= ImageModel(userName: userName,uid: uid,id:"image $len",imageUrl: imageUrl,discription: discription,profilePic: "",likes: [],commentCount: 0,shareCount: 0);

      await FirebaseFirestore.instance.collection("images").doc("image $len").set(imageModel.toJson());
      print("sucessfully uploaded data");
    }
    catch(er)
    {
      log(er.toString());

    }
  }


  //upload image to storage
  Future<String?> uploadImageToStorage(Uint8List file,String id) async
  {
    Reference ref= _storage.ref().child("Images").child(id);

    UploadTask uploadTask =  ref.putData(file!);

    TaskSnapshot taskSnapshot= await uploadTask!;

    String downloadUrl = await taskSnapshot.ref.getDownloadURL();

    print("sucessfully uploaded");
    print(downloadUrl);
    return downloadUrl!;

  }





  PickImage(ImageSource source ) async
  {
    final ImagePicker _imagePicker= ImagePicker();

    XFile? _file= await _imagePicker.pickImage(source: source);

    if(_file!= null)
      {
        return await  _file.readAsBytes();
      }

    print("no Image selected");

  }


  Future<String?>  SignUp(String email,String userName,String password)async
  {
    String? res;
    UserCredential? userCredential;
      try
        {
         userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
         print("user created");


         if(userCredential!= null)
         {
           UserModel userModel= UserModel(email:  email, password: password,uid:  userCredential.user!.uid,userName: userName,followers: [],follow: []);

           await FirebaseFirestore.instance.collection("users").doc(userCredential.user!.uid.toString()).set(userModel.toMap());

           res = "sucessful signUp";
         }
        }
       on FirebaseAuthException  catch(er)
    {
      res= er.code.toString();
    }
    catch(er)
    {
      res= er.toString();
    }
    return res!;
  }

  Future<String?> FirebaseLogin(String email,String password)async

  {
    UserCredential? userCredential;
    String? res;

    try{
      userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      if(userCredential!= null) {
        print("sucessful login");

        res = "sucessful";
      }
    }
    on FirebaseAuthException catch(er)
    {

      print(er.code.toString());

      res= er.code.toString();
    }
    return res!;

  }

   Future<UserModel?> getUserById(String id) async
  {
    UserModel? userModel;

    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection("users").doc(id).get();
      if(snapshot.data() != null) {
        userModel = UserModel.fromMap(snapshot.data() as Map<String, dynamic>);
      }
    }
    catch(er)
    {
      print(er.toString());

    }

    return  userModel!;

  }

}