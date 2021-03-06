import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:soft_skill_admin/helper/constants.dart';
import 'package:soft_skill_admin/helper/quiz_Collection_Names.dart';
import 'result_distribution_screens/result_display_card.dart';

class FEDivisionDisplayResult extends StatefulWidget {

  final String division;
  final String documentID;

  FEDivisionDisplayResult({this.division, this.documentID});

  @override
  _FEDivisionDisplayResultState createState() => _FEDivisionDisplayResultState();
}

class _FEDivisionDisplayResultState extends State<FEDivisionDisplayResult> {

  final Firestore _firestore = Firestore.instance;

  final _formKey = GlobalKey<FormState>();

  bool flag = false;

  @override
  Widget build(BuildContext context) {
    List<String> rollNumberList = [];
    List<String> nameList = [];
    List<String> marksList = [];
    return Scaffold(
      bottomNavigationBar: rollNumberList.length==0 ? Material(
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
                            rows.add(['Roll Number', 'Name', 'Marks']);
                            for (int i = 0; i <rollNumberList.length;i++) {
                              //row refer to each column of a row in csv file and rows refer to each row in a file
                              List<dynamic> row = List();
                              row.add(rollNumberList[i]);
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
            stream: _firestore.collection(firstYear)
              .document(QuizCollectionNames.mainCollectionQuizDocumentName)
              .collection(QuizCollectionNames.subCollectionQuizDocument)
              .document(widget.documentID)
              .collection(QuizCollectionNames.subCollectionQuizDocumentResults)
              .document(widget.division)
              .snapshots(),
            builder: (context, snapshot){
              if(!snapshot.hasData){
                return Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.blueGrey,
                  ),
                );
              }
              List<ResultDisplayCard> displayResult = [];
              for(var resultMap in snapshot.data.data.values) {

                if (resultMap['name'] != 'Demo') {
                  final name = resultMap['name'];
                  nameList.add(name);
                  final rollNumber = resultMap['rollNumber'];
                  rollNumberList.add(rollNumber);
                  final marks = resultMap['marks'];
                  marksList.add(marks);

                  displayResult.add(
                    ResultDisplayCard(
                      name: name,
                      rollNumber: rollNumber,
                      marks: marks,
                    )
                  );
                }

              }

              if(displayResult.isNotEmpty){
                flag = true;
              }
              return flag ? Column(
                children: <Widget>[
                  Card(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Text(
                              'Roll No.',
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

