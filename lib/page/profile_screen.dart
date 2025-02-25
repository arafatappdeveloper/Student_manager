import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final DatabaseReference _databaseRef =
  FirebaseDatabase.instance.ref().child('userdata');

  Map<String, dynamic>? userData; // To store fetched user data
  bool isLoading = true; // To track loading state

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  // 🔹 Fetch user data from Firebase
  void fetchUserData() {
    _databaseRef.child('dshR8KoKMick7CJ7b40RROOsFAZ2').once().then((snapshot) {
      if (snapshot.snapshot.value != null) {
        setState(() {
          userData = Map<String, dynamic>.from(
              snapshot.snapshot.value as Map<dynamic, dynamic>);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    }).catchError((error) {
      print("Error fetching data: $error");
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          leading: Icon(Icons.person),
          title: userData != null
              ? ListTile(
            title: Text(userData?['username'] ?? 'Unknown'),
            subtitle: Text(userData?['deptname'] ?? 'Unknown Department'),
          )
              : ListTile(
            title: Text('Loading...'),
            subtitle: Text('Fetching data'),
          ),
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator()) // 🔄 Show loading
            : userData == null
            ? Center(child: Text("No user data found")) // ❌ No data case
            : SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                // 🔹 Basic Info Section
                Container(
                  height: 100.h,
                  decoration: BoxDecoration(
                      color: Colors.white10,
                      border: Border.all(color: Colors.blue),
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Email: ${userData?['email']}'),
                            Text('Year: ${userData?['year']}'),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                          //  Text('Dept: ${userData?['deptname']}'),
                            Text('Status: Active'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 15.h),

                // 🔹 Statistics Section
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white10,
                      border: Border.all(color: Colors.blue),
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      ListTile(
                        title: Text('Statistics'),
                        subtitle: Text('24 Feb 2025'),
                        trailing: ElevatedButton(
                            onPressed: () {},
                            child: Text('Mark Complete')),
                      ),
                      ListTile(
                        title: Text('Attendance'),
                        subtitle: Text('90%'),
                        leading: Icon(Icons.co_present),
                      ),
                      ListTile(
                        title: Text('Task & Work'),
                        subtitle: Text('70%'),
                        leading: Icon(Icons.task_alt),
                      ),
                      ListTile(
                        title: Text('Quiz'),
                        subtitle: Text('85%'),
                        leading: Icon(Icons.quiz_outlined),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15.h),

                // 🔹 Settings Section
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white10,
                      border: Border.all(color: Colors.blue),
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      ListTile(
                        title: Text('Settings'),
                        leading: Icon(Icons.settings),
                        trailing: Icon(Icons.arrow_forward_ios),
                      ),
                      ListTile(
                        title: Text('Achievements'),
                        leading: Icon(Icons.archive_sharp),
                        trailing: Icon(Icons.arrow_forward_ios),
                      ),
                      ListTile(
                        title: Text('Privacy'),
                        leading: Icon(Icons.privacy_tip_outlined),
                        trailing: Icon(Icons.arrow_forward_ios),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
