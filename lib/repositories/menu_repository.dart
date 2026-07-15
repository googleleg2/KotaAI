import '../models/ingredient.dart';

class MenuRepository {
  const MenuRepository();

  Future<List<Ingredient>> loadMenu() async {
    return [
      const Ingredient(
        id: 'cheese',
        name: 'Cheese',
        price: 8,
        imagePath: 'assets/images/ingredients/cheese.png',
        width: 170,
        stackHeight: 10,
      ),
      const Ingredient(
        id: 'egg',
        name: 'Egg',
        price: 10,
        imagePath: 'assets/images/ingredients/egg.png',
        width: 180,
        stackHeight: 18,
      ),
      const Ingredient(
        id: 'polony',
        name: 'French Polony',
        price: 12,
        imagePath: 'assets/images/ingredients/polony.png',
        width: 180,
        stackHeight: 15,
      ),
      const Ingredient(
        id: 'vienna',
        name: 'Vienna',
        price: 15,
        imagePath: 'assets/images/ingredients/vienna.png',
        width: 190,
        stackHeight: 20,
      ),
      const Ingredient(
        id: 'russian',
        name: 'Russian',
        price: 20,
        imagePath: 'assets/images/ingredients/russian.png',
        width: 210,
        stackHeight: 30,
      ),
    ];
  }
}