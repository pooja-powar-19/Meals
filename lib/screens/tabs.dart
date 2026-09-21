import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals/providers/favorites_provider.dart';
import 'package:meals/providers/filters_provider.dart';
import 'package:meals/screens/categories.dart';
import 'package:meals/screens/filters.dart';
import 'package:meals/screens/meals.dart';
import 'package:meals/widgets/main_drawer.dart';

const kInitialFilters = { //here k at initial ia naming convention probably used for defining global vars
    Filter.glutenFree: false,
    Filter.lactoseFree: false,
    Filter.vegeterian:false,
    Filter.veganFree:false
};

class TabsScreen extends ConsumerStatefulWidget { //Removed StatefulWidget and added ConsumerStatefulWidget(riverpod) since i am using provider on this screen
  const TabsScreen({super.key});

  @override
  ConsumerState<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  int _selectedPageIndex = 0;
  //final List<Meal> _favoriteMeals = [];
 // Map<Filter, bool> _selectedFilters = kInitialFilters;

  // void _showInfoMessage(String message) {
  //   ScaffoldMessenger.of(context).clearSnackBars();
  //   ScaffoldMessenger.of(
  //     context,
  //   ).showSnackBar(SnackBar(content: Text(message)));
  // }

  // void _toggleMeakFavoriteStatus(Meal meal) {
  //   final isExisting = _favoriteMeals.contains(meal);

  //   if (isExisting) {
  //     setState(() {
  //       _favoriteMeals.remove(meal);
  //       _showInfoMessage('Meal is no longer favorite');
  //     });
  //   } else {
  //     setState(() {
  //       _favoriteMeals.add(meal);
  //       _showInfoMessage('Marked as favorite!');
  //     });
  //   }
  // }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void _setScreen(String identifier) async {
    Navigator.of(context).pop(); //close the drawer
    if (identifier == 'filters') {
      // Navigator.of(
      //   context,
      // ).push(MaterialPageRoute( //.pushreplacement basicLLy avoid from going back it removes that
      //   builder: (ctx) => const FilterScreen())
      //   );
      final result = await Navigator.of(context).push<Map<Filter, bool>>( //here Map is collection of key-value pairs, so Filter(enum defined in filter screen) is Key and bool is value
        MaterialPageRoute(
          //.pushreplacement basicLLy avoid from going back it removes that
          builder: (ctx) => FilterScreen(),
        ),
      );
      // setState(() {
      //    _selectedFilters = result ?? kInitialFilters;
      // }); 
     
    }
  }

  @override
  Widget build(BuildContext context) {

   // final meals = ref.watch(mealsProvider);
   // final activeFilters = ref.watch(filterProvider);
    final avialabledMeals = ref.watch(filterMealsProvider);

    //final avialabledMeals = 
    // meals.where((meal) { //used using riverpod provider
    //   if (activeFilters[Filter.glutenFree]! && !meal.isGlutenFree) {
    //     return false;
    //   }
    //   if (activeFilters[Filter.lactoseFree]! && !meal.isLactoseFree) {
    //     return false;
    //   }
    //   if (activeFilters[Filter.vegeterian]! && !meal.isVegetarian) {
    //     return false;
    //   }
    //   if (activeFilters[Filter.veganFree]! && !meal.isVegan) {
    //     return false;
    //   }
    //   return true;
    // }).toList();


    Widget activePage = CategoriesScreen(
      //onToggleFavorites: _toggleMeakFavoriteStatus,
      avialabledMeals:avialabledMeals
    );
    var activePageTitle = 'Categories';

    if (_selectedPageIndex == 1) {
      final favoriteMeals = ref.watch(favoriteMealsProvider);
      activePageTitle = 'Favorites';
      activePage = MealsScreen(
        meals: favoriteMeals,
        //onToggleFavorites: _toggleMeakFavoriteStatus,
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(activePageTitle)),
      body: activePage,
      drawer: MainDrawer(onSelectScreen: _setScreen),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.set_meal),
            label: 'Category',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Favorites'),
        ], //list of tabs
      ),
    );
  }
}
