import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateAndTimeConvertors {
  // Converts a given date and time to UTC format
  String toUTC(String date, TimeOfDay time) {
    DateTime parsedDate = DateTime.parse(date);
    int hour = time.hour;
    int minutes = time.minute; // Fixed incorrect index

    DateTime combinedDateTime = DateTime(
        parsedDate.year,
        parsedDate.month,
        parsedDate.day,
        hour,
        minutes
    );

    return combinedDateTime.toUtc().toIso8601String();
  }

  // Converts a UTC timestamp to local date and time
  Map<String, String> fromUTC(String utc) {
    DateTime utcTime = DateTime.parse(utc).toUtc();
    DateTime localTime = utcTime.toLocal();

    return {
      "date": DateFormat('yyyy-MM-dd').format(localTime),
      "time": DateFormat('HH:mm').format(localTime)
    };
  }

  // Returns the weekday name for a given date
  String getWeekday(String dateString) {
    DateTime date = DateTime.parse(dateString);
    DateTime now = DateTime.now();

    DateTime dateOnly = DateTime(date.year, date.month, date.day);
    DateTime nowOnly = DateTime(now.year, now.month, now.day);

    int diff = dateOnly.difference(nowOnly).inDays;

    if(diff == 0) {
      return "Today";
    } else if(diff == 1) {
      return "Tomorrow";
    } else if(diff <= 7) {
      return "In ${diff + 1} days";
    }
    return dateString;
  }

  // Adds minutes to a given time and returns the updated time
  String addMinutesToTime(String time, int minutesToAdd) {
    List<String> timeParts = time.split(":");

    int hour = int.parse(timeParts[0]);
    int minutes = int.parse(timeParts[1]); // Fixed incorrect index

    DateTime dateTime = DateTime(2025, 1, 1, hour, minutes)
        .add(Duration(minutes: minutesToAdd));

    final String period = dateTime.hour >= 12 ? "PM" : "AM";
    final int formattedHour = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12;

    final String formattedMinute = dateTime.minute.toString().padLeft(2, '0');


    return "$formattedHour:$formattedMinute $period";
  }

  String formatTimeOfDay(var time) {
    int? hour;
    int? minute;
    if(time is String) {
      try {
        if(RegExp(r'^\d{2}:\d{2}$').hasMatch(time)) {
          final parts = time.split(":");
          hour = int.parse(parts[0]);
          minute = int.parse(parts[1]);
        } else {
          DateTime utcTime = DateTime.parse(time).toUtc();
          DateTime localTime = utcTime.toLocal();
          hour = localTime.hour;
          minute = localTime.minute;
        }
      } catch(e) {
        return "Invalid time";
      }
    } else if( time is TimeOfDay || time is DateTime){
      hour = time.hour;
      minute = time.minute;
    } else {
      return "Unsupported time format";
    }

    final String period = hour! >= 12 ? "PM" : "AM";
    final int formattedHour = hour % 12 == 0 ? 12 : hour % 12;

    final String formattedMinute = minute.toString().padLeft(2, '0');

    return "$formattedHour:$formattedMinute $period";
  }

  String formatDate(String date) {
    List<String> parts = date.split(" ");
    DateTime parsedDate = DateTime.parse(parts[0]);
    String formattedDate = DateFormat("dd MMMM yyyy").format(parsedDate);

    return formattedDate;
  }

  bool compareUtc(String utc) {
    DateTime utcTime = DateTime.parse(utc).toUtc();
    return utcTime.isBefore(DateTime.now());
  }


  bool compareUtcBy1Hour(String utc) {
    DateTime utcTime = DateTime.parse(utc).toUtc();
    return utcTime.isBefore(DateTime.now().subtract(const Duration(minutes: 60)));
  }


  String getDayFromDate(String dateString) {
    try {
      // Parse the input date string (expected format: 'yyyy-MM-dd')
      DateTime date = DateTime.parse(dateString);

      List<String> days = [
        'Mon',
        'Tue',
        'Wed',
        'Thu',
        'Fri',
        'Sat',
        'Sun'
      ];

      // Get the day of the week (1 for Monday, 7 for Sunday)
      int dayIndex = date.weekday;

      // Return the day name
      return days[dayIndex - 1];
    } catch (e) {
      // Handle invalid date format
      return 'Invalid date format';
    }
  }
}
