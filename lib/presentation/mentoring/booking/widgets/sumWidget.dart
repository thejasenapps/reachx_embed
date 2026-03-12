
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reachx_embed/core/constants/color.dart';
import 'package:reachx_embed/core/helper/hexColor.dart';
import 'package:reachx_embed/presentation/mentoring/booking/bookingViewModel.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SumWidget extends StatefulWidget {

  final Map<String, dynamic> bookingDetails;
  final BookingViewModel bookingViewModel;
  const SumWidget({super.key, required this.bookingDetails, required this.bookingViewModel});

  @override
  State<SumWidget> createState() => _SumWidgetState();
}

class _SumWidgetState extends State<SumWidget> {

  @override
  void initState() {
    widget.bookingViewModel.getConversionRate(widget.bookingDetails["currencySymbol"]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Skeletonizer(
          enabled: widget.bookingViewModel.convLoading.value,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: HexColor(containerBorderColor))
                ),
                child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: widget.bookingDetails["sessionType"] == "oneToOne"
                        ? sumContainer("Service Charge", "rate", widget.bookingDetails["currencySymbol"])
                        : sumContainerForGroup("Service Charge", widget.bookingDetails["rate"], widget.bookingDetails["slotsBooked"], widget.bookingDetails["currencySymbol"])
                )
            ),
          )
      );
    });
  }

  Widget sumContainer(String label, String path, String currencySymbol) {

    return Column(
      children: [
        Row(
          spacing: 5,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style:  TextStyle(
                  fontSize: 12,
                  color: HexColor(black)
              ),
            ),
            Text(
              "$currencySymbol${widget.bookingDetails[path]}",
              style:  TextStyle(
                  fontSize: 12,
                  color: HexColor(black)

              ),
            ),
          ],
        ),
        if(widget.bookingDetails[path] != 0 && widget.bookingViewModel.tokens > widget.bookingViewModel.convRate)
          Row(
            spacing: 5,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Column(
                    children: [
                      Text(
                        "Pay by wallet:",
                        style:  TextStyle(
                            fontSize: 12,
                            color: HexColor(black)
                        ),
                      ),
                    ],
                  ),
                  Checkbox(
                      checkColor: Colors.white,
                      activeColor: HexColor(lightBlue),
                      value: widget.bookingViewModel.paidByWallet.value,
                      onChanged: (value) {
                        setState(() {
                          widget.bookingViewModel.paidByWallet.value = value ?? false;
                          widget.bookingViewModel.walletDiscount(widget.bookingDetails[path]);
                        });
                      }
                  )
                ],
              ),
            ],
          ),
          Obx(() {
            if(widget.bookingViewModel.paidByWallet.value) {
              return Column(
                children: [
                  const Divider(
                    height: 10,
                    thickness: 2,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Final Amount:",
                        style:  TextStyle(
                            fontSize: 12,
                            color: HexColor(black)

                        ),
                      ),
                      Text(
                        "$currencySymbol${widget.bookingViewModel.finalBalance}",
                        style:  TextStyle(
                            fontSize: 12,
                            color: HexColor(black)

                        ),
                      )
                    ],
                  )
                ],
              );
            } else {
              return const SizedBox.shrink();
            }
          })
      ],
    );
  }

  Widget sumContainerForGroup(String label, int rate, int bookedSlots, String currencySymbol) {
    return Column(
      children: [
        Row(
          spacing: 5,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style:  TextStyle(
                  fontSize: 12,
                  color: HexColor(black)
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "$currencySymbol${rate/bookedSlots}",
                  style:  TextStyle(
                      fontSize: 12,
                      color: HexColor(black)

                  ),
                ),
                Text(
                  "* $bookedSlots",
                  style:  TextStyle(
                      fontSize: 12,
                      color: HexColor(black)

                  ),
                ),
                SizedBox(
                  width: 40,
                  child: Divider(
                    thickness: 1,
                    color: HexColor(black),
                  ),
                ),
                Text(
                  "₹$rate",
                  style:  TextStyle(
                      fontSize: 12,
                      color: HexColor(black)

                  ),
                ),
              ],
            ),
          ],
        ),
        if(rate != 0 && widget.bookingViewModel.tokens > widget.bookingViewModel.convRate)
          Row(
            spacing: 5,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Column(
                    children: [
                      Text(
                        "Pay by wallet:",
                        style:  TextStyle(
                            fontSize: 12,
                            color: HexColor(black)
                        ),
                      ),
                    ],
                  ),
                  Checkbox(
                      checkColor: Colors.white,
                      activeColor: HexColor(lightBlue),
                      value: widget.bookingViewModel.paidByWallet.value,
                      onChanged: (value) {
                        setState(() {
                          widget.bookingViewModel.paidByWallet.value = value ?? false;
                          widget.bookingViewModel.walletDiscount(rate);
                        });
                      }
                  )
                ],
              ),
            ],
          ),
        Obx(() {
          if(widget.bookingViewModel.paidByWallet.value) {
            return Column(
              children: [
                const Divider(
                  height: 10,
                  thickness: 2,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Final Amount:",
                      style:  TextStyle(
                          fontSize: 12,
                          color: HexColor(black)

                      ),
                    ),
                    Text(
                      "$currencySymbol${widget.bookingViewModel.finalBalance}",
                      style:  TextStyle(
                          fontSize: 12,
                          color: HexColor(black)

                      ),
                    )
                  ],
                )
              ],
            );
          } else {
            return const SizedBox.shrink();
          }
        }),
      ],
    );
  }
}
