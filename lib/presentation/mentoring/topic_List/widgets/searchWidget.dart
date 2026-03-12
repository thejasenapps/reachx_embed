import 'package:flutter/material.dart';
import 'package:reachx_embed/assets/fonts/iconsax_icons.dart';
import 'package:reachx_embed/core/constants/color.dart';
import 'package:reachx_embed/core/helper/hexColor.dart';
import 'package:reachx_embed/presentation/mentoring/topic_List/topicListViewModel.dart';

class SearchWidget extends StatefulWidget {
  TopicListViewModel topicListViewModel;

  SearchWidget({super.key, required this.topicListViewModel});

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 60,
      child: TextField(
        controller: widget.topicListViewModel.searchController,
        // On submission, update the view model’s query and fetch the topic list.
        onSubmitted: (value) {
          widget.topicListViewModel.query = value;
          widget.topicListViewModel.fetchTopicList(search: widget.topicListViewModel.query);
        },
        decoration: InputDecoration(
            prefixIcon:  Icon(
              Iconsax.search_normal_1,
              color: HexColor(mainColor),
              size: 25,
            ),
            prefixIconColor: HexColor(mainColor),
            hintText: "Rewrite your concern",
            hintStyle: TextStyle(
              color: HexColor(secondaryTextColor)
            ),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(
                  color: HexColor(containerBorderColor),
                )
            ),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(
                    color: HexColor(mainColor),
                    width: 1.0
                )
            ),
            suffixIcon: widget.topicListViewModel.searchController.text.isNotEmpty ?
            IconButton(
              onPressed: () {
                setState(() {
                  widget.topicListViewModel.searchController.clear();
                });
              },
              icon: Icon(
                Iconsax.profile_delete,
                color: HexColor(secondaryTextColor),
              ),
            )
                : null
        ),
      ),
    );
  }
}
