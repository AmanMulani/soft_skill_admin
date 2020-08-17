import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ResultDisplayCard extends StatelessWidget {

  final String rollNumber;
  final String name;
  final String marks;

  ResultDisplayCard({this.marks, this.name, this.rollNumber});

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
                rollNumber,
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
