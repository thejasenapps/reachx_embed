import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reachx_embed/assets/fonts/iconsax_icons.dart';
import 'package:reachx_embed/presentation/mentoring/expert_registration/expertRegistrationViewModel.dart';


class ImageUploadWidget extends StatefulWidget {

  ExpertRegistrationViewModel expertRegistrationViewModel;
  ImageUploadWidget({super.key, required this.expertRegistrationViewModel});

  @override
  State<ImageUploadWidget> createState() => _ImageUploadWidgetState();
}

class _ImageUploadWidgetState extends State<ImageUploadWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () async {
            widget.expertRegistrationViewModel.selectImages();
          },
          child: SizedBox(
            height: 100,
            width: 100,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(60),
                child: Obx(() {
                  if(widget.expertRegistrationViewModel.selectedFile.value == null) {
                    if(widget.expertRegistrationViewModel.expertEntity.imageFile.isNotEmpty) {
                      return Image.network(widget.expertRegistrationViewModel.expertEntity.imageFile);
                    } else {
                      return  const Icon(
                        Iconsax.profile_add,
                        size: 50,
                        color: Colors.grey,
                      );
                    }
                  } else {
                    return Image.memory(widget.expertRegistrationViewModel.imageBytes!);
                  }
                })
            ),
          ),
        ),
        const Text('Insert your pic'),
      ],
    );
  }
}
