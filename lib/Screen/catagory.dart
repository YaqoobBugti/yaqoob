import 'package:flutter/material.dart';
import './homescreen.dart';
import '../Widgets/circlecontainer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Model/food.dart';

class Catagory extends StatefulWidget {
  @override
  _CatagoryState createState() => _CatagoryState();
}

class _CatagoryState extends State<Catagory> {
  Food pastaFood;
  Food chickenFood;
  @override
  void initState() {
    super.initState();
    setState(() {
      Firestore.instance
          .collection("catagory")
          .document('vegetable')
          .collection("pasta Cheese")
          .document("1NAr8vMXrRstsTOc9wxU")
          .snapshots()
          .listen(
        (event) {
          setState(() {
            pastaFood = Food(
              price: event['price'],
              image: event['image'],
              foodsubTittle: event['foodsubTittle'],
              foodName: event['foodName'],
              ratting: event['ratting'],
            );
          });
        },
      );
       Firestore.instance
          .collection("catagory")
          .document('vegetable')
          .collection("Chicken")
          .document("paX2ogIfclxPfcFKsjRy")
          .snapshots()
          .listen(
        (event) {
          setState(() {
            chickenFood = Food(
              price:event['price'],
              image:event['image'],
              foodsubTittle:event['foodsubTittle'],
              foodName:event['foodName'],
              ratting:event['ratting'],
            );
          });
        },
      );
    });
  }
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Piza",
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => HomeScreen()));
            }),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.shopping_cart,
                color: Colors.black,
              ),
              onPressed: () {})
        ],
      ),
      body: ListView(children: <Widget>[
        GestureDetector(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    CircleContainer(
                      image: pastaFood.image,
                      text: pastaFood.foodName,
                      subtext:pastaFood.foodsubTittle,
                      price:pastaFood.price,
                      ratting:pastaFood.ratting,
                    ),
                    CircleContainer(
                      image:chickenFood.image,
                      text:chickenFood.foodName,
                      subtext:chickenFood.foodsubTittle,
                      price:chickenFood.price,
                      ratting:chickenFood.ratting,
                      onPress:(){},
                    ),
                    
                  ],
                ),
                Row(
                  children: <Widget>[
                     CircleContainer(
                      image: pastaFood.image,
                      text: pastaFood.foodName,
                      subtext:pastaFood.foodsubTittle,
                      price:pastaFood.price,
                      ratting:pastaFood.ratting,
                    ),
                    CircleContainer(
                      image:chickenFood.image,
                      text:chickenFood.foodName,
                      subtext:chickenFood.foodsubTittle,
                      price:chickenFood.price,
                      ratting:chickenFood.ratting,
                      onPress:(){},
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                     CircleContainer(
                      image: pastaFood.image,
                      text: pastaFood.foodName,
                      subtext:pastaFood.foodsubTittle,
                      price:pastaFood.price,
                      ratting:pastaFood.ratting,
                    ),
                    CircleContainer(
                      image:chickenFood.image,
                      text:chickenFood.foodName,
                      subtext:chickenFood.foodsubTittle,
                      price:chickenFood.price,
                      ratting:chickenFood.ratting,
                      onPress:(){},
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                     CircleContainer(
                      image: pastaFood.image,
                      text: pastaFood.foodName,
                      subtext:pastaFood.foodsubTittle,
                      price:pastaFood.price,
                      ratting:pastaFood.ratting,
                    ),
                    CircleContainer(
                      image:chickenFood.image,
                      text:chickenFood.foodName,
                      subtext:chickenFood.foodsubTittle,
                      price:chickenFood.price,
                      ratting:chickenFood.ratting,
                      onPress:(){},
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
