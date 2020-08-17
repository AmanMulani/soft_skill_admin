import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../teachers_departmental_result.dart';

class TeacherDepartmentalCard extends StatelessWidget {

  final String department;
  final String documentID;
  final String path;
  final String departmentName;

  TeacherDepartmentalCard({
    @required this.documentID,
    @required this.department,
    @required this.path,
    @required this.departmentName
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context)=>
            TeachersDepartmentalResult(
              documentID: documentID,
              department: department,
            )
          )
        );
      },
      child: Padding(
        padding:  EdgeInsets.all(8.0),
        child: Card(
          elevation: 3.0,
          shadowColor: Colors.grey,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24.0))),

          child: Container(
            height: MediaQuery.of(context).size.height * 0.3,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(24.0)),
              color: Colors.white,
              image: DecorationImage(
                image: AssetImage(path),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: Text(
                departmentName,
                style: GoogleFonts.philosopher(
                  fontSize: MediaQuery.of(context).size.height * 0.04,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
