import 'package:reachx_embed/core/helper/requestUtils.dart';
import 'package:reachx_embed/core/injections.dart';
import 'package:reachx_embed/domain/topicList/topicListRepo.dart';


class TopicListUsecase {
  final TopicListRepo _topicListRepo = getIt();

  Future<Results> fetchTopicList({String type = '', String search = ''}) {
    return _topicListRepo.fetchTopicList(search: search, type: type);
  }

  Future<bool> saveSearch(String search) {
    return _topicListRepo.saveSearchItem(search);
  }
}