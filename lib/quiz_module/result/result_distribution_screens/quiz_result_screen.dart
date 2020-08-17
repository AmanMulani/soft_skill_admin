
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soft_skill_admin/providers/classifier.dart';
import 'package:soft_skill_admin/helper/constants.dart';
import 'file:///E:/SoftskillApp/soft_skill_admin/lib/quiz_module/result/result_distribution_screens/department_card.dart';
import 'file:///E:/SoftskillApp/soft_skill_admin/lib/quiz_module/result/result_distribution_screens/division_card.dart';
import 'file:///E:/SoftskillApp/soft_skill_admin/lib/quiz_module/result/result_distribution_screens/teacher_departmental_card.dart';

class QuizResultScreen extends StatefulWidget {

  final String documentID;

  QuizResultScreen({@required this.documentID});

  @override
  _QuizResultScreenState createState() => _QuizResultScreenState();
}

class _QuizResultScreenState extends State<QuizResultScreen> {
  @override
  Widget build(BuildContext context) {
    final classifierProvider = Provider.of<Classifier>(context);

    if(classifierProvider.group == firstYear) {
      return Scaffold(
        appBar: AppBar(),
        body: GridView(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          children: <Widget>[
            DivisionCard(
              division: 'A',
              documentID: widget.documentID,
            ),
            DivisionCard(
              division: 'B',
              documentID: widget.documentID,
            ),
            DivisionCard(
              division: 'C',
              documentID: widget.documentID,
            ),
            DivisionCard(
              division: 'D',
              documentID: widget.documentID,
            ),
            DivisionCard(
              division: 'E',
              documentID: widget.documentID,
            ),
            DivisionCard(
              division: 'F',
              documentID: widget.documentID,
            ),
            DivisionCard(
              division: 'G',
              documentID: widget.documentID,
            ),
            DivisionCard(
              division: 'H',
              documentID: widget.documentID,
            ),
            DivisionCard(
              division: 'I',
              documentID: widget.documentID,
            ),
            DivisionCard(
              division: 'J',
              documentID: widget.documentID,
            ),
          ],
        ),
      );
    }
    else if(classifierProvider.group == teachersAndFaculties) {
      return Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              TeacherDepartmentalCard(
                department: 'Computer',
                departmentName: 'Computer Department',
                documentID: widget.documentID,
                path: 'images/computer.jpg',
              ),
              TeacherDepartmentalCard(
                department: 'Mechanical',
                departmentName: 'Mechanical Department',
                documentID: widget.documentID,
                path: 'images/mechanical.jpg',
              ),
              TeacherDepartmentalCard(
                department: 'Civil',
                departmentName: 'Civil Department',
                documentID: widget.documentID,
                path: 'images/civil.jpg',
              ),
              TeacherDepartmentalCard(
                department: 'ENTC',
                departmentName: 'ENTC Department',
                documentID: widget.documentID,
                path: 'images/entc.jpg',
              ),
              TeacherDepartmentalCard(
                department: 'Chemical',
                departmentName: 'Chemical Department',
                documentID: widget.documentID,
                path: 'images/chemical.jpg',
              ),
            ],
          ),
        ),
      );
    }

    else{
      return Scaffold(
//        backgroundColor: Color(0xFF9F9F9F),
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              DepartmentCard(
                department: 'Computer',
                departmentName: 'Computer Department',
                documentID: widget.documentID,
                path: 'images/computer.jpg',
              ),
              DepartmentCard(
                department: 'Mechanial',
                departmentName: 'Mechanical Department',
                documentID: widget.documentID,
                path: 'images/mechanical.jpg',
              ),
              DepartmentCard(
                department: 'Civil',
                departmentName: 'Civil Department',
                documentID: widget.documentID,
                path: 'images/civil.jpg',
              ),
              DepartmentCard(
                department: 'ENTC',
                departmentName: 'ENTC Department',
                documentID: widget.documentID,
                path: 'images/entc.jpg',
              ),
              DepartmentCard(
                department: 'Chemical',
                departmentName: 'Chemical Department',
                documentID: widget.documentID,
                path: 'images/chemical.jpg',
              ),
            ],
          ),
        ),
      );
    }
  }
}



