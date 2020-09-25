import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:read_app/home/home.dart';
import 'package:read_app/models/database.dart';

class AddBook extends StatefulWidget {
  _AddBookState createState() => _AddBookState();
}

class _AddBookState extends State<AddBook> {
  final _formKey = GlobalKey<FormState>();
  DatabaseService _dbs = DatabaseService();
  String _bid;
  String _bname;
  String _bauthor;
  String _bchapters;
  String _pdf;
  File _imageFile;
  final imagePicker = ImagePicker();
  void initState() {
    _imageFile = null;
    super.initState();
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

  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(150, 0, 150, 0),
      child: FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Colors.blue[900],
          onPressed: () {
            _imageFile = null;
            showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              builder: (context) => Container(
                padding: MediaQuery.of(context).viewInsets,
                height: MediaQuery.of(context).size.height * 0.75,
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _imageView(),
                        Container(
                          padding: const EdgeInsets.fromLTRB(0, 20, 5, 0),
                          child: TextFormField(
                            decoration: new InputDecoration(
                              labelText: 'BookID',
                            ),
                            onChanged: (value) {
                              setState(() {
                                _bid = value;
                              });
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter the Id';
                              }
                              return null;
                            },
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(0, 20, 5, 0),
                          child: TextFormField(
                            decoration: new InputDecoration(
                              labelText: 'Title',
                            ),
                            onChanged: (value) {
                              setState(() {
                                _bname = value;
                              });
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter a title';
                              }
                              return null;
                            },
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(0, 20, 5, 0),
                          child: TextFormField(
                            decoration: new InputDecoration(
                              labelText: 'Author',
                            ),
                            onChanged: (value) {
                              setState(() {
                                _bauthor = value;
                              });
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter the name of the author';
                              }
                              return null;
                            },
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(0, 20, 5, 0),
                          child: TextFormField(
                            decoration: new InputDecoration(
                              labelText: 'Chapters',
                            ),
                            onChanged: (value) {
                              setState(() {
                                _bchapters = value;
                              });
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter the number of chapters';
                              }
                              return null;
                            },
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(0, 20, 5, 0),
                          child: TextFormField(
                            decoration: new InputDecoration(
                              labelText: 'Pdf Url',
                            ),
                            onChanged: (value) {
                              setState(() {
                                _pdf = value;
                              });
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter the url';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(height: 10),
                        Center(
                          child: RaisedButton(
                            color: Colors.green,
                            onPressed: () {
                              _dbs
                                  .addBooks(_bid, _bname, _bauthor, _bchapters,
                                      _imageFile, _pdf)
                                  .then((value) {
                                if (value == 200) {
                                  Navigator.pop(context);
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => HomePage(),
                                      ));
                                }
                              });
                            },
                            child: Text('Add Book'),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
