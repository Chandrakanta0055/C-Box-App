import 'package:c_box/Modals/UserModel.dart';
import 'package:c_box/pages/loginPages.dart';
import 'package:c_box/pages/splashPage.dart';
import 'package:c_box/widgets/FirebaseHelper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'firebase_options.dart';
import 'pages/BottomNavigationBar.dart';
var uuid= Uuid();

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

   User? user= FirebaseAuth.instance.currentUser;

    if(user!= null)
      {
        UserModel? exitUser = await helper().getUserById(user!.uid.toString());
        if(exitUser!= null) {
          
          runApp(exitLogin(userModel: exitUser!));
        }

        else{
          runApp(login());
        }
      }
    else{
      runApp(login());

    }


}

class login extends StatelessWidget {
  const login({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:  LoginPages(),
    );
  }
}

class exitLogin extends StatelessWidget {
  final UserModel userModel;
  const exitLogin({super.key, required this.userModel});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      debugShowCheckedModeBanner: false,
      home: BottomNavBar(userModel: userModel,),
    );
  }
}





