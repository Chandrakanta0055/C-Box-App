import 'package:flutter/material.dart';

import '../widgets/TextFiledHelper.dart';
import 'loginPages.dart';

class SignUpPages extends StatefulWidget {
  const SignUpPages({super.key});

  @override
  State<SignUpPages> createState() => _SignUpPagesState();
}

class _SignUpPagesState extends State<SignUpPages> {
  TextEditingController emailController=TextEditingController();
  TextEditingController passwordController=TextEditingController();
  TextEditingController userIdController =TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SignUp Page",style: (TextStyle(fontWeight: FontWeight.bold)),),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 70,),
            UiHelper.CustomTextFiled(userIdController, "User id", Icons.person, false),
            UiHelper.CustomTextFiled(emailController, "Email", Icons.email, false),
            UiHelper.CustomTextFiled(passwordController, "Password", Icons.password, true),
            SizedBox(height: 100,),
            UiHelper.CustomButton(() {
              // signup(emailController.text.toString(), passwordController.text.toString());
            }, "SignUp"),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Text("Already have an account ?"),
                TextButton(onPressed: (){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (contex)=>LoginPages()));
                }, child:Text("Login",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),))
              ],
            )

          ],

        ),
      ),
    );
  }
}
