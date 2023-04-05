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
    "Welcome to WNG Attendance App",
    "Let's get started!"
  ];
  final PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
        image: DecorationImage(
        image: AssetImage("assets/background_Image.jpeg"),
    fit: BoxFit.cover,
    ),
    ),
    child:Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _pages.length,
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "We Need Go",
                      style: TextStyle(
                        fontSize: 34.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Helvetica", // replace with your desired font family
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Image.asset(
                      'assets/attendence.jpg',
                      width: 300.0,
                      height: 300.0,
                    ),
                    SizedBox(height: 32.0),
                    Text(
                      _pages[index],
                      style: TextStyle(fontSize: 24.0),
                      textAlign: TextAlign.center,
                    ),
                  ],
                );
              } else if (index == 1) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "We Need Go",
                      style: TextStyle(
                        fontSize: 34.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Helvetica", // replace with your desired font family
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Image.asset(
                      'assets/trackRecord.jpeg',
                      width: 300.0,
                      height: 300.0,
                    ),
                    SizedBox(height: 32.0),
                    Text(
                      _pages[index],
                      style: TextStyle(fontSize: 24.0),
                      textAlign: TextAlign.center,
                    ),
                  ],
                );
              } else {
                return Container(); // return an empty container for any other index
              }
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
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0), // Set a larger radius value here
                    ),
                  ),
                ),
                child: Text(
                  "Get Started",
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
            ),
          ),
        ],
      ),
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
