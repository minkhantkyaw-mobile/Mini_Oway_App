import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../models/oway_hasPlace.dart';
class Favoritecontroller extends GetxController {
  final _box = GetStorage();
  final _key = 'favorite_drivers';

  var favorites = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadFavorites();
  }

  void loadFavorites() {
    final stored = _box.read<List<dynamic>>(_key);
    if (stored != null) {
      favorites.value = stored.cast<Map<String, dynamic>>();
    }
  }

  void saveFavorites() {
    _box.write(_key, favorites);
    print("This is key : $_key");
    print("This is value : $favorites");
    final storedList = _box.read<List<dynamic>>(_key);
    if (storedList != null) {
      print("This is length : ${storedList.length}");
    } else {
      print("No data stored yet.");
    }

  }

  bool isFavorite(String id) {
    return favorites.any((driver) => driver['id'] == id);
  }

  void toggleFavorite(Map<String, dynamic> driver) {
    final id = driver['id'];
    print("This is id : $id");
    final index = favorites.indexWhere((d) => d['id'] == id);

    if (index == -1) {
      final sanitized = Map<String, dynamic>.from(driver);
      if (sanitized['createdAt'] is Timestamp) {
        sanitized['createdAt'] =
            (sanitized['createdAt'] as Timestamp).toDate().toIso8601String();
      }
      favorites.add(sanitized);
    } else {
      favorites.removeAt(index);
    }

    saveFavorites();
    favorites.refresh();
  }

  RxBool favoriteStatus(String id) {
    return RxBool(isFavorite(id));
  }
}
