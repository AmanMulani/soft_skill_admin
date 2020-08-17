

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:soft_skill_admin/pdf_module/pdf_collection_names.dart';
import 'package:soft_skill_admin/pdf_module/view_pdf.dart';
import 'package:soft_skill_admin/providers/classifier.dart';
import 'package:soft_skill_admin/pdf_module/upload_pdf_screen.dart';

class PDFScreen extends StatefulWidget {
  @override
  _PDFScreenState createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> with TickerProviderStateMixin{

  Firestore _firestore = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    final classifierProvider = Provider.of<Classifier>(context);
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
      ),

      bottomNavigationBar: Material(
        child: InkWell(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(
              builder: (context)=> UploadPDFScreen(
                collection: classifierProvider.group,
              )
            ));
          },
          child: Container(
            width: double.infinity,
            color: Colors.lightBlueAccent,
            child: Padding(
              padding: EdgeInsets.all(18.0),
              child: Text(
                'Upload PDF',
                textAlign: TextAlign.center,
                style: GoogleFonts.bellota(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection(classifierProvider.group)
            .document(PDFCollectionNames.collectionFieldName)
            .collection(PDFCollectionNames.subCollectionFieldName)
            .snapshots(),
        builder: (context, snapshot) {

          if(!snapshot.hasData) {
            return Center(
              child: SpinKitWave(
                color: Color(0xFF11249F),
                size: 50.0,
                controller: AnimationController(vsync: this, duration: const Duration(milliseconds: 1200)),
              ),
            );
          }
          var allPdf = snapshot.data.documents;
          List<ViewPdfCard> viewCards = [];
          for( var pdf in allPdf){
            final documentID = pdf.documentID;
            final title = pdf[PDFCollectionNames.titleFieldName];
            final link = pdf[PDFCollectionNames.linkFieldName];
            final path = pdf[PDFCollectionNames.pathFieldName];
            viewCards.add(ViewPdfCard(
              title: title,
              link: link,
              documentID: documentID,
              path: path,
            ));
          }
          return allPdf.length != 0 ? SingleChildScrollView(
            child: Column(
              children: viewCards,
            ),
          ):
          Center(
            child: Text(
              'No PDF Uploaded',
              style: GoogleFonts.lato(
                fontSize: 24,
              ),
            ),
          );
        },
      ),
    );
  }
}

class ViewPdfCard extends StatefulWidget {

  final String title;
  final String link;
  final String documentID;
  final String path;

  ViewPdfCard({
    @required this.title,
    @required this.link,
    @required this.documentID,
    @required this.path,
  });

  @override
  _ViewPdfCardState createState() => _ViewPdfCardState();
}

class _ViewPdfCardState extends State<ViewPdfCard> {

  @override
  Widget build(BuildContext context) {
    final classifierProvider = Provider.of<Classifier>(context);
    return Padding(
      padding: EdgeInsets.all(15.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(MediaQuery.of(context).size.height * 0.03,)),
        ),
        elevation: 5.0,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(MediaQuery.of(context).size.height * 0.03,)),
            gradient: LinearGradient(
              colors: [Colors.lightBlueAccent, Colors.lightBlue, Colors.blue, Colors.blueAccent],
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Flexible(
                        child: Text(
                          widget.title,
                          textAlign: TextAlign.start,
                          style: GoogleFonts.montaga(
                            color: Colors.white,
                            fontSize: MediaQuery.of(context).size.height * 0.05,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          child: Container(
                            color: Colors.white,
                            child: Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Text(
                                'Preview PDF',
                                style: GoogleFonts.lato(),
                              ),
                            ),
                          ),
                          onTap: () {
                            Navigator.push(context,
                              MaterialPageRoute(
                                builder: (context)=>
                                  ViewPDF(
                                    title: widget.title,
                                    link: widget.link,
                                  ),
                              ));
                          },
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                            size: 30.0,
                          ),
                          onPressed: (){
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text(
                                      'Warning!',
                                      style: GoogleFonts.cinzel(),
                                    ),
                                    content: Text(
                                      'You are about to delete: "${widget.title}"',
                                      style: GoogleFonts.philosopher(),
                                    ),
                                    actions: <Widget>[
                                      FlatButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text(
                                          'Cancel',
                                          style: GoogleFonts.lato(),
                                        ),
                                      ),
                                      FlatButton(
                                        onPressed: () async{
                                          FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
                                          await _firebaseStorage.ref().child(widget.path).delete();
                                          Firestore _firestore = Firestore.instance;
                                          await _firestore.collection(classifierProvider.group)
                                            .document(PDFCollectionNames.collectionFieldName)
                                            .collection(PDFCollectionNames.subCollectionFieldName)
                                            .document(widget.documentID).delete();
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          'Delete',
                                          style: GoogleFonts.lato(),
                                        ),
                                      )
                                    ],
                                  );
                                }
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}