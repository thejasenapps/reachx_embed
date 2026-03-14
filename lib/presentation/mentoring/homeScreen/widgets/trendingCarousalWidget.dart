import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:reachx_embed/assets/fonts/iconsax_icons.dart';
import 'package:reachx_embed/core/constants/color.dart';
import 'package:reachx_embed/core/constants/navId.dart';
import 'package:reachx_embed/core/helper/hexColor.dart';
import 'package:reachx_embed/domain/homeScreen/homeScreenEntity.dart';
import 'package:reachx_embed/presentation/commonWidgets/customItems/customPlaceHolderImage.dart';
import 'package:reachx_embed/presentation/mentoring/expertDetail/expertDetailScreen.dart';
import 'package:reachx_embed/presentation/mentoring/homeScreen/homeScreenViewModel.dart';
import 'package:get/get.dart';

class TrendingCarousalWidget extends StatelessWidget {
  final HomeScreenViewModel homeScreenViewModel;
  const TrendingCarousalWidget({
    super.key,
    required this.homeScreenViewModel
  });


  String sessionClassification(String session, String sessionType) {
    if(sessionType.toLowerCase() == "group") {
      if(session.toLowerCase() == "online") {
        return "Webinar";
      } else {
        return "Seminar";
      }
    } else {
      return "1:1";
    }
  }

  String languageStringification(List<String> languages) {
    if(languages.isNotEmpty) {
      if(languages.length == 1) {
        return languages.first;
      } else {
        String languageString = '';
        for(String each in languages) {
          if(each == languages.last) {
            languageString = "$languageString $each";
          } else {
            languageString = "$languageString $each,";
          }
        }
        return languageString;
      }
    }
    return '';
  }

  String getFilteredLocation(String location) {
    List<String> locations =  location.split(",");
    String filteredLocation = locations.length > 2 ? "${locations[locations.length - 2].trim()}, ${locations.last.trim()}" : locations.join();

    return filteredLocation;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: homeScreenViewModel.fetchTrendingProfiles(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting || snapshot.hasError) {
            return CarouselSlider(
                items: List.generate(
                    3, (index) {
                      return Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12)
                        ),
                        child: Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(60),
                            child: Image.asset(
                              'lib/assets/images/reachX_icon.png',
                              height: 100,
                              width: 100,
                            ),
                          ),
                        ),
                      );
                }),
                options: CarouselOptions(
                  height: 220,
                  viewportFraction: 0.8,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  enlargeFactor: 0.2,
                  autoPlayInterval: const Duration(seconds: 2),
                )
            );
          } else {

            final TrendingProfilesListEntity profileList = snapshot.data as TrendingProfilesListEntity;

            if(profileList.trendingProfilesList.isNotEmpty) {
              return CarouselSlider(
                  items: profileList.trendingProfilesList.map((profile) {
                    return GestureDetector(
                      onTap: () {
                        Map<String, dynamic> arguments = {
                          "uniqueId": profile.expertId,
                          "topicId": profile.topicId
                        };

                        Get.toNamed(
                          ExpertDetailScreen.route, // Navigate to expert detail screen.
                          arguments: arguments,
                          id: NavIds.home,
                        );
                      },
                      child: Container(
                          width: MediaQuery.of(context).size.width * 0.70,
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: HexColor(containerBorderColor)
                              )
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: HexColor(containerBorderColor)
                                    ),
                                    shape: BoxShape.circle
                                ),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(60),
                                    child:  CachedNetworkImage(
                                      imageUrl: profile.imageUrl,
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => const Center(
                                        child: CustomPlaceHolderImage(),
                                      ),
                                      errorWidget: (context, url, error) => Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(60)
                                          ),
                                          child: const Icon(
                                            Icons.person, size: 40, color: Colors.grey,
                                          )
                                      ),
                                    )
                                ),
                              ),
                              const SizedBox(height: 4,),
                              SizedBox(
                                height: profile.name.length > 40 ? 40 : 20,
                                child: Text(
                                  profile.name,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: profile.name.length > 40 ? 14 : 16
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(height: 4,),
                              Text(
                                profile.expertName,
                                style: TextStyle(
                                    color: HexColor(secondaryTextColor),
                                    fontWeight: FontWeight.w300,
                                    fontSize: 12
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 4,),
                              Text(
                                languageStringification(profile.languages),
                                style: TextStyle(
                                    color: HexColor(lightBlue),
                                    fontWeight: FontWeight.w300,
                                    fontSize: 12
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4,),
                              profile.sessionType.toLowerCase() == "group"
                                  ? Text(
                                !profile.availability
                                    ? "Request Slot"
                                    : profile.session.toLowerCase() == "online"
                                    ? "Webinar"
                                    : "Seminar",
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w300,
                                    fontSize: 12
                                ),
                                textAlign: TextAlign.center,
                              )
                                  : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    profile.session.toLowerCase() == "online"
                                        ? Iconsax.monitor
                                        : Iconsax.location,
                                    color: HexColor(mainColor),
                                    size: 13,
                                  ),
                                  const SizedBox(width: 5,),
                                  Text(
                                    profile.session.toLowerCase() == "online"
                                        ? "Online"
                                        : getFilteredLocation(profile.location),
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w300,
                                        fontSize: 12
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(width: 20,),
                                  Text(
                                    sessionClassification(
                                        profile.session,
                                        profile.sessionType
                                    ),
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w300,
                                        fontSize: 12
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ],
                          )
                      ),
                    );
                  }).toList(),
                  options: CarouselOptions(
                    height: 220,
                    viewportFraction: 0.8,
                    autoPlay: true,
                    enlargeCenterPage: true,
                    autoPlayInterval: const Duration(seconds: 2),
                    enlargeFactor: 0.2,
                  )
              );
            } else {
              return const Center(
                child: Text(
                  "Loading soon.."
                ),
              );
            }
          }
        }
    );
  }

}
