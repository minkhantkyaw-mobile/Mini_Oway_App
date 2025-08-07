import 'package:flutter/material.dart';
import 'package:project_one/models/category_model.dart';

class CategorySelection extends StatefulWidget {
  const CategorySelection({super.key});

  @override
  State<CategorySelection> createState() => _CategorySelectionState();
}

class _CategorySelectionState extends State<CategorySelection> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [categorySelected(context), OurProduct()]);
  }

  SizedBox categorySelected(BuildContext context) {
    return SizedBox(
      height: 100,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        itemCount: categoryModel1.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [BoxShadow(color: Colors.black38, blurRadius: 4)],
              ),
              width: 150,
              child: Image.asset(
                categoryModel1[index].image,
                fit: BoxFit.contain,
                height: 120,
                width: 200,
              ),
            ),
          );
        },
      ),
    );
  }
}

Padding OurProduct() {
  return Padding(
    padding: const EdgeInsets.only(top: 15, left: 8, right: 10),
    child: Row(
      children: [
        Text(
          "Popular Places",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        Expanded(child: Container()),

      ],
    ),
  );
}
