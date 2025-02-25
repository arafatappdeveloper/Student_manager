import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:student_manager/Utils/model_text.dart';
import 'package:student_manager/Utils/raised_button.dart';
import 'package:student_manager/Utils/textform_decoration.dart';
import 'package:student_manager/screen/sign_in_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController deptname = TextEditingController();
  TextEditingController year = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController retypepassword = TextEditingController();

  final DatabaseReference createaccountdata = FirebaseDatabase.instance.ref().child('userdata');
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: const Icon(Icons.arrow_back_ios_new_sharp),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Center(
                  child: Model_Text(text: 'Create Account ', size: 20.sp),
                ),
                SizedBox(height: 20.h),
                TextFormField(
                  controller: username,
                  decoration: ModifyTextField('Username', const Icon(Icons.person)),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter a valid username';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20.h),
                TextFormField(
                  controller: deptname,
                  decoration: ModifyTextField('Department Name', const Icon(Icons.person)),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter a valid Department Name ';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20.h),
                TextFormField(
                  controller: year,
                  decoration: ModifyTextField('Year', const Icon(Icons.calendar_today_rounded)),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter a valid Year';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20.h),
                TextFormField(
                  controller: email,
                  decoration: ModifyTextField('Email', const Icon(Icons.email)),
                  validator: (value) {
                    if (value == null || !value.contains('@')) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20.h),
                TextFormField(
                  controller: password,
                  decoration: ModifyTextField('Password', const Icon(Icons.password)),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20.h),
                TextFormField(
                  controller: retypepassword,
                  decoration: ModifyTextField('Retype Password', const Icon(Icons.password)),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value != password.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20.h),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
                          email: email.text.trim(),
                          password: password.text.trim(),
                        );
        
                        await createaccountdata.child(userCredential.user!.uid.toString()).set({
                          "username": username.text.trim(),
                          "email": email.text.trim(),
                          "deptname": deptname.text.trim(),
                          "year": year.text.trim(),
                          "password": password.text.trim(),

                        });
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => SignInScreen()),
                        );
                      } on FirebaseAuthException catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(e.message ?? 'An error occurred')),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(e.toString())),
                        );
                      }
                    }
        
                  },
                  child: const Text('Sign Up'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
