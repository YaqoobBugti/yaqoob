import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:foodtastee/Model/food.dart';
import '../Model/foodcart.dart';

class FoodProvider with ChangeNotifier {
  List<FoodCart> foodcardlist = [];
  FoodCart foodcart;
  List<Food> foodList = [];
  void addFoodCart(
    String foodName,
    String foodType,
    int foodQuntites,
    String foodImage,
    double foodPrice,
  ) {
    foodcart = FoodCart(
        foodName: foodName,
        foodQuantity: foodQuntites,
        foodPrice: foodPrice,
        foodType: foodType,
        foodImage: foodImage);
    foodcardlist.add(foodcart);
  }

  void addFoodList({
    String foodName,
    String foodType,
    String foodimage,
    double foodprice,
  }) {}

  List<FoodCart> get getFoodCart {
    return List.from(foodcardlist);
  }

  int get foodCartLength {
    return foodcardlist.length;
  }

  void delete(int index) {
    foodcardlist.removeAt(index);
    notifyListeners();
  }

  List<Food> get getfoodList {
    return foodList;
  }

  Future<void> getFoodList() async {
    List<Food> newList = [];
    Food food;
    QuerySnapshot allfoodList =
        await Firestore.instance.collection('food').getDocuments();
    allfoodList.documents.forEach((element) {
      food = Food(
        price: element.data['foodPrice'],
        image: element.data['image'],
        foodsubTittle: element.data['foodsubTittle'],
        foodName: element.data['foodName'],
        ratting: element.data['ratting'],
      );
      newList.add(food);
    });
    foodList = newList;
  }
  List<Food> search(String query) {
    List<Food> searchList = foodList.where((element) {
      return 
      element.foodName.toUpperCase().contains(query)||
      element.foodName.toLowerCase().contains(query)||
      element.foodName.toUpperCase().contains(query)&&
      element.foodName.toLowerCase().contains(query)||
      element.foodsubTittle.toLowerCase().contains(query)||
      element.foodsubTittle.toUpperCase().contains(query);
    }).toList();
    return searchList;
  }
}
