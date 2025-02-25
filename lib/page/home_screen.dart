import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:student_manager/Utils/button_container.dart';
import 'package:student_manager/Utils/container.dart';
import 'package:student_manager/Utils/model_text.dart';
import 'package:student_manager/page/shedule_page.dart';

import '../Utils/date_formate.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> _initializeNotifications() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }


  Future<void>showNotifications(String title ,String body)async{
    const AndroidNotificationDetails androidDetails =
    AndroidNotificationDetails('class_channel', 'Class Notifications',
        importance: Importance.high, priority: Priority.high);

    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
        0, title, body, notificationDetails);
  }
  bool isNewsSelected = true;
  DateTime dateTime =DateTime.now();
  final firebaseFirestore =  FirebaseFirestore.instance.collection('TodayClass').snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: const Text('Home'),
      ),
      body: Padding(
        padding:  EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(height: 100.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Model_Text(text: 'Today\'s Class', size: 16.sp),
                GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>SchedulePage()));
                  },
                    child: Model_Text(text: 'Open Schedule', size: 16.sp)),
              ],
            ),
            SizedBox(
              height: 10.h,
            ),
            StreamBuilder(
              stream: FirebaseFirestore.instance.collection('TodayClass').snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: Model_Text(text: 'Check your Internet', size: 12.sp));
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error loading data'));
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No classes scheduled.'));
                } else {
                  int currentHour = DateTime.now().hour;
                  print('Current hour: $currentHour');
                  bool hasClass = false;
                  Map<String, dynamic>? classData;

                  for (var doc in snapshot.data!.docs) {
                    var data = doc.data() as Map<String, dynamic>;

                    if (data.containsKey('Time') && data['Time'] != null) {
                      String timeString = data['Time'].toString().trim(); // Ensure it's a string

                      // Check if it has the expected format
                      List<String> parts = timeString.split(' ');
                      if (parts.length > 1) {
                        List<String> timeParts = parts[1].split(':');

                        if (timeParts.isNotEmpty) {
                          int classHour = int.tryParse(timeParts[0]) ?? -1;
                          print("Extracted class hour: $classHour");

                          if (classHour == currentHour) {
                            hasClass = true;
                            classData = data;
                            showNotifications("Upcoming Class Alert",
                              "Your ${classData['Course']} class is happening now with ${classData['Instructor']}",);
                            break;
                          }
                        } else {
                          print("Invalid time format: Missing ':' in $timeString");

                        }
                      } else {
                        print("Invalid time format: Missing ' ' in $timeString");
                      }
                    }

                  }

                  if (hasClass) {
                    return CostomizeContainer(
                      100.h,
                      Colors.blue,
                      classData?['Instructor'] ?? 'Unknown',
                      classData?['time'] ?? 'No Time',
                      classData?['Class'].toString() ?? 'No Day',
                      classData?['Course'] ?? 'Unknown Subject',
                      15,
                    );
                  } else {
                    return Center(child: Text("No class at this hour."));
                  }
                }
              },
            ),



        SizedBox(
              height: 25.h,
            ),

            // Row for News & Event Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // News Button
                InkWell(
                  onTap: () {
                    setState(() {
                      isNewsSelected = true; // Select News
                    });
                  },
                  child:ButtomContainer(
                    height: 40.h,
                    width: 90.w,
                    backgroundColor: Colors.blue,
                    borderColor: Colors.blue,
                    text: 'News',
                    textSize: 16,
                    isSelected: isNewsSelected,
                  )
                ),

                SizedBox(width: 15),

                // Event Button
                InkWell(
                  onTap: () {
                    setState(() {
                      isNewsSelected = false; // Select Event
                    });
                  },
                  child: ButtomContainer(
                      height: 40.h,
                      width: 90.w,
                      backgroundColor: Colors.blue,
                      borderColor: Colors.blue,
                      text: 'Event',
                      textSize: 16,
                    isSelected: !isNewsSelected,
                  )
                ),
              ],
            ),


            // Show Data based on selection
            Expanded(
              child: isNewsSelected ? _buildNewsData() : _buildEventData(),
            ),
          ],
        ),
      ),
    );
  }

  // Widget for News Data
  Widget _buildNewsData() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
       children: [
         StreamBuilder(
             stream: FirebaseFirestore.instance.collection('News').orderBy('date',descending: true).snapshots(),
             builder: (context,AsyncSnapshot<QuerySnapshot>snapshot){
               if(snapshot.connectionState == ConnectionState.waiting){
               return Center(child: CircularProgressIndicator(),);
               }else if(snapshot.hasError){
                 return Center(child: Text('Something went wrong!'));
               }else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                 return Center(child: Text('No news available.'));
               }else{
                 return Expanded(
                     child: ListView.builder(
                       itemCount: snapshot.data!.docs.length,
                         itemBuilder: (context,index){
                           var newsData = snapshot.data!.docs[index];
                           return  Card(
                             elevation: 3,
                             child: Padding(
                               padding: const EdgeInsets.all(8.0),
                               child: Column(
                                 children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(child: Model_Text(text: newsData['title'].toString(), size: 17)),
                                      Container(
                                        height: 40.h,
                                        width: 120.w,
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius: BorderRadius.circular(10.r)
                                        ),
                                        child: Center(
                                            child: Text(formatTimestamp(snapshot.data!.docs[index]))),
                                      ),
                                    ],
                                  ),

                                   ListTile(

                                        subtitle: Text(newsData['desc'].toString()),
                                        // trailing:Text(formatTimestamp(snapshot.data!.docs[index])),
                                        ),
                                 ],
                               ),
                             ),
                           );
                         }));
               }
             })
       ],
      ),
    );
  }

  // Widget for Event Data
  Widget _buildEventData() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Model_Text(text: '🎉 Upcoming Events', size: 18),
          SizedBox(height: 10),
          Model_Text(text: '• Science Fair - March 10', size: 16),
          Model_Text(text: '• Art Competition - March 15', size: 16),
          Model_Text(text: '• Cultural Fest - March 20', size: 16),
        ],
      ),
    );
  }



}
