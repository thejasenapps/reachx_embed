import 'package:reachx_embed/domain/homeScreen/homeScreenEntity.dart';

class HomeScreenModel extends HomeScreenEntity {

  HomeScreenModel({
    required super.links,
    required super.length
  });  // Initialize the base class with name and phoneNo

  factory HomeScreenModel.fromFirestore(Map<String, dynamic> data) {

    final Map<String, String> formattedLinks = Map.fromEntries(
      data.entries.map((entry) {
        final index = data.keys.toList().indexOf(entry.key) + 1;
        return MapEntry('link$index', entry.value);
      }),
    );

    return HomeScreenModel(
        links: formattedLinks,
        length: formattedLinks.length
    );
  }
}



class PopularCategoryModel extends PopularCategoryEntity {

  PopularCategoryModel({
    required super.categories,
  });  // Initialize the base class with name and phoneNo

  factory PopularCategoryModel.fromFirestore(Map<String, dynamic> data) {
    return PopularCategoryModel(
      categories: (data['popular'] as List?)?.map((interest) => interest.toString()).toList() ?? [],
    );
  }
}