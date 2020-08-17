import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:soft_skill_admin/pdf_module/pdf_collection_names.dart';

class UploadPDFScreen extends StatefulWidget {

  final String collection;
  UploadPDFScreen({@required this.collection});

  @override
  _UploadPDFScreenState createState() => _UploadPDFScreenState();
}

class _UploadPDFScreenState extends State<UploadPDFScreen> with TickerProviderStateMixin{


  Firestore _firestore = Firestore.instance;

  File _pdf;
  bool flag = true;
  String titleInfo;
  bool fileNameFlag = true;
  final _formKey = GlobalKey<FormState>();

  Future<void> _uploadURL(String link, String titleInfo, String path) async{

    print(widget.collection);

    await _firestore.collection(widget.collection)
      .document(PDFCollectionNames.collectionFieldName)
      .collection(PDFCollectionNames.subCollectionFieldName)
      .document()
      .setData({
        PDFCollectionNames.titleFieldName: titleInfo,
        PDFCollectionNames.linkFieldName: link,
      PDFCollectionNames.pathFieldName: path,
      });

  }

  uploadPdf(BuildContext context) async {

    try{
      String fileName = basename(_pdf.path);
      StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child(fileName);
      StorageUploadTask uploadTask = firebaseStorageRef.putFile(_pdf);
      StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
      setState(() {
        Scaffold.of(context).showSnackBar(SnackBar(content: Text('PDF Uploaded'),));
      });
      String path = await firebaseStorageRef.getPath();
      String url = await firebaseStorageRef.getDownloadURL();
      await _uploadURL(url, titleInfo, path);
    }
    catch(e) {
      print(e);
      Scaffold.of(context).showSnackBar(SnackBar(content: Text(e.toString()),));
    }
  }

  Future<void> getPdf() async{
    try {
      File pdf = await FilePicker.getFile(
          type: FileType.custom,
          allowedExtensions: ['pdf']
      );
      setState(() {
        _pdf = pdf;
        print('pdf path: $_pdf');
      });


    }
    catch(e) {
      print(e.toString());
    }
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Upload PDF'),
      ),
      body: Builder(
        builder: (context)=>
            Stack(
              children: <Widget>[
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[

                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: InkWell(
                          child: DottedBorder(
                            dashPattern: [4, 8],
                            strokeWidth: 2,
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.15,
                              child: Center(
                                child: fileNameFlag ? Text(
                                  'Tap to select the file.',
                                  style: TextStyle(color: Colors.grey),
                                ): Text(
                                  '${basename(_pdf.path)}',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                            ),
                          ),
                          onTap: ()async {
                            await getPdf();
                            setState(() {
                              fileNameFlag = false;
                            });
                          },
                        ),
                      ),

                      Container(
                        height: MediaQuery.of(context).size.height * 0.15,
                        child: Padding(
                          padding: EdgeInsets.all(12.0),
                          child: TextFormField(
                            expands: true,
                            maxLines: null,
                            minLines: null ,
                            validator: (value){
                              if(value.isEmpty){
                                return 'Please enter the title';
                              }
                              return null;
                            },
                            onChanged: (title){
                              titleInfo = title;
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(36.0))),
                              labelText: 'Title',
                              hintText: 'Please give a title',
                            ),
                          ),
                        ),
                      ),
                      RaisedButton(
                        color: Colors.lightBlueAccent,
                        textColor: Colors.white,
                        child: Text('Upload'),
                        onPressed: () async{
                          if (_formKey.currentState.validate()) {
                            setState(() {
                              flag = false;
                            });
                            await uploadPdf(context);
                            setState(() {
                              flag = true;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
                !flag ? Center(
                  child: SpinKitWave(
                    color: Color(0xFF11249F),
                    size: 50.0,
                    controller: AnimationController(vsync: this, duration: const Duration(milliseconds: 1200)),
                  ),
                ) : Offstage(),
              ],
            ),
      ),
    );
  }
}
