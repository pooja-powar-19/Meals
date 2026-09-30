
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals/model/meal.dart';
import 'package:meals/providers/favorites_provider.dart';

class MealDetailsScreen extends ConsumerWidget{
  const MealDetailsScreen({
    super.key,
    required this.meal,
   // required this.onToggleFavorites
  });

  final Meal meal;
 // final void Function(Meal meal) onToggleFavorites;

  @override
  Widget build(BuildContext context, WidgetRef ref) { //added WidgetRef since ref for riverpod is not easily accessible like statefullwidget
  final favoriteMeals = ref.watch(favoriteMealsProvider);
  final isFavorite = favoriteMeals.contains(meal);


   return Scaffold(
    appBar: AppBar(
      title:Text(meal.title),
      actions: [
        IconButton(
        onPressed: (){
         final wasAdded = ref.read(favoriteMealsProvider.notifier).toggleMealFavoriteStatus(meal);//riverpod
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(wasAdded ? 'Meal added as favorite' : 'Meal removed from favorites')));

          //onToggleFavorites(meal);
        }, 
        
        icon: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Icon(isFavorite ? Icons.star : Icons.star_border, key: ValueKey(isFavorite)), //by adding key it will understand there is change and need to animate
          transitionBuilder: (child,animation){
            return RotationTransition(
              //turns:animation
              turns: Tween(
                begin: 0.5,
                end:1.0
              ).animate(animation),
              child: child,
            );
          },
          
        ),
        
        ),
      ],
    ),
    body: SingleChildScrollView(
      child: Column(
        children: [
          Hero(
            tag: meal.id, 
            child:  Image.network(
            meal.imageUrl,
            width: double.infinity,
            height: 300,
            fit: BoxFit.cover,
            ),
            ),
         
            const SizedBox(height: 14,),
            Text('Ingridents', style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold
            ),
            ),
            const SizedBox(height: 14,),
            for(final ingredient in meal.ingredients)
              Text(
                ingredient,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Theme.of(context).colorScheme.onBackground
            ),
            ),
            const SizedBox(height: 24,),
             Text('Steps', style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold
            ),
            ),
            for(final step in meal.steps)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 12),
                child: Text(
                  step,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                          ),
                          ),
              ),
        ],
      ),
    ),
   );
  }
}