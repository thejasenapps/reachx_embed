
import 'package:reachx_embed/core/helper/requestUtils.dart';

abstract class TopicListRepo {
  Future<Results> fetchTopicList({String type = '', String search = ''});
  Future<bool> saveSearchItem(String search);
}