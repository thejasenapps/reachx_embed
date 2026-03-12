import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reachx_embed/core/constants/color.dart';
import 'package:reachx_embed/core/helper/findPlatform.dart';
import 'package:reachx_embed/core/helper/hexColor.dart';
import 'package:reachx_embed/core/injections.dart';
import 'package:reachx_embed/presentation/mentoring/booking/bookingViewModel.dart';
import 'package:reachx_embed/presentation/mentoring/booking/widgets/eventDetailsWidget.dart';
import 'package:reachx_embed/presentation/mentoring/booking/widgets/sumWidget.dart';
import 'package:reachx_embed/presentation/commonWidgets/customItems/customElevatedButton.dart';
import 'package:reachx_embed/presentation/commonWidgets/backNavigationWidget.dart';


class BookingDialogScreen extends StatefulWidget {

  static const route = "/paymentScreen";

  final Map<String, dynamic> bookingDetails;

  const BookingDialogScreen({super.key, required this.bookingDetails});

  @override
  State<BookingDialogScreen> createState() => _BookingDialogScreenState();
}

class _BookingDialogScreenState extends State<BookingDialogScreen> {
  final BookingViewModel bookingViewModel = getIt();

  @override
  void initState() {
    bookingViewModel.paidByWallet.value = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final containerHeight = findPlatform();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
            border: Border.all(color: HexColor(containerBorderColor), width: 2),
          ),
          height: containerHeight,
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            leading: BackNavigationWidget(context: context),
            title: Text(
              "Confirm Booking",
              style: TextStyle(
                color: HexColor(black),
                fontSize: 15,
              ),
            ),
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        spacing: 5,
        children: [
          EventDetailsWidget(bookingDetails: widget.bookingDetails),
          SumWidget(bookingDetails: widget.bookingDetails, bookingViewModel: bookingViewModel,),
          Obx(() {
            if(bookingViewModel.paidByWallet.value) {
              return Center(
                child: Text(
                  "You saved ${widget.bookingDetails["currencySymbol"]}${bookingViewModel.finalTokens/bookingViewModel.convRate}  using wallet !",
                  style:  TextStyle(
                      fontSize: 12,
                      color: HexColor(lightBlue)
                  ),
                ),
              );
            } else {
              return const SizedBox.shrink();
            }
          }),
          const Spacer(),
          Obx(() {
            if(bookingViewModel.isLoading.value == true) {
              return Center(child: CircularProgressIndicator(
                  color: HexColor(loadingIndicatorColor),
                ),
              );
            } else {
              return CustomElevatedButton(
                  label: "Confirm & Pay",
                  onTap: () async {
                    bookingViewModel.paymentFlow(widget.bookingDetails, context);
                  }
              );
            }
          }),
          const SizedBox(height: 120,),
        ],
      ),
    );
  }
}
