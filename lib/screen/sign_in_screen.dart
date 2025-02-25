import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:student_manager/page/bottom_page.dart';
import 'package:student_manager/screen/sign_up_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController email =TextEditingController();
  TextEditingController password =TextEditingController();
  FirebaseAuth _firebaseAuth=FirebaseAuth.instance;
  final _formKey= GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Sign In Screen'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child:  Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              TextFormField(

                controller: email,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)
                    )
                ),
                validator: (value){
                  if(value!.isEmpty){
                    return 'Enter Email ';
                  }
                },
              ),
              SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: password,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)
                    )
                ),
                validator: (value){
                  if(value!.isEmpty){
                    return 'Enter Password ';
                  }
                },
              ),

              SizedBox(
                height: 60,
              ),
              ElevatedButton(
                  onPressed: (){
                    if(_formKey.currentState!.validate()){
                      _firebaseAuth.signInWithEmailAndPassword(
                          email: email.text,
                          password: password.text);
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>BottomPage()));
                    }else{
                      'Incorrect ';
                    }

                  },
                  child: Text('Sign In ')),

              ElevatedButton(
                  onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>SignUpScreen()));
                  },
                  child: Text('Go to sign Up page ')),


            ],
          ),
        ),
      ),
    );
  }
}
