import 'package:reachx_embed/domain/entities/slotEntity.dart';

class SlotModel extends SlotEntity {
  SlotModel({required super.slotsByDate});


  factory SlotModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> slots = json["data"]["slots"];

    Map<String, List<String>> parsedSlots = slots.map((date, time) {
      List<String> timeList = (time as List).map(
              (slot) => slot["time"] as String
      ).toList();
      return MapEntry(date, timeList);
    });

    return SlotModel(slotsByDate: parsedSlots);
  }
}