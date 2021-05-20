import 'package:app1/screens/conversation.dart';
import 'package:app1/session/session_management.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app1/models/users.dart';
import 'package:app1/screens/conversation.dart';
import 'package:app1/session/session_management.dart';
import 'package:flutter/material.dart';

class Contacts extends StatefulWidget {
  const Contacts({Key key}) : super(key: key);

  @override
  _ContactsState createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  String _currentUserID;
  CollectionReference reference =
      FirebaseFirestore.instance.collection('users');

  List<User> _usersList = [];

  @override
  void initState() {
    super.initState();
    SessionManagement.getLoggedInUID().then((value) {
      setState(() {
        _currentUserID = value;
      });
    });
    createContactList();
  }

  @override
  Widget build(BuildContext context) {
    if (_usersList.length > 0) {
      return ListView.builder(
        itemCount: _usersList.length,
        itemBuilder: (context, index) {
          return Wrap(
            children: [
              ListTile(
                leading: _usersList[index].imageURL == ''
                    ? Icon(Icons.person)
                    : CircleAvatar(
                        backgroundImage:
                            NetworkImage(_usersList[index].imageURL)),
                title: Text(_usersList[index].name),
                subtitle: Text(_usersList[index].desc),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) =>
                        ConversationScreen(user: _usersList[index]),
                  ),
                ),
              ),
              Divider(
                indent: 15,
                endIndent: 15,
                height: 5,
                color: Colors.purple,
              ),
            ],
          );
        },
      );
    } else {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  void createContactList() async {
    await reference.get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs
          .where((element) => _currentUserID != element.id)
          .forEach((DocumentSnapshot doc) {
        User user = User(
          name: doc['name'],
          email: doc['email'],
          imageURL: doc['image'],
          desc: doc['desc'],
        );
        _usersList.add(user);
      });
    }).catchError((onError) => print(onError));
  }
}