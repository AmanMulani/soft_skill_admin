import 'package:carousel_slider/carousel_slider.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:soft_skill_admin/firebaseBackend/authenticate.dart';
import 'package:soft_skill_admin/providers/classifier.dart';
import 'package:soft_skill_admin/screens/pdf_screen.dart';
import 'package:soft_skill_admin/screens/quiz_screen.dart';
import 'package:soft_skill_admin/screens/sign_in_screen.dart';
import 'package:soft_skill_admin/screens/url_screen.dart';


class DisplayScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

    List<SectionViewCard> sectionViewCards = [

      SectionViewCard(
        title: 'Quiz Section',
        imagePath: 'images/quiz.png',
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=> QuizScreen()));
        },
      ),

      SectionViewCard(
        title: 'Study Material',
        imagePath: 'images/documents.png',
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=> PDFScreen()));
        },
      ),

      SectionViewCard(
        title: 'Video URL',
        imagePath: 'images/video.png',
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=> URLScreen()));
        },
      )

    ];

    final classifierProvider = Provider.of<Classifier>(context, listen: false);
    final authProvider = Provider.of<Authenticate>(context);
    return Scaffold(
      floatingActionButton: FabCircularMenu(
        fabOpenIcon: Icon(
          Icons.info_outline,
          color: Colors.white,
        ),
        fabCloseIcon: Icon(
          Icons.cancel,
          color: Colors.white,
        ),
        fabColor: Color(0xFF01219F),
        ringColor: Colors.white.withAlpha(55),
        ringDiameter: 300.0,
        ringWidth: 75.0,
        children: <Widget>[
          IconButton(
            icon: Icon(
              Icons.insert_emoticon,
              color: Colors.green,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context)=> AlertDialog(
                  title: Text(
                    'About',
                    style: GoogleFonts.philosopher(),
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Developed By:',
                          style: GoogleFonts.philosopher(),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Aman Mulani',
                          style: GoogleFonts.philosopher(),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Contact Details: ',
                          style: GoogleFonts.philosopher(),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'amanmulani369@gmail.com',
                          style: GoogleFonts.philosopher(),
                        ),
                      )
                    ],
                  ),
                  actions: <Widget>[
                    RaisedButton(
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Okay',
                        style: GoogleFonts.philosopher(
                          color: Colors.white,
                        ),
                      ),
                      color: Colors.lightBlueAccent,
                    )
                  ],
                ),
              );
          }),
          IconButton(
            icon: Icon(
              Icons.warning,
              color: Colors.yellow,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  // return object of type Dialog
                  return AboutDialog(
                    applicationName: 'Soft Skills Admin',
                    children: <Widget>[
                      Text('Here are all the licenses. Please click the button below to view all licenses.'),
                    ],
                  );
                },
              );

          }),
          IconButton(
            icon: Icon(
              Icons.power_settings_new,
              color: Colors.red,
            ),
            onPressed: (){
              authProvider.signOut();
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> SignInScreen()), (route) => false);
            },
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height * 0.40,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xFF3383CD), Color(0xFF11249F),]
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Welcome!',
                  style: GoogleFonts.pacifico(
                    fontSize: 60.0,
                    color: Colors.white,
                  ),
                ),
                Text(
                  classifierProvider.group,
                  style: GoogleFonts.philosopher(
                    fontSize: 30.0,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: CarouselSlider(
              options: CarouselOptions(
                height: MediaQuery.of(context).size.height * 0.50,
                autoPlayCurve: Curves.bounceInOut,
              ),
              items: sectionViewCards.map((viewCard) {
                return Builder(
                  builder: (BuildContext context) {
                    return viewCard;
                  },
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class SectionViewCard extends StatelessWidget {

  final String title;
  final String imagePath;
  final Function onTap;

  SectionViewCard({@required this.title, @required this.imagePath, @required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.0),
        ),
        child: InkWell(
          onTap: onTap,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24.0),
              gradient: LinearGradient(
                colors: [Color(0xFF3383CD), Color(0xFF11249F),]
              )
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: AspectRatio(
                    aspectRatio: 0.9,
                    child: Image(
                      image: AssetImage(imagePath),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.philosopher(
                      color: Colors.white,
                      fontSize: 24.0,
                    ),
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
