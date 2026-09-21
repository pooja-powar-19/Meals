import 'package:flutter/material.dart';
import 'package:meals/data/dummy_data.dart';
import 'package:meals/model/category.dart';
import 'package:meals/model/meal.dart';
import 'package:meals/screens/meals.dart';
import 'package:meals/widgets/category_grid_item.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key,required this.avialabledMeals});//required this.onToggleFavorites,

 //final void Function(Meal meal) onToggleFavorites;
 final List<Meal> avialabledMeals;

  void _selectCategory(BuildContext context, Category category ) {
    final filteredMeals = avialabledMeals
    .where((meal) => meal.categories.contains(category.id))
    .toList();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => MealsScreen(
          title: category.title,
           meals: filteredMeals,
           //onToggleFavorites:onToggleFavorites
           ),
      ),
    ); //Navigator.push(context, route)
  }

  @override
  Widget build(BuildContext context) {
    return GridView(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
        children: [
          for (final category in availableCategories)
            CategoryGridItem(
              category: category,
              onSelectCategory: (){
                _selectCategory(context,category);
              }
              ),
        ],
      );
   
  }
}
