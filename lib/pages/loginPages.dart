import 'package:c_box/pages/BottomNavigationBar.dart';
import 'package:c_box/pages/SignUpPages.dart';
import 'package:c_box/widgets/FirebaseHelper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../Modals/UserModel.dart';
import '../widgets/TextFiledHelper.dart';

class LoginPages extends StatefulWidget {
  const LoginPages({super.key});

  @override
  State<LoginPages> createState() => _LoginPagesState();
}

class _LoginPagesState extends State<LoginPages> {
  TextEditingController emailController=TextEditingController();
  TextEditingController passwordController=TextEditingController();
  FocusNode passowrdNode= FocusNode();


  void Login() async
  {
    User? user= FirebaseAuth.instance.currentUser;
    String email= emailController.text.trim();
    String pass= passwordController.text.trim();
    if(email =="" || pass =="")
      {
        print("enter all the field");

      }
    else{
      String? res= await helper().FirebaseLogin(email, pass);

      if(res =="sucessful")
        {
          if(user!= null) {
            UserModel? newUser = await helper().getUserById(FirebaseAuth.instance.currentUser!.uid!.toString());
            print("sucessfully navigate");

            Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) => BottomNavBar(userModel: newUser!)));
          }
        }
      else
        {

        }

    }

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(

      appBar: AppBar(
        title: Text("Login Page",style: (TextStyle(fontWeight: FontWeight.bold)),),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [

            Container(
              margin: EdgeInsets.only(top: 30),
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(75),
                image: DecorationImage(
                  image: AssetImage("assets/C_Box_Image.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            SizedBox(height: 70,),

            Padding(

              padding: const EdgeInsets.symmetric(horizontal: 20,vertical:5 ),
              child: Card(
                elevation: 3,
                child: TextField(
                  onSubmitted: (val){
                    if(val!="")
                      {

                        passowrdNode.requestFocus();

                      }
                  },
                  autofocus: true,

                  controller: emailController,//set the controller
                  decoration: InputDecoration(// set decotation
                      hintText: "Enter your email",// set the hint text
                      suffixIcon:Icon(Icons.email) ,// set the icon
                      border: OutlineInputBorder(// set th radious
                          borderRadius: BorderRadius.circular(10)
                      )
                  ),

                ),
              ),
            ),

            // UiHelper.CustomTextFiled(emailController,"Enter your email",Icons.email, false),
            SizedBox(height: 20,),

      Padding(

        padding: const EdgeInsets.symmetric(horizontal: 20,vertical:5 ),
        child: Card(
          elevation: 3,
            child:TextField(
              focusNode:passowrdNode ,

              controller: passwordController,//set the controller
              decoration: InputDecoration(// set decotation
                  hintText: "Enter your password",// set the hint text
                  suffixIcon:Icon(Icons.password) ,// set the icon
                  border: OutlineInputBorder(// set th radious
                      borderRadius: BorderRadius.circular(10)
                  )
              ),

            ),
        ),
      ),



            // UiHelper.CustomTextFiled(passwordController, "Enter your Password", Icons.password, true),
            SizedBox(height: 60,),
            UiHelper.CustomButton(() {

              setState(() {
                Login();
              });

            }, "Login"),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Text("Create an account ?"),
                TextButton(onPressed: (){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SignUpPages()));
                }, child:Text("Sign up",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),))
              ],
            )

          ],
        ),
      ),
    );
  }
}
