import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_one/screens/nav_bar.dart';

class CityListviewScreen extends StatefulWidget {
  final String userName;

  const CityListviewScreen({super.key, required this.userName});

  @override
  State<CityListviewScreen> createState() => _CityListviewScreenState();
}

class _CityListviewScreenState extends State<CityListviewScreen> {
  var collection = FirebaseFirestore.instance.collection("city_list");
  late List<Map<String, dynamic>> city_list;
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    loadCities();
  }

  void loadCities() async {
    List<Map<String, dynamic>> templist = [];
    var data = await collection.get();

    for (var element in data.docs) {
      templist.add(element.data());
    }

    setState(() {
      city_list = templist;
      isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 186, 211, 255),
      appBar: AppBar(
        title: Text('Hello,${widget.userName} All Cities in Myanmar'),
        backgroundColor: const Color.fromARGB(255, 186, 211, 255),
      ),
      body: Center(
        child: isLoaded
            ? ListView.builder(
                itemCount: city_list.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 1,
                    color: Colors.white60,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        Navigator.of(
                          context,
                        ).push(MaterialPageRoute(builder: (_) => NavBar()));
                      },
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              city_list[index]['image'],
                              width: 100,
                              height: 90, // ✅ custom image height works here!
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              city_list[index]['cityname'] ?? "Not Given",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          const Icon(Icons.more_vert),
                        ],
                      ),
                    ),
                  );
                },
              )
            : CircularProgressIndicator(),
      ),
    );
  }
}
