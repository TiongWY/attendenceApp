import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'attendanceRecord.dart';
import 'record_detail.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Attendance App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: OnboardingScreen(),
    );
  }
}

class OnboardingScreen extends StatelessWidget {
  final List<String> _pages = [
    "Welcome to Attendance App",
    "Keep track of your attendance easily",
    "View your attendance history anytime",
    "Let's get started!"
  ];
  final PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _pages.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/attendence.jpg',
                    width: 200.0,
                    height: 200.0,
                  ),
                  SizedBox(height: 32.0),
                  Text(
                    _pages[index],
                    style: TextStyle(fontSize: 24.0),
                    textAlign: TextAlign.center,
                  ),
                ],
              );
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => AttendancePage()),
                  );
                },
                child: Text(
                  "Get Started",
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AttendancePage extends StatefulWidget {
  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  final List<AttendanceRecord> records = [];
  final TextEditingController searchController = TextEditingController();
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  List<AttendanceRecord> filteredRecords = [];

  List<AttendanceRecord> _buildAttendanceList() {
    List<AttendanceRecord> filteredRecords = records.where((record) => record.user.toLowerCase().contains(searchController.text.toLowerCase())).toList();
    if (filteredRecords.isEmpty) {
      return records;
    }
    return filteredRecords;
  }

  void _addRecord() {
    String user = _userController.text;
    String phone = _phoneController.text;
    DateTime now = DateTime.now();
    AttendanceRecord record = AttendanceRecord(user: user, phone: phone, checkIn: now);
    setState(() {
      records.insert(0, record);
    });
    _userController.clear();
    _phoneController.clear();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Record added successfully."),
      duration: Duration(seconds: 2),
    ));
  }

  @override
  Widget build(BuildContext context) {
    records.sort((a, b) => b.checkIn.compareTo(a.checkIn));
    bool _showEndIndicator = false;
    return MaterialApp(
      title: 'Attendance App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Attendance Records'),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(48.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 1.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Search',
                        border: InputBorder.none,
                        icon: Icon(Icons.search),
                      ),
                      onChanged: (value) {
                        setState(() {
                          filteredRecords = records.where((record) => record.user.toLowerCase().contains(value.toLowerCase())).toList();
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: 8.0),
              ],
            ),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _userController,
                      decoration: InputDecoration(
                        labelText: "User",
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a value';
                        }
                        return null;
                      },
                    ),

                  ),
                  SizedBox(width: 16.0),
                  Expanded(
                    child: TextFormField(
                      controller: _phoneController,
                      decoration: InputDecoration(
                        labelText: "Phone",
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a value';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed:_userController.text.isEmpty || _phoneController.text.isEmpty? null : _addRecord,
              child: Text("Add Record"),
            ),
            Expanded(
              child: NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                    // show the end indicator
                    setState(() {
                      _showEndIndicator = true;
                    });
                  } else {
                    // hide the end indicator
                    setState(() {
                      _showEndIndicator = false;
                    });
                  }
                  return true;
                },
                child: ListView.builder(
                  itemCount: _buildAttendanceList().length,
                  itemBuilder: (BuildContext context, int index) {
                    String formattedTime = timeago.format(_buildAttendanceList()[index].checkIn);
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RecordDetailPage(record: _buildAttendanceList()[index])),
                        );
                      },
                      child: ListTile(
                        title: Text(_buildAttendanceList()[index].user),
                        subtitle: Text(formattedTime),
                        trailing: Text(_buildAttendanceList()[index].phone),
                      ),
                    );
                  },
                ),
              ),
            ),
            _showEndIndicator
                ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text("You have reached the end of the list."),
              ),
            )
                : SizedBox.shrink(),

          ],
        ),
      ),
    );
  }
}
