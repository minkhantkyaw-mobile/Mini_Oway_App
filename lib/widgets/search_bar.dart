import 'package:flutter/material.dart';

class searchBar extends StatelessWidget {
  const searchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.only(left: 8, right: 8, bottom: 10, top: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextFormField(
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Search...',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
          ),
          //For Notification Icon
          // Padding(
          //   padding: const EdgeInsets.only(left: 10),
          //   child: InkWell(
          //     onTap: () {},
          //     child: SizedBox(
          //       width: 50,
          //       height: 50,
          //       child: ClipRRect(
          //         borderRadius: BorderRadius.circular(50),
          //         child: Image.asset(
          //           "assets/images/person.jpg",
          //           fit: BoxFit.cover,
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
