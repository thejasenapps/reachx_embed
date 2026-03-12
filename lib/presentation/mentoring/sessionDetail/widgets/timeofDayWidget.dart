
import 'package:flutter/material.dart';
import 'package:time_range/time_range.dart';
import 'package:reachx_embed/presentation/mentoring/sessionDetail/sessionDetailViewModel.dart';

class TimeOfDayWidget extends StatefulWidget {
  final List<dynamic> timeInterval, selectedDays;
  final int minutes;
  final SessionDetailViewModel sessionDetailViewModel;

  const TimeOfDayWidget({
    super.key,
    required this.selectedDays,
    required this.timeInterval,
    required this.minutes,
    required this.sessionDetailViewModel,
  });

  @override
  State<TimeOfDayWidget> createState() => _TimeOfDayWidgetState();
}

class _TimeOfDayWidgetState extends State<TimeOfDayWidget> {
  List<TimeOfDay> time = [];
  String alertMessage = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      title: const Text("Schedule"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Time"),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TimeRange(
              timeBlock: widget.minutes,
              onRangeCompleted: (selectedRange) {
                if (!isValidTimeInterval(selectedRange!.start, selectedRange.end, widget.minutes)) {
                  setState(() {
                    alertMessage = "Please choose a time interval of ${widget.minutes} minutes.";
                  });
                } else {
                  setState(() {
                    time = [selectedRange.start, selectedRange.end];
                    alertMessage = ""; // Clear previous alert if any
                  });
                }
              },
              fromTitle: const Text("From:"),
              toTitle: const Text("To:"),
              firstTime: widget.sessionDetailViewModel.stringToTime(widget.timeInterval[0]),
              lastTime: widget.sessionDetailViewModel.stringToTime(widget.timeInterval[1]),
            ),
          ),
          if (alertMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                alertMessage,
                style: const TextStyle(color: Colors.red, fontSize: 14),
              ),
            ),
          const Text("Date"),
          ElevatedButton(
            onPressed: () {
              if (time.isEmpty || alertMessage.isNotEmpty) {
                setState(() {
                  alertMessage = "Please complete all fields before submitting.";
                });
              } else {
                // widget.sessionDetailViewModel.saveSchedule(time);
                Navigator.pop(context, "returned");
              }
            },
            child: const Text("Submit"),
          ),
        ],
      ),
    );
  }

  bool isValidTimeInterval(TimeOfDay start, TimeOfDay end, int expectedMinutes) {
    int startMinutes = start.hour * 60 + start.minute;
    int endMinutes = end.hour * 60 + end.minute;
    return (endMinutes - startMinutes) == expectedMinutes;
  }
}
