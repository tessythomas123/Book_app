import 'package:flutter/foundation.dart';

class User extends ChangeNotifier {
  String uid = "";
  String email = "";
  String name = "";
  String image = "";
  void setUser(userId, uemail, uname, uimage) {
    uid = userId;
    email = uemail;
    name = uname;
    image = uimage;
    notifyListeners();
  }

  String getUserId() {
    return uid;
  }

  String getUserEmail() {
    return email;
  }

  String getUserName() {
    return name;
  }

  String getUserImage() {
    return image;
  }
}
