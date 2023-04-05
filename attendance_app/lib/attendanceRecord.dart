import 'package:flutter/foundation.dart';

class AttendanceRecord {
  String user;
  DateTime checkIn;
  String phone;

  AttendanceRecord({
    required this.user,
    required this.phone,
    required this.checkIn,
  });
}