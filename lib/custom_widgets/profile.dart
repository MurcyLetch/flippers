import 'dart:io';
import 'package:app1/session/session_management.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Profile extends StatefulWidget {
  const Profile({Key key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  File _profileImage;
  String userId;
  CollectionReference reference =
      FirebaseFirestore.instance.collection('users');

  @override
  void initState() {
    super.initState();
    SessionManagement.getLoggedInUID().then((value) {
      setState(() {
        userId = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        fit: StackFit.loose,
        alignment: AlignmentDirectional.bottomEnd,
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey,
            backgroundImage: _profileImage == null
                ? NetworkImage(
                    "https://k2partnering.com/wp-content/uploads/2016/05/Person.jpg")
                : FileImage(_profileImage),
            radius: 80,
          ),
          FloatingActionButton(
            onPressed: showModal,
            child: Icon(Icons.edit),
          ),
        ],
      ),
    );
  }

  void editPicture(ImageSource imageSource) async {
    final pickedFile = await ImagePicker().getImage(source: imageSource);
    setState(() {
      if (pickedFile != null) {
        _profileImage = File(pickedFile.path);
        storeInServer();
      } else {
        print("No Image Selected");
      }
    });
  }

  void showModal() {
    showModalBottomSheet(
        context: context,
        builder: (build) {
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  child: Icon(Icons.camera_alt, size: 50),
                  onTap: () {
                    editPicture(ImageSource.camera);
                    Navigator.pop(build);
                  },
                ),
                InkWell(
                  child: Icon(Icons.image, size: 50),
                  onTap: () {
                    editPicture(ImageSource.gallery);
                    Navigator.pop(build);
                  },
                )
              ],
            ),
          );
        });
  }

  void updateDB(String imageURL) async {
    Map<String, dynamic> updatedData = {
      'image': imageURL,
    };
    reference
        .doc(userId)
        .update(updatedData)
        .then(
          (_) => notifyUser(context, 'Profile picture updated successfully!'),
        )
        .catchError(
          (onError) => notifyUser(context, onError),
        );
  }

  void storeInServer() async {
    Reference storage = FirebaseStorage.instance.ref('profile-pics/$userId.png');
    await storage
        .putFile(_profileImage)
        .then((_) async {
      String imageURL =
          await storage.getDownloadURL();
      updateDB(imageURL);
    }).catchError((onError) => notifyUser(context, onError));
  }

  void notifyUser(BuildContext context, String s) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(s),
      ),
    );
  }
}