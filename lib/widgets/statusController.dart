import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import '../Modals/StatusModel.dart';
import '../Modals/UserModel.dart';


Future<List<StatusModel>> getStatusData(UserModel userModel) async {
  List<StatusModel> status = await getStatus(userModel: userModel);
  print("future status excute");
  print(status);
  return status;
}

Future<List<StatusModel>> getStatus({required UserModel userModel}) async {
  List<StatusModel> statusData = [];
  try {
    List<String> follow = userModel.follow?.map((e) => e.toString()).toList() ?? [];
    print("total followers: $follow");

    for (int i = 0; i < follow.length; i++) {
      var statusSnapshot = await FirebaseFirestore.instance
          .collection("status")
          .where("uid", isEqualTo: follow[i])
          .where("createAt", isGreaterThan: Timestamp.fromDate(DateTime.now().subtract(const Duration(hours: 24))))
          .get();

      // for (var tempData in statusSnapshot.docs) {
      var tempData= statusSnapshot.docs[0];
        print("temp data$tempData");
        StatusModel tempStatus = StatusModel.fromMap(tempData.data() as Map<String, dynamic>);
        // if (tempStatus.whoCanSee.contains(userModel.uid)) {
          print(tempStatus);
          statusData.add(tempStatus);
          print("Added status for user ${userModel.uid}");
        // }
      // }
    }
    print("Data added successfully");
  } catch (er) {
    print("Error fetching status data: ${er.toString()}");
  }

  print("status return successfully");
  return statusData;
}


Future<String> uploadStatus({required UserModel userMode, required Uint8List file}) async {
  try {
    String statusId = Uuid().v1();
    String? url = await getDownloadUrl(file, statusId);
    if (url == null) {
      return 'Failed to upload image';
    }

    List<String> whoCanSee = userMode.followers?.map((e) => e.toString()).toList() ?? [];
    List<String> statusImageUrl = [];

    QuerySnapshot qsnapshot = await FirebaseFirestore.instance
        .collection("status")
        .where("uid", isEqualTo: userMode.uid)
        .get();

    if (qsnapshot.docs.isNotEmpty) {
      DocumentSnapshot documentSnapshot = qsnapshot.docs[0];
      Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
      StatusModel statusModel = StatusModel.fromMap(data);
      statusImageUrl = List<String>.from(statusModel.photoUrl);

      statusImageUrl.add(url);
      await FirebaseFirestore.instance.collection("status").doc(documentSnapshot.id).update({"photoUrl": statusImageUrl});

      print("update successfully");
      return "success";
    } else {
      statusImageUrl = [url];
    }

    StatusModel statusModel = StatusModel(
      uid: userMode.uid!,
      userName: userMode.userName!,
      statusId: statusId,
      profilePic: "", // Provide profilePic value
      photoUrl: statusImageUrl,
      createAt: DateTime.now(),
      whoCanSee: whoCanSee,
    );

    await FirebaseFirestore.instance.collection("status").doc(statusId).set(statusModel.toMap());

    return "success";
  } catch (er) {
    print(er);
    return er.toString();
  }
}

Future<String?> getDownloadUrl(Uint8List file, String statusId) async {
  try {
    Reference storageReference = FirebaseStorage.instance.ref().child("status/$statusId");
    UploadTask uploadTask = storageReference.putData(file);
    TaskSnapshot snapshot = await uploadTask;

    String url = await snapshot.ref.getDownloadURL();

    print("image uploaded successfully");
    return url;
  } catch (er) {
    print("error: ${er.toString()}");
    return null;
  }
}
