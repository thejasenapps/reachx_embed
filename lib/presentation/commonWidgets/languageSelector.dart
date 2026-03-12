import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:language_picker/language_picker.dart';
import 'package:language_picker/languages.dart' as lang;
import 'package:reachx_embed/core/constants/color.dart';
import 'package:reachx_embed/core/helper/hexColor.dart';
import 'package:reachx_embed/presentation/mentoring/expert_registration/expertRegistrationViewModel.dart';

class LanguageSelectorWidget extends StatefulWidget {

  ExpertRegistrationViewModel viewModel;

  LanguageSelectorWidget({super.key, required this.viewModel});

  @override
  State<LanguageSelectorWidget> createState() => _LanguageSelectorWidgetState();
}

class _LanguageSelectorWidgetState extends State<LanguageSelectorWidget> {


  @override
  void initState() {
    widget.viewModel.languages.add("English");
    widget.viewModel.saveBasicRegistration("languages");
    super.initState();
  }



  Widget _buildDialogItem(lang.Language language) => Row(
    children: <Widget>[
      Text(language.name),
      const SizedBox(width: 8.0),
      Flexible(child: Text("(${language.isoCode})"))
    ],
  );


  void _openLanguagePickerDialog() => showDialog(
      context: context,
      builder: (context) => LanguagePickerDialog(
        titlePadding: const EdgeInsets.all(8),
        searchCursorColor: HexColor(lightBlue),
        searchInputDecoration: const InputDecoration(hintText: 'Search ..'),
        isSearchable: true,
        title: const Text("Select your language"),
        onValuePicked: (lang.Language language) => setState(() {
          widget.viewModel.languages.add(language.name);
          widget.viewModel.saveBasicRegistration("languages");
        }),
        itemBuilder: _buildDialogItem,
      )
  );



  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Select 3 languages"),
        GestureDetector(
          onTap: () =>  _openLanguagePickerDialog(),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: HexColor(containerBorderColor)),
              color: Colors.white
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.language,
                    color: HexColor(black),
                  ),
                ),
              ],
            ),
          ),
        ),
        Obx(() {
          if(widget.viewModel.languages.isNotEmpty) {
            return Wrap(
              children: widget.viewModel.languages.map((language) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  child: Container(
                    height: 35,
                    decoration: BoxDecoration(
                      color: HexColor(containerBorderColor),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              setState(() {
                                widget.viewModel.languages.remove(language);
                              });
                              widget.viewModel.saveBasicRegistration("languages");
                            },
                            icon: const Icon(
                              Icons.cancel,
                              size: 15,
                            )
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: Text(language),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          } else {
            return const SizedBox.shrink();
          }
        })
      ],
    );
  }
}
