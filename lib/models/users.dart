import 'package:flutter/material.dart';

class User {
  String name, email, desc, imageURL;

  User({
    @required this.name,
    @required this.email,
    @required this.desc,
    @required this.imageURL,
  });

  // get userName => this.name;
  //
  // get userEmail => this.email;
  //
  // get userDesc => this.desc;
  //
  // get userImage => this.imageURL;
}