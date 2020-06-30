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
  @override
  _ProfileState createState() => _ProfileState();
}
class _ProfileState extends State<Profile> {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController address = TextEditingController();
  User classuser;
  File _image;
  String userImage;
  bool edit = false;
  Future getImage() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.camera);
    setState(() {
      _image = File(pickedFile.path);
    });
  }
  
  void inputData() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final uid = user.uid;
     print(uid.toString());
    Firestore.instance.collection("user").document(uid).snapshots().listen(
      (event) {
        print(event["username"]);
        userImage=event["image Url"];
       
        setState(
          () {
            classuser = User(
              address: event['address'],
              contect: event['contect'],
              email: event['email'],
              fullname: event['username'],
              gender:event["gender"],
              image: null,
              password: "a",
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

  @override
  Widget build(BuildContext context) {
    email=TextEditingController(text:classuser.email);
     name=TextEditingController(text:classuser.fullname);
      phone=TextEditingController(text:classuser.contect);
       address=TextEditingController(text:classuser.address);
    return Scaffold(
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
                              whenpress: () {},
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
                        : FileImage(_image), //image == null ?//:FileImage(image),
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
