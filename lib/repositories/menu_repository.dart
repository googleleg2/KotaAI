import '../models/ingredient.dart';

class MenuRepository {
  const MenuRepository();

  Future<List<Ingredient>> loadMenu() async {
    return const [
      Ingredient(
        id: 'cheese',
        name: 'Cheese',
        price: 8,
        imagePath: 'assets/images/ingredients/cheese.png',
      ),
      Ingredient(
        id: 'egg',
        name: 'Egg',
        price: 10,
        imagePath: 'assets/images/ingredients/egg.png',
      ),
      Ingredient(
        id: 'polony',
        name: 'Polony',
        price: 12,
        imagePath: 'assets/images/ingredients/polony.png',
      ),
      Ingredient(
        id: 'vienna',
        name: 'Vienna',
        price: 15,
        imagePath: 'assets/images/ingredients/vienna.png',
      ),
      Ingredient(
        id: 'russian',
        name: 'Russian',
        price: 20,
        imagePath: 'assets/images/ingredients/russian.png',
      ),
      Ingredient(
        id: 'bacon',
        name: 'Bacon',
        price: 20,
        imagePath: 'assets/images/ingredients/bacon.png',
      ),
    ];
  }
}