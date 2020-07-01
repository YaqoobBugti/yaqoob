import 'package:flutter/material.dart';
import '../Model/user.dart';
import './homescreen.dart';
import '../Widgets/mytextfield.dart';
import '../Widgets/Button.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Profile extends StatefulWidget {
  static Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  static Pattern patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  RegExp regex = RegExp(Profile.pattern);
  RegExp regExp = RegExp(Profile.patttern);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController name;
  TextEditingController email;
  TextEditingController phone;
  TextEditingController address;
  var uid;
  User classuser;
  File _image;
  String userImage;
  bool edit = false;

  Future getImage() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.camera);
    setState(() {
      _image = File(pickedFile.path);
    });
  }

  void inputData() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    uid = user.uid;
    print(uid.toString());
    Firestore.instance.collection("user").document(uid).snapshots().listen(
      (event) {
        print(event["username"]);
        userImage = event["image Url"];

        setState(
          () {
            classuser = User(
              address: event['address'],
              contect: event['contect'],
              email: event['email'],
              fullname: event['username'],
              gender: event["gender"],
              image: null,
              password: null,
            );
          },
        );
      },
    );
  }

  @override
  void initState() {
    inputData();
    super.initState();
  }

  void userDataUpdate()  {
    Firestore.instance
        .collection("user")
        .document(uid)
        .updateData({
      "username": name.text,
      "email": email.text,
      "address": address.text,
      "contect": phone.text,
    });
  }

  function() {
    if (name.text.isEmpty &&
        email.text.isEmpty &&
        phone.text.isEmpty &&
        address.text.isEmpty) {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text('All field is emtpy'),
          backgroundColor: Theme.of(context).primaryColor,
        ),
      );
      return;
    }
    if (name.text.trim().isEmpty || name.text.trim() == null) {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text('Full Name is empty'),
          backgroundColor: Theme.of(context).primaryColor,
        ),
      );
      return;
    }
    if (email.text.trim().isEmpty || email.text.trim() == null) {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text('Email is empty'),
          backgroundColor: Theme.of(context).primaryColor,
        ),
      );
      return;
    } else if (!regex.hasMatch(email.text)) {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text('Please Enter Valid Email'),
          backgroundColor: Theme.of(context).primaryColor,
        ),
      );
      return;
    }
    if (phone.text.trim().isEmpty || phone.text.trim() == null) {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text('phone is empty'),
          backgroundColor: Theme.of(context).primaryColor,
        ),
      );
      return;
    } else if (phone.text.length > 11) {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text('Phone Number Must be eleven'),
          backgroundColor: Theme.of(context).primaryColor,
        ),
      );
      return;
    } else if (!regExp.hasMatch(phone.text)) {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text('Please enter valid mobile number'),
          backgroundColor: Theme.of(context).primaryColor,
        ),
      );
      return;
    }
    if (address.text.trim().isEmpty || address.text.trim() == null) {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text('Address is empty'),
          backgroundColor: Theme.of(context).primaryColor,
        ),
      );
    
    } else {
      setState(() {
        edit = false;
        userDataUpdate();
      });
    }
  }

  Widget textsContainer(String text) {
    return Container(
      height: 65,
      width: double.infinity,
      decoration: BoxDecoration(
          color: Color(0xfffef6fa), borderRadius: BorderRadius.circular(10)),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: TextStyle(color: Colors.grey, fontSize: 22),
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    email = TextEditingController(text: classuser.email);
    name = TextEditingController(text: classuser.fullname);
    phone = TextEditingController(text: classuser.contect);
    address = TextEditingController(text: classuser.address);
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Theme.of(context).primaryColor,
          leading: edit == false
              ? IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    size: 25,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => HomeScreen()));
                  })
              : IconButton(
                  icon: Icon(
                    Icons.close,
                    size: 25,
                  ),
                  onPressed: () {
                    setState(() {
                      edit = false;
                    });
                  }),
          actions: <Widget>[
            IconButton(
                icon: Text(
                  "Edit",
                  style: TextStyle(fontSize: 17),
                ),
                onPressed: () {
                  setState(() {
                    edit = true;
                  });
                })
          ],
          centerTitle: true,
          title: Text(
            "Profiles",
            style: TextStyle(fontSize: 25),
          )),
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  width: double.infinity,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  padding: EdgeInsets.only(left: 20, right: 20, top: 30),
                  child: edit == true
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            MYTextField(
                              hintText: "Brie Larson",
                              obscuretext: false,
                              keyboard: TextInputType.text,
                              controller: name,
                            ),
                            MYTextField(
                              hintText: "BrieLarson@gmail.com",
                              obscuretext: false,
                              keyboard: TextInputType.text,
                              controller: email,
                            ),
                            MYTextField(
                              hintText: "+13257788963",
                              obscuretext: false,
                              keyboard: TextInputType.text,
                              controller: phone,
                            ),
                            textsContainer(classuser.gender),
                            MYTextField(
                              hintText: "16,floor,mountainview,ca,USA",
                              obscuretext: false,
                              keyboard: TextInputType.text,
                              controller: address,
                            ),
                            Container(
                              width: 350,
                            ),
                            Button(
                              buttoncolors: Theme.of(context).primaryColor,
                              textcolor: Colors.white,
                              tittle: "Update",
                              whenpress: () {
                                function();
                              },
                            )
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            textsContainer(classuser.fullname),
                            textsContainer(classuser.email),
                            textsContainer(classuser.contect),
                            textsContainer(classuser.gender),
                            textsContainer(classuser.address),
                          ],
                        ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 140, top: 50),
            child: Stack(
              children: <Widget>[
                CircleAvatar(
                  maxRadius: 80,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    maxRadius: 75,
                    backgroundImage: _image == null
                        ? NetworkImage(userImage)
                        : FileImage(
                            _image), //image == null ?//:FileImage(image),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 125, top: 100),
                  child: edit == true
                      ? CircleAvatar(
                          backgroundColor: Colors.white,
                          child: IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                getImage();
                              }),
                        )
                      : Container(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
