import 'package:flutter/material.dart';
import 'package:map_location_picker/map_location_picker.dart';

import 'package:reachx_embed/core/env_config.dart';
import 'package:reachx_embed/presentation/mentoring/expert_registration/expertRegistrationViewModel.dart';

class MeetingPickerWidget extends StatefulWidget {

  ExpertRegistrationViewModel expertRegistrationViewModel;

  MeetingPickerWidget({super.key, required this.expertRegistrationViewModel});

  @override
  State<MeetingPickerWidget> createState() => _MeetingPickerWidgetState();
}

class _MeetingPickerWidgetState extends State<MeetingPickerWidget> {

  static const apiKey = String.fromEnvironment('GOOGLE_MAPS_API_KEY');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: MapLocationPicker(
          apiKey: apiKey,
          popOnNextButtonTaped: true,
          bottomCardMargin: const EdgeInsets.only(bottom: 100),
          currentLatLng: const LatLng(29.146727, 76.464895),
          debounceDuration: const Duration(milliseconds: 500),
          onNext: (GeocodingResult? result) {
            if(result != null) {
              setState(() {
                widget.expertRegistrationViewModel.location.value = result.formattedAddress ?? '';
              });
            }
          },
          onSuggestionSelected: (PlacesDetailsResponse? result) {
            if(result != null) {
              setState(() {
                widget.expertRegistrationViewModel.location.value = result.result.formattedAddress ?? "";
              });
            }
          },
        ),
      ),
    );
  }
}
