import '../custom_widgets/chats.dart';
import '../custom_widgets/contacts.dart';
import '../custom_widgets/profile.dart';
class LocalData{
  static List<Map<String,String>> pagerList=[
    {
      'image': 'assets/images/chat1.jpg',
      'title': 'Send & Recieve Messages',
    },
    {
      'image': 'assets/images/chat2.jpg',
      'title': 'Be Connected',
    },
    {
      'image': 'assets/images/chat3.jpg',
      'title': 'Enjoy Messaging',
    },
    {
      'image': 'assets/images/chat4.png',
      'title': 'Lets Gossip ^_^ ',
    },
  ];
  static List<Map<String, dynamic>> bottomNavList = [
    {
      'screen': Chats(),
      'title': 'Chats'
    }, {
      'screen': Contacts(),
      'title': 'Contacts'
    }, {
      'screen': Profile(),
      'title': 'Profile'
    },
  ];
}