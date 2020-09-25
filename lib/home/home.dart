import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:read_app/add/add_books.dart';
//import 'package:read_app/chapters/chapter_webview.dart';
import 'package:read_app/chapters/chapterlist.dart';
import 'package:read_app/models/books.dart';
import 'package:read_app/models/database.dart';
import 'package:read_app/users/userprofile.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseService dbs = DatabaseService();
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserProfile(),
                  ));
            },
          )
        ],
      ),
      floatingActionButton: AddBook(),
      body: FutureBuilder(
        future: dbs.getBooks(),
        builder: (BuildContext context, AsyncSnapshot<List<Book>> snapshot) {
          if (snapshot.hasData) {
            List<Book> books = snapshot.data;
            if (dbs.image.isNotEmpty) {
              return ListView.builder(
                  itemCount: books.length,
                  itemBuilder: (context, index) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(5.0),
                      child: Container(
                        padding: EdgeInsets.all(5),
                        margin: const EdgeInsets.only(
                            bottom: 10.0,
                            left: 5.0,
                            right: 5.0), //Same as `blurRadius` i guess
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              offset: Offset(0.0, 1.0), //(x,y)
                              blurRadius: 8.0,
                            ),
                          ],
                        ),
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Chapters(
                                    pdfUrl: books[index].pdfUrl,
                                  ),
                                ));
                            /* Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChapterWebview(
                                    pdfUrl: books[index].pdfUrl,
                                  ),
                                ));*/
                          },
                          leading: Container(
                            child: dbs.image[index],
                            height: MediaQuery.of(context).size.height * 0.35,
                            width: MediaQuery.of(context).size.width * 0.15,
                          ),
                          title: Text(
                            books[index].bname,
                            style: TextStyle(color: Colors.blue[900]),
                          ),
                          subtitle: Text("Author: ${books[index].bauthor}" +
                              "\nChapters: ${books[index].bchapters}"),
                          trailing: IconButton(
                              color: Colors.red[900],
                              onPressed: () {
                                dbs.deleteBook(books[index].bid).then((value) {
                                  if (value == 200) {
                                    setState(() {});
                                  }
                                });
                              },
                              icon: Icon(Icons.delete)),
                        ),
                      ),
                    );
                  });
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
