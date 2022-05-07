import 'package:flutter/material.dart';
import 'package:nitc_telehealth_application/FrontEnd/screens/BookAppNow.dart';
import 'package:snippet_coder_utils/hex_color.dart';

class BookAppointments extends StatelessWidget {
  const BookAppointments({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: HexColor('#283B71'),
        appBar: AppBar(
          title: Text(
            "Book Appointment",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: HexColor("#283B71"),
        ),
        drawer: Drawer(),
        body: Padding(
          padding: const EdgeInsets.only(
            top: 40,
            left: 20,
            right: 20,
          ),
          child: GridView(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              mainAxisSpacing: 16.0,
              crossAxisSpacing: 16.0,
              childAspectRatio: (_width / (_height / 4)),
            ),
            scrollDirection: Axis.vertical,
            children: [
              Material(
                color: HexColor('#283b71'),
                //borderRadius: BorderRadius.circular(25.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.white),
                ),
                child: InkWell(
                  splashColor: Colors.black,
                  child: Container(
                    child: const Text(
                      'Mental Health Care',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    alignment: Alignment.center,
                  ),
                  onTap: () {
                    //Navigator.pushNamed(context, "/bookappnow");
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookAppNow(
                            problemtype: "Mental Health",
                          ),
                        ));
                  },
                ),
              ),
              Material(
                color: HexColor('#283b71'),
                //borderRadius: BorderRadius.circular(25.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.white),
                ),
                child: InkWell(
                  splashColor: Colors.black,
                  child: Container(
                    child: const Text(
                      'Dental Health Care',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    alignment: Alignment.center,
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookAppNow(
                            problemtype: "Dental Health",
                          ),
                        ));
                  },
                ),
              ),
              Material(
                color: HexColor('#283b71'),
                //borderRadius: BorderRadius.circular(25.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.white),
                ),
                child: InkWell(
                  splashColor: Colors.black,
                  child: Container(
                    child: const Text(
                      'Labooratory And Diagnostic Care',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    alignment: Alignment.center,
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookAppNow(
                            problemtype: "Diagnostic Care",
                          ),
                        ));
                  },
                ),
              ),
              Material(
                color: HexColor('#283b71'),
                //borderRadius: BorderRadius.circular(25.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.white),
                ),
                child: InkWell(
                  splashColor: Colors.black,
                  child: Container(
                    child: const Text(
                      'Prevensive Care',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    alignment: Alignment.center,
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookAppNow(
                            problemtype: "Prevensive Care",
                          ),
                        ));
                  },
                ),
              ),
              Material(
                color: HexColor('#283b71'),
                //borderRadius: BorderRadius.circular(25.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.white),
                ),
                child: InkWell(
                  splashColor: Colors.black,
                  child: Container(
                    child: const Text(
                      'Physical And Occupational Therapy',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    alignment: Alignment.center,
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookAppNow(
                            problemtype: "Physical therapy",
                          ),
                        ));
                  },
                ),
              ),
              Material(
                color: HexColor('#283b71'),
                //borderRadius: BorderRadius.circular(25.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.white),
                ),
                child: InkWell(
                  splashColor: Colors.black,
                  child: Container(
                    child: const Text(
                      'Nutritional Care',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    alignment: Alignment.center,
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookAppNow(
                            problemtype: "Nutritional Care",
                          ),
                        ));
                  },
                ),
              ),
              Material(
                color: HexColor('#283b71'),
                //borderRadius: BorderRadius.circular(25.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.white),
                ),
                child: InkWell(
                  splashColor: Colors.black,
                  child: Container(
                    child: const Text(
                      'Mild Problems',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    alignment: Alignment.center,
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookAppNow(
                            problemtype: "Mild Problems",
                          ),
                        ));
                  },
                ),
              ),
              Material(
                color: HexColor('#283b71'),
                //borderRadius: BorderRadius.circular(25.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.white),
                ),
                child: InkWell(
                  splashColor: Colors.black,
                  child: Container(
                    child: const Text(
                      'Request Medical Leave',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    alignment: Alignment.center,
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, "/deletedoctor");
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
