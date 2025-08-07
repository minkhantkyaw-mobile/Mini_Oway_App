import 'package:get/get.dart';

class MainLayoutController extends GetxController {
  var selectedIndex = 0.obs;

  void goToTab(int index) {
    selectedIndex.value = index;
  }
}
