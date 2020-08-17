import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'file:///E:/SoftskillApp/soft_skill_admin/lib/quiz_module/result/fe_division_result_display.dart';

class DivisionCard extends StatelessWidget {

  final String division;
  final String documentID;

  DivisionCard({
    @required this.documentID,
    @required this.division,
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
                builder: (context)=> FEDivisionDisplayResult(
                  division: division,
                  documentID: documentID,
                ),
              )
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