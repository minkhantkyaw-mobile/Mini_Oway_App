import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_one/screens/favorite_screen/user_favorite_card.dart';

import '../../viewModels/favorite_controller/favorite_controller.dart';

class FavoriteDriverScreen extends StatelessWidget {
  final Favoritecontroller controller = Get.put(Favoritecontroller());

  FavoriteDriverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        final favorites = controller.favorites;

        if (favorites.isEmpty) {
          return Center(child: Text('No favorite drivers found.'));
        }

        return ListView.builder(
          itemCount: favorites.length,
          itemBuilder: (context, index) {
            final driver = favorites[index];

            return FavoriteDriverCard(driver: driver);

          },
        );
      }),
    );
  }
}
