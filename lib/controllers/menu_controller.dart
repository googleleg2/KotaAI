import 'package:flutter/material.dart';

import '../models/ingredient.dart';
import '../repositories/menu_repository.dart';

class MenusController extends ChangeNotifier {
  final MenuRepository _repository =
      const MenuRepository();

  final List<Ingredient> _menu = [];

  List<Ingredient> get menu => _menu;

  Future<void> loadMenu() async {
    _menu.clear();

    _menu.addAll(
      await _repository.loadMenu(),
    );

    notifyListeners();
  }
}