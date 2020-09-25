import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:read_app/home/home.dart';
import 'package:read_app/models/auth.dart';
import 'package:read_app/models/user.dart';

class RegistrationForm extends StatefulWidget {
  @override
  _RegistrationFormState createState() {
    return _RegistrationFormState();
  }
}

class _RegistrationFormState extends State<RegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  String error = "";
  String name = "";
  String email = "";
  String password = "";
  File _imageFile;
  final imagePicker = ImagePicker();

  AuthenticationService _auth = new AuthenticationService();
  dynamic status;

  void initState() {
    super.initState();
  }

  bool validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    return (!regex.hasMatch(value)) ? false : true;
  }

  void _openGallery(BuildContext context) async {
    var picture = File(await imagePicker
        .getImage(source: ImageSource.gallery)
        .then((pickedFile) => pickedFile.path));
    print(picture);
    this.setState(() {
      _imageFile = picture;
    });
    if (_imageFile != null) {
      print(_imageFile);
      Navigator.of(context).pop();
    }
  }

  void _openCamera(BuildContext context) async {
    var picture = File(await imagePicker
        .getImage(source: ImageSource.camera)
        .then((pickedFile) => pickedFile.path));
    this.setState(() {
      _imageFile = picture;
    });
    Navigator.of(context).pop();
  }

  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Choose the image:"),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  GestureDetector(
                    child: Text("Gallery"),
                    onTap: () {
                      _openGallery(context);
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                  ),
                  GestureDetector(
                    child: Text("Camera"),
                    onTap: () {
                      _openCamera(context);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget _imageView() {
    if (_imageFile == null) {
      return Container(
        padding: const EdgeInsets.fromLTRB(0, 10, 5, 10),
        child: Column(
          children: [
            SizedBox(height: 30),
            TextFormField(
                decoration: new InputDecoration(
                    icon: const Icon(Icons.person),
                    hintText: 'Enter Image',
                    labelText: 'Image',
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(12.0),
                      borderSide: new BorderSide(),
                    ))),
            RaisedButton(
              child: Text("Insert Image"),
              textColor: Colors.white,
              color: Colors.blue[900],
              onPressed: () {
                _showChoiceDialog(context);
              },
            )
          ],
        ),
      );
    } else {
      return Padding(
          padding: new EdgeInsets.fromLTRB(
              MediaQuery.of(context).size.width * 0.10,
              MediaQuery.of(context).size.height * 0.10,
              MediaQuery.of(context).size.width * 0.10,
              MediaQuery.of(context).size.height * 0.05),
          child: Image.file(_imageFile,
              width: MediaQuery.of(context).size.width * 0.80,
              height: MediaQuery.of(context).size.height * 0.30));
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return
        //loading? Loading():
        Scaffold(
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 30,
              ),
              Center(
                child: _imageView(),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(0, 20, 5, 0),
                child: TextFormField(
                    decoration: new InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Name',
                      labelText: 'Name',
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(12.0),
                        borderSide: new BorderSide(),
                      ),
                    ),
                    onChanged: (val) {
                      setState(() => name = val);
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter your name';
                      } else {
                        return null;
                      }
                    }),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(0, 20, 5, 0),
                child: TextFormField(
                    decoration: new InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'example@gmail.com',
                      labelText: 'Username',
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(12.0),
                        borderSide: new BorderSide(),
                      ),
                    ),
                    onChanged: (val) {
                      setState(() => email = val);
                    },
                    validator: (value) {
                      if (!validateEmail(value)) {
                        return 'not a valid username';
                      } else {
                        return null;
                      }
                    }),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(0, 20, 5, 0),
                child: TextFormField(
                  decoration: new InputDecoration(
                    icon: const Icon(Icons.lock),
                    hintText: 'Password',
                    labelText: 'Password',
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(12.0),
                      borderSide: new BorderSide(),
                    ),
                  ),
                  obscureText: true,
                  validator: (val) =>
                      val.length < 6 ? 'Enter a password 6+ chars long' : null,
                  onChanged: (val) {
                    setState(() => password = val);
                  },
                ),
              ),
              new Container(
                padding: const EdgeInsets.only(left: 130, top: 40.0),
                child: new RaisedButton(
                    child: const Text(
                      "Register",
                    ),
                    textColor: Colors.white,
                    color: Colors.green[900],
                    padding: EdgeInsets.all(15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7)),
                    disabledColor: Colors.grey[500],
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        status = await _auth.registerWithEmailAndPassword(
                            email, password, name, _imageFile);
                        if (status == 400) {
                          setState(() {
                            error = "Email already exits!!";
                          });
                        } else {
                          user.setUser(status.uid, status.email, status.name,
                              status.image);
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomePage(),
                              ));
                        }
                      }
                    }),
              ),
              SizedBox(height: 12.0),
              Center(
                child: Text(
                  error,
                  style: TextStyle(color: Colors.red, fontSize: 14.0),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
