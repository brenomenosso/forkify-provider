import 'package:flutter/material.dart';
import 'package:forky_app_provider/database/localstorage_database.dart';
import 'package:forky_app_provider/fp/either.dart';
import 'package:forky_app_provider/model/dishe.dart';
import 'package:forky_app_provider/repositories/dishe_repository_impl.dart';

class DisheProvider extends ChangeNotifier {
  final repository = DisheRepositoryImpl();

  bool isLoading = false;
  bool isLoadingFavorites = false;

  final List<Dishes> _dishes = [];
  final List<Dishes> _dishesFavorites = [];
  final ValueNotifier<bool> _isLogged = ValueNotifier(false);

  List<Dishes> get dishes => _dishes;
  List<Dishes> get dishesFavorites => _dishesFavorites;

  Future<void> getDishes(String food) async {
    isLoading = true;
    notifyListeners();

    final result = await repository.getDishes(food);

    switch (result) {
      case Left():
        isLoading = false;
        notifyListeners();
        return;
      case Right(value: List<Dishes> dishe):
        if (_dishes.isNotEmpty) {
          _dishes.clear();
        }
        setFavoriteAfterLogin(dishe);
        _isLogged.value = true;
        isLoading = false;
        notifyListeners();
    }
  }

  Future<void> getAllDishes([bool? removeFavorites]) async {
    isLoading = true;
    notifyListeners();

    List<Dishes> newDishesFavorites = [..._dishesFavorites];

    if (_dishes.isEmpty == true) {
      isLoading = false;
      notifyListeners();
      return;
    }

    if (_dishesFavorites.isEmpty == true) {
      _dishesFavorites.clear();
      newDishesFavorites.clear();
      var newList = setAllFavoritesFalase();
      _dishes.clear();
      _dishes.addAll(newList);
      await LocalStorageDatabase().setKey('lastDishe', _dishesFavorites);
      isLoading = false;
      notifyListeners();
    }

    if (_dishesFavorites.isNotEmpty && removeFavorites == true) {

      final listRemoveFavorite = _dishes.map((e) {
        return e.copyWith(isFavorite: false);
      }).toList();

      final list = listRemoveFavorite.map((e) {
        final index = _dishesFavorites
            .indexWhere((element) => element.recipeId == e.recipeId);
        if (index != -1) {
          return e.copyWith(isFavorite: true);
        }
        return e;
      }).toList();

      for (var savedFavorites in _dishesFavorites) {
        final index = _dishesFavorites
            .indexWhere((e) => e.recipeId == savedFavorites.recipeId);
        if (index == -1) {
          newDishesFavorites.remove(savedFavorites);
        }
      }

      _dishes.clear();
      _dishes.addAll(list);
     _dishesFavorites.clear();
     _dishesFavorites.addAll(getFavorites());

      await LocalStorageDatabase().setKey('lastDishe', _dishesFavorites);
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> setFavoriteDishe(Dishes value) async {
    
    isLoading = true;
    notifyListeners();

    final list = _dishes.map((e) {
      if (e.recipeId == value.recipeId) {
        if (e.isFavorite == true) {
          _dishesFavorites
              .removeWhere((element) => element.recipeId == e.recipeId);
        }
        return e.copyWith(isFavorite: !e.isFavorite);
      }
      return e;
    }).toList();

    _dishes.clear();
    _dishes.addAll(list);
    //aqui mudar
    _dishesFavorites.clear();
    _dishesFavorites.addAll(getFavorites());

    await LocalStorageDatabase().setKey('lastDishe', _dishesFavorites);
    isLoading = false;
    notifyListeners();
  }

  List<Dishes> getFavorites() {

    List<Dishes> newDishesFavorites = [..._dishesFavorites];

    if (_dishes.isEmpty) {
      return _dishesFavorites;
    }

    var list = _dishes.where((element) => element.isFavorite).toList();
    for (var element in list) {
      final index =
          _dishesFavorites.indexWhere((e) => e.recipeId == element.recipeId);
      if (index == -1) {
        newDishesFavorites.add(element);
      }
    }
    return newDishesFavorites;
  }

  Future<void> getInitialDishes(String food) async {

    isLoading = true;
    notifyListeners();

    final result = await repository.getDishes(food);
    switch (result) {
      case Left():
        isLoading = false;
        notifyListeners();
        return;
      case Right(value: List<Dishes> dishe):
        if (_dishes.isNotEmpty) {
          _dishes.clear();
        }
        setFavoriteAfterLogin(dishe);
        _isLogged.value = true;
        isLoading = false;
        notifyListeners();
    }
  }

  setFavoriteAfterLogin(List<Dishes> recipes) {
    var result = recipes.map((element) {
      final index =
          _dishesFavorites.indexWhere((e) => e.recipeId == element.recipeId);
      if (index != -1) {
        return element.copyWith(isFavorite: true);
      }
      return element;
    }).toList();
    _dishes.addAll(result);
  }

  Future<void> getDishesLocalStorage() async {
    isLoading = true;
    notifyListeners();
    
    final result = await LocalStorageDatabase().getKey('lastDishe');
    if (result != null) {
      for (var element in result) {
        _dishesFavorites.add(Dishes.fromJson(element));
      }
      _isLogged.value = true;
    }
    isLoading = false;
    notifyListeners();
  }

  void removeFavoriteDishe(Dishes value) {
    isLoadingFavorites = false;

    _dishes.map((e) {
      if (e.recipeId == value.recipeId) {
        return e.copyWith(isFavorite: !e.isFavorite);
      }
      return e;
    }).toList();

    _dishesFavorites.removeWhere((element) => element.recipeId == value.recipeId);
    isLoadingFavorites = true;
    notifyListeners();
  }

  List<Dishes> setAllFavoritesFalase() {
    return _dishes.map((e) {
      return e.copyWith(isFavorite: false);
    }).toList();
  }
}
