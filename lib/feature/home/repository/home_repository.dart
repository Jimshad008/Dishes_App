import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dishes/model/dishes_model.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:http/http.dart' as http;
final homeRepositoryProvider=Provider((ref) => HomeRepository());
class HomeRepository{
  Future<List<Dishes>> getDishes() async {
   List<Dishes> dishes=[];

    try {
      // Check for internet connectivity
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        throw Exception('No internet connection');
      }

      final response = await http.get(Uri.parse(
          "https://fls8oe8xp7.execute-api.ap-south-1.amazonaws.com/dev/nosh-assignment"));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        for (var i in data) {
          dishes.add(Dishes.fromMap(i));
        }


      } else {
        throw Exception('Failed to load data');
      }
    } on SocketException {
      throw Exception('No Internet connection');
    } on HttpException {
      throw Exception("Couldn't find the post");
    } on FormatException {
      throw Exception("Bad response format");
    } catch (e) {
      throw Exception( 'Unexpected error: $e');

    }

    return dishes;
  }
  Future<List<Dishes>> getCurrentDishes({required String search}) async {
    List<Dishes> dishes=[];

    try {
      // Check for internet connectivity
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        throw Exception('No internet connection');
      }

      final response = await http.get(Uri.parse(
          "https://fls8oe8xp7.execute-api.ap-south-1.amazonaws.com/dev/nosh-assignment"));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if(search.isEmpty){
          for (var i in data) {
            dishes.add(Dishes.fromMap(i));
          }
        }
        else{
          for (var i in data) {
            if(i["dishName"].toString().toUpperCase().contains(search.toUpperCase())){
              dishes.add(Dishes.fromMap(i));
            }

          }
        }



      } else {
        throw Exception('Failed to load data');
      }
    } on SocketException {
      throw Exception('No Internet connection');
    } on HttpException {
      throw Exception("Couldn't find the post");
    } on FormatException {
      throw Exception("Bad response format");
    } catch (e) {
      throw Exception( 'Unexpected error: $e');

    }

    return dishes;
  }
  Future<List<Dishes>> getFavouriteDishes({required List favourites}) async {
    List<Dishes> dishes=[];

    try {
      // Check for internet connectivity
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        throw Exception('No internet connection');
      }

      final response = await http.get(Uri.parse(
          "https://fls8oe8xp7.execute-api.ap-south-1.amazonaws.com/dev/nosh-assignment"));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

          for (var i in data) {
            if(favourites.contains(i["dishId"])){
              dishes.add(Dishes.fromMap(i));
            }


        }



      } else {
        throw Exception('Failed to load data');
      }
    } on SocketException {
      throw Exception('No Internet connection');
    } on HttpException {
      throw Exception("Couldn't find the post");
    } on FormatException {
      throw Exception("Bad response format");
    } catch (e) {
      throw Exception( 'Unexpected error: $e');

    }

    return dishes;
  }

}