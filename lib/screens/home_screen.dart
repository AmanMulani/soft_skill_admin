
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:soft_skill_admin/helper/constants.dart';
import 'package:soft_skill_admin/providers/classifier.dart';
import 'package:soft_skill_admin/screens/display_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final classifierProvider = Provider.of<Classifier>(context, listen: false);

    List<ViewCard> viewCards = [
      ViewCard(
        title: 'First Year',
        onTap: (){
          classifierProvider.setGroupName(firstYear);
          Navigator.push(context, MaterialPageRoute(builder: (context)=> DisplayScreen()));
        },
        gradient: LinearGradient(
          colors: [Color(0xFFff9a9e), Color(0xFFfad0c4)],
        ),
      ),
      ViewCard(
        title: 'Second Year',
        onTap: (){
          classifierProvider.setGroupName(secondYear);
          Navigator.push(context, MaterialPageRoute(builder: (context)=> DisplayScreen()));
        },
        gradient: LinearGradient(
          colors: [Color(0xFFa1c4fd ), Color(0xFFc2e9fb)],
        ),
      ),
      ViewCard(
        title: 'Third Year',
        onTap: (){
          classifierProvider.setGroupName(thirdYear);
          Navigator.push(context, MaterialPageRoute(builder: (context)=> DisplayScreen()));
        },
        gradient: LinearGradient(
          colors: [Color(0xFF78c6ef), Color(0xFF6f86d6)],
        ),
      ),
      ViewCard(
        title: 'Fourth Year',
        onTap: (){
          classifierProvider.setGroupName(fourthYear);
          Navigator.push(context, MaterialPageRoute(builder: (context)=> DisplayScreen()));
        },
        gradient: LinearGradient(
          colors: [Color(0xFF96deda) ,Color(0xFF50c9c3),],
        ),
      ),
      ViewCard(
        title: 'Teachers and Faculties',
        onTap: (){
          classifierProvider.setGroupName(teachersAndFaculties);
          Navigator.push(context, MaterialPageRoute(builder: (context)=> DisplayScreen()));
        },
        gradient: LinearGradient(
          colors: [Color(0xFFB7F8DB), Color(0xFF50A7C2),],
        ),
      ),
    ];

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height * 0.50,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF3383CD), Color(0xFF11249F),]
              ),
            ),
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Image.asset('images/SoftSkills.png'),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TypewriterAnimatedTextKit(
                          speed: Duration(milliseconds: 600 ),
                          totalRepeatCount: 1,
                          text: ['Soft Skills'],
                          textStyle: GoogleFonts.philosopher(
                            fontSize: 60.0,
                            color: Colors.white
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TypewriterAnimatedTextKit(
                          speed: Duration(milliseconds: 500 ),
                          totalRepeatCount: 3,
                          text: ['Online Training'],
                          textStyle: GoogleFonts.philosopher(
                            fontSize: 18.0,
                            color: Colors.white
                          ),
                        ),
                      )
                    ],
                  )
                )
              ],
            ),
          ),
          CarouselSlider(
            options: CarouselOptions(
              height: MediaQuery.of(context).size.height * 0.45,
              autoPlayCurve: Curves.bounceInOut,
            ),
            items: viewCards.map((viewCard) {
              return Builder(
                builder: (BuildContext context) {
                  return viewCard;
                },
              );
            }).toList(),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Powered by DYPIEMR',
              textAlign: TextAlign.center,
              style: GoogleFonts.philosopher(
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ViewCard extends StatelessWidget {

  final String title;
  final Function onTap;
  final LinearGradient gradient;

  ViewCard({@required this.title, @required this.onTap, @required this.gradient});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
        elevation: 5.0,
        child: InkWell(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24.0),
              gradient: gradient,
            ),
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.philosopher(
                    fontSize: 36.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w100,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
