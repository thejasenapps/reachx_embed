import 'package:get/get.dart';

class NavigationController extends GetxController {
  // Provides a singleton instance for easy access
  static NavigationController get to => Get.find();

  // Observes the current index for reactive UI updates
  var currentIndex = 0.obs;


  // Updates the current index to change pages
  void changePage(int index) {
    currentIndex.value = index;
  }

}
