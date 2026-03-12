import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reachx_embed/assets/fonts/iconsax_icons.dart';
import 'package:reachx_embed/core/constants/color.dart';
import 'package:reachx_embed/core/constants/navId.dart';
import 'package:reachx_embed/core/helper/hexColor.dart';
import 'package:reachx_embed/presentation/mentoring/homeScreen/homeScreenViewModel.dart';
import 'package:reachx_embed/presentation/mentoring/topic_List/topicListScreen.dart';



class SearchWidget extends StatefulWidget {

  HomeScreenViewModel homeScreenViewModel;

  SearchWidget({super.key, required this.homeScreenViewModel});

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {

  List<String> searchItems = [];
  List<String> filteredSearchItems = [];

  final TextEditingController menuController = TextEditingController();

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    menuController.addListener(_searchChanged);
    super.initState();
  }


  void _searchChanged() {
    String query = menuController.text;
    List<String> newFilteredItems = searchItems.where(
          (item) => item.toLowerCase().contains(query.toLowerCase()),
    ).toList();

    if (!mounted) return; // Ensure widget is still active

    if (filteredSearchItems != newFilteredItems) {
        filteredSearchItems = newFilteredItems;
    }
  }



  String? selectedItem;


  @override
  void dispose() {
    menuController.dispose();
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      children: [
        const Text(
            'Find your growth journey coach',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 18
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10,),
        TextField(
          textAlign: TextAlign.center,
          cursorColor: HexColor(mainColor),
          decoration: InputDecoration(
            hintText: "Where do you want guidance?",
            hintStyle: TextStyle(
              color: Colors.grey[600],
              fontWeight: FontWeight.w400,
            ),
            suffixIcon: const Padding(
              padding: EdgeInsets.only(right: 10),
              child: Icon(
                  Iconsax.search_normal_1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide:  BorderSide(color: Colors.grey[400]!),
              borderRadius: BorderRadius.circular(30),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: HexColor(mainColor), width: 2)
            ),
            contentPadding: const EdgeInsets.all(20),
            filled: true,
            fillColor: Colors.white,
          ),
          focusNode: _focusNode,
          controller: _searchController,
          onSubmitted: (text) {
            selectedItem = text;
            if (selectedItem != null) {
              Get.toNamed(
                TopicListScreen.route,
                arguments: selectedItem,
                id: NavIds.home,
              )?.then((_) {
                if(mounted) {
                  setState(() {
                    selectedItem = null;
                  });
                }
              });
              setState(() {
                _searchController.clear();
                selectedItem = '';
              });
            }
          },
          onTapOutside: (value) => FocusScope.of(context).unfocus(),
        ),
      ],
    );
  }
}

