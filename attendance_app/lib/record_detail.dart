import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'attendanceRecord.dart';
import 'package:flutter_share/flutter_share.dart';

class RecordDetailPage extends StatelessWidget {
  final AttendanceRecord record;

  RecordDetailPage({required this.record});

  Future<void> _shareRecord() async {
    String formattedTime = timeago.format(record.checkIn);
    String message =
        'User: ${record.user}\nPhone: ${record.phone}\nCheck-in time: $formattedTime';
    await FlutterShare.share(
        title: 'Attendance Record',
        text: message,
        chooserTitle: 'Share record with');
  }

  @override
  Widget build(BuildContext context) {
    String formattedTime = timeago.format(record.checkIn);

    return Scaffold(
      appBar: AppBar(
        title: Text('Record Detail'),
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: _shareRecord,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'User: ${record.user}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Phone: ${record.phone}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Check-in time: $formattedTime',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
