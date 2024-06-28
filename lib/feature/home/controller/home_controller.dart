import 'dart:convert';

import 'package:dishes/model/dishes_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repository/home_repository.dart';
final getDishesProvider=FutureProvider.autoDispose((ref) {

  return ref.read(homeControllerProvider).getDishes();
} );
final getCurrentDishesProvider=FutureProvider.autoDispose.family((ref,String search) {

  return ref.read(homeControllerProvider).getCurrentDishes(search: search);
} );
final getFavouriteDishesProvider=FutureProvider.autoDispose.family((ref,List wishlist) {

  return ref.read(homeControllerProvider).getFavouriteDishes(favourite: wishlist,);
} );
final homeControllerProvider=Provider((ref) => HomeController(homeRepository: ref.read(homeRepositoryProvider)));
class HomeController{
  final HomeRepository _homeRepository;
  HomeController({required HomeRepository homeRepository}):_homeRepository=homeRepository;
  Future<List<Dishes>> getDishes()async {
    return _homeRepository.getDishes();
  }
  Future<List<Dishes>> getCurrentDishes({required String search})async {
    return _homeRepository.getCurrentDishes(search: search);
  }
  Future<List<Dishes>> getFavouriteDishes({required List favourite})async {
    return _homeRepository.getFavouriteDishes(favourites: favourite);
  }
}