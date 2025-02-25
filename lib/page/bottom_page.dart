import 'package:flutter/material.dart';
import 'package:student_manager/page/home_screen.dart';
import 'package:student_manager/page/profile_screen.dart';
import 'package:student_manager/page/shedule_page.dart';

class BottomPage extends StatefulWidget {
  const BottomPage({super.key});

  @override
  State<BottomPage> createState() => _BottomPageState();
}

class _BottomPageState extends State<BottomPage> {
  List _widgetList =[
   HomeScreen(),
    Text('Page 2'),
    Text('Page 3'),
    SchedulePage(),
    ProfileScreen(),
  ];
  int _currentIndex=0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(child:_widgetList.elementAt(_currentIndex)),
      bottomNavigationBar: BottomNavigationBar(

        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.orange,
        currentIndex: _currentIndex,
        onTap: (int index){
          setState(() {
            _currentIndex=index;
          });
        },
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home),label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.folder_copy_rounded),label: 'Course'),
            BottomNavigationBarItem(icon: Icon(Icons.reply_sharp),label: 'Result'),
            BottomNavigationBarItem(icon: Icon(Icons.edit_calendar_sharp),label: 'Shedule'),
            BottomNavigationBarItem(icon: Icon(Icons.person),label: 'Profile'),
          ]),
    );
  }
}
