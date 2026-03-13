import 'package:reachx_embed/core/global_passion.dart';
import 'package:reachx_embed/core/helper/requestUtils.dart';
import 'package:reachx_embed/data/data_source/remote/firebase/getFromFireStore.dart';
import 'package:reachx_embed/data/data_source/remote/firebase/saveInFirestore.dart';
import 'package:reachx_embed/data/data_source/semantic_search/chromaDB.dart';
import 'package:reachx_embed/data/models/topicModel.dart';
import 'package:reachx_embed/domain/entities/topicEntity.dart';
import 'package:reachx_embed/domain/topicList/topicListRepo.dart';


class TopicListRepoImpl implements TopicListRepo{

  final GetFromFirestore _getFromFirestore = GetFromFirestore();
  final SaveInFirestore _saveInFirestore = SaveInFirestore();

  final ChromaDB _chromaDB  = ChromaDB();

  @override
  Future<Results> fetchTopicList({String type = '', String search = ''}) async {
    try {
      Set<String> searchList = {};
      TopicsModel fullTopicsModel = TopicsModel(topics: []);
      Set<TopicModel> setTopicModel = {};

      if(search != '') {

        Results result = await _chromaDB.getSearchCode(search.toLowerCase(), );

        if(result is SuccessState) {
          for(int i = 0; i < result.value["documents"][0].length; i++) {
            if(result.value["distances"][0][i] < 1.35) {
              final doc = result.value["documents"][0][i] as String;
              final list = doc.split(":");
              searchList.add(list[0]);
            }
          }
        } else if( result is ErrorState  && result.msg == "Rate limit exceeded: 50 per 5 minute"){
          return Results.error("limit");
        } else {
          return Results.error(TopicsEntity(topics: []));
        }

        for(String each in searchList) {
          TopicsModel topicsModel = await _getFromFirestore.getSearchTopics(type: type, searchQuery: each);

          if(topicsModel.topics.isNotEmpty) {

            if(globalInstitutionId.value.isNotEmpty) {
              final topics = topicsModel.topics.where((topic) => topic.institutionId == globalInstitutionId.value);
              setTopicModel.addAll(topics as List<TopicModel>);
            } else {
              setTopicModel.addAll(topicsModel.topics as List<TopicModel>);
            }
          }
        }

        fullTopicsModel.topics.addAll(setTopicModel);
      } else {

        if(globalInstitutionId.value.isNotEmpty) {
          final topics = await _getFromFirestore.getSearchTopics(type: type, searchQuery: '');
          fullTopicsModel = topics.topics.where((topic) => topic.institutionId == globalInstitutionId.value) as TopicsModel;
          setTopicModel.addAll(topics as List<TopicModel>);
        } else {
          fullTopicsModel = await _getFromFirestore.getSearchTopics(type: type, searchQuery: '');
        }
      }
      // Map ExpertsModel to ExpertsListEntity
      List<TopicEntity> topicEntity = fullTopicsModel.topics.where((topic) => topic.status == "online" && topic.skillType == "professional").map((topic) {
          return TopicEntity(
            name: topic.name,
            description: topic.description,
            session: topic.session,
            sessionType: topic.sessionType,
            topicRate: topic.topicRate,
            expertise: topic.expertise,
            topicId: topic.topicId,
            expertId: topic.expertId,
            expertName: topic.expertName,
            rating: topic.rating,
            count: topic.count,
            location: topic.location,
            skillType: topic.skillType,
            imageUrl: topic.imageUrl,
            audio: topic.audio,
            sessionId: topic.sessionId,
            status: topic.status,
            languages: topic.languages,
            currencySymbol: topic.currencySymbol,
            meetingUrl: topic.meetingUrl,
            momentsIds: topic.momentsIds,
              availability: topic.availability
          );
      }).toList();

      if(topicEntity.isEmpty) {
        return Results.error(TopicsEntity(topics: []));
      }
      return Results.success(TopicsEntity(topics: topicEntity)); // Return the list of maps
    } catch (e) {
      print(e);
      // Handle and throw an exception in case of failure
      return Results.error(TopicsEntity(topics: []));
    }
  }


  @override
  Future<bool> saveSearchItem(String search) async {
    return _saveInFirestore.saveSearch(search);
  }

}