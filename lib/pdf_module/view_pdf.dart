import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


class ViewPDF extends StatefulWidget {

  final String title;
  final String link;
  ViewPDF({@required this.title, @required this.link,});

  @override
  _ViewPDFState createState() => _ViewPDFState();
}

class _ViewPDFState extends State<ViewPDF> with TickerProviderStateMixin{

  bool flag = false;
  var document;


  @override
  void deactivate(){
    super.deactivate();
  }

  @override
  void initState() {
    super.initState();
    getFileFromUrl(widget.link).then((pdfFile){
      setState(() {
        document = pdfFile;
        flag = true;
      });
    });
  }


  getFileFromUrl(String url) async {
    try{
      document = await PDFDocument.fromURL(url);
      return document;
    } catch(e) {
      print(e.toString());
    }
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(),
      body: flag ? PDFViewer(
        document: document,
        zoomSteps: 1,
      ) :
      Center(
        child: SpinKitWave(
          color: Color(0xFF11249F),
          size: 50.0,
          controller: AnimationController(vsync: this, duration: const Duration(milliseconds: 1200)),
        )
      )
    );
  }
}

