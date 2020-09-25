class Book {
  final String bid;
  final String bname;
  final String bauthor;
  final int bchapters;
  final String pdfUrl;
  Book({this.bid, this.bname, this.bauthor, this.bchapters, this.pdfUrl});
}

class Chapter {
  final String cid;
  final String cname;
  final String content;
  Chapter({this.cid, this.cname, this.content});
}
