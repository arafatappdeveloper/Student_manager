import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:student_manager/Utils/model_text.dart';


class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  DateTime dateTime =DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Model_Text(text: 'Schedule', size: 17.sp),
        actions: [
          Icon(Icons.notifications_off,color: Colors.white,),
          SizedBox(
            width: 20.w,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
             Row(
               children: [
                 Model_Text(text: dateTime.day.toString(), size: 30.sp),
                 Column(
                   children: [
                     Model_Text(text: DateFormat('MMM').format(dateTime), size: 12.sp),
                     Model_Text(text: dateTime.year.toString(), size: 12.sp),
                   ],
                 )
               ],
             ),
            SizedBox(
              height: 15.h,
            ),
            StreamBuilder(
              stream: FirebaseFirestore.instance.collection('TodayClass').snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error loading data'));
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No class data available.'));
                } else {
                  // Get today's and tomorrow's date in 'yyyy-MM-dd' format
                  String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
                  String tomorrowDate = DateFormat('yyyy-MM-dd')
                      .format(DateTime.now().add(Duration(days: 1)));

                  // Filter today's classes
                  var todayClasses = snapshot.data!.docs.where((doc) {
                    String classDate = doc['Time'].split(' ')[0]; // Extract date part
                    return classDate == todayDate;
                  }).toList();

                  // Filter tomorrow's classes
                  var tomorrowClasses = snapshot.data!.docs.where((doc) {
                    String classDate = doc['Time'].split(' ')[0]; // Extract date part
                    return classDate == tomorrowDate;
                  }).toList();

                  return Expanded(
                    child: ListView(
                      children: [
                        // 🔹 Section for Today's Classes
                        if (todayClasses.isNotEmpty) ...[
                          Model_Text(text: "Today's Classes", size: 20.sp,),
                          SizedBox(height: 10.h),
                          _buildClassList(todayClasses),
                        ] else
                          Center(child: Text('No classes scheduled for today.')),

                        SizedBox(height: 20.h), // Space between sections

                        // 🔹 Section for Tomorrow's Classes
                        if (tomorrowClasses.isNotEmpty) ...[
                          Model_Text(text: "Tomorrow's Classes", size: 20.sp,),
                          SizedBox(height: 10.h),
                          _buildClassList(tomorrowClasses),
                        ] else
                          Center(child: Text('No classes scheduled for tomorrow.')),
                      ],
                    ),
                  );
                }
              },
            ),



          ],
        ),
      ),

    );
  }
  Widget _buildClassList(List<QueryDocumentSnapshot> classList) {
    return Column(
      children: classList.map((scheduleData) {
        DateTime time = DateTime.parse(scheduleData['Time']);
        String formattedTime =
            "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";

        return Row(
          children: [
            Model_Text(text: formattedTime, size: 17.sp),
            SizedBox(width: 30.w),
            Column(
              children: [
                Container(
                  height: 170,
                  width: 250,
                  decoration: BoxDecoration(
                    color: Colors.greenAccent,
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: Colors.blue),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        title: Model_Text(text: scheduleData['Course'], size: 18.sp),
                        subtitle: Model_Text(text: 'Class No : ${scheduleData['Class']}', size: 18.sp),
                      ),
                      ListTile(
                        subtitle: Model_Text(text: scheduleData['Instructor'].toString(), size: 18.sp),
                        trailing: Icon(Icons.circle_notifications_rounded),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15.h),
              ],
            ),
          ],
        );
      }).toList(),
    );
  }

}
