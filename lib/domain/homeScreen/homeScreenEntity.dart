class HomeScreenEntity {
  Map<String, dynamic> links;
  int length;

  HomeScreenEntity({required this.links, required this.length});
}

class PopularCategoryEntity {
  List<String> categories;

  PopularCategoryEntity({required this.categories});
}


class TrendingProfilesEntity {
  String topicId;
  String expertId;
  String name;
  String imageUrl;
  String session;
  String sessionType;
  String expertName;
  String skillType;
  List<String> languages;
  String location;
  bool availability;

  TrendingProfilesEntity ({
    required this.topicId,
    required this.expertId,
    required this.name,
    required this.session,
    required this.sessionType,
    required this.expertName,
    required this.imageUrl,
    required this.skillType,
    required this.languages,
    required this.location,
    required this.availability
  });
}


class TrendingProfilesListEntity {
  List<TrendingProfilesEntity> trendingProfilesList;

  TrendingProfilesListEntity({
    required this.trendingProfilesList
  });
}