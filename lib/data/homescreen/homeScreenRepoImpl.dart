import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:reachx_embed/core/global_passion.dart';
import 'package:reachx_embed/core/helper/requestUtils.dart';
import 'package:reachx_embed/data/booked/bookedModel.dart';
import 'package:reachx_embed/data/data_source/local/sharedPreferenceServices.dart';
import 'package:reachx_embed/data/data_source/remote/firebase/firebaseAuthentication.dart';
import 'package:reachx_embed/data/data_source/remote/firebase/getFromFireStore.dart';
import 'package:reachx_embed/data/models/expertsModel.dart';
import 'package:reachx_embed/data/models/institutionModel.dart';
import 'package:reachx_embed/data/models/topicModel.dart';
import 'package:reachx_embed/domain/entities/expertsEntity.dart';
import 'package:reachx_embed/domain/entities/institutionEntity.dart';
import 'package:reachx_embed/domain/homeScreen/homeScreenEntity.dart';
import 'package:reachx_embed/domain/homeScreen/homeScreenRepo.dart';

class HomeScreenRepoImpl implements HomeScreenRepo {

  final GetFromFirestore _getFromFirestore = GetFromFirestore();
  final FirebaseAuthentication _firebaseAuthentication = FirebaseAuthentication();
  final SharedPreferenceServices _sharedPreferenceServices = SharedPreferenceServices();

  @override
  Future<HomeScreenEntity> fetchTutorials() async {
    final HomeScreenEntity formattedLinks = await _getFromFirestore.getTutorials();
    return formattedLinks;
  }



  @override
  Future<bool> isLoggedIn() async {
    bool? isLoggedIn = await _sharedPreferenceServices.getValue("loggedIn");
    return isLoggedIn ?? false;
  }



  @override
  Future<PopularCategoryEntity> getPopularCategories() {
    return _getFromFirestore.getPopularTopics();
  }


  @override
  Future<Results> fetchTrendingProfiles() async {
    try {
      List<TrendingProfilesEntity> trendingProfiles = [];

      final futures = [
        _getFromFirestore.getAllBookings(),
        _getFromFirestore.getSearchTopics()
      ];

      final response = await Future.wait(futures);

      BookedModel bookedModel = response[0] as BookedModel;
      TopicsModel topicsModel = response[1] as TopicsModel;

      List<String> topicIds = bookedModel.bookingSessions
          .where((booking) =>
          DateTime.parse(booking.start).isAfter(DateTime.now()))
          .map(
              (booking) => booking.topicId ?? ''
      ).toList();

      List<TrendingProfilesEntity> profiles = [];

      if(globalInstitutionId.value.isEmpty) {
        profiles = topicsModel.topics
            .where((topic) =>
        topic.status == "online" && topic.skillType == "professional")
            .map((topic) {
          return TrendingProfilesEntity(
              topicId: topic.topicId,
              expertId: topic.expertId ?? '',
              name: topic.name,
              session: topic.session,
              sessionType: topic.sessionType,
              expertName: topic.expertName ?? '',
              imageUrl: topic.imageUrl ?? '',
              skillType: topic.skillType ?? 'professional',
              languages: topic.languages!.isNotEmpty ? topic.languages! : [
                'English'
              ],
              location: topic.location!.isNotEmpty
                  ? topic.location!
                  : "Loading...",
              availability: topic.availability
          );
        }).toList();
      } else {
        profiles = topicsModel.topics
            .where((topic) =>
        topic.status == "online"
            && topic.skillType == "professional"
            && topic.institutionId!.isNotEmpty
            && topic.institutionId! == globalInstitutionId.value
        )
            .map((topic) {
          return TrendingProfilesEntity(
              topicId: topic.topicId,
              expertId: topic.expertId ?? '',
              name: topic.name,
              session: topic.session,
              sessionType: topic.sessionType,
              expertName: topic.expertName ?? '',
              imageUrl: topic.imageUrl ?? '',
              skillType: topic.skillType ?? 'professional',
              languages: topic.languages!.isNotEmpty ? topic.languages! : [
                'English'
              ],
              location: topic.location!.isNotEmpty
                  ? topic.location!
                  : "Loading...",
              availability: topic.availability
          );
        }).toList();
      }


      if (topicIds.isNotEmpty) {
        for (String id in topicIds) {
          trendingProfiles.addAll(
              profiles.where((profile) => profile.topicId == id));
          profiles.removeWhere((profile) => profile.topicId == id);
        }
      }

      if (trendingProfiles.length < 10) {
        profiles.shuffle();
        trendingProfiles.addAll(profiles);
      }

      trendingProfiles = trendingProfiles.take(10).toList();

      if (trendingProfiles.isEmpty) {
        return Results.error('No trending profiles');
      }

      return Results.success(
          TrendingProfilesListEntity(trendingProfilesList: trendingProfiles)
      );
    } catch (e) {
      debugPrint(e.toString());
      return Results.error(e.toString());
    }
  }


  @override
  Future<bool> logOut() {
    return _firebaseAuthentication.signOut();
  }

  @override
  void localLoginSave() {
    _sharedPreferenceServices.setValue("loggedIn", false);
  }

  @override
  // Fetches expert profile details from Firestore
  Future<ExpertEntity> fetchExpertProfile() async {
    ExpertModel expertModel = await  _getFromFirestore.getExpertProfileDetails();

    ExpertEntity expertEntity = ExpertEntity(
        uniqueId: expertModel.uniqueId,
        name: expertModel.name,
        minutes: expertModel.minutes,
        topics: expertModel.topics,
        intro: expertModel.intro,
        location: expertModel.location,
        experience: expertModel.experience,
        imageId: expertModel.imageId,
        imageFile: expertModel.imageFile,
        status: expertModel.status,
        isExpert: expertModel.isExpert,
        achievements: expertModel.achievements,
        languages: expertModel.languages
    );

    return expertEntity;
  }



  @override
  Future<void> saveOnline(String storage, String status) async {
    if (storage == "online") {
      _sharedPreferenceServices.setValue(storage, status == "online");
    } else {
      _sharedPreferenceServices.setValue(storage, true);
    }
  }


  @override
  Future<InstitutionEntity> getInstitution(String institutionId) async {
    final result = await _getFromFirestore.fetchInstitution(institutionId);

    if(result is SuccessState) {
      final institutionModel = result.value as InstitutionModel;

      return institutionModel.toEntity();
    }

    return InstitutionEntity(id: '', name: '');
  }

}