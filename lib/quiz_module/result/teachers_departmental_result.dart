import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:soft_skill_admin/helper/quiz_Collection_Names.dart';
import 'package:soft_skill_admin/providers/classifier.dart';

class TeachersDepartmentalResult extends StatefulWidget {

  final String documentID;
  final String department;

  TeachersDepartmentalResult({this.documentID, this.department});

  @override
  _TeachersDepartmentalResultState createState() => _TeachersDepartmentalResultState();
}

class _TeachersDepartmentalResultState extends State<TeachersDepartmentalResult> with TickerProviderStateMixin{
  final Firestore _firestore = Firestore.instance;

  final String collectionDivision = 'division';

  final _formKey = GlobalKey<FormState>();

  bool flag = false;

  @override
  Widget build(BuildContext context) {
    final classifierProvider = Provider.of<Classifier>(context);

    List<String> nameList = [];
    List<String> marksList = [];
    return Scaffold(
      bottomNavigationBar: nameList.length==0 ? Material(
        child: InkWell(
          onTap: () async {
            String _title;
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Confirm'),
                    content: Form(
                      key: _formKey,
                      child: TextFormField(
                        validator: (title){
                          if(title == null) {
                            return 'Please enter your mail id.';
                          }
                          return null;
                        },
                        onChanged: (title) {
                          _title = title;
                        },
                        decoration: InputDecoration(
                          labelText: 'Title',
                          hintText: 'Please enter a title',
                          border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(18.0))),
                        ),
                      ),
                    ),
                    actions: <Widget>[
                      RaisedButton(
                        child: Text('Cancel'),
                        onPressed: ()=> Navigator.pop(context),
                      ),
                      RaisedButton(
                        child: Text('Proceed'),
                        onPressed: () async{
                          if(_formKey.currentState.validate()) {
                            List<List<dynamic>> rows = List<List<dynamic>>();
                            rows.add(['Name', 'Marks']);
                            for (int i = 0; i <nameList.length;i++) {
                              //row refer to each column of a row in csv file and rows refer to each row in a file
                              List<dynamic> row = List();
                              row.add(nameList[i]);
                              row.add(marksList[i]);
                              rows.add(row);
                            }
                            String dir = await ExtStorage.getExternalStoragePublicDirectory(ExtStorage.DIRECTORY_DOWNLOADS);
                            String file = "$dir/";
                            print(" FILE " + file);
                            await Permission.storage.request();
                            File f = new File(file+"$_title.csv");
                            String csv =  const ListToCsvConverter().convert(rows);
                            await f.writeAsString(csv);
                          }
                        },
                      ),
                    ],
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
                'Export File',
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
      ) : Offstage(),
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: StreamBuilder<DocumentSnapshot>(
            stream: _firestore.collection(classifierProvider.group)
                .document(QuizCollectionNames.mainCollectionQuizDocumentName)
                .collection(QuizCollectionNames.subCollectionQuizDocument)
                .document(widget.documentID)
                .collection(QuizCollectionNames.subCollectionQuizDocumentResults)
                .document(widget.department)
                .snapshots(),
            builder: (context, snapshot){
              if(!snapshot.hasData){
                return Center(
                  child: SpinKitWave(
                    color: Color(0xFF11249F),
                    size: 50.0,
                    controller: AnimationController(vsync: this, duration: const Duration(milliseconds: 1200)),
                  ),
                );
              }
              List<TeachersResultDisplayCard> displayResult = [];
//              print(snapshot.data.data);
              int serialNumber = 1;
              for(var resultMap in snapshot.data.data.values) {
//                print(resultMap);
                if(resultMap['name'] != 'Demo'){
                  final name = resultMap['name'];
                  nameList.add(name);
                  final marks = resultMap['marks'];
                  marksList.add(marks);
                  displayResult.add(
                      TeachersResultDisplayCard(
                        name: name,
                        marks: marks,
                        serialNumber: serialNumber.toString(),
                      )
                  );
                  serialNumber++;
                }
              }
              if (displayResult.isNotEmpty) {
                  flag = true;
              }
              return flag ? Column(
                children: <Widget>[

                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      '${widget.department} Department.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.philosopher(
                        fontSize: 18,
                      ),
                    ),
                  ),

                  Card(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Text(
                              'Sr. No.',
                              style: GoogleFonts.philosopher(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          VerticalDivider(),
                          Expanded(
                            flex: 4,
                            child: Text(
                              'Name',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.philosopher(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          VerticalDivider(),
                          Expanded(
                            flex: 1,
                            child: Text(
                              'Marks',
                              textAlign: TextAlign.end,
                              style: GoogleFonts.philosopher(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(),
                  Column(
                    children: displayResult,
                  ),
                ],
              )
              :
              Center(
                child: Text(
                  'No Attempts.',
                  style: GoogleFonts.lato(
                    fontSize: 24,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class TeachersResultDisplayCard extends StatelessWidget {

  final String serialNumber;
  final String name;
  final String marks;

  TeachersResultDisplayCard({@required this.marks, @required this.name, @required this.serialNumber});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Text(
                serialNumber,
                style: GoogleFonts.philosopher(),
              ),
            ),
            VerticalDivider(),
            Expanded(
              flex: 4,
              child: Text(
                name,
                textAlign: TextAlign.center,
                style: GoogleFonts.philosopher(),
              ),
            ),
            VerticalDivider(),
            Expanded(
              flex: 1,
              child: Text(
                marks,
                textAlign: TextAlign.end,
                style: GoogleFonts.philosopher(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

