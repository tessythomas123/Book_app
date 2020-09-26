import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:read_app/models/user.dart';

class AuthenticationService {
  User usr = new User();
  final String url1 =
      "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=####SyDIiFA6T4r0S4ai6fWzbFPsjPnRNqgh7gE";
  final String url2 =
      "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=####SyDIiFA6T4r0S4ai6fWzbFPsjPnRNqgh7gE";
  final String userUrl =
      "https://firestore.googleapis.com/v1beta1/projects/book-store-c9fd2/databases/(default)/documents/Users";
  final String key = '?key=####SyDIiFA6T4r0S4ai6fWzbFPsjPnRNqgh7gE';
  Future<dynamic> loginWithEmailAndPassword(
      String email, String password) async {
    var response = await http.post(url1, body: {
      "email": email,
      "password": password,
      "returnSecureToken": "true"
    });
    if (response.statusCode == 200) {
      var responseDecode = jsonDecode(response.body);
      print(responseDecode["localId"].toString());
      var res = await http
          .get(userUrl + '/' + responseDecode["localId"].toString() + key);
      var item = jsonDecode(res.body);
      usr.email = item['fields']['Email']['stringValue'].toString();
      usr.uid = item['fields']['Uid']['stringValue'].toString();
      usr.name = item['fields']['Name']['stringValue'].toString();
      usr.image = item['fields']['Uimage']['stringValue'].toString();
      return usr;
    }
    return response.statusCode;
  }

  Future<dynamic> registerWithEmailAndPassword(
      String email, String password, String name, File imageFile) async {
    var regresponse = await http.post(url2, body: {
      "email": email,
      "password": password,
      "returnSecureToken": "true"
    });
    var reg = jsonDecode(regresponse.body);
    if (regresponse.statusCode == 200) {
      final bytes = await imageFile.readAsBytes();
      String uimage = base64.encode(bytes);
      http.Response res =
          await http.post(userUrl + "?documentId=" + reg["localId"].toString(),
              body: jsonEncode({
                "fields": {
                  "Uid": {"stringValue": reg["localId"]},
                  "Name": {"stringValue": name},
                  "Uimage": {"stringValue": uimage},
                  "Email": {"stringValue": email}
                },
              }));
      if (res.statusCode == 200) {
        usr.email = email;
        usr.uid = reg["localId"].toString();
        usr.name = name;
        usr.image = uimage;
        return usr;
      } else {
        return res.statusCode;
      }
    } else {
      return 400;
    }
  }
}
