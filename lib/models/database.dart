import 'dart:convert';
import 'dart:io' as Io;
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:read_app/models/books.dart';

class DatabaseService {
  final String bookurl =
      "https://firestore.googleapis.com/v1beta1/projects/book-store-c9fd2/databases/(default)/documents/Books";
  final String key = '?key=AIzaSyDIiFA6T4r0S4ai6fWzbFPsjPnRNqgh7gE';
  List<Image> image = [];

  Future<List<Book>> getBooks() async {
    image = [];
    Response res = await get(bookurl + key);
    print(res.statusCode);

    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body)["documents"] as List;

      List<Book> posts = body.map((dynamic item) {
        final decodedBytes =
            base64Decode(item['fields']['Bimage']['stringValue']);
        image.add(Image.memory(decodedBytes, fit: BoxFit.fitWidth));

        return Book(
          bid: item['fields']['Bid']['stringValue'].toString(),
          bname: item['fields']['Name']['stringValue'].toString(),
          bauthor: item['fields']['Author']['stringValue'].toString(),
          bchapters: int.parse(item['fields']['Chapters']['integerValue']),
          pdfUrl: item['fields']['PdfUrl']['stringValue'].toString(),
        );
      }).toList();
      return posts;
    } else {
      print("error");

      throw "Can't get books.";
    }
  }

  Future<int> addBooks(dynamic bid, dynamic bname, dynamic bauthor,
      dynamic bchapters, Io.File imageFile, String pdfUrl) async {
    final bytes = await imageFile.readAsBytes();
    String bimage = base64.encode(bytes);
    Response res = await post(bookurl + "?documentId=" + bid.toString(),
        body: jsonEncode({
          "fields": {
            "Bid": {"stringValue": bid},
            "Name": {"stringValue": bname},
            "Author": {"stringValue": bauthor},
            "Chapters": {"integerValue": bchapters},
            "Bimage": {"stringValue": bimage},
            "PdfUrl": {"stringValue": pdfUrl}
          },
        }));
    print(res.statusCode);
    return (res.statusCode);
  }

  Future<int> deleteBook(String id) async {
    Response res = await delete("$bookurl/$id");
    if (res.statusCode == 200) {
      print("DELETED");
      return res.statusCode;
    } else {
      throw "Can't delete post.";
    }
  }

  /*Future<List<Chapter>> getChapters(String bid) async {
    Response res = await get(bookurl + '/' + bid + '/Chapters' + key);
    print(res.statusCode);
    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body)["documents"] as List;
      List<Chapter> chapters = body.map((dynamic item) {
        return Chapter(
            cid: item['fields']['Cid']['stringValue'].toString(),
            cname: item['fields']['Name']['stringValue'].toString(),
            content: item['fields']['Content']['stringValue'].toString());
      }).toList();
      return chapters;
    } else {
      print("error");
      throw "Can't get chapters";
    }
  }

  Future<Chapter> getChapter(String bid, String cid) async {
    Response res = await get(bookurl + '/' + bid + '/Chapters/' + cid + key);
    if (res.statusCode == 200) {
      var item = jsonDecode(res.body);

      return Chapter(
          cid: cid,
          cname: item['fields']['Name']['stringValue'].toString(),
          content: item['fields']['Content']['stringValue'].toString());
    } else {
      print("error");
      throw "Can't get chapters";
    }
  }*/

/*  Future<int> addChapters(
      dynamic bid, dynamic cid, dynamic cname, dynamic ccontent) async {
    Response res = await post(
        bookurl +
            '/' +
            bid.toString() +
            '/Chapters' +
            "?documentId=" +
            cid.toString(),
        body: jsonEncode({
          "fields": {
            "Cid": {"stringValue": cid},
            "Name": {"stringValue": cname},
            "Content": {"stringValue": ccontent},
          },
        }));
    print(res.statusCode);
    return res.statusCode;
  }

  Future<int> deleteChapter(String bid, String cid) async {
    Response res = await delete("$bookurl/$bid/Chapters/$cid");
    if (res.statusCode == 200) {
      print("DELETED");
      return res.statusCode;
    } else {
      throw "Can't delete post.";
    }
  }

  Future<int> updateChapters(
      dynamic bid, dynamic cid, dynamic cname, dynamic ccontent) async {
    print(bid.toString() +
        "," +
        cid.toString() +
        "," +
        cname.toString() +
        "," +
        ccontent.toString());
    Response res = await patch(
        bookurl + '/' + bid.toString() + '/Chapters' + "/" + cid.toString(),
        body: jsonEncode({
          "fields": {
            "Cid": {"stringValue": cid},
            "Name": {"stringValue": cname},
            "Content": {"stringValue": ccontent},
          },
        }));
    print(res.statusCode);
    return res.statusCode;
  }*/
}
