import 'package:flutter/material.dart';
import 'package:reachx_embed/assets/fonts/iconsax_icons.dart';
import 'package:reachx_embed/core/constants/color.dart';
import 'package:reachx_embed/core/constants/rescheduleStatus.dart';
import 'package:reachx_embed/core/helper/dateAndTimeConvertors.dart';
import 'package:reachx_embed/core/helper/hexColor.dart';
import 'package:reachx_embed/domain/entities/bookingEntity.dart';
import 'package:reachx_embed/presentation/mentoring/meetingSetup/meetingSetupViewModel.dart';
import 'package:reachx_embed/presentation/mentoring/sessionDetail/sessionDetailViewModel.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class Customcalendar extends StatefulWidget {

  CalendarDataSource calendarDataSource;
  SessionDetailViewModel? sessionDetailViewModel;
  MeetingSetupViewModel? meetingSetupViewModel;
  String? bookingUniqueId;
  BookingEntity? booking;

  Customcalendar({super.key, required this.calendarDataSource, this.sessionDetailViewModel, this.meetingSetupViewModel, this.bookingUniqueId, this.booking});

  @override
  State<Customcalendar> createState() => _CustomcalendarState();
}

class _CustomcalendarState extends State<Customcalendar> {


  late final CalendarController _calendarController;

  @override
  void initState() {
    super.initState();

    _calendarController = CalendarController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }


  final DateAndTimeConvertors _dateAndTimeConvertors = DateAndTimeConvertors();

  List<dynamic> selectedAppointments = []; // List to store selected appointments
  Appointment? selectedAppointment;


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 300,
          child: SfCalendar(
            controller: _calendarController,
            view: CalendarView.month,
            dataSource: widget.calendarDataSource,
            backgroundColor: Colors.white,
            minDate: DateTime.now(),
            maxDate: DateTime.now().add(const Duration(days: 60)),
            headerStyle: CalendarHeaderStyle(
              textStyle: const TextStyle(
                color: Colors.white
              ),
              backgroundColor: HexColor(lightBlue),
            ),
            selectionDecoration: BoxDecoration(
              color: HexColor(lightBlue).withOpacity(0.3),
              shape: BoxShape.circle
            ),
            // blackoutDates: _getBlackListedDays(),
            monthViewSettings:  const MonthViewSettings(
              appointmentDisplayMode: MonthAppointmentDisplayMode.indicator,
            ),
            // On tap, update the list of selected appointments
            onTap: (CalendarTapDetails details) {
              setState(() {
                selectedAppointments = details.appointments!;
              });
            },
          ),
        ),
        const SizedBox(height: 10,),
        selectedAppointments.isEmpty
            ? const Text(
          "No available slots for this date",
          style:  TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        )
            : Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: selectedAppointments.length,
                itemBuilder: (context, index) {
                  Appointment appointment = selectedAppointments[index];
                  TimeOfDay startTime = TimeOfDay(hour: appointment.startTime.hour, minute: appointment.startTime.minute);
                  TimeOfDay endTime = TimeOfDay(hour: appointment.endTime.hour, minute: appointment.endTime.minute);

                  return GestureDetector(
                    onTap: () async {

                      // Handle tap event based on the available view models
                      if(widget.meetingSetupViewModel != null) {
                        widget.meetingSetupViewModel!.rescheduleConfirmation(appointment.startTime, widget.booking!, RescheduleStatus.closed);
                        Navigator.pop(context, "returned");
                      } else if(widget.sessionDetailViewModel != null) {
                        setState(() {
                          if(selectedAppointment == appointment) {
                            selectedAppointment = null;
                            widget.sessionDetailViewModel!.onCleared();
                          } else {
                            selectedAppointment = appointment;
                            widget.sessionDetailViewModel!.onTapped(appointment.startTime.toString(), appointment.startTime, appointment.endTime);
                          }
                        });
                      }
                    },
                    child: Card(
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      color: selectedAppointment == appointment ? Colors.blue[100] : Colors.white,
                      child: ListTile(
                        leading:  const Icon(Iconsax.clock, color: Colors.blue),
                        title: Text(
                          "${_dateAndTimeConvertors.formatTimeOfDay(startTime)} - ${_dateAndTimeConvertors.formatTimeOfDay(endTime)}",
                          style: const TextStyle(fontSize: 15),
                        ),
                        subtitle: const Text("Duration: 1 hour"),
                      ),
                    ),
                  );
                }
            )
        )
      ],
    );
  }
}
