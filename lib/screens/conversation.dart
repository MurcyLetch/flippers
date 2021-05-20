import 'package:app1/models/users.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ConversationScreen extends StatefulWidget {
  static const ROUTE_CONV = "/conversation";

  const ConversationScreen({Key key, @required this.user}) : super(key: key);

  final User user;

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            widget.user.imageURL == ''
                ? Icon(Icons.person)
                : CircleAvatar(
                    backgroundImage: NetworkImage(widget.user.imageURL),
                  ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Text(widget.user.name),
            ),
          ],
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 18.0),
          child: GestureDetector(
            child: Icon(Icons.arrow_back_ios),
            onTap: () => Navigator.pop(context),
          ),
        ),
        leadingWidth: 30,
      ),
      body: Container(),
    );
  }
}