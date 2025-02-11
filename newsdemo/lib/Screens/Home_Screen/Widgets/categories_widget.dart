import 'package:flutter/material.dart';
import 'package:newsdemo/Models/categories.dart';
import 'package:newsdemo/Screens/CategoryList_Screen/category_news.dart';

class CategoryWidget extends StatelessWidget {
  const CategoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final categoryItems = CategoryList().categoryList;
    return ListView.separated(
      shrinkWrap: true,
      itemCount: categoryItems.length,
      itemBuilder: (context, index) {
        return ElevatedButton(
          style: const ButtonStyle(
            minimumSize: MaterialStatePropertyAll(Size(50, 50)),
            backgroundColor: MaterialStatePropertyAll(Colors.black),
          ),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        CategoryNews(category: categoryItems[index])));
          },
          child: Text(
            categoryItems[index],
            style: const TextStyle(
              fontSize: 20,
              color: Colors.white,
              backgroundColor: Colors.black,
            ),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return const Divider(
          color: Colors.white,
        );
      },
    );
  }
}
