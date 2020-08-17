import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:soft_skill_admin/providers/classifier.dart';
import 'package:soft_skill_admin/video_upload/url_collection_names.dart';
import 'package:url_launcher/url_launcher.dart';


class URLScreen extends StatefulWidget {
  @override
  _URLScreenState createState() => _URLScreenState();
}

class _URLScreenState extends State<URLScreen> with TickerProviderStateMixin{

  Firestore _firestore = Firestore.instance;

  _uploadURL(BuildContext context,String url, String title, String collection) async{

    try{
      await _firestore.collection(collection)
          .document(URLCollectionNames.mainFieldDocumentName)
          .collection(URLCollectionNames.subCollectionName)
          .document()
          .setData({
            URLCollectionNames.subCollectionFieldTitle: title,
            URLCollectionNames.subCollectionFieldURL: url,
          });
    } catch(e) {
      print(e.toString());
      return showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text('Upload Failed'),
            content: Text('Try again after some time'),
            actions: <Widget>[
              FlatButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                child: Text('Back'),
                color: Colors.lightBlueAccent,
                textColor: Colors.white,
              )
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    final classifierProvider = Provider.of<Classifier>(context);
    final _formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Open URL'),
        backgroundColor: Colors.lightBlueAccent,
      ),

      bottomNavigationBar: Material(
        child: InkWell(
          onTap: (){
            showDialog(
              context: context,
              builder: (context) {
                String _title;
                String _url;
                return AlertDialog(
                    title: Text(
                      'Upload URL',
                      style: GoogleFonts.philosopher(),
                    ),
                    content: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            height: MediaQuery.of(context).size.height * 0.15,
                            child: Padding(
                              padding: EdgeInsets.all(12.0),
                              child: TextFormField(
                                expands: true,
                                maxLines: null,
                                minLines: null,
                                validator: (value){
                                  if(value.isEmpty){
                                    return 'Please enter the url/link';
                                  }
                                  return null;
                                },
                                onChanged: (url){
                                  _url = url;
                                },
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(36.0))),
                                  labelText: 'Please Enter the URL',
                                  hintStyle: GoogleFonts.philosopher(),
                                  labelStyle: GoogleFonts.philosopher(),
                                  hintText: 'www.google.com',
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.15,
                            child: Padding(
                              padding: EdgeInsets.all(12.0),
                              child: TextFormField(
                                expands: true,
                                maxLines: null,
                                minLines: null,
                                validator: (value){
                                  if(value.isEmpty){
                                    return 'Please enter the title';
                                  }
                                  return null;
                                },
                                onChanged: (title){
                                  _title = title;
                                },
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(36.0))),
                                  labelText: 'Title',
                                  hintText: 'Please give a title',
                                  hintStyle: GoogleFonts.philosopher(),
                                  labelStyle: GoogleFonts.philosopher(),
                                ),
                              ),
                            ),
                          ),
                          RaisedButton(
                            color: Colors.lightBlueAccent,
                            textColor: Colors.white,
                            child: Text(
                              'Upload',
                              style: GoogleFonts.bellota(),
                            ),
                            onPressed: () async{
                              if (_formKey.currentState.validate()) {
                                await _uploadURL(context, _url, _title, classifierProvider.group);
                                Navigator.pop(context);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                );
              }
            );
          },
          child: Container(
            width: double.infinity,
            color: Colors.lightBlueAccent,
            child: Padding(
              padding: EdgeInsets.all(18.0),
              child: Text(
                'Upload Video Link',
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
                .document(URLCollectionNames.mainFieldDocumentName)
                .collection(URLCollectionNames.subCollectionName)
                .snapshots(),
        builder: (context, snapshot) {
          if(!snapshot.hasData){
            return Center(
              child: SpinKitWave(
                color: Color(0xFF11249F),
                size: 50.0,
                controller: AnimationController(vsync: this, duration: const Duration(milliseconds: 1200)),
              ),
            );
          }
          List<ViewURLCard> viewCards = [];
          var allURLs = snapshot.data.documents;
          for(var url in allURLs){
            final documentID = url.documentID;
            final title = url.data['title'];
            final videoLink = url.data['url'];
            viewCards.add(ViewURLCard(
              url: videoLink,
              title: title,
              documentID: documentID,
            ));
          }
          return  allURLs.length != 0 ? SingleChildScrollView(
            child: Column(
              children: viewCards,
            ),
          ):
          Center(
            child: Text(
              'No Videos Uploaded',
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
class ViewURLCard extends StatefulWidget {

  final String title;
  final String url;
  final String documentID;

  ViewURLCard({
    @required this.title,
    @required this.url,
    @required this.documentID,
  });

  @override
  _ViewURLCardState createState() => _ViewURLCardState();
}

class _ViewURLCardState extends State<ViewURLCard> {

  Future<void> _launchURL(String url) async{

    if( await canLaunch(url)){
      launch(
        url,
        forceWebView: false,
        forceSafariVC: false,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    }
    else{
      throw 'Could not launch $url';
    }

  }

  @override
  Widget build(BuildContext context) {
    final classifierProvider = Provider.of<Classifier>(context);
    return Padding(
      padding: EdgeInsets.all(15.0),
      child: Card(
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(MediaQuery
              .of(context)
              .size
              .height * 0.03,))
        ),
        child: Container(
          height: MediaQuery
              .of(context)
              .size
              .height * 0.30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(MediaQuery
                .of(context)
                .size
                .height * 0.03,)),
            gradient: LinearGradient(
              colors: [
                Colors.lightBlueAccent,
                Colors.lightBlue,
                Colors.blue,
                Colors.blueAccent
              ],
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
                            fontSize: MediaQuery
                                .of(context)
                                .size
                                .height * 0.05,
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
                          child: Card(
                            elevation: 3.0,
                            child: Container(
                              color: Colors.white,
                              child: Padding(
                                padding: EdgeInsets.all(12.0),
                                child: Text(
                                  'View Video',
                                  style: GoogleFonts.lato(),
                                ),
                              ),
                            ),
                          ),
                          onTap: () async{
                            await _launchURL(widget.url);
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
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text(
                                      'Warning!',
                                      style: GoogleFonts.cinzel(),
                                    ),
                                    content: Text(
                                      'You are about to delete: "${widget
                                          .title}"',
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
                                        onPressed: () async {
                                          Firestore _firestore = Firestore
                                              .instance;
                                          await _firestore.collection(
                                              classifierProvider.group)
                                              .document(URLCollectionNames.mainFieldDocumentName)
                                              .collection(URLCollectionNames
                                              .subCollectionName)
                                              .document(widget.documentID)
                                              .delete();
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

