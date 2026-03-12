import 'package:reachx_embed/core/helper/dateAndTimeConvertors.dart';
import 'package:reachx_embed/core/injections.dart';
import 'package:reachx_embed/domain/sessionDetail/sessionDetailRepo.dart';
import 'package:reachx_embed/domain/entities/slotEntity.dart';

class SessionDetailUsecase {

  SessionDetailRepo sessionDetailRepo = getIt();
  DateAndTimeConvertors dateAndTimeConvertors = DateAndTimeConvertors();

  // Retrieves the login status from local storage
  Future<bool> getLog(String storage) {
    return sessionDetailRepo.getLog(storage);
  }

  // Retrieves available slots for the next 60 days for a given event type ID
  Future<SlotEntity> getSlots(int eventTypeId) {
    DateTime start = DateTime.now();
    DateTime end = start.add(const Duration(days: 60));

    return sessionDetailRepo.getSlots(start.toUtc().toIso8601String(), end.toUtc().toIso8601String(), eventTypeId);
  }

}