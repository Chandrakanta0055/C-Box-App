import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:c_box/Modals/UserModel.dart';
import 'package:c_box/Modals/imageModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class Helper {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseStorage _storage = FirebaseStorage.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Upload data into Firebase Firestore
  void uploadImageData(UserModel userModel, Uint8List file, String description) async {
    String? uid = userModel.uid;
    String? userName = userModel.userName;

    try {
      var allDocs = await _firestore.collection("images").get();
      int len = allDocs.docs.length;

      String? imageUrl = await uploadImageToStorage(file, "image $len");
      if (imageUrl != null) {
        ImageModel imageModel = ImageModel(
          userName: userName,
          uid: uid,
          id: "image $len",
          imageUrl: imageUrl,
          discription: description,
          profilePic: "",
          likes: [],
          commentCount: 0,
          shareCount: 0,
        );

        await FirebaseFirestore.instance.collection("images").doc("image $len").set(imageModel.toJson());
        print("Successfully uploaded data");
      } else {
        print("Some error occurred");
      }
    } catch (er) {
      log(er.toString());
    }
  }

  Future<String?> uploadImageToStorage(Uint8List file, String id) async {
    try {
      // Create a temporary file in the device's temporary directory
      Directory tempDir = await getTemporaryDirectory();
      File tempFile = File('${tempDir.path}/temp_image.jpg');

      // Write the Uint8List to the file
      await tempFile.writeAsBytes(file);

      // Upload the file to Firebase Storage
      Reference storageReference = FirebaseStorage.instance.ref().child('images/$id');
      UploadTask uploadTask = storageReference.putFile(tempFile);
      TaskSnapshot snapshot = await uploadTask;

      // Get the download URL
      String downloadUrl = await snapshot.ref.getDownloadURL();
      print("Download URL: $downloadUrl"); // Log the download URL for debugging
      return downloadUrl;
    } catch (e) {
      print('Error uploading image to storage: $e');
      return null;
    }
  }

  // Pick an image from the specified source
  Future<Uint8List?> pickImage(ImageSource source) async {
    final ImagePicker _imagePicker = ImagePicker();
    XFile? _file = await _imagePicker.pickImage(source: source);

    if (_file != null) {
      return await _file.readAsBytes();
    }

    print("No image selected");
    return null;
  }

  // Sign up a new user
  Future<String?> signUp(String email, String userName, String password) async {
    String? res;
    UserCredential? userCredential;

    try {
      userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      print("User created");

      if (userCredential != null) {
        UserModel userModel = UserModel(
          email: email,
          password: password,
          uid: userCredential.user!.uid,
          userName: userName,
          followers: null,
          follow: null,
        );

        await FirebaseFirestore.instance.collection("users").doc(userCredential.user!.uid.toString()).set(userModel.toMap());

        res = "Successful sign up";
      }
    } on FirebaseAuthException catch (er) {
      res = er.code.toString();
    } catch (er) {
      res = er.toString();
    }
    return res;
  }

  // Firebase login
  Future<String?> firebaseLogin(String email, String password) async {
    UserCredential? userCredential;
    String? res;

    try {
      userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      if (userCredential != null) {
        print("Successful login");
        res = "Successful";
      }
    } on FirebaseAuthException catch (er) {
      print(er.code.toString());
      res = er.code.toString();
    }
    return res;
  }

  // Get user by ID
  Future<UserModel?> getUserById(String id) async {
    UserModel? userModel;

    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection("users").doc(id).get();
      if (snapshot.data() != null) {
        userModel = UserModel.fromUser(snapshot.data() as Map<String, dynamic>);
      }
    } catch (er) {
      print(er.toString());
    }

    return userModel;
  }
}
