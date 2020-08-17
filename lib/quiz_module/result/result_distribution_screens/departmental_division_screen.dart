import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../departmental_division_result_screen.dart';

class DepartmentalDivisionScreen extends StatelessWidget {

  final String documentID;
  final String department;

  DepartmentalDivisionScreen({
    @required this.documentID,
    @required this.department,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: GridView(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        children: <Widget>[
          DepartmentalDivisionCard(
            division: 'A',
            documentID: documentID,
            department: department,
          ),
          DepartmentalDivisionCard(
            division: 'B',
            documentID: documentID,
            department: department,
          ),
          DepartmentalDivisionCard(
            division: 'C',
            documentID: documentID,
            department: department,
          ),
          DepartmentalDivisionCard(
            division: 'D',
            documentID: documentID,
            department: department,
          ),
        ],
      ),
    );
  }
}

class DepartmentalDivisionCard extends StatelessWidget {

  final String division;
  final String documentID;
  final String department;

  DepartmentalDivisionCard({
    @required this.documentID,
    @required this.division,
    @required this.department,
  });

  @override
  Widget build(BuildContext context) {

    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: (){
            Navigator.push(
              context,
              MaterialPageRoute(
                 builder: (context)=>DepartmentalDivisionResultScreen(
                  department: department,
                  division: division,
                  documentID: documentID,
                 ),
              ),
            );
          },
          child: Container(
            height: MediaQuery.of(context).size.height * 0.25,
            width: MediaQuery.of(context).size.width * 0.4,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(18.0)),
                color: Colors.lightBlueAccent,
                gradient: LinearGradient(colors: [Colors.lightBlueAccent, Colors.lightBlue, Colors.blue, Colors.blueAccent])
            ),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  'Division $division',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montaga(
                    color: Colors.white,
                    fontSize: MediaQuery.of(context).size.height * 0.03,
                  ),
                ),
              ),
            ),
          ),
        )
    );
  }
}
