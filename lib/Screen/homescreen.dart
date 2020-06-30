import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import './cartscreen.dart';
import './catagory.dart';
import './profile.dart';
import '../Widgets/circlecontainer.dart';
import './detailscreen.dart';
import './about.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Model/food.dart';
class HomeScreen extends StatefulWidget {
  _HomeScreenState createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  Food food;
  String userImage;
  Widget container({String image, String tittle, Function onClick, context}) {
    return Padding(
      padding: EdgeInsets.only(top: 60),
      child: GestureDetector(
        onTap: onClick,
        child: Container(
          margin: EdgeInsets.only(right: 10, left: 10),
          height: 170,
          width: 150,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 3,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                child: Image.asset(image, width: 70),
              ),
              SizedBox(
                height: 20,
              ),
              Text(tittle,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
            ],
          ),
        ),
      ),
    );
  }

  Widget draver({IconData icon, String tittle, Function whenpress, context}) {
    return Container(
      margin: EdgeInsets.only(
        left: 15,
        right: 15,
      ),
      height: MediaQuery.of(context).size.height * 0.1 - 5,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        onTap: whenpress,
        leading: Icon(icon),
        title: Padding(
          padding: EdgeInsets.only(
              left: MediaQuery.of(context).viewPadding.left + 30),
          child: Text(
            tittle,
            style: TextStyle(fontSize: 19),
          ),
        ),
      ),
    );
  }
  @override
  void initState() {
    super.initState();
    Firestore.instance
        .collection("food")
        .document('uWdh10cVO6bZNDb9OYh0')
        .snapshots()
        .listen(
      (event) {
        setState(() {
          food = Food(
            price: event['foodPrice'],
            image: event['image'],
            foodsubTittle: event['foodsubTittle'],
            foodName: event['foodName'],
            ratting: event['ratting'],
          );
        });
      },
    );
    Firestore.instance
        .collection("user")
        .document('EVnNyZyfTVSnmllvmey9ByXrNa73')
        .snapshots()
        .listen(
      (event) {
        setState(() {
         userImage=event["image Url"];
        });
      },
    );
  }
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: SafeArea(
          child: Container(
            color: Color(0xfff8f8f8),
            child: Column(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(width: 1.0, color: Colors.grey),
                      ),
                      color: Colors.white),
                  child: Center(
                      child: Text(
                    "Tastee",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 30),
                  )),
                ),
                draver(
                  context: context,
                  icon: Icons.home,
                  tittle: "Home",
                  whenpress: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => HomeScreen()));
                  },
                ),
                draver(
                  context: context,
                  icon: Icons.add_shopping_cart,
                  tittle: "Cart",
                  whenpress: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => CartScreen()));
                  },
                ),
                draver(
                    context: context,
                    icon: Icons.location_on,
                    tittle: "Address"),
                draver(
                    context: context,
                    icon: Icons.notifications,
                    tittle: "Notification"),
                draver(
                  context: context,
                  icon: Icons.perm_identity,
                  tittle: "Profile",
                  whenpress: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => Profile()));
                  },
                ),
                draver(
                    context: context,
                    icon: Icons.perm_identity,
                    tittle: "Order"),
                draver(
                  context: context,
                  icon: Icons.info_outline,
                  tittle: "About",
                  whenpress: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) => About()));
                  },
                ),
                draver(context: context, icon: Icons.call, tittle: "Contact"),
                draver(
                  context: context,
                  icon: Icons.exit_to_app,
                  tittle: "Logout",
                  whenpress: () {
                    FirebaseAuth.instance.signOut();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Theme.of(context).primaryColor,
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.notifications,
                size: 33,
              ),
              onPressed: () {
                Firestore.instance
                    .collection('food')
                    .snapshots()
                    .listen((event) {
                  event.documents.forEach((element) {
                    print(element["foodtitle"]);
                  });
                });
              })
        ],
      ),
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  width: double.infinity,
                  color: Theme.of(context).primaryColor,
                  child: Container(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 50),
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      // color: Colors.red,
                      child: Row(
                        children: <Widget>[
                          CircleAvatar(
                            maxRadius: 50,
                            backgroundColor: Colors.white,
                            child: CircleAvatar(
                              maxRadius: 46,
                              backgroundImage: NetworkImage(userImage),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Have you upset",
                                style: TextStyle(
                                    fontSize: 22,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).viewPadding.top *
                                    0.2,
                              ),
                              Text(
                                "stomatch?",
                                style: TextStyle(
                                    fontSize: 22,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  color: Color(0xfff2f2f2),
                  width: double.infinity,
                  child: Column(
                    children: <Widget>[
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: <Widget>[
                            container(
                                context: context,
                                image: "images/pizza.png",
                                tittle: "Pizza",
                                onClick: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => Catagory()));
                                }),
                            container(
                                context: context,
                                image: "images/salads.png",
                                tittle: "Salads",
                                onClick: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => Catagory()));
                                }),
                            container(
                                context: context,
                                image: "images/pasta.png",
                                tittle: "Food",
                                onClick: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => Catagory()));
                                }),
                          ],
                        ),
                      ),
                      Container(
                        height: 60,
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Featured",
                              style: TextStyle(
                                  color: Color(0xff04d4ee),
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "View All",
                              style: TextStyle(
                                  color: Color(0xff04d4ee), fontSize: 19),
                            ),
                          ],
                        ),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: <Widget>[
                            CircleContainer(
                              image: food.image,
                              text: food.foodName,
                              subtext: food.foodsubTittle,
                              price: food.price,
                              ratting: food.ratting,
                              onPress: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => DetailScreen(
                                          foodName: food.foodName,
                                          image: food.image,
                                          price: food.price,
                                          foodsubtittle: food.foodsubTittle,
                                        )));
                              },
                            ),
                            CircleContainer(
                              image: food.image,
                              text: food.foodsubTittle,
                              subtext: food.foodsubTittle,
                              price: food.price,
                              ratting: food.ratting,
                              onPress: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => DetailScreen(
                                          foodName: food.foodName,
                                          image: food.image,
                                          price: food.price,
                                          foodsubtittle: food.foodsubTittle,
                                        )));
                              },
                            ),
                            CircleContainer(
                              image: food.image,
                              text: food.foodName,
                              subtext: food.foodsubTittle,
                              price: food.price,
                              ratting: food.ratting,
                              onPress: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => DetailScreen(
                                          foodName: food.foodName,
                                          image: food.image,
                                          price: food.price,
                                          foodsubtittle: food.foodsubTittle,
                                        )));
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: 155,
            left: 20,
            right: 20,
            child: Container(
              child: TextField(
                decoration: InputDecoration(
                  suffixIcon: Icon(
                    Icons.search,
                    color: Theme.of(context).primaryColor,
                  ),
                  hintText: 'Want to search anything',
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide.none),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide.none),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
