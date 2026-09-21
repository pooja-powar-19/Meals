

import 'package:flutter_riverpod/legacy.dart';
import 'package:meals/model/meal.dart';

class FavoriteMealsNotifier extends StateNotifier<List<Meal>>{ //here <List<Meal>> means this notifier class will deal with List of Meals
  FavoriteMealsNotifier() : super([]); //initial data [];

  bool toggleMealFavoriteStatus(Meal meal){
    final mealIsFavorite = state.contains(meal);
    if(mealIsFavorite){
      state = state.where((m) => m.id != meal.id).toList(); //since we cannot use .add or .remove directly in provider
      return false;
    }else{
      state = [...state,meal];//use spread operator insetad of .add();
      return true;
    }
  }
}

final favoriteMealsProvider = StateNotifierProvider<FavoriteMealsNotifier,List<Meal>>((ref){
  return FavoriteMealsNotifier();
});