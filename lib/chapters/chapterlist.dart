import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';
//import 'package:read_app/add/add_chapter.dart';
//import 'package:read_app/models/books.dart';
//import 'package:read_app/models/database.dart';
//import 'package:read_app/update/updateChapters.dart';

class Chapters extends StatefulWidget {
  final String pdfUrl;
  Chapters({this.pdfUrl});
  _ChaptersState createState() => _ChaptersState();
}

class _ChaptersState extends State<Chapters> {
  PDFDocument _document;
  bool _isLoading = true;

  void initState() {
    super.initState();
    getPdf().then((value) => _document = value);
  }

  Future<PDFDocument> getPdf() async {
    PDFDocument doc = await PDFDocument.fromURL(widget.pdfUrl);
    setState(() {
      _isLoading = false;
    });
    return doc;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chapters'),
      ),
      body: Center(
          child: _isLoading
              ? Center(child: CircularProgressIndicator())
              : PDFViewer(document: _document)),
    );
  }
}

/* Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Chapters")),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => UpadateChapters(
                  bid: widget.bookId,
                ),
              ));
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          addChapter(context, widget.bookId);
        },
      ),
      body: FutureBuilder(
        future: _dbs.getChapters(widget.bookId),
        builder: (BuildContext context, AsyncSnapshot<List<Chapter>> snapshot) {
          if (snapshot.hasData) {
            List<Chapter> chapters = snapshot.data;
            return ListView.builder(
                itemCount: chapters.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.all(10),
                    height: 400,
                    child: Column(
                      children: [
                        Center(
                            child: Text(
                          chapters[index].cname,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        )),
                        Container(
                          height: 3,
                          color: Colors.grey,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(chapters[index].content)
                      ],
                    ),
                  );
                });
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}*/
