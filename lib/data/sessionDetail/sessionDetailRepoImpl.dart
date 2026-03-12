import 'package:reachx_embed/core/helper/requestUtils.dart';
import 'package:reachx_embed/data/data_source/cal_service/slots.dart';
import 'package:reachx_embed/data/data_source/local/sharedPreferenceServices.dart';
import 'package:reachx_embed/data/models/slotModel.dart';
import 'package:reachx_embed/domain/sessionDetail/sessionDetailRepo.dart';
import 'package:reachx_embed/domain/entities/slotEntity.dart';

class SessionDetailRepoImpl implements SessionDetailRepo {

  final SharedPreferenceServices _sharedPreferenceServices = SharedPreferenceServices();
  final Slots _slots = Slots();

  @override
  Future<bool> getLog(storage) async {
    bool response = await  _sharedPreferenceServices.getValue(storage) ?? false;
    return response;
  }

  @override
  Future<SlotEntity> getSlots(String start, String end, int eventTypeId) async {
    Results result = await _slots.getAvailableSlots(start, end, eventTypeId);

    if(result is SuccessState) {
      SlotModel slotModel = result.value;
      SlotEntity slotEntity = SlotEntity(
          slotsByDate:slotModel.slotsByDate,
      );
      return slotEntity;
    } else {
      return SlotEntity(slotsByDate: {});
    }
  }
}