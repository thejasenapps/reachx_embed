import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reachx_embed/core/helper/dateAndTimeConvertors.dart';
import 'package:reachx_embed/core/injections.dart';
import 'package:reachx_embed/data/data_source/remote/firebase/firebaseAuthentication.dart';
import 'package:reachx_embed/presentation/mentoring/booked/bookedViewModel.dart';
import 'package:reachx_embed/presentation/mentoring/booked/widgets/bookingsWidget.dart';
import 'package:reachx_embed/presentation/mentoring/booked/widgets/customLoginAlertWidget.dart';
import 'package:reachx_embed/presentation/mentoring/meetingSetup/meetingSetupViewModel.dart';
import 'package:reachx_embed/presentation/mentoring/booking/bookingViewModel.dart';
import 'package:reachx_embed/presentation/mentoring/signUp/signUpViewModel.dart';
import 'package:reachx_embed/presentation/mentoring/profile/profileViewModel.dart';
import 'package:skeletonizer/skeletonizer.dart';



class BookedListWidget extends StatefulWidget {

  // ViewModel instance for managing booking data
  final BookedViewModel bookedViewModel;
  final  String type;

  const BookedListWidget({super.key, required this.bookedViewModel, required this.type});

  @override
  State<BookedListWidget> createState() => _BookedListWidgetState();
}

class _BookedListWidgetState extends State<BookedListWidget> {

  BookingViewModel bookingViewModel = getIt();
  SignUpViewModel signUpViewModel = getIt();
  ProfileViewModel profileViewModel = getIt();
  MeetingSetupViewModel meetingSetupViewModel = getIt();

  final DateAndTimeConvertors _dateAndTimeConvertors = DateAndTimeConvertors();

  bool isExpert = false;
  String bookingName = '';

  @override
  void initState() {
    super.initState();

    ever(bookingViewModel.isConfirmed, (bool isSaved) {
      if(mounted) {
        widget.bookedViewModel.getSessionsBookings();
      }
    });


    ever(profileViewModel.result, (bool isSaved) {
      if(mounted) {
        widget.bookedViewModel.getSessionsBookings();
      }
    });

    ever(meetingSetupViewModel.passingDeleteIds, (List<String> uniqueIds) {
      if(mounted) {
        setState(() {
          for (var id in uniqueIds) {
            widget.bookedViewModel.combinedEntity!.removeWhere((a) => a.bookingUniqueId == id);
          }
        });
        widget.bookedViewModel.addLatestBookings(widget.bookedViewModel.combinedEntity!);
      }
    });

    getId();
  }

  void getId() async {
    widget.bookedViewModel.userId = await FirebaseAuthentication().getFirebaseUid();
  }


  @override
  Widget build(BuildContext context) {

    RxBool loader = widget.bookedViewModel.isLoading;

    return Obx(() {
      return Skeletonizer(
          enabled: loader.value,
          child: widget.bookedViewModel.userId == null
              ? const CustomLoginAlertWidget()
              : widget.bookedViewModel.combinedEntity!.isNotEmpty
              ? BookingsWidget(
              bookingsList: widget.bookedViewModel.combinedEntity!,
              bookedViewModel: widget.bookedViewModel
          )
              : const Center(
            child: Text(
                "No Bookings Yet"
            ),
          )
      );
    });
  }

}
