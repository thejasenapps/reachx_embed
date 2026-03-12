import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:reachx_embed/core/constants/color.dart';
import 'package:reachx_embed/core/helper/hexColor.dart';
import 'package:reachx_embed/presentation/mentoring/booked/bookedViewModel.dart';


class RatingBoxWidget extends StatefulWidget {

  final BookedViewModel bookedViewModel;
  final String expertId;
  final String bookingId;

  const RatingBoxWidget({super.key, required this.bookedViewModel, required this.expertId, required this.bookingId});

  @override
  State<RatingBoxWidget> createState() => _RatingBoxWidgetState();
}

class _RatingBoxWidgetState extends State<RatingBoxWidget> {

  double rating = 0;


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 20,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Rate the expert"),
              IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.cancel)
              )
            ],
          ),
          StarRating(
            rating: widget.bookedViewModel.rating,
            onRatingChanged: (rating) {
              setState(() {
                widget.bookedViewModel.rating = rating;
              });
            },
          ),
          TextField(
            controller: widget.bookedViewModel.ratingController,
            maxLines: null,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
              hintText: "Write your review here",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(color: Colors.grey)
              ),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: HexColor(mainColor))
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.all(20),
            ),
            style: const TextStyle(
              fontSize: 14
            ),
          ),
          ElevatedButton(
              onPressed: () => widget.bookedViewModel.saveRating(context, widget.expertId, widget.bookingId),
              child: const Text("Submit")
          )
        ],
      ),
    );
  }
}
