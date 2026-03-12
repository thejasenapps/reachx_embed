import 'dart:async';

import 'package:flutter/material.dart';
import 'package:reachx_embed/core/constants/color.dart';
import 'package:reachx_embed/core/helper/hexColor.dart';
import 'package:reachx_embed/presentation/mentoring/expert_registration/expertRegistrationViewModel.dart';

class LocationSelectorWidget extends StatefulWidget {

  var  viewModel;
  double length;
  TextEditingController textController;

  LocationSelectorWidget({super.key, required this.viewModel, required this.textController, required this.length});

  @override
  State<LocationSelectorWidget> createState() => _LocationSelectorWidgetState();
}

class _LocationSelectorWidgetState extends State<LocationSelectorWidget> {

  List<String> _placeList = [];
  bool _shouldSearch = true;
  Timer? _debounce;
  bool isBasicEdit = false;


  @override
  void initState() {
    widget.textController.addListener(() {
      _onChanged();
    });

    super.initState();
  }

  @override
  void dispose() {
    widget.textController.removeListener(_onChanged);
    super.dispose();
  }


  void _onChanged()  {
    if(_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () async {
      if (widget.textController.text.isNotEmpty && _shouldSearch) {
        List<String> result = await widget.viewModel.getLocationResults(widget.textController.text);
        setState(() {
          _placeList = result;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
          const Text("Location"),
          TextField(
          controller: widget.textController,
            autocorrect: false,
            style: const TextStyle(color: Colors.black, fontSize: 18),
            decoration: InputDecoration(
              hintText: "Kochi, Kerala",
              hintStyle: TextStyle(
                fontSize: 15,
                color: HexColor(secondaryTextColor)
              ),
              floatingLabelBehavior: FloatingLabelBehavior.never,
              prefixIcon: const Icon(Icons.map),
              suffixIcon: widget.textController.text.isNotEmpty
                  ? IconButton(
                onPressed: () {
                  widget.textController.clear();
                  setState(() => _placeList.clear());
                  _shouldSearch = true;

                  if(isBasicEdit) {
                    widget.viewModel.saveBasicRegistration("location");
                  }
                },
                icon: const Icon(Icons.cancel),
              )
                  : null,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: HexColor(containerBorderColor)
                ),
                borderRadius: BorderRadius.circular(10)
              ),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: HexColor(containerBorderColor)
                    ),
                    borderRadius: BorderRadius.circular(10)
                )
            ),
            onSubmitted: (value) {
              setState(() {
                _shouldSearch = false;
              });
            },
          ),
        if (_placeList.isNotEmpty)
          SizedBox(
            height: widget.length,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _placeList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: HexColor(containerBorderColor)),
                    ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(_placeList[index]),
                      )
                  ),
                  onTap: () {
                    widget.textController.text = _placeList[index];
                    if(widget.viewModel is ExpertRegistrationViewModel) {
                      setState(() {
                        _placeList.clear();
                        _shouldSearch = false;
                      });
                      widget.viewModel.saveBasicRegistration("location");

                    } else {
                      _placeList.clear();
                      _shouldSearch = false;
                      Navigator.pop(context, true);
                    }
                  },
                );
              },
            ),
          ),
      ],
    );
  }
}
