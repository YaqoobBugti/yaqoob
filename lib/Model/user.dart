import 'dart:io';
import 'package:flutter/material.dart';
class User{
  String fullname;
  String email;
  String password;
  String  contect;
  String address;
  String gender;
  File image;
  User({@required this.fullname,@required this.email,@required this.contect,@required this.password,@required this.address,@required this.gender,@required this.image});
}