import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_one/screens/oway_list_screen/oway_card.dart';
import 'package:project_one/viewModels/favorite_controller/favorite_controller.dart';
import 'package:project_one/viewModels/user/oway_list_controller/oway_list_controller.dart';

class OwayListScreen extends StatelessWidget {
  const OwayListScreen({super.key});



  @override
  Widget build(BuildContext context) {
    final controller = Get.put(Favoritecontroller());
    final owayListController = Get.put(OwayListController());

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
         title:  InkWell(
            onTap: () {
              _showTownshipsDialog(context);
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children:  [
                Flexible(
                  child: Obx(()=>Text(
                    owayListController.selectedTownship.value.isEmpty
                        ? "Choose Township"
                        : owayListController.selectedTownship.value,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: Colors.black,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),),
                ),
                SizedBox(width: 5),
                Icon(Icons.keyboard_arrow_down, size: 25, color: Colors.black),
              ],
            ),
          ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 5),
        child: Obx(
          () {
            final selected = owayListController.selectedTownship.value;
            final filteredDrivers = (selected.isEmpty || selected == 'All Drivers')
                ? owayListController.drivers
                : owayListController.drivers
                .where((d) => d['township'] == selected)
                .toList();
          return  GridView.builder(
              itemCount: filteredDrivers.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                crossAxisSpacing: 1,
                mainAxisSpacing: 1,
                childAspectRatio: 1,
              ),
              itemBuilder: (context, index) {
                final driver = filteredDrivers[index];
                return OwayCard(driver: driver);
              },
            );
          }
        ),
      ),
    );
  }
  void _showTownshipsDialog(BuildContext context) {
    List<String> townships = [
      'All Drivers',
      'MahaAungmye Township, Maha Aungmye District,Mandalay Region',
      'Chanayethazan Township, Maha Aungmye District,Mandalay Region',
      "Chanmyathazi Township,Maha Aungmye District,Mandalay Region",
      "Pyigyidagun Township, Maha Aungmye District,Mandalay Region",
      "Aungmyethazan Township,Aungmyethazan District,Mandalay Region",
      "Patheingyi Township,Aungmyethazan District,Mandalay Region",
      "Madaya Township,Aungmyethazan District,Mandalay Region",
      "Amarapura Township,Amarapura District,Mandalay Region",
      "Pyinoolwin Township, Pyin-Oo-Lwin District, Mandalay Region",
      "Thabeikkyin Township,Thabeikkyin District,Mandalay Region",
      "Singu Township,Thabeikkyin District,Mandalay Region",
      "Mogok Township,Thabeikkyin District,Mandalay Region",
      'Kyaukse Township,Kyaukse District, Mandalay Region',
      'Myittha Township, Kyaukse District, Mandalay Region',
      'Sintgaing Township, Kyaukse District, Mandalay Region',
      'Tada-U Township, Tada-U District,Mandalay Region',
      'Ngazun Township, Tada-U District,Mandalay Region',
      'Mahlaing Township,Meiktila District,Mandalay Region',
      'Meiktila Township ,Meiktila District,Mandalay Region',
      'Thazi Township,Meiktila District,Mandalay Region',
      'Wundwin Township,Meiktila District,Mandalay Region',
      'Myingyan Township,Myingyan District,Mandalay Region',
      'Natogyi Township,Myingyan District,Mandalay Region',
      'Taungtha Township,Myingyan District,Mandalay Region',
      'Nyaung-U Township,Nyaung-U District,Mandalay Region',
      'Kyaukpadaung Township,Nyaung-U District,Mandalay Region',
      'Pyawbwe Township,Yamethin District,Mandalay Region',
      'Yamethin Township ,Yamethin District,Mandalay Region',
    ];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 16),
              child: Text(
                "Select Townships in Mandalay Region",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: townships.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey.shade300,
                          width: 1,
                        ),
                      ),
                    ),
                    child: ListTile(
                      leading: Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 20,
                      ),
                      title: Text(
                        townships[index],
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        // Update selected township state
                        Get.find<OwayListController>().setSelectedTownship(townships[index]);

                      },
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
