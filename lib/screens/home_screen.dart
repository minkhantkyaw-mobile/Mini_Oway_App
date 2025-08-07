import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_one/models/products_model.dart';
import 'package:project_one/screens/details_screen.dart';
import 'package:project_one/viewModels/user/user_home/user_home_controller.dart';
import 'package:project_one/widgets/category_selection.dart';
import 'package:project_one/widgets/search_bar.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  // This is the function you want to use to close snackbars & bottom sheets
  void closeOpenSheets() {
    final messenger = ScaffoldMessenger.of(context);
    messenger.clearSnackBars(); // ✅ This clears any visible snackbars

    // To close modal bottom sheets:
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop(); // ✅ Pops the bottom sheet if open
    }
  }

  @override
  void initState() {
    super.initState();

    // Close any open sheets/snackbars right after the first frame renders
    WidgetsBinding.instance.addPostFrameCallback((_) {
      closeOpenSheets();
    });
  }

  List<bool> loved = List.generate(ourProducts.length, (_) => false);
  final List<String> myCarousels = [
    'assets/images/image1.png',
    'assets/images/imag2.webp',
    'assets/images/image3.webp',
    'assets/images/image4.png',
    'assets/images/image5.png',
  ];

  int myCurrentIndex = 0;
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final UserHomeController controller = Get.put(UserHomeController());
    return Scaffold(
      key: scaffoldKey,
      body: Column(
        children: [


          /// Scrollable content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // carousel
                  carousel_widget(),
                  const SizedBox(height: 20),

                  CategorySelection(),

                  const SizedBox(height: 10),

                  /// Horizontal scroll list (Trending)
                  /// This is the Popular Places from Firebase
                  SizedBox(
                    height: 280,
                    child: Obx(() {
                      if (controller.restaurants.isEmpty) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        itemCount: controller.restaurants.length,
                        itemBuilder: (context, index) {
                          final e = controller.restaurants[index];
                          return Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: buildRestaurantCard(e, index, width: 200),
                          );
                        },
                      );
                    }),
                  ),

                  const SizedBox(height: 13),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      'Pagodas',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                  const SizedBox(height: 10),

                  /// GridView for popular places
                  SizedBox(
                    height: 280,
                    child: Obx(() {
                      if (controller.restaurants.isEmpty) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        itemCount: controller.pagodas.length,
                        itemBuilder: (context, index) {
                          final e = controller.pagodas[index];

                          return Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: buildPagodaCard(e, index, width: 200),
                          );
                        },
                      );
                    }),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding carousel_widget() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        children: [
          CarouselSlider(
            items: myCarousels.map((path) {
              return Builder(
                builder: (context) => Stack(
                  fit: StackFit.expand,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        path,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                    // Overlay with color + opacity
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.black.withOpacity(
                          0.2,
                        ), // change to your color
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
            options: CarouselOptions(
              autoPlay: true,
              autoPlayCurve: Curves.fastEaseInToSlowEaseOut,
              autoPlayAnimationDuration: const Duration(milliseconds: 2000),
              enlargeCenterPage: true,
              aspectRatio: 2.0,
              height: 200,
              onPageChanged: (index, reason) {
                setState(() {
                  myCurrentIndex = index;
                });
              },
            ),
          ),

          SizedBox(height: 8),
          AnimatedSmoothIndicator(
            activeIndex: myCurrentIndex,
            count: myCarousels.length,
            effect: WormEffect(
              dotHeight: 8,
              dotWidth: 8,
              spacing: 10,
              dotColor: Colors.grey.shade200,
              activeDotColor: Colors.grey.shade900,
              paintStyle: PaintingStyle.fill,
            ),
          ),
        ],
      ),
    );
  }

  /// 🔧 Inline card builder method
  Widget buildProductCard(Map<String, String> e, int index, {double? width}) {
    return GestureDetector(
      // onTap: () {
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (_) => DetailsScreen(
      //         title: e['title']!,
      //         image: e['image']!,
      //         price: e['price']!,
      //         rating: e['rating']!,
      //         discount: e['discount']!,
      //         description: e['description']!,
      //       ),
      //     ),
      //   );
      // },
      child: SizedBox(
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    e['image']!,

                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: InkWell(
                    onTap: () {
                      setState(() => loved[index] = !loved[index]);
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Icon(
                        Icons.favorite,
                        size: 30,
                        color: loved[index] ? Colors.red : Colors.black38,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 5,
                  right: 5,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(60),
                      ),
                    ),
                    child: Text(
                      e['discount']!,
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),

            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(

                    e['title']!,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        size: 15,
                        color: Color.fromARGB(255, 186, 211, 255),
                      ),
                      Text(
                        e['rating']!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 186, 211, 255),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: Text(
                e['address']!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildRestaurantCard(
    Map<String, dynamic> e,
    int index, {
    double? width,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetailsScreen(
              destinationLat: double.parse(e['latitude']),
              destinationLng: double.parse(e['longitude']),
              placeName: e['eng_name'],
              image: e['image'],
              address: e['address'],
            ),
          ),
        );
      },

      child: SizedBox(
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    e['image'],
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                // Favorite and Discount (optional)
                Positioned(
                  top: 5,
                  right: 5,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      "Featured",
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                e['eng_name'],
                maxLines: 2,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                e['address'],
                maxLines: 1,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPagodaCard(
      Map<String, dynamic> e,
      int index, {
        double? width,
      }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetailsScreen(
              destinationLat: double.parse(e['latitude']),
              destinationLng: double.parse(e['longitude']),
              placeName: e['eng_name'],
              image: e['image'],
              address: e['address'],
            ),
          ),
        );
      },

      child: SizedBox(
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    e['image'],
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                // Favorite and Discount (optional)
                Positioned(
                  top: 5,
                  right: 5,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      "Featured",
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                e['eng_name'],
                maxLines: 2,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                e['address'],
                maxLines: 1,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
