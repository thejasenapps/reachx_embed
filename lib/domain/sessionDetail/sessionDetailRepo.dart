import 'package:reachx_embed/domain/entities/slotEntity.dart';

abstract class SessionDetailRepo {
  Future<bool> getLog(String storage);
  Future<SlotEntity> getSlots(String start, String end, int eventTypeId);
}